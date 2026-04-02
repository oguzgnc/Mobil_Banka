import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/dashboard_kpi_model.dart';
import '../../domain/providers/dashboard_providers.dart';
import '../widgets/crop_pie_chart.dart';
import '../widgets/kpi_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(dashboardKpiProvider);

    // .when() — React'taki if(isLoading)/if(error) bloklarının Riverpod karşılığı
    return kpiAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, _) => _ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(dashboardKpiProvider),
      ),
      data: (kpi) => _DashboardContent(kpi: kpi),
    );
  }
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  final DashboardKpiModel kpi;

  const _DashboardContent({required this.kpi});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'KPI Göstergeleri',
            icon: Icons.bar_chart_rounded,
          ),
          const SizedBox(height: 12),
          _KpiGrid(kpi: kpi),
          const SizedBox(height: 28),
          const _SectionHeader(
            title: 'Ürün Dağılımı',
            icon: Icons.donut_large_rounded,
          ),
          const SizedBox(height: 12),
          CropPieChart(cropDistribution: kpi.cropDistribution),
          const SizedBox(height: 28),
          const _SectionHeader(
            title: 'Başvuru Durumları',
            icon: Icons.assignment_turned_in_outlined,
          ),
          const SizedBox(height: 12),
          _StatusSummaryRow(kpi: kpi),
        ],
      ),
    );
  }
}

// ─── KPI Grid ─────────────────────────────────────────────────────────────────

class _KpiGrid extends StatelessWidget {
  final DashboardKpiModel kpi;

  const _KpiGrid({required this.kpi});

  @override
  Widget build(BuildContext context) {
    final cards = [
      KpiCard(
        title: 'Toplam Çiftçi',
        value: _fmt(kpi.totalFarmers),
        icon: Icons.people_alt_outlined,
        accentColor: AppColors.primary,
        subtitle: 'Kayıtlı çiftçi sayısı',
      ),
      KpiCard(
        title: 'Bekleyen Başvuru',
        value: _fmt(kpi.pendingApplications),
        icon: Icons.pending_actions_outlined,
        accentColor: AppColors.warning,
        subtitle: 'İşlem bekliyor',
      ),
      KpiCard(
        title: 'Onay Oranı',
        value: '%${kpi.approvalRate.toStringAsFixed(1)}',
        icon: Icons.verified_outlined,
        accentColor: AppColors.success,
        subtitle: '${_fmt(kpi.approvedCount)} onaylandı',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet/Desktop: 3 sütun yan yana
        if (constraints.maxWidth >= 480) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
              const SizedBox(width: 12),
              Expanded(child: cards[2]),
            ],
          );
        }
        // Telefon: 2 kart + 1 tam genişlik
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 12),
                Expanded(child: cards[1]),
              ],
            ),
            const SizedBox(height: 12),
            cards[2],
          ],
        );
      },
    );
  }

  static String _fmt(int v) =>
      v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

// ─── Status Summary ───────────────────────────────────────────────────────────

class _StatusSummaryRow extends StatelessWidget {
  final DashboardKpiModel kpi;

  const _StatusSummaryRow({required this.kpi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          _StatusPill(
            label: 'Onaylandı',
            count: kpi.approvedCount,
            color: AppColors.statusApproved,
          ),
          const SizedBox(width: 8),
          _StatusPill(
            label: 'İncelemede',
            count: kpi.underReviewCount,
            color: AppColors.statusUnderReview,
          ),
          const SizedBox(width: 8),
          _StatusPill(
            label: 'Reddedildi',
            count: kpi.rejectedCount,
            color: AppColors.statusRejected,
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatusPill({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: AppTextStyles.headlineMedium.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(title, style: AppTextStyles.headlineSmall),
      ],
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Veriler Yüklenemedi',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
