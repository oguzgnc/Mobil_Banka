import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// ─── ApprovalStatus ───────────────────────────────────────────────────────────
// Backend Durum değerleri: "Onaylı" | "İncelemede" | "Riskli"

enum ApprovalStatus {
  approved,
  pending,
  rejected,
  underReview;

  static ApprovalStatus fromString(String value) {
    final v = value.trim();
    return switch (v) {
      // Türkçe (gerçek API)
      'Onaylı'      => ApprovalStatus.approved,
      'İncelemede'  => ApprovalStatus.underReview,
      'Riskli'      => ApprovalStatus.rejected,
      // İngilizce fallback
      _ when v.toUpperCase() == 'APPROVED'     => ApprovalStatus.approved,
      _ when v.toUpperCase() == 'UNDER_REVIEW' => ApprovalStatus.underReview,
      _ when v.toUpperCase() == 'REJECTED'     => ApprovalStatus.rejected,
      _ when v.toUpperCase() == 'PENDING'      => ApprovalStatus.pending,
      _ => ApprovalStatus.pending,
    };
  }

  String get label => switch (this) {
        ApprovalStatus.approved    => 'Onaylandı',
        ApprovalStatus.pending     => 'Beklemede',
        ApprovalStatus.rejected    => 'Reddedildi',
        ApprovalStatus.underReview => 'İncelemede',
      };

  Color get color => switch (this) {
        ApprovalStatus.approved    => AppColors.statusApproved,
        ApprovalStatus.pending     => AppColors.statusPending,
        ApprovalStatus.rejected    => AppColors.statusRejected,
        ApprovalStatus.underReview => AppColors.statusUnderReview,
      };

  String get toApiString => switch (this) {
        ApprovalStatus.approved    => 'Onaylı',
        ApprovalStatus.pending     => 'İncelemede',
        ApprovalStatus.rejected    => 'Riskli',
        ApprovalStatus.underReview => 'İncelemede',
      };
}

// ─── FarmerModel ──────────────────────────────────────────────────────────────

class FarmerModel {
  final String id;
  final String tcNo;
  final String fullName;
  final String province;
  final String product;
  final double hectares;

  /// 0–100 ölçeği, düşük = iyi.
  /// Backend: Tesvik_Skoru (0–10, yüksek=iyi) → dönüştürme: (1 - s/10) * 100
  final double riskScore;

  final ApprovalStatus approvalStatus;
  final DateTime applicationDate;
  final bool isContractFarming;

  /// Backend region_aciklama → yapay zeka/bölgesel analiz özeti
  final String? aiDecisionSummary;
  final List<String> riskFactors;

  const FarmerModel({
    required this.id,
    required this.tcNo,
    required this.fullName,
    required this.province,
    required this.product,
    required this.hectares,
    required this.riskScore,
    required this.approvalStatus,
    required this.applicationDate,
    required this.isContractFarming,
    this.aiDecisionSummary,
    this.riskFactors = const [],
  });

  // ── Python API key mapping ────────────────────────────────────────────────
  //   TCKN             → tcNo
  //   ad_soyad         → fullName
  //   Il               → province
  //   Urun1_Adi        → product
  //   Urun1_Alan       → hectares
  //   sozlesmeli_tarim → isContractFarming
  //   Tesvik_Skoru     → riskScore (0-10 → inverted 0-100)
  //   Durum            → approvalStatus ("Onaylı"/"İncelemede"/"Riskli")
  //   Tarih            → applicationDate
  //   region_aciklama  → aiDecisionSummary
  // ─────────────────────────────────────────────────────────────────────────
  factory FarmerModel.fromJson(Map<String, dynamic> json) {
    final tckn        = json['TCKN']?.toString() ?? '';
    final tesvikSkoru = (json['Tesvik_Skoru'] as num?)?.toDouble() ?? 5.0;
    final durum       = json['Durum'] as String? ?? 'İncelemede';
    final region      = json['region_aciklama'] as String? ?? '';
    final sozlesmeli  = _parseBool(json['sozlesmeli_tarim']);

    return FarmerModel(
      id:               json['id']?.toString() ?? tckn,
      tcNo:             tckn,
      fullName:         json['ad_soyad']  as String? ?? '',
      province:         json['Il']        as String? ?? '',
      product:          json['Urun1_Adi'] as String? ?? '',
      hectares:         (json['Urun1_Alan'] as num?)?.toDouble() ?? 0.0,
      isContractFarming: sozlesmeli,
      // Tesvik_Skoru (0-10, yüksek=iyi) → riskScore (0-100, düşük=iyi)
      riskScore:        ((1.0 - tesvikSkoru / 10.0) * 100).clamp(0.0, 100.0),
      approvalStatus:   ApprovalStatus.fromString(durum),
      applicationDate:  _parseDate(json['Tarih'] as String?),
      // region_aciklama yoksa Durum + Risk_Durumu'ndan özet üret
      aiDecisionSummary: region.isNotEmpty
          ? region
          : _buildAiSummary(
              durum: durum,
              riskDurumu: json['Risk_Durumu'] as String? ?? '',
              sozlesmeli: sozlesmeli,
              il: json['Il'] as String? ?? '',
              urun: json['Urun1_Adi'] as String? ?? '',
            ),
      riskFactors: _buildRiskFactors(
        sozlesmeli:     sozlesmeli,
        regionAciklama: region,
        riskDurumu:     json['Risk_Durumu'] as String? ?? '',
        marketEtki:     (json['market_etki_puani'] as num?)?.toDouble() ?? 0.0,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id':              id,
        'TCKN':            tcNo,
        'ad_soyad':        fullName,
        'Il':              province,
        'Urun1_Adi':       product,
        'Urun1_Alan':      hectares,
        'sozlesmeli_tarim': isContractFarming,
        'Durum':           approvalStatus.toApiString,
        'Tarih':           applicationDate.toIso8601String().substring(0, 10),
      };

  // ── Helpers ───────────────────────────────────────────────────────────────

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    return v.toString().toLowerCase() == 'true' || v.toString() == '1';
  }

  static DateTime _parseDate(String? s) {
    if (s == null || s.isEmpty) return DateTime.now();
    try { return DateTime.parse(s); } catch (_) { return DateTime.now(); }
  }

  static String _buildAiSummary({
    required String durum,
    required String riskDurumu,
    required bool sozlesmeli,
    required String il,
    required String urun,
  }) {
    final parts = <String>[];
    if (riskDurumu.isNotEmpty) parts.add('$riskDurumu risk seviyesi tespit edildi.');
    if (sozlesmeli) parts.add('Sözleşmeli tarım güvencesi değerlendirmeyi olumlu etkiliyor.');
    if (il.isNotEmpty && urun.isNotEmpty) {
      parts.add('$il bölgesinde $urun üretimine yönelik analiz tamamlandı.');
    }
    return parts.join(' ');
  }

  static List<String> _buildRiskFactors({
    required bool sozlesmeli,
    required String regionAciklama,
    required String riskDurumu,
    required double marketEtki,
  }) {
    final factors = <String>[];
    if (sozlesmeli) {
      factors.add('Sözleşmeli tarım güvencesi ✓');
    } else {
      factors.add('Sözleşmeli tarım yok ⚠️');
    }
    if (regionAciklama.isNotEmpty) factors.add('$regionAciklama ⚠️');
    if (marketEtki > 0) factors.add('Piyasa etkisi olumlu (+${marketEtki.toStringAsFixed(1)}) ✓');
    if (marketEtki < 0) factors.add('Piyasa etkisi olumsuz (${marketEtki.toStringAsFixed(1)}) ⚠️');
    if (riskDurumu == 'Düşük') factors.add('Risk seviyesi düşük ✓');
    if (riskDurumu == 'Yüksek') factors.add('Risk seviyesi yüksek ✗');
    return factors;
  }

  // ── Computed ──────────────────────────────────────────────────────────────

  String get riskLabel {
    if (riskScore <= 33) return 'Düşük Risk';
    if (riskScore <= 66) return 'Orta Risk';
    return 'Yüksek Risk';
  }

  Color get riskColor {
    if (riskScore <= 33) return AppColors.statusApproved;
    if (riskScore <= 66) return AppColors.statusPending;
    return AppColors.statusRejected;
  }
}
