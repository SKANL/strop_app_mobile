import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Intenta iniciar sesión y devuelve el usuario si tiene éxito.
  Future<User> login(String email, String password);

  /// Cierra la sesión del usuario actual.
  Future<void> logout();

  /// Obtiene el usuario actualmente autenticado, si existe.
  Future<User?> getCurrentUser();
}