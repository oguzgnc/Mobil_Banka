import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/ai_opportunity_model.dart';

class AiOpportunitiesRepository {
  final ApiClient _client;
  AiOpportunitiesRepository(this._client);

  /// GET /api/ai-opportunities
  /// Yanıt: { "opportunities": [ {...}, ... ] }
  Future<List<AiOpportunityModel>> getOpportunities() async {
    debugPrint('[AiOpportunities] GET ${ApiConstants.aiOpportunities} isteği başlatıldı');
    try {
      final response = await _client.dio.get(ApiConstants.aiOpportunities);
      debugPrint('[AiOpportunities] Yanıt alındı — status: ${response.statusCode}');

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException(
          '[AiOpportunities] Beklenen Map<String,dynamic>, gelen: ${data.runtimeType}',
        );
      }

      final list = AiOpportunityListParser.fromApiResponse(data);
      debugPrint('[AiOpportunities] ${list.length} fırsat parse edildi');
      return list;
    } catch (e, st) {
      debugPrint('[AiOpportunities] HATA: $e\n$st');
      rethrow; // Riverpod'un error state'ine düşmesi için yeniden fırlat
    }
  }
}
