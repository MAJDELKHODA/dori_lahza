import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/slot_picker_controller.dart';
import 'package:dori_lahza/features/booking/presentation/models/booking_draft.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:get/get.dart';

/// First booking step: pick person, day and time for [service].
class BookingSlotsController extends SlotPickerController {
  BookingSlotsController({
    required this.service,
    required super.getDays,
    required super.getSlots,
    required super.place,
  }) : super(serviceId: service.id, staffOptions: service.staff);

  final Service service;

  @override
  Future<void> submit() async {
    final slot = selectedSlot.value;
    final day = selectedDay.value;
    if (slot == null || day == null) return;
    await Get.toNamed<void>(
      AppRoutes.bookingConfirm,
      arguments: BookingDraft(
        service: service,
        day: day,
        slot: slot,
        staffId: staffId.value,
        staffName: staffName,
      ),
    );
  }
}
