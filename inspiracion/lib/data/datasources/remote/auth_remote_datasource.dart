import '../../../core/api/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/entities/user_entity.dart';
import '../../models/user_model.dart';

/// Interfaz para la fuente de datos de autenticación
abstract class AuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

/// Implementación real de AuthDataSource usando la API REST
/// 
/// Endpoints:
/// - POST /auth/login
/// - POST /auth/logout  
/// - GET /auth/me
class AuthRemoteDataSource implements AuthDataSource {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  
  AuthRemoteDataSource(this._apiClient, this._tokenStorage);
  
  @override
  Future<UserModel> login(String email, String password) async {
    AppLogger.info('═══ AuthRemoteDataSource.login() ═══', category: AppLogger.categoryAuth);
    AppLogger.info('Email: $email', category: AppLogger.categoryAuth);
    
    try {
      // POST /auth/login
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      // Extraer datos de la respuesta
      final data = response.data['data'];
      final userData = data['user'];
      final tokensData = data['tokens'];
      
      // Guardar tokens y caché de usuario en paralelo (métodos atómicos)
      await Future.wait([
        _tokenStorage.saveAccessToken(tokensData['accessToken']),
        _tokenStorage.saveRefreshToken(tokensData['refreshToken']),
        _tokenStorage.saveUserId(userData['id']),
        _tokenStorage.saveUserEmail(userData['email']),
        _tokenStorage.saveUserRole(userData['role']),
      ]);
      
      // Convertir a modelo
      final user = UserModel.fromJson(userData);
      
      AppLogger.info('✓ Login exitoso: ${user.name} (${user.role})', 
        category: AppLogger.categoryAuth);
      
      return user;
      
    } on ApiException catch (e) {
      AppLogger.error('Error en login (API)', error: e, category: AppLogger.categoryAuth);
      
      // Convertir excepciones de API a mensajes amigables
      if (e is UnauthorizedException) {
        throw Exception('Email o contraseña incorrectos');
      } else if (e is ConnectionException) {
        throw Exception('No hay conexión a internet');
      } else if (e is TimeoutException) {
        throw Exception('La conexión tardó demasiado tiempo');
      } else {
        throw Exception('Error al iniciar sesión: ${e.message}');
      }
    } catch (e) {
      AppLogger.error('Error inesperado en login', error: e, category: AppLogger.categoryAuth);
      throw Exception('Error inesperado al iniciar sesión');
    }
  }
  
  @override
  Future<void> logout() async {
    AppLogger.info('═══ AuthRemoteDataSource.logout() ═══', category: AppLogger.categoryAuth);
    
    try {
      // POST /auth/logout
      await _apiClient.post('/auth/logout');
      
      AppLogger.info('✓ Logout exitoso en servidor', category: AppLogger.categoryAuth);
      
    } on ApiException catch (e) {
      // Aunque falle el logout en el servidor, continuamos con la limpieza local
      AppLogger.warning('Error al hacer logout en servidor (continuando): ${e.message}', 
        category: AppLogger.categoryAuth);
    } catch (e) {
      AppLogger.error('Error inesperado en logout (continuando)', 
        category: AppLogger.categoryAuth, error: e);
    } finally {
      // SIEMPRE limpiar tokens locales
      await _tokenStorage.clearAll();
      AppLogger.info('✓ Tokens locales eliminados', category: AppLogger.categoryAuth);
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    AppLogger.info('═══ AuthRemoteDataSource.getCurrentUser() ═══', 
      category: AppLogger.categoryAuth);
    
    try {
      // Verificar si hay token guardado
      final hasToken = await _tokenStorage.hasAccessToken();
      if (!hasToken) {
        AppLogger.info('No hay token guardado. Usuario no autenticado.', 
          category: AppLogger.categoryAuth);
        return null;
      }
      
      // GET /auth/me
      final response = await _apiClient.get('/auth/me');
      
      final userData = response.data['data'];
      final user = UserModel.fromJson(userData);
      
      AppLogger.info('✓ Usuario actual obtenido: ${user.name} (${user.role})', 
        category: AppLogger.categoryAuth);
      
      return user;
      
    } on UnauthorizedException {
      // Token inválido o expirado
      AppLogger.warning('Token inválido. Usuario debe hacer login nuevamente.', 
        category: AppLogger.categoryAuth);
      
      // Limpiar tokens inválidos
      await _tokenStorage.clearAll();
      return null;
      
    } on ConnectionException {
      // Sin conexión - intentar obtener datos guardados localmente
      AppLogger.warning('Sin conexión. Intentando obtener datos locales...', 
        category: AppLogger.categoryAuth);
      
      final userId = await _tokenStorage.getUserId();
      final email = await _tokenStorage.getUserEmail();
      final roleStr = await _tokenStorage.getUserRole();
      
      if (userId != null && email != null && roleStr != null) {
        // Convertir string a UserRole enum
        final role = _parseUserRole(roleStr);
        
        final user = UserModel(
          id: userId,
          name: email.split('@').first, // Extraer nombre del email
          email: email,
          role: role,
        );
        
        AppLogger.info('✓ Usuario obtenido desde caché local: ${user.email}', 
          category: AppLogger.categoryAuth);
        
        return user;
      }
      
      return null;
      
    } on ApiException catch (e) {
      AppLogger.error('Error en getCurrentUser (API)', 
        category: AppLogger.categoryAuth, error: e);
      return null;
    } catch (e) {
      AppLogger.error('Error inesperado en getCurrentUser', 
        category: AppLogger.categoryAuth, error: e);
      return null;
    }
  }
  
  /// Convertir string a UserRole enum
  UserRole _parseUserRole(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'superintendent':
        return UserRole.superintendent;
      case 'resident':
        return UserRole.resident;
      case 'cabo':
        return UserRole.cabo;
      default:
        AppLogger.warning('Rol desconocido: $roleStr. Usando resident por defecto.', 
          category: AppLogger.categoryAuth);
        return UserRole.resident;
    }
  }
}
