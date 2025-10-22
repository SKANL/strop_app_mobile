// lib/src/features/auth/data/datasources/auth_remote_datasource.dart
import '../../../../core/core_network/dio_client.dart';
import '../../../../core/core_domain/errors/exceptions.dart';
import '../models/user_model.dart';

/// DataSource remoto para autenticación
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> resetPassword(String email);
}

/// Implementación del DataSource remoto
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;
  
  AuthRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
  final data = response.data['data'];
  final userData = data['user'];
      
      // TODO: Guardar tokens con flutter_secure_storage
      // await _secureStorage.write(key: 'accessToken', value: tokens['accessToken']);
      // await _secureStorage.write(key: 'refreshToken', value: tokens['refreshToken']);
      
      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException('Error al iniciar sesión: ${e.toString()}');
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await client.post('/auth/logout');
      
      // TODO: Limpiar tokens
      // await _secureStorage.deleteAll();
    } catch (e) {
      // Aunque falle el logout en servidor, limpiamos localmente
      // await _secureStorage.deleteAll();
      throw ServerException('Error al cerrar sesión: ${e.toString()}');
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // TODO: Verificar si hay token
      // final token = await _secureStorage.read(key: 'accessToken');
      // if (token == null) return null;
      
      final response = await client.get('/auth/me');
      final userData = response.data['data'];
      
      return UserModel.fromJson(userData);
    } on AuthException {
      // Token inválido, retornar null
      return null;
    } catch (e) {
      throw ServerException('Error al obtener usuario actual: ${e.toString()}');
    }
  }
  
  @override
  Future<void> resetPassword(String email) async {
    try {
      await client.post(
        '/auth/reset-password',
        data: {'email': email},
      );
    } catch (e) {
      throw ServerException('Error al enviar correo de recuperación: ${e.toString()}');
    }
  }
}
