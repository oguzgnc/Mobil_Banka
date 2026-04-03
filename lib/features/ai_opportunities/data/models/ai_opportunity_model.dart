import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// GET /api/ai-opportunities yanıt yapısı:
/// {
///   "opportunities": [
///     {
///       "TCKN":          "12345678901",
///       "ad_soyad":      "Ahmet Yıldız",
///       "Il":            "Konya",
///       "Ilce":          "Merkez",
///       "Urun1_Adi":     "Mısır",
///       "Urun1_Alan":    85.0,
///       "Onerilen_Urun": "Buğday",
///       "Tesvik_Skoru":  8.5,         // 0-10, yüksek = iyi
///       "Risk_Durumu":   "Düşük",
///       "Telefon":       "Sistemde Kayıtlı",
///       "ai_neden":      "Bölge ekolojisi... teşvik paketi sunulabilir."
///     }
///   ]
/// }
class AiOpportunityModel {
  final String tcNo;
  final String fullName;
  final String province;
  final String district;
  final String currentProduct;
  final double hectares;
  final String recommendedProduct;

  /// creditScore: Tesvik_Skoru × 10 → 0–100 ölçeği, yüksek = iyi
  final double creditScore;

  final String riskLevel;   // "Düşük" | "Orta" | "Yüksek"
  final String phone;
  final String aiSummary;   // ai_neden

  const AiOpportunityModel({
    required this.tcNo,
    required this.fullName,
    required this.province,
    required this.district,
    required this.currentProduct,
    required this.hectares,
    required this.recommendedProduct,
    required this.creditScore,
    required this.riskLevel,
    required this.phone,
    required this.aiSummary,
  });

  // ── Python API key mapping ───────────────────────────────────────────────
  factory AiOpportunityModel.fromJson(Map<String, dynamic> json) {
    final tesvikSkoru = (json['Tesvik_Skoru'] as num?)?.toDouble() ?? 0.0;
    return AiOpportunityModel(
      tcNo:               json['TCKN']          as String? ?? '',
      fullName:           json['ad_soyad']       as String? ?? '',
      province:           json['Il']             as String? ?? '',
      district:           json['Ilce']           as String? ?? 'Merkez',
      currentProduct:     json['Urun1_Adi']      as String? ?? '',
      hectares:           (json['Urun1_Alan'] as num?)?.toDouble() ?? 0.0,
      recommendedProduct: json['Onerilen_Urun']  as String? ?? '',
      creditScore:        (tesvikSkoru * 10).clamp(0.0, 100.0),
      riskLevel:          json['Risk_Durumu']    as String? ?? 'Orta',
      phone:              json['Telefon']        as String? ?? '',
      aiSummary:          json['ai_neden']       as String? ?? '',
    );
  }

  // ── Computed ─────────────────────────────────────────────────────────────

  /// Yüksek Potansiyel: creditScore ≥ 75
  bool get isHighPotential => creditScore >= 75.0;

  Color get scoreColor {
    if (creditScore >= 75) return AppColors.statusApproved;
    if (creditScore >= 55) return AppColors.statusPending;
    return AppColors.statusRejected;
  }

  Color get scoreBackgroundColor => scoreColor.withValues(alpha: 0.12);

  String get scoreLabel {
    if (creditScore >= 75) return 'Yüksek Potansiyel';
    if (creditScore >= 55) return 'Orta Potansiyel';
    return 'Düşük Potansiyel';
  }

  IconData get riskIcon {
    return switch (riskLevel) {
      'Düşük' => Icons.shield_outlined,
      'Orta'  => Icons.warning_amber_outlined,
      _       => Icons.dangerous_outlined,
    };
  }

  Color get riskColor {
    return switch (riskLevel) {
      'Düşük' => AppColors.statusApproved,
      'Orta'  => AppColors.statusPending,
      _       => AppColors.statusRejected,
    };
  }
}

/// GET /api/ai-opportunities → { "opportunities": [...] }
/// Wrapper, düz liste değil — parse ederken bunu kullanıyoruz.
extension AiOpportunityListParser on List<dynamic> {
  static List<AiOpportunityModel> fromApiResponse(Map<String, dynamic> json) {
    final list = json['opportunities'] as List<dynamic>? ?? [];
    return list
        .map((e) => AiOpportunityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
