import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MarketProductModel {
  final String id;
  final String name;
  final String emoji;

  /// Admin tarafından ayarlanan risk katsayısı. 1.0 – 5.0 arası, 0.1 adım.
  final double riskFactor;

  const MarketProductModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.riskFactor,
  });

  MarketProductModel copyWith({double? riskFactor}) => MarketProductModel(
        id: id,
        name: name,
        emoji: emoji,
        riskFactor: riskFactor ?? this.riskFactor,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'risk_factor': riskFactor,
      };

  /// 1.0–2.0 → Düşük  |  2.1–3.5 → Orta  |  3.6–5.0 → Yüksek
  String get riskLabel {
    if (riskFactor <= 2.0) return 'Düşük';
    if (riskFactor <= 3.5) return 'Orta';
    return 'Yüksek';
  }

  Color get riskColor {
    if (riskFactor <= 2.0) return AppColors.statusApproved;
    if (riskFactor <= 3.5) return AppColors.statusPending;
    return AppColors.statusRejected;
  }

  IconData get riskIcon {
    if (riskFactor <= 2.0) return Icons.arrow_downward_rounded;
    if (riskFactor <= 3.5) return Icons.remove_rounded;
    return Icons.arrow_upward_rounded;
  }
}
