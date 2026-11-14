import 'dart:async';
import 'dart:math' as math;

import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/booking/domain/usecases/booking_usecases.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';
import 'package:get/get.dart';

/// Day strip → slots → (optional) person. Shared by new bookings and
/// rescheduling; subclasses decide what happens with the chosen slot.
abstract class SlotPickerController extends GetxController {
  SlotPickerController({
    required this.serviceId,
    required this.staffOptions,
    required GetAvailableDays getDays,
    required GetDaySlots getSlots,
    required PlaceController place,
    int? initialStaffId,
  })  : _getDays = getDays,
        _getSlots = getSlots,
        _place = place,
        staffId = RxnInt(initialStaffId);

  final int serviceId;

  /// People the user may pick; empty hides the selector.
  final List<StaffBrief> staffOptions;
  final GetAvailableDays _getDays;
  final GetDaySlots _getSlots;
  final PlaceController _place;

  /// null = "أي شخص متاح".
  final RxnInt staffId;
  final days = Rx<ViewState<List<AvailabilityDay>>>(const ViewLoading());
  final selectedDay = Rxn<AvailabilityDay>();
  final slots = Rx<ViewState<DaySlots>>(const ViewLoading());
  final selectedSlot = Rxn<Slot>();

  int _slotsRequest = 0;

  int get _windowDays => math.min(math.max(_place.rules.windowDays, 7), 30);

  bool get canContinue => selectedSlot.value != null;

  String? get staffName {
    final id = staffId.value;
    if (id == null) return null;
    return staffOptions.firstWhereOrNull((s) => s.id == id)?.name;
  }

  @override
  void onReady() {
    super.onReady();
    unawaited(loadDays());
  }

  Future<void> loadDays() async {
    days.value = const ViewLoading();
    selectedSlot.value = null;
    final result = await _getDays(AvailabilityQuery(serviceId: serviceId, staffId: staffId.value, days: _windowDays));
    days.value = ViewState.fromResult(result, isEmpty: (d) => d.isEmpty);
    final list = result.dataOrNull ?? const [];
    final keep = list.firstWhereOrNull((d) => d.date == selectedDay.value?.date && d.isAvailable);
    final first = keep ?? list.firstWhereOrNull((d) => d.isAvailable) ?? list.firstOrNull;
    if (first != null) {
      await selectDay(first);
    } else {
      selectedDay.value = null;
      slots.value = const ViewEmpty();
    }
  }

  Future<void> selectDay(AvailabilityDay day) async {
    selectedDay.value = day;
    selectedSlot.value = null;
    final request = ++_slotsRequest;
    slots.value = const ViewLoading();
    final result = await _getSlots(
      AvailabilityQuery(serviceId: serviceId, staffId: staffId.value, date: day.date),
    );
    if (request != _slotsRequest) return;
    slots.value = ViewState.fromResult(result, isEmpty: (s) => s.slots.isEmpty);
  }

  Future<void> reloadSlots() async {
    final day = selectedDay.value;
    if (day != null) await selectDay(day);
  }

  void selectStaff(int? id) {
    if (staffId.value == id) return;
    staffId.value = id;
    unawaited(loadDays());
  }

  void selectSlot(Slot slot) => selectedSlot.value = slot;

  /// Called by the view's main button once a slot is chosen.
  Future<void> submit();
}
