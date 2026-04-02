import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/farmer_model.dart';
import '../../domain/providers/farmer_providers.dart';
import '../widgets/approval_badge.dart';

class FarmerDetailScreen extends ConsumerWidget {
  final String farmerId;

  const FarmerDetailScreen({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmerAsync = ref.watch(farmerDetailProvider(farmerId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Risk Karnesi'),
        leading: const BackButton(),
      ),
      body: farmerAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(err.toString(), style: AppTextStyles.bodySmall),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(farmerDetailProvider(farmerId)),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
        data: (farmer) => _DetailBody(farmer: farmer),
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  final FarmerModel farmer;

  const _DetailBody({required this.farmer});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileCard(farmer: farmer),
          const SizedBox(height: 16),
          if (farmer.aiDecisionSummary != null) ...[
            _AiSummaryCard(summary: farmer.aiDecisionSummary!),
            const SizedBox(height: 16),
          ],
          if (farmer.riskFactors.isNotEmpty) ...[
            _RiskFactorsCard(factors: farmer.riskFactors),
            const SizedBox(height: 16),
          ],
          _RiskScoreCard(farmer: farmer),
        ],
      ),
    );
  }
}

// ─── Profil Kartı ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final FarmerModel farmer;

  const _ProfileCard({required this.farmer});

  static String _maskTc(String tc) {
    if (tc.length != 11) return tc;
    return '${tc.substring(0, 3)}*****${tc.substring(9)}';
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  _initials(farmer.fullName),
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(farmer.fullName, style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 4),
                    Text(
                      'TC: ${_maskTc(farmer.tcNo)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              ApprovalBadge(status: farmer.approvalStatus),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _InfoItem(
                icon: Icons.location_on_outlined,
                label: 'İl',
                value: farmer.province,
              ),
              _InfoItem(
                icon: Icons.grass_outlined,
                label: 'Ürün',
                value: farmer.product,
              ),
              _InfoItem(
                icon: Icons.crop_square_outlined,
                label: 'Arazi',
                value: '${farmer.hectares.toStringAsFixed(0)} ha',
              ),
              _InfoItem(
                icon: Icons.handshake_outlined,
                label: 'Sözleşmeli Tarım',
                value: farmer.isContractFarming ? 'Evet' : 'Hayır',
                valueColor: farmer.isContractFarming
                    ? AppColors.statusApproved
                    : AppColors.statusPending,
              ),
              _InfoItem(
                icon: Icons.calendar_today_outlined,
                label: 'Başvuru Tarihi',
                value: _formatDate(farmer.applicationDate),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelSmall),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Yapay Zeka Özet Kartı ────────────────────────────────────────────────────

class _AiSummaryCard extends StatelessWidget {
  final String summary;

  const _AiSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  size: 18,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 10),
              Text('Yapay Zeka Analiz Özeti', style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              summary,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Risk Faktörleri Kartı ────────────────────────────────────────────────────

class _RiskFactorsCard extends StatelessWidget {
  final List<String> factors;

  const _RiskFactorsCard({required this.factors});

  static _FactorType _classify(String factor) {
    if (factor.contains('✓')) return _FactorType.positive;
    if (factor.contains('✗')) return _FactorType.negative;
    return _FactorType.warning;
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  size: 18,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Text('Risk Faktörleri', style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: 14),
          ...factors.map((factor) => _RiskFactorRow(
                factor: factor,
                type: _classify(factor),
              )),
        ],
      ),
    );
  }
}

enum _FactorType { positive, negative, warning }

class _RiskFactorRow extends StatelessWidget {
  final String factor;
  final _FactorType type;

  const _RiskFactorRow({required this.factor, required this.type});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      _FactorType.positive => (Icons.check_circle_rounded, AppColors.statusApproved),
      _FactorType.negative => (Icons.cancel_rounded, AppColors.statusRejected),
      _FactorType.warning  => (Icons.warning_amber_rounded, AppColors.statusPending),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              factor,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Risk Skoru Kartı ─────────────────────────────────────────────────────────

class _RiskScoreCard extends StatelessWidget {
  final FarmerModel farmer;

  const _RiskScoreCard({required this.farmer});

  @override
  Widget build(BuildContext context) {
    final score = farmer.riskScore;
    final color = farmer.riskColor;
    final fraction = (score / 100).clamp(0.0, 1.0);

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.speed_rounded, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Text('Risk Skoru', style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: 20),
          // ── Büyük skor gösterimi ──
          Center(
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: score.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: color,
                          height: 1,
                        ),
                      ),
                      TextSpan(
                        text: '/100',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: color.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    farmer.riskLabel,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // ── Renkli çubuk ──
          _RiskGaugeBar(fraction: fraction),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Düşük Risk', style: AppTextStyles.labelSmall.copyWith(color: AppColors.statusApproved)),
              Text('Orta Risk', style: AppTextStyles.labelSmall.copyWith(color: AppColors.statusPending)),
              Text('Yüksek Risk', style: AppTextStyles.labelSmall.copyWith(color: AppColors.statusRejected)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskGaugeBar extends StatelessWidget {
  final double fraction;

  const _RiskGaugeBar({required this.fraction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final indicatorLeft = (fraction * totalWidth).clamp(2.0, totalWidth - 6);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Renkli zemin
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 14,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.statusApproved,
                      AppColors.statusPending,
                      AppColors.statusRejected,
                    ],
                  ),
                ),
              ),
            ),
            // Beyaz dikey gösterge çizgisi
            Positioned(
              left: indicatorLeft - 2,
              top: -3,
              child: Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 3),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Paylaşılan Kart Konteyneri ───────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
