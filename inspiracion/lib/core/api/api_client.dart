import 'package:dio/dio.dart';
import '../config/environment.dart';
import '../storage/token_storage.dart';
import '../utils/app_logger.dart';
import 'api_error_handler.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

// Re-exportar excepciones para mantener compatibilidad con código existente
export 'api_exceptions.dart';

/// Cliente HTTP centralizado usando Dio.
///
/// Responsabilidad única: Wrapper limpio de Dio con manejo de errores.
///
/// Características:
/// - BaseURL configurable por entorno
/// - Interceptores para autenticación y logging
/// - Manejo automático de errores HTTP
/// - Timeouts configurables
///
/// Principios SOLID aplicados:
/// - SRP: Solo envuelve Dio y delega el manejo de errores
/// - DIP: Depende de abstracciones (TokenStorage inyectado)
/// - OCP: Extensible vía interceptores sin modificar el cliente
class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Environment.baseUrl,
        connectTimeout: Duration(milliseconds: Environment.connectTimeout),
        receiveTimeout: Duration(milliseconds: Environment.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();

    AppLogger.info(
      'ApiClient inicializado',
      category: AppLogger.categoryNetwork,
    );
    AppLogger.info(
      'BaseURL: ${Environment.baseUrl}',
      category: AppLogger.categoryNetwork,
    );
    AppLogger.info(
      'Entorno: ${Environment.environmentName}',
      category: AppLogger.categoryNetwork,
    );
  }

  /// Configurar interceptores en el orden correcto:
  /// 1. Logging (para ver todas las peticiones)
  /// 2. Auth (para añadir token y manejar renovación)
  void _setupInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(AuthInterceptor(_tokenStorage, _dio));

    AppLogger.debug(
      'Interceptores configurados: LoggingInterceptor, AuthInterceptor',
      category: AppLogger.categoryNetwork,
    );
  }

  // =================== MÉTODOS HTTP ===================

  /// Realiza una petición GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// Realiza una petición POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// Realiza una petición PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// Realiza una petición PATCH
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// Realiza una petición DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// Acceso directo a la instancia de Dio (para casos especiales)
  ///
  /// Úsalo solo cuando necesites funcionalidad avanzada de Dio
  /// que no esté cubierta por los métodos estándar.
  Dio get dio => _dio;
}
