import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> login(String email, String password) async {
    return await dataSource.login(email, password);
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await dataSource.getCurrentUser();
  }
}