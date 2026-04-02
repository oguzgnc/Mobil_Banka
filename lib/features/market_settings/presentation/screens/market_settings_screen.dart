import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/market_product_model.dart';
import '../../domain/providers/market_settings_providers.dart';

class MarketSettingsScreen extends ConsumerStatefulWidget {
  const MarketSettingsScreen({super.key});

  @override
  ConsumerState<MarketSettingsScreen> createState() =>
      _MarketSettingsScreenState();
}

class _MarketSettingsScreenState extends ConsumerState<MarketSettingsScreen> {
  bool _isSaving = false;

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(marketSettingsNotifierProvider.notifier).save();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cloud_done_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ayarlar başarıyla güncellendi!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.statusApproved,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(marketSettingsNotifierProvider);

    return Column(
      children: [
        // ── Bilgi başlığı ──────────────────────────────────────────────────
        _InfoHeader(productCount: products.length),
        // ── Ürün listesi ───────────────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _ProductCard(
              product: products[index],
              onIncrement: () => ref
                  .read(marketSettingsNotifierProvider.notifier)
                  .increment(products[index].id),
              onDecrement: () => ref
                  .read(marketSettingsNotifierProvider.notifier)
                  .decrement(products[index].id),
            ),
          ),
        ),
        // ── Sabit save butonu ──────────────────────────────────────────────
        _BottomSaveBar(isSaving: _isSaving, onSave: _save),
      ],
    );
  }
}

// ─── Info Header ──────────────────────────────────────────────────────────────

class _InfoHeader extends StatelessWidget {
  final int productCount;

  const _InfoHeader({required this.productCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 15, color: AppColors.info),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$productCount ürün için risk katsayısı ayarlanıyor  •  Aralık: 1.0 – 5.0',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final MarketProductModel product;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ProductCard({
    required this.product,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final color = product.riskColor;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Sol: Emoji + isim ────────────────────────────────────────
            Text(product.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 3),
                  _RiskBadge(product: product),
                ],
              ),
            ),
            // ── Sağ: Counter ─────────────────────────────────────────────
            _CounterControl(
              value: product.riskFactor,
              color: color,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
              atMin: product.riskFactor <= 1.0,
              atMax: product.riskFactor >= 5.0,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Risk Badge ───────────────────────────────────────────────────────────────

class _RiskBadge extends StatelessWidget {
  final MarketProductModel product;

  const _RiskBadge({required this.product});

  @override
  Widget build(BuildContext context) {
    final color = product.riskColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(product.riskIcon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          '${product.riskLabel} Risk',
          style: AppTextStyles.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Counter Control ──────────────────────────────────────────────────────────

class _CounterControl extends StatelessWidget {
  final double value;
  final Color color;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool atMin;
  final bool atMax;

  const _CounterControl({
    required this.value,
    required this.color,
    required this.onIncrement,
    required this.onDecrement,
    required this.atMin,
    required this.atMax,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove_rounded,
            color: atMin ? AppColors.textDisabled : color,
            onPressed: atMin ? null : onDecrement,
          ),
          SizedBox(
            width: 46,
            child: Text(
              value.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            color: atMax ? AppColors.textDisabled : color,
            onPressed: atMax ? null : onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _StepButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: color,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

// ─── Bottom Save Bar ──────────────────────────────────────────────────────────

class _BottomSaveBar extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;

  const _BottomSaveBar({required this.isSaving, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isSaving ? null : onSave,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isSaving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save_rounded, size: 18),
                    SizedBox(width: 10),
                    Text(
                      'Değişiklikleri Kaydet',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
