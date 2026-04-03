import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Backend GET /api/market-trends yanıtı:
///   { "id": 1, "urun_adi": "Buğday", "etki_puani": 0.0, "aciklama": "" }
///
/// PUT /api/market-trends/{id} body:
///   { "etki_puani": 1.5, "aciklama": "" }
///
/// etki_puani aralığı: -2.0 ... +2.0
///   Pozitif → ürün için piyasa etkisi olumlu
///   Negatif → olumsuz etki (örn. su kısıtı bölgesi)
class MarketProductModel {
  final String id;
  final String name;
  final String emoji;

  /// etki_puani: -2.0 ... +2.0
  final double riskFactor;

  /// Açıklama (yönetici notu)
  final String aciklama;

  const MarketProductModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.riskFactor,
    this.aciklama = '',
  });

  factory MarketProductModel.fromJson(Map<String, dynamic> json) {
    final name = json['urun_adi'] as String? ?? json['name'] as String? ?? '';
    return MarketProductModel(
      id:         json['id']?.toString() ?? '',
      name:       name,
      emoji:      _emojiFor(name),
      riskFactor: (json['etki_puani'] as num?)?.toDouble() ?? 0.0,
      aciklama:   json['aciklama'] as String? ?? '',
    );
  }

  /// PUT /api/market-trends/{id} body
  Map<String, dynamic> toJson() => {
        'etki_puani': riskFactor,
        'aciklama':   aciklama,
      };

  MarketProductModel copyWith({double? riskFactor, String? aciklama}) =>
      MarketProductModel(
        id:         id,
        name:       name,
        emoji:      emoji,
        riskFactor: riskFactor ?? this.riskFactor,
        aciklama:   aciklama  ?? this.aciklama,
      );

  // ── Computed — etki_puani aralığı: -2.0 / +2.0 ────────────────────────

  /// < -0.5 → Olumsuz  |  -0.5–+0.5 → Nötr  |  > +0.5 → Olumlu
  String get riskLabel {
    if (riskFactor > 0.5)  return 'Olumlu Etki';
    if (riskFactor < -0.5) return 'Olumsuz Etki';
    return 'Nötr';
  }

  Color get riskColor {
    if (riskFactor > 0.5)  return AppColors.statusApproved;
    if (riskFactor < -0.5) return AppColors.statusRejected;
    return AppColors.statusUnderReview;
  }

  IconData get riskIcon {
    if (riskFactor > 0.5)  return Icons.trending_up_rounded;
    if (riskFactor < -0.5) return Icons.trending_down_rounded;
    return Icons.trending_flat_rounded;
  }

  // ── Emoji lookup ───────────────────────────────────────────────────────

  static const _emojiMap = {
    'Buğday': '🌾', 'Mısır': '🌽', 'Ayçiçeği': '🌻',
    'Pamuk': '☁️',  'Arpa': '🫘',  'Domates': '🍅',
    'Patates': '🥔', 'Şeker': '🌿', 'Zeytin': '🫒',
    'Çeltik': '🍚', 'Nohut': '🟡', 'Fasulye': '🫘',
  };

  static String _emojiFor(String name) {
    for (final e in _emojiMap.entries) {
      if (name.contains(e.key)) return e.value;
    }
    return '🌱';
  }
}
