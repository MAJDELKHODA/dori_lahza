import 'package:dori_lahza/core/state/paged_controller.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Infinite list bound to a [PagedController]: pull to refresh, loads the next
/// page near the end, and shows a footer spinner / retry.
class PagedListView<T> extends StatelessWidget {
  const PagedListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.loading,
    this.empty,
    this.header,
    this.padding = const EdgeInsets.fromLTRB(Gap.page, Gap.sm, Gap.page, Gap.xxl),
    this.separator = const VSpace(Gap.sm),
  });

  final PagedController<T> controller;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? loading;
  final Widget? empty;

  /// Scrolls with the list, above the items (e.g. a rating summary).
  final Widget? header;
  final EdgeInsetsGeometry padding;
  final Widget separator;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StateView<List<T>>(
        state: controller.state.value,
        loading: loading,
        empty: RefreshIndicator(
          onRefresh: () => controller.refreshList(showLoading: false),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            children: [
              ?header,
              empty ?? const EmptyView(title: 'لا يوجد محتوى بعد'),
            ],
          ),
        ),
        onRetry: controller.refreshList,
        builder: (context, _) => RefreshIndicator(
          onRefresh: () => controller.refreshList(showLoading: false),
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 400) controller.loadMore();
              return false;
            },
            child: Obx(() {
              final items = controller.items;
              final offset = header == null ? 0 : 1;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: padding,
                itemCount: items.length + offset + 1,
                separatorBuilder: (_, _) => separator,
                itemBuilder: (context, index) {
                  if (header != null && index == 0) return header!;
                  final i = index - offset;
                  if (i < items.length) return itemBuilder(context, items[i]);
                  return _Footer(controller: controller);
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Footer<T> extends StatelessWidget {
  const _Footer({required this.controller});

  final PagedController<T> controller;

  @override
  Widget build(BuildContext context) => Obx(() {
        if (controller.isLoadingMore.value) {
          return const Padding(
            padding: EdgeInsets.all(Gap.md),
            child: Center(child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2.4))),
          );
        }
        final failure = controller.loadMoreFailure.value;
        if (failure != null) {
          return ErrorView(failure: failure, onRetry: controller.loadMore, compact: true);
        }
        return const SizedBox(height: Gap.xs);
      });
}
