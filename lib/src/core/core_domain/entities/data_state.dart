// lib/src/core/core_domain/entities/data_state.dart
import '../errors/failures.dart';

/// Estado sealed para representar diferentes estados de carga de datos
/// 
/// Usado en providers para manejar estados async de forma type-safe
/// Reemplaza el uso manual de flags isLoading, error, data
sealed class DataState<T> {
  const DataState();
  
  /// Estado inicial antes de cargar datos
  const factory DataState.initial() = _Initial<T>;
  
  /// Estado de carga en progreso
  const factory DataState.loading() = _Loading<T>;
  
  /// Estado exitoso con datos
  const factory DataState.success(T data) = _Success<T>;
  
  /// Estado de error con fallo
  const factory DataState.error(Failure failure) = _Error<T>;
  
  /// Pattern matching exhaustivo
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    if (this is _Initial<T>) return initial();
    if (this is _Loading<T>) return loading();
    if (this is _Success<T>) return success((this as _Success<T>).data);
    if (this is _Error<T>) return error((this as _Error<T>).failure);
    throw Exception('Invalid DataState');
  }
  
  /// Pattern matching opcional
  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(Failure failure)? error,
    required R Function() orElse,
  }) {
    if (this is _Initial<T> && initial != null) return initial();
    if (this is _Loading<T> && loading != null) return loading();
    if (this is _Success<T> && success != null) return success((this as _Success<T>).data);
    if (this is _Error<T> && error != null) return error((this as _Error<T>).failure);
    return orElse();
  }
  
  // Helpers de verificación
  bool get isLoading => this is _Loading<T>;
  bool get isSuccess => this is _Success<T>;
  bool get isError => this is _Error<T>;
  bool get isInitial => this is _Initial<T>;
  
  // Helpers de extracción segura
  T? get dataOrNull => this is _Success<T> ? (this as _Success<T>).data : null;
  Failure? get failureOrNull => this is _Error<T> ? (this as _Error<T>).failure : null;
}

// Implementaciones privadas
class _Initial<T> extends DataState<T> {
  const _Initial();
}

class _Loading<T> extends DataState<T> {
  const _Loading();
}

class _Success<T> extends DataState<T> {
  final T data;
  const _Success(this.data);
}

class _Error<T> extends DataState<T> {
  final Failure failure;
  const _Error(this.failure);
}
