import '../utils/app_logger.dart';
import 'secure_storage_interface.dart';
import 'storage_keys.dart';

/// Servicio especializado en gestión segura de tokens y caché de usuario.
///
/// Responsabilidad Única (SRP):
/// - Gestionar tokens de autenticación (access + refresh)
/// - Cachear datos mínimos de usuario para fallback offline
///
/// Principios SOLID aplicados:
/// - SRP: Solo almacenamiento de tokens y caché de usuario
/// - DIP: Depende de SecureStorageInterface (abstracción)
/// - ISP: Métodos atómicos en lugar de métodos compuestos
///
/// Nota Arquitectural:
/// Los datos de usuario aquí son SOLO caché temporal para casos offline.
/// La fuente de verdad es el backend (GET /auth/me).
///
/// Uso:
/// ```dart
/// // Guardar tokens individualmente
/// await tokenStorage.saveAccessToken(token);
/// await tokenStorage.saveRefreshToken(refreshToken);
///
/// // O componerlos en un UseCase/DataSource
/// await Future.wait([
///   tokenStorage.saveAccessToken(token),
///   tokenStorage.saveRefreshToken(refreshToken),
/// ]);
/// ```
class TokenStorage {
  final SecureStorageInterface _secureStorage;

  TokenStorage(this._secureStorage);

  // =================== ACCESS TOKEN ===================

  /// Guarda el JWT access token de forma segura.
  ///
  /// El access token es de corta duración y se usa en el header
  /// Authorization de cada petición autenticada.
  Future<void> saveAccessToken(String token) async {
    try {
      AppLogger.debug(
        '[TokenStorage] Guardando access token (${token.length} chars)...',
        category: AppLogger.categoryAuth,
      );
      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: token,
      );
      AppLogger.info(
        'Access token guardado',
        category: AppLogger.categoryAuth,
      );
      
      // Verificación inmediata (debug)
      final verification = await _secureStorage.read(key: StorageKeys.accessToken);
      AppLogger.debug(
        '[TokenStorage] Verificación inmediata: ${verification != null ? "OK" : "FALLO"}',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al guardar access token',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Obtiene el JWT access token guardado.
  ///
  /// Retorna `null` si no existe o si ocurrió un error al leer.
  Future<String?> getAccessToken() async {
    try {
      AppLogger.debug(
        '[TokenStorage] Leyendo access token...',
        category: AppLogger.categoryAuth,
      );
      final token = await _secureStorage.read(key: StorageKeys.accessToken);
      AppLogger.debug(
        '[TokenStorage] Access token leído: ${token != null ? "SÍ (${token.length} chars)" : "NULL"}',
        category: AppLogger.categoryAuth,
      );
      return token;
    } catch (e, st) {
      AppLogger.error(
        'Error al leer access token',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Verifica si existe un access token válido (no vacío).
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Elimina el access token del almacenamiento seguro.
  Future<void> deleteAccessToken() async {
    try {
      await _secureStorage.delete(key: StorageKeys.accessToken);
      AppLogger.info(
        'Access token eliminado',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al eliminar access token',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // =================== REFRESH TOKEN ===================

  /// Guarda el JWT refresh token de forma segura.
  ///
  /// El refresh token es de larga duración y se usa para obtener
  /// un nuevo access token cuando este expira.
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: StorageKeys.refreshToken,
        value: token,
      );
      AppLogger.info(
        'Refresh token guardado',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al guardar refresh token',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Obtiene el JWT refresh token guardado.
  ///
  /// Retorna `null` si no existe o si ocurrió un error al leer.
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: StorageKeys.refreshToken);
    } catch (e, st) {
      AppLogger.error(
        'Error al leer refresh token',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Elimina el refresh token del almacenamiento seguro.
  Future<void> deleteRefreshToken() async {
    try {
      await _secureStorage.delete(key: StorageKeys.refreshToken);
      AppLogger.info(
        'Refresh token eliminado',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al eliminar refresh token',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // =================== USER CACHE (Fallback Offline) ===================

  /// Guarda el user ID en caché.
  ///
  /// Nota: Esto es SOLO para fallback offline. El User completo
  /// debe obtenerse desde la API (GET /auth/me).
  Future<void> saveUserId(String userId) async {
    try {
      await _secureStorage.write(
        key: StorageKeys.userId,
        value: userId,
      );
      AppLogger.debug(
        'User ID cacheado: $userId',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al guardar user ID',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Obtiene el user ID desde la caché.
  Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: StorageKeys.userId);
    } catch (e, st) {
      AppLogger.error(
        'Error al leer user ID',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Guarda el email del usuario en caché.
  Future<void> saveUserEmail(String email) async {
    try {
      await _secureStorage.write(
        key: StorageKeys.userEmail,
        value: email,
      );
      AppLogger.debug(
        'User email cacheado: $email',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al guardar user email',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Obtiene el email del usuario desde la caché.
  Future<String?> getUserEmail() async {
    try {
      return await _secureStorage.read(key: StorageKeys.userEmail);
    } catch (e, st) {
      AppLogger.error(
        'Error al leer user email',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Guarda el rol del usuario en caché.
  Future<void> saveUserRole(String role) async {
    try {
      await _secureStorage.write(
        key: StorageKeys.userRole,
        value: role,
      );
      AppLogger.debug(
        'User role cacheado: $role',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al guardar user role',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Obtiene el rol del usuario desde la caché.
  Future<String?> getUserRole() async {
    try {
      return await _secureStorage.read(key: StorageKeys.userRole);
    } catch (e, st) {
      AppLogger.error(
        'Error al leer user role',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Guarda el nombre del usuario en caché (opcional).
  Future<void> saveUserName(String name) async {
    try {
      await _secureStorage.write(
        key: StorageKeys.userName,
        value: name,
      );
      AppLogger.debug(
        'User name cacheado: $name',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al guardar user name',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Obtiene el nombre del usuario desde la caché.
  Future<String?> getUserName() async {
    try {
      return await _secureStorage.read(key: StorageKeys.userName);
    } catch (e, st) {
      AppLogger.error(
        'Error al leer user name',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  // =================== CLEAR OPERATIONS ===================

  /// Elimina TODOS los tokens del almacenamiento.
  ///
  /// Útil al hacer logout completo.
  Future<void> clearTokens() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
    ]);
    AppLogger.info(
      'Tokens eliminados',
      category: AppLogger.categoryAuth,
    );
  }

  /// Elimina TODA la caché de usuario.
  Future<void> clearUserCache() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: StorageKeys.userId),
        _secureStorage.delete(key: StorageKeys.userEmail),
        _secureStorage.delete(key: StorageKeys.userRole),
        _secureStorage.delete(key: StorageKeys.userName),
      ]);
      AppLogger.info(
        'Caché de usuario eliminada',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al limpiar caché de usuario',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Elimina TODO: tokens + caché de usuario.
  ///
  /// Úsalo al hacer logout o cuando el usuario cierra sesión.
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      AppLogger.info(
        'Todo el almacenamiento de auth limpiado',
        category: AppLogger.categoryAuth,
      );
    } catch (e, st) {
      AppLogger.error(
        'Error al limpiar todo el almacenamiento',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // =================== CONVENIENCE METHODS ===================

  /// Verifica si el usuario está autenticado (tiene ambos tokens).
  Future<bool> isAuthenticated() async {
    try {
      final hasAccess = await hasAccessToken();
      final refreshToken = await getRefreshToken();
      return hasAccess && refreshToken != null && refreshToken.isNotEmpty;
    } catch (e, st) {
      AppLogger.error(
        'Error al verificar autenticación',
        category: AppLogger.categoryAuth,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }
}
