import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// 
/// All failures must extend this class to ensure consistent error handling
/// throughout the application
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.statusCode,
    this.stackTrace,
  });
  
  final String message;
  final int? statusCode;
  final StackTrace? stackTrace;
  
  @override
  List<Object?> get props => [message, statusCode];
  
  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

/// Failure occurring during network operations
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'NetworkFailure(message: $message, statusCode: $statusCode)';
}

/// Failure occurring during server communication
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'ServerFailure(message: $message, statusCode: $statusCode)';
}

/// Failure occurring during local database operations
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'DatabaseFailure(message: $message)';
}

/// Failure occurring during cache operations
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'CacheFailure(message: $message)';
}

/// Failure occurring during validation
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'ValidationFailure(message: $message)';
}

/// Failure occurring during authentication
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'AuthenticationFailure(message: $message, statusCode: $statusCode)';
}

/// Failure occurring due to unauthorized access
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'UnauthorizedFailure(message: $message, statusCode: $statusCode)';
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'UnexpectedFailure(message: $message)';
}

/// Failure occurring when no internet connection is available
class NoConnectionFailure extends Failure {
  const NoConnectionFailure({
    super.message = 'No hay conexión a internet',
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'NoConnectionFailure(message: $message)';
}

/// Failure occurring during timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'La operación ha excedido el tiempo de espera',
    super.statusCode,
    super.stackTrace,
  });
  
  @override
  String toString() => 'TimeoutFailure(message: $message)';
}
