import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/ai_opportunity_model.dart';
import '../../domain/providers/ai_opportunities_providers.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class AiOpportunitiesScreen extends ConsumerWidget {
  const AiOpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiOpportunitiesProvider);

    return state.when(
      loading: () => const _LoadingSkeleton(),
      error: (err, _) => _ErrorView(
        message: err.toString(),
        onRetry: () => ref.invalidate(aiOpportunitiesProvider),
      ),
      data: (list) => _OpportunitiesBody(opportunities: list),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _OpportunitiesBody extends StatelessWidget {
  final List<AiOpportunityModel> opportunities;

  const _OpportunitiesBody({required this.opportunities});

  @override
  Widget build(BuildContext context) {
    final highPotential  = opportunities.where((o) => o.isHighPotential).length;
    final newSuggestions = opportunities
        .where((o) => o.recommendedProduct.isNotEmpty &&
                      o.recommendedProduct != o.currentProduct)
        .length;

    return CustomScrollView(
      slivers: [
        // ── KPI Özet Kartları ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yapay Zeka Fırsatları', style: AppTextStyles.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  'Kredi skoru yüksek, riski düşük önerilen çiftçiler',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        icon: Icons.people_alt_outlined,
                        iconColor: AppColors.statusUnderReview,
                        label: 'Toplam Fırsat',
                        value: '${opportunities.length}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _KpiCard(
                        icon: Icons.star_outline_rounded,
                        iconColor: AppColors.statusApproved,
                        label: 'Yüksek Potansiyel',
                        value: '$highPotential',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _KpiCard(
                        icon: Icons.auto_awesome_outlined,
                        iconColor: AppColors.warning,
                        label: 'Yeni Öneri',
                        value: '$newSuggestions',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // ── Liste Başlığı ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: 6),
                Text(
                  'Fırsat Listesi',
                  style: AppTextStyles.headlineSmall,
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${opportunities.length} kayıt',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        // ── Fırsat Kartları ────────────────────────────────────────────────
        if (opportunities.isEmpty)
          const SliverFillRemaining(child: _EmptyView())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList.separated(
              itemCount: opportunities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _OpportunityCard(opportunity: opportunities[i]),
            ),
          ),
      ],
    );
  }
}

// ─── KPI Card ─────────────────────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _KpiCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.kpiValue.copyWith(
              fontSize: 22,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.kpiLabel),
        ],
      ),
    );
  }
}

// ─── Opportunity Card ─────────────────────────────────────────────────────────

class _OpportunityCard extends StatelessWidget {
  final AiOpportunityModel opportunity;

  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final o = opportunity;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: o.isHighPotential
              ? AppColors.statusApproved.withValues(alpha: 0.35)
              : AppColors.outlineVariant,
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Üst kısım: Skor + Çiftçi bilgisi ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol: Skor çemberi
                _ScoreBadge(score: o.creditScore, color: o.scoreColor),
                const SizedBox(width: 14),
                // Orta: İsim + konum/ürün
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              o.fullName,
                              style: AppTextStyles.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (o.isHighPotential)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.statusApproved
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 11,
                                    color: AppColors.statusApproved,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'VIP',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.statusApproved,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _InfoChip(
                            icon: Icons.location_on_outlined,
                            label: '${o.province} / ${o.district}',
                          ),
                          _InfoChip(
                            icon: Icons.grass_outlined,
                            label: o.currentProduct,
                          ),
                          _InfoChip(
                            icon: Icons.crop_square_outlined,
                            label: '${o.hectares.toStringAsFixed(0)} ha',
                          ),
                        ],
                      ),
                      if (o.recommendedProduct.isNotEmpty &&
                          o.recommendedProduct != o.currentProduct) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 13,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Öneri: ${o.recommendedProduct}',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Yapay Zeka Özeti ───────────────────────────────────────────
          if (o.aiSummary.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D47A1).withValues(alpha: 0.06),
                    const Color(0xFF1B5E20).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF0D47A1).withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.smart_toy_outlined,
                    size: 16,
                    color: Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      o.aiSummary,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF0D3270),
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Aksiyon Butonları ──────────────────────────────────────────
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Risk rozeti
                Icon(o.riskIcon, size: 14, color: o.riskColor),
                const SizedBox(width: 4),
                Text(
                  o.riskLevel,
                  style: AppTextStyles.labelSmall.copyWith(color: o.riskColor),
                ),
                const Spacer(),
                // Detay butonu
                TextButton.icon(
                  onPressed: () =>
                      context.push('/farmers/${o.tcNo}'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.onSurfaceVariant,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text('Detay'),
                ),
                const SizedBox(width: 6),
                // Teklif Yap butonu
                OutlinedButton.icon(
                  onPressed: () => _showOfferDialog(context, o),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.statusUnderReview,
                    side: const BorderSide(color: AppColors.statusUnderReview),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.send_rounded, size: 14),
                  label: const Text('Teklif Yap'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOfferDialog(BuildContext context, AiOpportunityModel o) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.send_rounded, color: AppColors.statusUnderReview),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Teklif Gönder',
                style: AppTextStyles.headlineSmall,
              ),
            ),
          ],
        ),
        content: Text(
          '${o.fullName} adlı çiftçiye ${o.recommendedProduct.isNotEmpty ? o.recommendedProduct : o.currentProduct} ürünü için '
          'kredi teklifi hazırlanacak.\n\n'
          'Bu özellik bir sonraki sürümde aktif olacak.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.statusUnderReview,
            ),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}

// ─── Score Badge ──────────────────────────────────────────────────────────────

class _ScoreBadge extends StatelessWidget {
  final double score;
  final Color color;

  const _ScoreBadge({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          Text(
            '/100',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

// ─── Loading Skeleton ─────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bone(width: 200, height: 22),
          const SizedBox(height: 8),
          _Bone(width: 280, height: 14),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _Bone(width: double.infinity, height: 80)),
              const SizedBox(width: 10),
              Expanded(child: _Bone(width: double.infinity, height: 80)),
              const SizedBox(width: 10),
              Expanded(child: _Bone(width: double.infinity, height: 80)),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _Bone(width: double.infinity, height: 160),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;

  const _Bone({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
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
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.statusRejected,
              ),
            ),
            const SizedBox(height: 20),
            Text('Fırsatlar yüklenemedi', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tekrar Dene'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty View ───────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text('Henüz fırsat bulunamadı', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Yeni başvurular eklendikçe AI fırsatlar burada görünecek.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
