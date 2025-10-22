// lib/src/core/core_domain/repositories/auth_repository.dart
import '../entities/user_entity.dart';

/// Contrato de repositorio de autenticación - Core Domain
/// 
/// Este es un contrato compartido que define las operaciones de auth.
/// Las features pueden implementar este contrato o consumirlo.
abstract class AuthRepository {
  /// Iniciar sesión con credenciales
  Future<UserEntity> login(String email, String password);
  
  /// Cerrar sesión
  Future<void> logout();
  
  /// Obtener el usuario actualmente autenticado
  Future<UserEntity?> getCurrentUser();
  
  /// Verificar si hay una sesión activa
  Future<bool> isAuthenticated();
  
  /// Recuperar contraseña
  Future<void> resetPassword(String email);
  
  /// Cambiar contraseña
  Future<void> changePassword(String oldPassword, String newPassword);
}
