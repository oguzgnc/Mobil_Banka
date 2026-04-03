import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/market_product_model.dart';

class MarketSettingsRepository {
  final ApiClient _client;
  MarketSettingsRepository(this._client);

  /// GET /api/market-trends → tüm ürünlerin risk katsayıları
  Future<List<MarketProductModel>> getMarketTrends() async {
    final response = await _client.dio.get(ApiConstants.marketTrends);

    return (response.data as List<dynamic>)
        .map((e) => MarketProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// PUT /api/market-trends/{id}
  /// Body: { "etki_puani": double, "aciklama": string }
  Future<void> updateMarketTrend(MarketProductModel product) async {
    await _client.dio.put(
      '${ApiConstants.marketTrends}/${product.id}',
      data: product.toJson(), // { "etki_puani": ..., "aciklama": ... }
    );
  }

  /// Tüm ürünleri paralel PUT ile kaydet
  Future<void> saveAll(List<MarketProductModel> products) async {
    await Future.wait(products.map(updateMarketTrend));
  }
}
