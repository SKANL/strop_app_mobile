// lib/src/features/auth/domain/usecases/reset_password_usecase.dart
import '../../../../core/core_domain/repositories/auth_repository.dart';
import '../../../../core/core_domain/usecases/usecase.dart';

/// Caso de uso: Recuperar contraseña
class ResetPasswordUseCase extends UseCase<void, String> {
  final AuthRepository repository;
  
  ResetPasswordUseCase(this.repository);
  
  @override
  Future<void> call(String email) async {
    // Validación básica
    if (!email.contains('@')) {
      throw Exception('Formato de email inválido');
    }
    
    return await repository.resetPassword(email);
  }
}
