import 'package:dio/dio.dart';
import '../../config/environment.dart';
import '../../utils/app_logger.dart';

/// Interceptor para loggear todas las peticiones y respuestas HTTP
/// Solo se activa en modo desarrollo para no afectar performance en producción
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (Environment.enableDetailedLogs) {
      AppLogger.info('╔══ HTTP REQUEST ══════════════════════════════', 
        category: AppLogger.categoryNetwork);
      AppLogger.info('║ ${options.method} ${options.path}', 
        category: AppLogger.categoryNetwork);
      
      if (options.queryParameters.isNotEmpty) {
        AppLogger.info('║ Query: ${options.queryParameters}', 
          category: AppLogger.categoryNetwork);
      }
      
      if (options.data != null) {
        // Filtrar datos sensibles (passwords, tokens)
        final sanitizedData = _sanitizeData(options.data);
        AppLogger.info('║ Body: $sanitizedData', 
          category: AppLogger.categoryNetwork);
      }
      
      if (options.headers.containsKey('Authorization')) {
        final token = options.headers['Authorization'] as String;
        final truncated = token.length > 30 
          ? '${token.substring(0, 30)}...' 
          : token;
        AppLogger.info('║ Auth: $truncated', 
          category: AppLogger.categoryNetwork);
      }
      
      AppLogger.info('╚══════════════════════════════════════════════', 
        category: AppLogger.categoryNetwork);
    }
    
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (Environment.enableDetailedLogs) {
      AppLogger.info('╔══ HTTP RESPONSE ═════════════════════════════', 
        category: AppLogger.categoryNetwork);
      AppLogger.info('║ ${response.requestOptions.method} ${response.requestOptions.path}', 
        category: AppLogger.categoryNetwork);
      AppLogger.info('║ Status: ${response.statusCode}', 
        category: AppLogger.categoryNetwork);
      
      if (response.data != null) {
        final dataStr = response.data.toString();
        final truncated = dataStr.length > 200 
          ? '${dataStr.substring(0, 200)}...' 
          : dataStr;
        AppLogger.info('║ Data: $truncated', 
          category: AppLogger.categoryNetwork);
      }
      
      AppLogger.info('╚══════════════════════════════════════════════', 
        category: AppLogger.categoryNetwork);
    }
    
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (Environment.enableDetailedLogs) {
      AppLogger.error('╔══ HTTP ERROR ════════════════════════════════', 
        category: AppLogger.categoryNetwork);
      AppLogger.error('║ ${err.requestOptions.method} ${err.requestOptions.path}', 
        category: AppLogger.categoryNetwork);
      AppLogger.error('║ Status: ${err.response?.statusCode}', 
        category: AppLogger.categoryNetwork);
      AppLogger.error('║ Message: ${err.message}', 
        category: AppLogger.categoryNetwork);
      
      if (err.response?.data != null) {
        AppLogger.error('║ Response: ${err.response?.data}', 
          category: AppLogger.categoryNetwork);
      }
      
      AppLogger.error('╚══════════════════════════════════════════════', 
        category: AppLogger.categoryNetwork);
    }
    
    handler.next(err);
  }
  
  /// Ocultar datos sensibles de los logs
  dynamic _sanitizeData(dynamic data) {
    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      
      // Campos sensibles a ocultar
      const sensitiveFields = ['password', 'refreshToken', 'accessToken', 'token'];
      
      for (final field in sensitiveFields) {
        if (sanitized.containsKey(field)) {
          sanitized[field] = '***HIDDEN***';
        }
      }
      
      return sanitized;
    }
    
    return data;
  }
}
