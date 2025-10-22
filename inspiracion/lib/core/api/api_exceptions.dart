// Excepciones personalizadas para errores de API
// Estas excepciones representan errores del dominio HTTP y se usan para comunicar fallos específicos desde la capa de datos.

/// Excepción base para errores de API
abstract class ApiException implements Exception {
  final String message;
  final String? errorCode;
  
  ApiException(this.message, {this.errorCode});
  
  @override
  String toString() => message;
}

/// 400 Bad Request - Datos inválidos enviados al servidor
class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.errorCode});
}

/// 401 Unauthorized - Token inválido o expirado
class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message) : super(errorCode: 'UNAUTHORIZED');
}

/// 403 Forbidden - Sin permisos para acceder al recurso
class ForbiddenException extends ApiException {
  ForbiddenException(super.message) : super(errorCode: 'FORBIDDEN');
}

/// 404 Not Found - Recurso no encontrado
class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.errorCode});
}

/// 409 Conflict - Conflicto (ej. UUID duplicado, recurso ya existe)
class ConflictException extends ApiException {
  ConflictException(super.message, {super.errorCode});
}

/// 500 Internal Server Error - Error del servidor
class ServerException extends ApiException {
  ServerException(super.message) : super(errorCode: 'INTERNAL_SERVER_ERROR');
}

/// Timeout - La petición tardó demasiado tiempo
class TimeoutException extends ApiException {
  TimeoutException(super.message) : super(errorCode: 'TIMEOUT');
}

/// Petición cancelada por el usuario o el sistema
class CancelledException extends ApiException {
  CancelledException(super.message) : super(errorCode: 'CANCELLED');
}

/// Error de conexión - Sin internet o servidor no alcanzable
class ConnectionException extends ApiException {
  ConnectionException(super.message) : super(errorCode: 'CONNECTION_ERROR');
}

/// Error de seguridad (certificado SSL inválido)
class SecurityException extends ApiException {
  SecurityException(super.message) : super(errorCode: 'SECURITY_ERROR');
}

/// Error desconocido - Catch-all para casos no manejados
class UnknownApiException extends ApiException {
  UnknownApiException(super.message) : super(errorCode: 'UNKNOWN_ERROR');
}
