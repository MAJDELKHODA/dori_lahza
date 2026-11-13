import 'package:dori_lahza/core/result/result.dart';

/// A single application action. Use cases keep controllers free of data logic
/// and give each feature an explicit, testable list of what it can do.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Marker for use cases that take no input.
final class NoParams {
  const NoParams();
}
