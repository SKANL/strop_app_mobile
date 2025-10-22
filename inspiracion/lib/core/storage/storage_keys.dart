/// Centraliza todas las keys de almacenamiento seguro.
/// 
/// Principios aplicados:
/// - DRY (Don't Repeat Yourself): Keys definidas en un solo lugar
/// - Open/Closed: Fácil agregar nuevas keys sin modificar código existente
/// - Mantenibilidad: Cambiar una key no requiere buscar strings en todo el código
/// 
/// Uso:
/// ```dart
/// await storage.write(key: StorageKeys.accessToken, value: token);
/// final token = await storage.read(key: StorageKeys.accessToken);
/// ```
class StorageKeys {
  // Constructor privado - esta es una clase de constantes
  StorageKeys._();

  // =================== Authentication Keys ===================
  
  /// JWT access token para autenticación de peticiones
  static const String accessToken = 'access_token';
  
  /// JWT refresh token para renovar el access token expirado
  static const String refreshToken = 'refresh_token';
  
  // =================== User Cache Keys ===================
  // Nota: Estos son SOLO para fallback offline temporal.
  // La fuente de verdad del User es la API (GET /auth/me)
  
  /// ID único del usuario autenticado
  static const String userId = 'user_id';
  
  /// Email del usuario autenticado
  static const String userEmail = 'user_email';
  
  /// Rol del usuario autenticado (admin, superintendent, resident, cabo)
  static const String userRole = 'user_role';
  
  /// Nombre completo del usuario autenticado (opcional)
  static const String userName = 'user_name';
  
  // =================== Settings Keys ===================
  // Reservadas para futuras funcionalidades
  
  /// Preferencia de tema (light/dark/system)
  static const String themeMode = 'theme_mode';
  
  /// Código de idioma preferido (es, en)
  static const String language = 'language';
  
  // =================== Sync Keys ===================
  // Reservadas para futuras funcionalidades de sincronización
  
  /// Timestamp de última sincronización exitosa
  static const String lastSyncTimestamp = 'last_sync_timestamp';
}
