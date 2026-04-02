import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

part 'api_client.g.dart';

/// Uygulamanın tek Dio örneği. Tüm HTTP istekleri buradan geçer.
/// Python FastAPI backend'e bağlanmak için yapılandırılmıştır.
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      if (kDebugMode) _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  /// Auth token'ı header'a ekler (Adım 8'de auth entegrasyonu için hazır)
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

// ─── Logging Interceptor ──────────────────────────────────────────────────────

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌── API REQUEST ─────────────────────────');
    debugPrint('│ ${options.method} ${options.uri}');
    if (options.data != null) debugPrint('│ Body: ${options.data}');
    debugPrint('└────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌── API RESPONSE ────────────────────────');
    debugPrint('│ ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('└────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌── API ERROR ───────────────────────────');
    debugPrint('│ ${err.type.name}: ${err.message}');
    debugPrint('│ URL: ${err.requestOptions.uri}');
    debugPrint('└────────────────────────────────────────');
    handler.next(err);
  }
}

// ─── Error Interceptor ────────────────────────────────────────────────────────

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapDioError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        message: appException.message,
        type: err.type,
        response: err.response,
      ),
    );
  }

  AppException _mapDioError(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const TimeoutException(),

      DioExceptionType.connectionError => const NetworkException(),

      DioExceptionType.badResponse => _mapStatusCode(
          err.response?.statusCode,
          err.response?.data?['detail'] as String?,
        ),

      _ => UnknownException(err.message ?? 'Bilinmeyen hata'),
    };
  }

  AppException _mapStatusCode(int? statusCode, String? detail) {
    return switch (statusCode) {
      401 => const UnauthorizedException(),
      404 => NotFoundException(detail ?? 'Kayıt bulunamadı.'),
      _ when (statusCode ?? 0) >= 500 => ServerException(
          detail ?? 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.',
          statusCode: statusCode,
        ),
      _ => ServerException(
          detail ?? 'Beklenmedik bir sunucu hatası.',
          statusCode: statusCode,
        ),
    };
  }
}

// ─── Riverpod Provider ────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) => ApiClient();
