import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:flutter/material.dart';

/// Renders a [ViewState]: [loading] (skeleton) → [builder] / [empty] /
/// error with retry. Wrap in `Obx` at the call site.
class StateView<T> extends StatelessWidget {
  const StateView({
    super.key,
    required this.state,
    required this.builder,
    this.loading,
    this.empty,
    this.onRetry,
    this.compact = false,
  });

  final ViewState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loading;
  final Widget? empty;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final child = switch (state) {
      ViewLoading<T>() => loading ?? const SkeletonList(),
      ViewSuccess<T>(:final data) => builder(context, data),
      ViewEmpty<T>() => empty ?? const EmptyView(title: 'لا يوجد محتوى بعد'),
      ViewError<T>(:final failure) => ErrorView(failure: failure, onRetry: onRetry, compact: compact),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: KeyedSubtree(key: ValueKey(state.runtimeType), child: child),
    );
  }
}
