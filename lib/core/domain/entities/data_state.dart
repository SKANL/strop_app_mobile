import 'package:freezed_annotation/freezed_annotation.dart';
import '../failures/failure.dart';

part 'data_state.freezed.dart';

/// Represents the state of data fetching operations
/// 
/// This sealed class encapsulates all possible states of an async operation:
/// - [initial]: Before any operation has started
/// - [loading]: Operation in progress
/// - [success]: Operation completed successfully with data
/// - [error]: Operation failed with a Failure
@freezed
class DataState<T> with _$DataState<T> {
  const factory DataState.initial() = _Initial<T>;
  
  const factory DataState.loading() = _Loading<T>;
  
  const factory DataState.success(T data) = _Success<T>;
  
  const factory DataState.error(Failure failure) = _Error<T>;
  
  const DataState._();
  
  /// Returns true if the state is loading
  bool get isLoading => this is _Loading<T>;
  
  /// Returns true if the state is success
  bool get isSuccess => this is _Success<T>;
  
  /// Returns true if the state is error
  bool get isError => this is _Error<T>;
  
  /// Returns true if the state is initial
  bool get isInitial => this is _Initial<T>;
  
  /// Returns the data if state is success, null otherwise
  T? get dataOrNull => maybeWhen(
        success: (data) => data,
        orElse: () => null,
      );
  
  /// Returns the failure if state is error, null otherwise
  Failure? get failureOrNull => maybeWhen(
        error: (failure) => failure,
        orElse: () => null,
      );
}
