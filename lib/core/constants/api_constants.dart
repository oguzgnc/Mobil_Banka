import 'package:flutter/foundation.dart';

abstract final class ApiConstants {
  /// Flutter Web → 127.0.0.1  |  Android Emülatör → 10.0.2.2  |  Diğer → 127.0.0.1
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String cksAnalyses      = '/api/cks-analyses';
  static const String applications     = '/api/applications';
  static const String marketTrends     = '/api/market-trends';
  static const String aiOpportunities  = '/api/ai-opportunities';
}
