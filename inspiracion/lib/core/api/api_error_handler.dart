import 'package:dio/dio.dart';
import '../utils/app_logger.dart';
import 'api_exceptions.dart';

/// Manejador centralizado de errores HTTP.
/// 
/// Responsabilidad única: Transformar DioException en excepciones del dominio
/// que la capa de aplicación pueda entender y manejar.
/// 
/// Principios SOLID:
/// - SRP: Solo maneja errores, no hace peticiones HTTP
/// - OCP: Extensible para nuevos tipos de error sin modificar código existente
class ApiErrorHandler {
  /// Convierte un DioException en una excepción específica del dominio
  static Exception handleError(DioException error) {
    AppLogger.error(
      'DioException capturado: ${error.type}',
      error: error,
      category: AppLogger.categoryNetwork,
    );
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('La petición tardó demasiado tiempo');
        
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
        
      case DioExceptionType.cancel:
        return CancelledException('La petición fue cancelada');
        
      case DioExceptionType.connectionError:
        return ConnectionException('Error de conexión. Verifica tu internet.');
        
      case DioExceptionType.badCertificate:
        return SecurityException('Certificado SSL inválido');
        
      case DioExceptionType.unknown:
        return UnknownApiException('Error desconocido: ${error.message}');
    }
  }
  
  /// Maneja errores HTTP específicos basados en el código de estado
  static Exception _handleResponseError(Response? response) {
    if (response == null) {
      return UnknownApiException('Respuesta nula del servidor');
    }
    
    final statusCode = response.statusCode ?? 0;
    final errorData = response.data;
    
    // Intentar extraer mensaje de error del servidor
    String errorMessage = 'Error HTTP $statusCode';
    String? errorCode;
    
    if (errorData is Map<String, dynamic>) {
      errorMessage = errorData['error']?['message'] ?? 
                     errorData['message'] ?? 
                     errorMessage;
      errorCode = errorData['error']?['code'] ?? errorData['code'];
    }
    
    AppLogger.error(
      'Error HTTP $statusCode: $errorMessage (code: $errorCode)',
      category: AppLogger.categoryNetwork,
    );
    
    // Mapear códigos HTTP a excepciones específicas
    switch (statusCode) {
      case 400:
        return BadRequestException(errorMessage, errorCode: errorCode);
      case 401:
        return UnauthorizedException(errorMessage);
      case 403:
        return ForbiddenException(errorMessage);
      case 404:
        return NotFoundException(errorMessage, errorCode: errorCode);
      case 409:
        return ConflictException(errorMessage, errorCode: errorCode);
      case 500:
      case 502:
      case 503:
        return ServerException(errorMessage);
      default:
        return UnknownApiException(errorMessage);
    }
  }
}
