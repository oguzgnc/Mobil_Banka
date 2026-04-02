import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CropPieChart extends StatefulWidget {
  final Map<String, int> cropDistribution;

  const CropPieChart({super.key, required this.cropDistribution});

  @override
  State<CropPieChart> createState() => _CropPieChartState();
}

class _CropPieChartState extends State<CropPieChart> {
  int _touchedIndex = -1;

  // Her ürün tipi için özenle seçilmiş renkler
  static const _cropColors = [
    Color(0xFFE8A838), // Buğday — buğday altını
    Color(0xFF4CAF50), // Mısır  — yaprak yeşili
    Color(0xFFF5820D), // Ayçiçeği — parlak turuncu
    Color(0xFF64B5F6), // Pamuk  — açık mavi
    Color(0xFFA0785A), // Arpa   — toprak kahvesi
    Color(0xFF9C27B0), // Diğer  — mor
  ];

  @override
  Widget build(BuildContext context) {
    final entries = widget.cropDistribution.entries.toList();
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 230,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: _buildSections(entries, total),
                    centerSpaceRadius: 58,
                    sectionsSpace: 3,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                  ),
                ),
                _buildCenterLabel(entries, total),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildLegend(entries, total),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
    List<MapEntry<String, int>> entries,
    int total,
  ) {
    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final crop = entry.value;
      final isTouched = index == _touchedIndex;
      final pct = total > 0 ? (crop.value / total) * 100 : 0.0;
      final color = _cropColors[index % _cropColors.length];

      return PieChartSectionData(
        value: crop.value.toDouble(),
        color: isTouched ? color : color.withValues(alpha: 0.85),
        radius: isTouched ? 82 : 70,
        title: isTouched ? '%${pct.toStringAsFixed(1)}' : '',
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
        ),
        borderSide: isTouched
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      );
    }).toList();
  }

  Widget _buildCenterLabel(
    List<MapEntry<String, int>> entries,
    int total,
  ) {
    final touched = _touchedIndex >= 0 && _touchedIndex < entries.length;

    if (touched) {
      final crop = entries[_touchedIndex];
      final pct = total > 0 ? (crop.value / total) * 100 : 0.0;
      final color = _cropColors[_touchedIndex % _cropColors.length];
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '%${pct.toStringAsFixed(1)}',
            style: AppTextStyles.headlineMedium.copyWith(color: color),
          ),
          Text(crop.key, style: AppTextStyles.labelMedium),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          total.toString(),
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text('Çiftçi', style: AppTextStyles.labelMedium),
      ],
    );
  }

  Widget _buildLegend(List<MapEntry<String, int>> entries, int total) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: entries.asMap().entries.map((entry) {
        final index = entry.key;
        final crop = entry.value;
        final pct = total > 0 ? (crop.value / total) * 100 : 0.0;
        final color = _cropColors[index % _cropColors.length];
        final isActive = index == _touchedIndex;

        return GestureDetector(
          onTap: () => setState(
            () => _touchedIndex = isActive ? -1 : index,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isActive
                  ? color.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? color : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${crop.key}  %${pct.toStringAsFixed(0)}',
                  style: isActive
                      ? AppTextStyles.labelMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        )
                      : AppTextStyles.labelMedium,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
