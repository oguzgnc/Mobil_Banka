import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/farmer_model.dart';
import 'approval_badge.dart';

class FarmerCard extends StatelessWidget {
  final FarmerModel farmer;
  final VoidCallback onTap;

  const FarmerCard({super.key, required this.farmer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Üst satır: avatar + ad + rozet ──────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AvatarCircle(name: farmer.fullName),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farmer.fullName,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              farmer.province,
                              style: AppTextStyles.bodySmall,
                            ),
                            const _Dot(),
                            const Icon(
                              Icons.grass_outlined,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              farmer.product,
                              style: AppTextStyles.bodySmall,
                            ),
                            const _Dot(),
                            Text(
                              '${farmer.hectares.toStringAsFixed(0)} ha',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ApprovalBadge(status: farmer.approvalStatus, compact: true),
                ],
              ),
              const SizedBox(height: 12),
              // ── Alt satır: risk skoru çubuğu + ok ────────────────────────
              Row(
                children: [
                  Expanded(child: _RiskMiniBar(score: farmer.riskScore)),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.textDisabled,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Avatar ───────────────────────────────────────────────────────────────────

class _AvatarCircle extends StatelessWidget {
  final String name;

  const _AvatarCircle({required this.name});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primaryContainer,
      child: Text(
        _initials.toUpperCase(),
        style: AppTextStyles.titleSmall.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Risk Mini Bar ────────────────────────────────────────────────────────────

class _RiskMiniBar extends StatelessWidget {
  final double score;

  const _RiskMiniBar({required this.score});

  @override
  Widget build(BuildContext context) {
    final fraction = (score / 100).clamp(0.0, 1.0);
    final color = score <= 33
        ? AppColors.statusApproved
        : score <= 66
            ? AppColors.statusPending
            : AppColors.statusRejected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Risk: ', style: AppTextStyles.labelSmall),
            Text(
              score.toStringAsFixed(1),
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('/100', style: AppTextStyles.labelSmall),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 5,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─── Dot separator ────────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text('·', style: TextStyle(color: AppColors.textDisabled)),
    );
  }
}
