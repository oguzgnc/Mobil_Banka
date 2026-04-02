import '../../../../core/network/api_client.dart';
import '../models/dashboard_kpi_model.dart';

class DashboardRepository {
  final ApiClient _client;
  DashboardRepository(this._client);

  /// Backend hazır olduğunda: GET /dashboard/kpi
  /// Şimdilik 1.5s gecikme ile dummy veri döner.
  Future<DashboardKpiModel> getKpi() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    // TODO: Backend hazır olduğunda aşağıdaki satırları aç:
    // final response = await _client.dio.get(ApiConstants.dashboardKpi);
    // return DashboardKpiModel.fromJson(response.data as Map<String, dynamic>);

    return const DashboardKpiModel(
      totalFarmers: 1284,
      pendingApplications: 47,
      approvedCount: 892,
      rejectedCount: 156,
      underReviewCount: 189,
      totalHectares: 38750.5,
      cropDistribution: {
        'Buğday': 412,
        'Mısır': 298,
        'Ayçiçeği': 187,
        'Pamuk': 134,
        'Arpa': 253,
      },
    );
  }

  // ignore: unused_field
  ApiClient get client => _client;
}
