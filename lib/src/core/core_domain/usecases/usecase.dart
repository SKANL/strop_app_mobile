// lib/src/core/core_domain/usecases/usecase.dart

/// Caso de uso base genérico
/// 
/// [T] - Tipo del resultado que retorna el caso de uso
/// [P] - Tipo de parámetros que recibe el caso de uso
abstract class UseCase<T, P> {
  /// Ejecuta el caso de uso
  Future<T> call(P params);
}

/// Caso de uso sin parámetros
abstract class UseCaseNoParams<T> {
  Future<T> call();
}
