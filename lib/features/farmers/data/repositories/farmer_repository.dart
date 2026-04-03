import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/farmer_model.dart';

class FarmerRepository {
  final ApiClient _client;
  FarmerRepository(this._client);

  /// GET /api/cks-analyses → tüm çiftçi listesi
  Future<List<FarmerModel>> getFarmers() async {
    final response = await _client.dio.get(ApiConstants.cksAnalyses);

    return (response.data as List<dynamic>)
        .map((e) => FarmerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Tekil kayıt: TCKN ile listeden filtrele.
  /// Backend /api/cks-analyses/{tckn} endpoint'i destekliyorsa
  /// aşağıdaki satırı açarak daha verimli hale getirilebilir.
  Future<FarmerModel> getFarmerById(String id) async {
    // Verimli yol (backend destekliyorsa):
    // final r = await _client.dio.get('${ApiConstants.cksAnalyses}/$id');
    // return FarmerModel.fromJson(r.data as Map<String, dynamic>);

    final all = await getFarmers();
    return all.firstWhere(
      (f) => f.id == id || f.tcNo == id,
      orElse: () => throw Exception('Çiftçi bulunamadı: $id'),
    );
  }
}
