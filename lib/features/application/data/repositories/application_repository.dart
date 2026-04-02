import '../../../../core/network/api_client.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final ApiClient _client;
  ApplicationRepository(this._client);

  /// Backend hazır olduğunda: POST /applications
  /// Şimdilik 2 saniyelik gecikme ile başarılı yanıt simüle eder.
  Future<ApplicationModel> submitApplication(ApplicationModel model) async {
    await Future.delayed(const Duration(seconds: 2));

    // TODO: final response = await _client.dio.post(
    //   ApiConstants.applications,
    //   data: model.toJson(),
    // );
    // return ApplicationModel.fromJson(response.data as Map<String, dynamic>);

    return model.copyWith(
      id: 'APP-${DateTime.now().millisecondsSinceEpoch}',
      applicationDate: DateTime.now(),
      status: 'PENDING',
    );
  }

  /// Backend hazır olduğunda: GET /applications
  Future<List<ApplicationModel>> getApplications() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // TODO: final response = await _client.dio.get(ApiConstants.applications);
    // return (response.data as List).map((e) => ApplicationModel.fromJson(e)).toList();

    return [
      ApplicationModel(
        id: 'APP-001',
        tcNo: '11122233344',
        fullName: 'Osman Güneş',
        province: 'Diyarbakır',
        product: 'Buğday',
        hectares: 48.0,
        isContractFarming: false,
        applicationDate: DateTime(2025, 3, 25),
        status: 'PENDING',
      ),
      ApplicationModel(
        id: 'APP-002',
        tcNo: '22233344455',
        fullName: 'Leyla Aydın',
        province: 'Bursa',
        product: 'Mısır',
        hectares: 30.5,
        isContractFarming: true,
        applicationDate: DateTime(2025, 3, 26),
        status: 'UNDER_REVIEW',
      ),
    ];
  }

  // ignore: unused_field
  ApiClient get client => _client;
}
