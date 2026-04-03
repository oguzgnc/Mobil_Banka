import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final ApiClient _client;
  ApplicationRepository(this._client);

  /// POST /api/applications
  /// Body: { TCKN, ad_soyad, Il, Urun1_Adi, Urun1_Alan, sozlesmeli_tarim }
  Future<ApplicationModel> submitApplication(ApplicationModel model) async {
    final response = await _client.dio.post(
      ApiConstants.applications,
      data: model.toJson(),
    );

    // Backend kayıtlı nesneyi döndürüyorsa parse et, sadece 201 dönüyorsa fallback
    if (response.data is Map<String, dynamic>) {
      return ApplicationModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    }
    return model.copyWith(
      id:              'APP-${DateTime.now().millisecondsSinceEpoch}',
      applicationDate: DateTime.now(),
      status:          'PENDING',
    );
  }

  /// GET /api/applications (opsiyonel — başvuru geçmişi için)
  Future<List<ApplicationModel>> getApplications() async {
    final response = await _client.dio.get(ApiConstants.applications);

    return (response.data as List<dynamic>)
        .map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
