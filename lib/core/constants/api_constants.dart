abstract final class ApiConstants {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String dashboardKpi = '/dashboard/kpi';
  static const String farmers = '/farmers';
  static const String farmerById = '/farmers/{id}';
  static const String applications = '/applications';
  static const String marketProducts = '/market/products';
}
