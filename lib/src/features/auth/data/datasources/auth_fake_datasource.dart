// lib/src/features/auth/data/datasources/auth_fake_datasource.dart

/// DataSource FAKE para Auth
/// 
/// Esta implementación usa datos mockeados en memoria.
/// Ventajas:
/// - No requiere API real
/// - Permite probar toda la app
/// - Fácil de reemplazar por AuthRemoteDataSource en el futuro
/// 
/// Para cambiar a API real:
/// 1. Ir a auth_di.dart
/// 2. Reemplazar registro de AuthFakeDataSource por AuthRemoteDataSource
/// 3. ¡Listo! La arquitectura garantiza que todo funcione sin cambios adicionales
library;


class AuthFakeDataSource {
  /// Base de datos fake de usuarios
  /// En producción, esto vendría de la API
  final List<Map<String, dynamic>> _fakeUsers = [
    {
      'id': '1',
      'email': 'admin@strop.com',
      'password': 'admin123',
      'name': 'Administrador Principal',
      'role': 'superadmin',
      'phone': '+52 55 1234 5678',
      'createdAt': '2024-01-01T00:00:00Z',
    },
    {
      'id': '2',
      'email': 'super@strop.com',
      'password': 'super123',
      'name': 'Superintendente García',
      'role': 'superintendent',
      'phone': '+52 55 2345 6789',
      'createdAt': '2024-01-15T00:00:00Z',
    },
    {
      'id': '3',
      'email': 'residente@strop.com',
      'password': 'residente123',
      'name': 'Residente González',
      'role': 'resident',
      'phone': '+52 55 3456 7890',
      'createdAt': '2024-02-01T00:00:00Z',
    },
    {
      'id': '4',
      'email': 'cabo@strop.com',
      'password': 'cabo123',
      'name': 'Cabo López',
      'role': 'cabo',
      'phone': '+52 55 4567 8901',
      'createdAt': '2024-02-15T00:00:00Z',
    },
  ];

  /// Usuario actualmente autenticado (simulación de sesión)
  Map<String, dynamic>? _currentUser;

  /// Token fake (simulación)
  String? _currentToken;

  /// Login con email y password
  /// Simula delay de red (500ms)
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    // Buscar usuario en la "base de datos"
    final user = _fakeUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception('Credenciales inválidas'),
    );

    // Generar token fake
    _currentToken = 'fake_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}';
    _currentUser = user;

    // Retornar respuesta simulando estructura de API
    return {
      'user': user,
      'token': _currentToken,
      'expiresIn': 86400, // 24 horas en segundos
    };
  }

  /// Logout
  /// Limpia sesión local
  Future<void> logout() async {
    // Simular delay
    await Future.delayed(const Duration(milliseconds: 300));

    _currentUser = null;
    _currentToken = null;
  }

  /// Obtener usuario actual
  /// Simula verificación de token
  Future<Map<String, dynamic>> getCurrentUser() async {
    // Simular delay
    await Future.delayed(const Duration(milliseconds: 200));

    if (_currentToken == null || _currentUser == null) {
      throw Exception('No hay sesión activa');
    }

    return _currentUser!;
  }

  /// Verificar si hay sesión activa
  Future<bool> hasActiveSession() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentToken != null && _currentUser != null;
  }

  /// Resetear password (simulado)
  /// En producción enviaría email con link
  Future<void> resetPassword(String email) async {
    // Simular delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Verificar que el email existe
    final userExists = _fakeUsers.any((u) => u['email'] == email);
    
    if (!userExists) {
      throw Exception('El correo no está registrado');
    }

    // En producción: aquí se enviaría el email
    // Por ahora solo simulamos éxito
  }

  /// Helper: Obtener token actual (para interceptors si es necesario)
  String? get currentToken => _currentToken;

  /// Helper: Hacer login directo sin password (útil para tests)
  Future<Map<String, dynamic>> loginDirect(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final user = _fakeUsers.firstWhere(
      (u) => u['id'] == userId,
      orElse: () => throw Exception('Usuario no encontrado'),
    );

    _currentToken = 'fake_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}';
    _currentUser = user;

    return {
      'user': user,
      'token': _currentToken,
      'expiresIn': 86400,
    };
  }
}
