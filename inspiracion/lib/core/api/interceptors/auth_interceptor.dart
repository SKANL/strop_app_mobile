import 'package:dio/dio.dart';
import '../../storage/token_storage.dart';
import '../../utils/app_logger.dart';

/// Interceptor para añadir automáticamente el token JWT a las peticiones
/// y manejar la renovación automática del token cuando expira (401)
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  
  // Flag para evitar bucle infinito en refresh
  bool _isRefreshing = false;
  
  AuthInterceptor(this._tokenStorage, this._dio);
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Endpoints públicos que NO requieren autenticación
    final publicEndpoints = ['/auth/login', '/auth/refresh'];
    final isPublic = publicEndpoints.any((endpoint) => options.path.endsWith(endpoint));
    
    if (!isPublic) {
      // Añadir token a la petición
      AppLogger.debug('[AuthInterceptor] Intentando leer token para: ${options.path}', 
        category: AppLogger.categoryAuth);
      
      final accessToken = await _tokenStorage.getAccessToken();
      
      AppLogger.debug('[AuthInterceptor] Token leído: ${accessToken != null ? "SÍ (${accessToken.length} chars)" : "NULL"}', 
        category: AppLogger.categoryAuth);
      
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        AppLogger.debug('Token JWT añadido a la petición: ${options.path}', 
          category: AppLogger.categoryNetwork);
      } else {
        AppLogger.warning('No hay token disponible para la petición: ${options.path}', 
          category: AppLogger.categoryAuth);
      }
    }
    
    handler.next(options);
  }
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Manejar 401 Unauthorized (token expirado)
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      AppLogger.warning('Token expirado (401). Intentando renovar...', 
        category: AppLogger.categoryAuth);
      
      _isRefreshing = true;
      
      try {
        // Intentar renovar el token
        final refreshToken = await _tokenStorage.getRefreshToken();
        
        if (refreshToken == null) {
          AppLogger.error('No hay refresh token disponible. Usuario debe hacer login.', 
            category: AppLogger.categoryAuth);
          _isRefreshing = false;
          return handler.next(err);
        }
        
        // Llamar al endpoint de refresh
        final response = await _dio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );
        
        // Guardar nuevo access token
        final newAccessToken = response.data['data']['accessToken'];
        await _tokenStorage.saveAccessToken(newAccessToken);
        
        AppLogger.info('Token renovado correctamente', category: AppLogger.categoryAuth);
        
        // Reintentar la petición original con el nuevo token
        final originalRequest = err.requestOptions;
        originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
        
        final retryResponse = await _dio.fetch(originalRequest);
        _isRefreshing = false;
        
        return handler.resolve(retryResponse);
        
      } catch (e) {
        AppLogger.error('Error al renovar token', error: e, category: AppLogger.categoryAuth);
        _isRefreshing = false;
        
        // Si falla el refresh, limpiar tokens y forzar re-login
        await _tokenStorage.clearAll();
        return handler.next(err);
      }
    }
    
    // Otros errores pasan sin modificar
    handler.next(err);
  }
}
