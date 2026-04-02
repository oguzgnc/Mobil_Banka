import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/farmer_model.dart';
import '../../domain/providers/farmer_providers.dart';
import '../widgets/farmer_card.dart';

class FarmersScreen extends ConsumerWidget {
  const FarmersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmersAsync = ref.watch(farmersProvider);

    return farmersAsync.when(
      loading: () => const _FarmerListSkeleton(),
      error: (err, _) => _ErrorView(
        message: err.toString(),
        onRetry: () => ref.invalidate(farmersProvider),
      ),
      data: (farmers) => _FarmerList(farmers: farmers),
    );
  }
}

// ─── List ─────────────────────────────────────────────────────────────────────

class _FarmerList extends StatelessWidget {
  final List<FarmerModel> farmers;

  const _FarmerList({required this.farmers});

  @override
  Widget build(BuildContext context) {
    if (farmers.isEmpty) {
      return const Center(
        child: Text('Kayıtlı çiftçi bulunamadı.'),
      );
    }

    return Column(
      children: [
        _StatusSummaryBar(farmers: farmers),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: farmers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final farmer = farmers[index];
              return FarmerCard(
                farmer: farmer,
                onTap: () => context.push('/farmers/${farmer.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Status Summary Bar ───────────────────────────────────────────────────────

class _StatusSummaryBar extends StatelessWidget {
  final List<FarmerModel> farmers;

  const _StatusSummaryBar({required this.farmers});

  @override
  Widget build(BuildContext context) {
    final counts = <ApprovalStatus, int>{};
    for (final f in farmers) {
      counts[f.approvalStatus] = (counts[f.approvalStatus] ?? 0) + 1;
    }

    final chips = ApprovalStatus.values
        .where((s) => (counts[s] ?? 0) > 0)
        .map((status) => _CountChip(
              label: '${status.label.split(' ')[0]} ${counts[status]}',
              color: status.color,
            ))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${farmers.length} çiftçi kayıtlı',
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: chips,
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final Color color;

  const _CountChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _FarmerListSkeleton extends StatelessWidget {
  const _FarmerListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            // avatar
            _SkeletonBox(width: 44, height: 44, radius: 22, opacity: _anim.value),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: 140, height: 14, opacity: _anim.value),
                  const SizedBox(height: 8),
                  _SkeletonBox(width: 100, height: 10, opacity: _anim.value),
                  const SizedBox(height: 10),
                  _SkeletonBox(width: double.infinity, height: 6, opacity: _anim.value),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _SkeletonBox(width: 70, height: 24, radius: 12, opacity: _anim.value),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double opacity;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 6,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.outlineVariant.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(radius),
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
            const Icon(Icons.cloud_off_rounded, size: 52, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Liste yüklenemedi', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
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
