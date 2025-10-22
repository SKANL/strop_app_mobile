// lib/src/features/auth/domain/usecases/login_usecase.dart
import '../../../../core/core_domain/entities/user_entity.dart';
import '../../../../core/core_domain/repositories/auth_repository.dart';
import '../../../../core/core_domain/usecases/usecase.dart';

/// Caso de uso: Iniciar sesión
class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  @override
  Future<UserEntity> call(LoginParams params) async {
    // Validaciones básicas
    if (!params.email.contains('@')) {
      throw Exception('Formato de email inválido');
    }
    
    if (params.password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    return await repository.login(params.email, params.password);
  }
}

/// Parámetros para el login
class LoginParams {
  final String email;
  final String password;
  
  LoginParams({
    required this.email,
    required this.password,
  });
}
