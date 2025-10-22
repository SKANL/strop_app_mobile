// lib/src/features/auth/data/repositories_impl/auth_repository_impl.dart
import '../../../../core/core_domain/entities/user_entity.dart';
import '../../../../core/core_domain/repositories/auth_repository.dart';
import '../../../../core/core_domain/errors/failures.dart';
import '../datasources/auth_fake_datasource.dart';
import '../models/user_model.dart';

/// Implementación del repositorio de autenticación con FakeDataSource
/// 
/// Para cambiar a API real:
/// 1. Importar AuthRemoteDataSource en lugar de AuthFakeDataSource
/// 2. Actualizar el constructor
/// 3. Descomentar verificación de networkInfo en cada método
/// 4. Actualizar auth_di.dart para inyectar AuthRemoteDataSource
class AuthRepositoryImpl implements AuthRepository {
  final AuthFakeDataSource fakeDataSource;
  
  AuthRepositoryImpl({
    required this.fakeDataSource,
  });
  
  @override
  Future<UserEntity> login(String email, String password) async {
    // Para API real: descomentar esta verificación
    // if (!await networkInfo.isConnected) {
    //   throw const NetworkFailure('No hay conexión a internet');
    // }
    
    try {
      final response = await fakeDataSource.login(
        email: email,
        password: password,
      );
      
      // Convertir Map a UserModel y luego a Entity
      final userModel = UserModel.fromJson(response['user']);
      return userModel.toEntity();
    } catch (e) {
      // Convertir excepción genérica a AuthFailure
      throw AuthFailure(e.toString().replaceAll('Exception: ', ''));
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await fakeDataSource.logout();
    } catch (e) {
      throw ServerFailure('Error al cerrar sesión: ${e.toString()}');
    }
  }
  
  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userData = await fakeDataSource.getCurrentUser();
      final userModel = UserModel.fromJson(userData);
      return userModel.toEntity();
    } catch (e) {
      // Si no hay sesión activa, retornar null
      return null;
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    return await fakeDataSource.hasActiveSession();
  }
  
  @override
  Future<void> resetPassword(String email) async {
    // Para API real: descomentar esta verificación
    // if (!await networkInfo.isConnected) {
    //   throw const NetworkFailure('No hay conexión a internet');
    // }
    
    try {
      await fakeDataSource.resetPassword(email);
    } catch (e) {
      throw ServerFailure(e.toString().replaceAll('Exception: ', ''));
    }
  }
  
  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    // TODO: Implementar cuando sea necesario
    throw UnimplementedError();
  }
}
