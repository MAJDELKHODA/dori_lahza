import 'package:dori_lahza/core/error/failure.dart';

/// Either-like result returned by every repository and use case.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = FailureResult<T>;

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) =>
      switch (this) {
        Success<T>(:final data) => onSuccess(data),
        FailureResult<T>(:final failure) => onFailure(failure),
      };

  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success<T>(:final data) => Result.success(transform(data)),
        FailureResult<T>(:final failure) => Result.failure(failure),
      };

  bool get isSuccess => this is Success<T>;
  T? get dataOrNull => switch (this) { Success<T>(:final data) => data, _ => null };
  Failure? get failureOrNull =>
      switch (this) { FailureResult<T>(:final failure) => failure, _ => null };
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}
