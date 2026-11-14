import 'dart:async';

import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';
import 'package:dori_lahza/features/insights/domain/usecases/get_busy_hours.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';
import 'package:get/get.dart';

class BusyHoursController extends GetxController {
  BusyHoursController({required GetBusyHours getBusyHours}) : _get = getBusyHours;

  final GetBusyHours _get;

  final state = Rx<ViewState<BusyHours>>(const ViewLoading());

  /// Day shown in the hourly chart; defaults to today.
  final selectedDay = DayHours.weekdayKey(DateTime.now()).obs;

  /// The full weekly grid is folded by default to keep the screen calm.
  final showWeek = false.obs;

  String get todayKey => DayHours.weekdayKey(DateTime.now());

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load() async {
    state.value = const ViewLoading();
    state.value = ViewState.fromResult(await _get(), isEmpty: (b) => b.isEmpty);
  }

  void selectDay(String day) => selectedDay.value = day;

  void toggleWeek() => showWeek.toggle();

  BusyDay? dayOf(BusyHours data) {
    for (final d in data.days) {
      if (d.day == selectedDay.value) return d;
    }
    return data.days.isEmpty ? null : data.days.first;
  }

  /// Quietest suggestion for today, otherwise the overall quietest time.
  BestTime? suggestion(BusyHours data) =>
      data.bestTimes.firstWhereOrNull((b) => b.day == todayKey) ?? data.bestTimes.firstOrNull;

  /// Quietest and busiest open hours of [day] (null when closed all day).
  ({BusyHour? quiet, BusyHour? peak}) extremes(BusyDay? day) {
    final open = day?.hours.where((h) => h.open).toList() ?? const <BusyHour>[];
    if (open.isEmpty) return (quiet: null, peak: null);
    final quiet = open.reduce((a, b) => b.level < a.level ? b : a);
    final peak = open.reduce((a, b) => b.level > a.level ? b : a);
    // A flat day has no meaningful peak.
    return (quiet: quiet, peak: peak.level > quiet.level ? peak : null);
  }

  /// Level wording for a busy level.
  static String levelLabel(double level) => switch (level) {
        <= 0.0 => 'هادئ',
        < 0.4 => 'خفيف',
        < 0.7 => 'متوسط',
        _ => 'مزدحم',
      };
}
