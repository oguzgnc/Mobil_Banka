import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum ApprovalStatus {
  approved,
  pending,
  rejected,
  underReview;

  static ApprovalStatus fromString(String value) {
    return switch (value.toUpperCase()) {
      'APPROVED' => ApprovalStatus.approved,
      'PENDING' => ApprovalStatus.pending,
      'REJECTED' => ApprovalStatus.rejected,
      'UNDER_REVIEW' => ApprovalStatus.underReview,
      _ => ApprovalStatus.pending,
    };
  }

  String get label => switch (this) {
        ApprovalStatus.approved => 'Onaylandı',
        ApprovalStatus.pending => 'Beklemede',
        ApprovalStatus.rejected => 'Reddedildi',
        ApprovalStatus.underReview => 'İncelemede',
      };

  Color get color => switch (this) {
        ApprovalStatus.approved => AppColors.statusApproved,
        ApprovalStatus.pending => AppColors.statusPending,
        ApprovalStatus.rejected => AppColors.statusRejected,
        ApprovalStatus.underReview => AppColors.statusUnderReview,
      };

  String get toApiString => switch (this) {
        ApprovalStatus.approved => 'APPROVED',
        ApprovalStatus.pending => 'PENDING',
        ApprovalStatus.rejected => 'REJECTED',
        ApprovalStatus.underReview => 'UNDER_REVIEW',
      };
}

class FarmerModel {
  final String id;
  final String tcNo;
  final String fullName;
  final String province;
  final String product;
  final double hectares;

  /// 0–100 arası AI risk skoru. Düşük = iyi.
  final double riskScore;

  final ApprovalStatus approvalStatus;
  final DateTime applicationDate;
  final bool isContractFarming;

  /// AI'nin ürettiği karar özeti (Risk Karnesi için)
  final String? aiDecisionSummary;

  /// AI'nin tespit ettiği risk faktörleri listesi
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

  factory FarmerModel.fromJson(Map<String, dynamic> json) {
    return FarmerModel(
      id: json['id'] as String,
      tcNo: json['tc_no'] as String,
      fullName: json['full_name'] as String,
      province: json['province'] as String,
      product: json['product'] as String,
      hectares: (json['hectares'] as num).toDouble(),
      riskScore: (json['risk_score'] as num).toDouble(),
      approvalStatus: ApprovalStatus.fromString(
        json['approval_status'] as String,
      ),
      applicationDate: DateTime.parse(json['application_date'] as String),
      isContractFarming: json['is_contract_farming'] as bool,
      aiDecisionSummary: json['ai_decision_summary'] as String?,
      riskFactors: List<String>.from(
        (json['risk_factors'] as List<dynamic>?) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tc_no': tcNo,
        'full_name': fullName,
        'province': province,
        'product': product,
        'hectares': hectares,
        'risk_score': riskScore,
        'approval_status': approvalStatus.toApiString,
        'application_date': applicationDate.toIso8601String(),
        'is_contract_farming': isContractFarming,
        'ai_decision_summary': aiDecisionSummary,
        'risk_factors': riskFactors,
      };

  /// Risk skoru 0–33 arası: Düşük Risk
  /// 34–66: Orta Risk
  /// 67–100: Yüksek Risk
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
