/// Represents a value of one of two possible types (a disjoint union)
/// An instance of [Either] is either a [Left] or a [Right]
/// 
/// By convention:
/// - [Left] is used for failure cases
/// - [Right] is used for success cases
sealed class Either<L, R> {
  const Either();
  
  /// Creates a Left value
  const factory Either.left(L value) = Left<L, R>;
  
  /// Creates a Right value
  const factory Either.right(R value) = Right<L, R>;
  
  /// Returns true if this is a Right value
  bool get isRight => this is Right<L, R>;
  
  /// Returns true if this is a Left value
  bool get isLeft => this is Left<L, R>;
  
  /// Transforms the Right value using the provided function
  /// If this is a Left, returns the Left unchanged
  Either<L, R2> map<R2>(R2 Function(R) fn) {
    return switch (this) {
      Left(:final value) => Left(value),
      Right(:final value) => Right(fn(value)),
    };
  }
  
  /// Transforms the Left value using the provided function
  /// If this is a Right, returns the Right unchanged
  Either<L2, R> mapLeft<L2>(L2 Function(L) fn) {
    return switch (this) {
      Left(:final value) => Left(fn(value)),
      Right(:final value) => Right(value),
    };
  }
  
  /// Applies the appropriate function based on whether this is Left or Right
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    return switch (this) {
      Left(:final value) => leftFn(value),
      Right(:final value) => rightFn(value),
    };
  }
  
  /// Returns the Right value or null if this is a Left
  R? get rightOrNull => switch (this) {
        Right(:final value) => value,
        _ => null,
      };
  
  /// Returns the Left value or null if this is a Right
  L? get leftOrNull => switch (this) {
        Left(:final value) => value,
        _ => null,
      };
  
  /// Returns the Right value or throws if this is a Left
  R get right => switch (this) {
        Right(:final value) => value,
        Left(:final value) =>
          throw Exception('Called right on Left value: $value'),
      };
  
  /// Returns the Left value or throws if this is a Right
  L get left => switch (this) {
        Left(:final value) => value,
        Right(:final value) =>
          throw Exception('Called left on Right value: $value'),
      };
}

/// Represents the Left side of [Either]
final class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  
  final L value;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Left && runtimeType == other.runtimeType && value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'Left($value)';
}

/// Represents the Right side of [Either]
final class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  
  final R value;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Right &&
          runtimeType == other.runtimeType &&
          value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'Right($value)';
}
