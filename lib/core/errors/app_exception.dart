/// Uygulamanın tüm hata tiplerini temsil eden sealed class hiyerarşisi.
/// React'taki custom Error sınıflarının Dart karşılığı.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Sunucuya ulaşılamadı, DNS hatası, bağlantı kesildi
class NetworkException extends AppException {
  const NetworkException([super.message = 'Sunucuya bağlanılamadı. İnternet bağlantınızı kontrol edin.']);
}

/// HTTP 4xx / 5xx yanıtları
class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}

/// HTTP 401 — Token geçersiz veya süresi dolmuş
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Oturum süresi doldu. Lütfen tekrar giriş yapın.']);
}

/// HTTP 404
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'İstenen kayıt bulunamadı.']);
}

/// Bağlantı veya okuma zaman aşımı
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.']);
}

/// JSON parse hatası
class ParseException extends AppException {
  const ParseException([super.message = 'Sunucu yanıtı işlenemedi.']);
}

/// Yukarıdakilerden hiçbirine girmeyen beklenmedik hatalar
class UnknownException extends AppException {
  const UnknownException([super.message = 'Beklenmedik bir hata oluştu.']);
}
