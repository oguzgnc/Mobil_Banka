import 'package:flutter/material.dart';
import '../../data/models/farmer_model.dart';
import '../../../../core/theme/app_text_styles.dart';

class ApprovalBadge extends StatelessWidget {
  final ApprovalStatus status;

  /// [compact] = true → sadece ikon+kısa etiket (liste kartları için)
  /// [compact] = false → tam genişlik chip (detay sayfası için)
  final bool compact;

  const ApprovalBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  static IconData _icon(ApprovalStatus s) => switch (s) {
        ApprovalStatus.approved => Icons.check_circle_rounded,
        ApprovalStatus.pending => Icons.schedule_rounded,
        ApprovalStatus.rejected => Icons.cancel_rounded,
        ApprovalStatus.underReview => Icons.manage_search_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(status), size: compact ? 12 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: (compact ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
                .copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
