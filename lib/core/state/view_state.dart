import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/result/result.dart';

/// UI state of one async resource. Controllers expose `Rx<ViewState<T>>` and
/// views render it with `StateView`, so loading / error / empty look the same
/// on every screen.
sealed class ViewState<T> {
  const ViewState();

  /// Maps a [Result] to a state, treating [isEmpty] data as [ViewEmpty].
  factory ViewState.fromResult(Result<T> result, {bool Function(T data)? isEmpty}) =>
      result.fold(
        ViewError.new,
        (data) => (isEmpty?.call(data) ?? false) ? ViewEmpty<T>(data) : ViewSuccess<T>(data),
      );

  bool get isLoading => this is ViewLoading<T>;
  T? get dataOrNull => switch (this) {
        ViewSuccess<T>(:final data) => data,
        ViewEmpty<T>(:final data) => data,
        _ => null,
      };
}

final class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}

final class ViewSuccess<T> extends ViewState<T> {
  const ViewSuccess(this.data);
  final T data;
}

final class ViewEmpty<T> extends ViewState<T> {
  const ViewEmpty([this.data]);
  final T? data;
}

final class ViewError<T> extends ViewState<T> {
  const ViewError(this.failure);
  final Failure failure;
}
