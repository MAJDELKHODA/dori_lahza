import 'dart:async';

import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/state/paged_controller.dart';
import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/domain/usecases/services_usecases.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';
import 'package:dori_lahza/features/staff/domain/usecases/staff_usecases.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Services tab: categories, text search (debounced) and filters, all
/// backed by `GET /services`.
class ServicesController extends PagedController<Service> {
  ServicesController({
    required SearchServices searchServices,
    required GetCategories getCategories,
    required GetTeam getTeam,
  })  : _search = searchServices,
        _getCategories = getCategories,
        _getTeam = getTeam;

  final SearchServices _search;
  final GetCategories _getCategories;
  final GetTeam _getTeam;

  static const durationOptions = [30, 60, 90, 120];

  final filter = const ServiceFilter().obs;
  final categories = Rx<ViewState<List<Category>>>(const ViewLoading());
  final team = Rx<ViewState<List<StaffMember>>>(const ViewLoading());

  final searchText = TextEditingController();
  final searchFocus = FocusNode();
  final hasQuery = false.obs;
  Worker? _debounce;

  @override
  void onInit() {
    super.onInit();
    final query = ''.obs;
    searchText.addListener(() {
      query.value = searchText.text;
      hasQuery.value = searchText.text.isNotEmpty;
    });
    _debounce = debounce<String>(
      query,
      (q) {
        if (q.trim() != filter.value.query.trim()) _apply(filter.value.copyWith(query: q));
      },
      time: const Duration(milliseconds: 450),
    );
  }

  @override
  void onReady() {
    super.onReady();
    unawaited(loadCategories());
  }

  @override
  Future<Result<Paginated<Service>>> fetchPage(int page) =>
      _search(SearchServicesParams(filter.value, page: page));

  Future<void> loadCategories() async {
    categories.value = const ViewLoading();
    categories.value = ViewState.fromResult(await _getCategories(), isEmpty: (c) => c.isEmpty);
  }

  /// Team for the "by person" filter; loaded the first time the sheet opens.
  Future<void> loadTeamIfNeeded() async {
    if (team.value is ViewSuccess) return;
    team.value = const ViewLoading();
    team.value = ViewState.fromResult(await _getTeam(), isEmpty: (t) => t.isEmpty);
  }

  void selectCategory(int? categoryId) {
    if (filter.value.categoryId == categoryId) return;
    _apply(filter.value.copyWith(categoryId: () => categoryId));
  }

  /// Edited copy of [filter] while the filter sheet is open.
  final draft = const ServiceFilter().obs;

  void beginEditingFilters() {
    draft.value = filter.value;
    unawaited(loadTeamIfNeeded());
  }

  void editDraft(ServiceFilter Function(ServiceFilter current) change) => draft.value = change(draft.value);

  void resetDraft() => draft.value = draft.value.clearAdvanced();

  void applyDraft() => _apply(draft.value.copyWith(query: filter.value.query));

  void clearFilters() => _apply(filter.value.clearAdvanced());

  void clearSearch() {
    searchText.clear();
    _apply(filter.value.copyWith(query: ''));
  }

  void requestSearchFocus() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => searchFocus.requestFocus());

  void _apply(ServiceFilter value) {
    filter.value = value;
    unawaited(refreshList());
  }

  @override
  void onClose() {
    _debounce?.dispose();
    searchText.dispose();
    searchFocus.dispose();
    super.onClose();
  }
}
