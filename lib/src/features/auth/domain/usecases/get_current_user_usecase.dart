// lib/src/features/auth/domain/usecases/get_current_user_usecase.dart
import '../../../../core/core_domain/entities/user_entity.dart';
import '../../../../core/core_domain/repositories/auth_repository.dart';
import '../../../../core/core_domain/usecases/usecase.dart';

/// Caso de uso: Obtener el usuario actual
class GetCurrentUserUseCase extends UseCaseNoParams<UserEntity?> {
  final AuthRepository repository;
  
  GetCurrentUserUseCase(this.repository);
  
  @override
  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}
