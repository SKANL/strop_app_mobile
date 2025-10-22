// lib/src/core/core_domain/errors/exceptions.dart

/// Excepción base
class AppException implements Exception {
  final String message;
  
  AppException(this.message);
  
  @override
  String toString() => message;
}

/// Excepción de servidor
class ServerException extends AppException {
  final int? statusCode;
  
  ServerException(super.message, {this.statusCode});
}

/// Excepción de caché
class CacheException extends AppException {
  CacheException(super.message);
}

/// Excepción de red
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Excepción de validación
class ValidationException extends AppException {
  ValidationException(super.message);
}

/// Excepción de autenticación
class AuthException extends AppException {
  AuthException(super.message);
}
