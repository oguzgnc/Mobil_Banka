class DashboardKpiModel {
  final int totalFarmers;
  final int pendingApplications;
  final int approvedCount;
  final int rejectedCount;
  final int underReviewCount;
  final double totalHectares;

  /// Ürün dağılımı: {"Buğday": 45, "Mısır": 30, ...}
  final Map<String, int> cropDistribution;

  const DashboardKpiModel({
    required this.totalFarmers,
    required this.pendingApplications,
    required this.approvedCount,
    required this.rejectedCount,
    required this.underReviewCount,
    required this.totalHectares,
    required this.cropDistribution,
  });

  factory DashboardKpiModel.fromJson(Map<String, dynamic> json) {
    return DashboardKpiModel(
      totalFarmers: json['total_farmers'] as int,
      pendingApplications: json['pending_applications'] as int,
      approvedCount: json['approved_count'] as int,
      rejectedCount: json['rejected_count'] as int,
      underReviewCount: json['under_review_count'] as int,
      totalHectares: (json['total_hectares'] as num).toDouble(),
      cropDistribution: Map<String, int>.from(
        (json['crop_distribution'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, v as int),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_farmers': totalFarmers,
        'pending_applications': pendingApplications,
        'approved_count': approvedCount,
        'rejected_count': rejectedCount,
        'under_review_count': underReviewCount,
        'total_hectares': totalHectares,
        'crop_distribution': cropDistribution,
      };

  /// Toplam işlem yapılmış başvuru sayısı (grafik için)
  int get totalProcessed => approvedCount + rejectedCount + underReviewCount;

  /// Onay oranı yüzdesi
  double get approvalRate =>
      totalProcessed == 0 ? 0 : (approvedCount / totalProcessed) * 100;
}
