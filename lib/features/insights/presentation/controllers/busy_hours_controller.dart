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

  BusyDay? dayOf(BusyHours data) {
    for (final d in data.days) {
      if (d.day == selectedDay.value) return d;
    }
    return data.days.isEmpty ? null : data.days.first;
  }

  /// Level label for a busy level (matches the API's own wording).
  static String levelLabel(double level) => switch (level) {
        <= 0.0 => 'هادئ',
        < 0.4 => 'خفيف',
        < 0.7 => 'متوسط',
        _ => 'مزدحم',
      };
}
