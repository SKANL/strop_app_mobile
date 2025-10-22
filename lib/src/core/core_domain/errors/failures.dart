// lib/src/core/core_domain/errors/failures.dart
import 'package:equatable/equatable.dart';

/// Clase base para todos los errores de la aplicación
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Falla de red/servidor
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Falla de caché/base de datos local
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Falla de validación
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Falla de autenticación
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Falla de permisos
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Falla de red (sin conexión)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
