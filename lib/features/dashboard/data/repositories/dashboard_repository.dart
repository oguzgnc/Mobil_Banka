import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../farmers/data/models/farmer_model.dart';
import '../models/dashboard_kpi_model.dart';

class DashboardRepository {
  final ApiClient _client;
  DashboardRepository(this._client);

  /// GET /api/cks-analyses → KPI'lar uygulama içinde hesaplanır.
  /// Backend Durum değerleri: "Onaylı" | "İncelemede" | "Riskli"
  Future<DashboardKpiModel> getKpi() async {
    final response = await _client.dio.get(ApiConstants.cksAnalyses);

    final farmers = (response.data as List<dynamic>)
        .map((e) => FarmerModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return _computeKpi(farmers);
  }

  DashboardKpiModel _computeKpi(List<FarmerModel> farmers) {
    var approved = 0, rejected = 0, underReview = 0, pending = 0;
    var totalHectares = 0.0;
    final cropDist = <String, int>{};

    for (final f in farmers) {
      switch (f.approvalStatus) {
        case ApprovalStatus.approved:    approved++;    break;
        case ApprovalStatus.rejected:    rejected++;    break;
        case ApprovalStatus.underReview: underReview++; break;
        case ApprovalStatus.pending:     pending++;     break;
      }
      totalHectares += f.hectares;

      final crop = f.product.trim();
      if (crop.isNotEmpty) {
        cropDist[crop] = (cropDist[crop] ?? 0) + 1;
      }
    }

    return DashboardKpiModel(
      totalFarmers:        farmers.length,
      pendingApplications: pending + underReview, // incelemede + beklemede
      approvedCount:       approved,
      rejectedCount:       rejected,
      underReviewCount:    underReview,
      totalHectares:       totalHectares,
      cropDistribution:    cropDist,
    );
  }
}
