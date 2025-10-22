// lib/src/features/auth/domain/usecases/logout_usecase.dart
import '../../../../core/core_domain/repositories/auth_repository.dart';
import '../../../../core/core_domain/usecases/usecase.dart';

/// Caso de uso: Cerrar sesión
class LogoutUseCase extends UseCaseNoParams<void> {
  final AuthRepository repository;
  
  LogoutUseCase(this.repository);
  
  @override
  Future<void> call() async {
    return await repository.logout();
  }
}
