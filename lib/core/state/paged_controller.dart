import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/state/view_state.dart';
import 'package:get/get.dart';

/// Base controller for paginated lists (services, reviews, bookings,
/// notifications). Subclasses only implement [fetchPage].
abstract class PagedController<T> extends GetxController {
  final state = Rx<ViewState<List<T>>>(const ViewLoading());
  final items = <T>[].obs;
  final isLoadingMore = false.obs;
  final loadMoreFailure = Rxn<Failure>();

  /// The last page received, for list-level `meta` (e.g. review distribution).
  final lastPage = Rxn<Paginated<T>>();

  int _page = 1;
  bool _hasMore = true;
  int _generation = 0;

  bool get hasMore => _hasMore;

  Future<Result<Paginated<T>>> fetchPage(int page);

  /// Whether to load the first page in [onReady]. Override to defer.
  bool get loadOnReady => true;

  @override
  void onReady() {
    super.onReady();
    if (loadOnReady) refreshList();
  }

  /// Reloads from page 1. Results of older in-flight requests are dropped.
  Future<void> refreshList({bool showLoading = true}) async {
    final generation = ++_generation;
    if (showLoading || items.isEmpty) state.value = const ViewLoading();
    loadMoreFailure.value = null;
    final result = await fetchPage(1);
    if (generation != _generation) return;
    result.fold(
      (failure) => state.value = ViewError(failure),
      (page) {
        _page = page.page;
        _hasMore = page.hasMore;
        lastPage.value = page;
        items.assignAll(page.items);
        state.value = page.items.isEmpty ? ViewEmpty(page.items) : ViewSuccess(page.items);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value || state.value is! ViewSuccess) return;
    final generation = _generation;
    isLoadingMore.value = true;
    loadMoreFailure.value = null;
    final result = await fetchPage(_page + 1);
    isLoadingMore.value = false;
    if (generation != _generation) return;
    result.fold(
      (failure) => loadMoreFailure.value = failure,
      (page) {
        _page = page.page;
        _hasMore = page.hasMore;
        lastPage.value = page;
        items.addAll(page.items);
        state.value = ViewSuccess(items.toList());
      },
    );
  }

  /// Replaces an item in place (e.g. after marking a notification as read).
  void replaceWhere(bool Function(T item) test, T Function(T item) update) {
    for (var i = 0; i < items.length; i++) {
      if (test(items[i])) items[i] = update(items[i]);
    }
    if (state.value is ViewSuccess) state.value = ViewSuccess(items.toList());
  }
}
