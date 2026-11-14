import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/slot_picker_controller.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/usecases/bookings_usecases.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';
import 'package:get/get.dart';

/// Pick a new time for an existing booking; pops with the updated [Booking].
class RescheduleController extends SlotPickerController {
  RescheduleController({
    required this.booking,
    required RescheduleBooking rescheduleBooking,
    required super.getDays,
    required super.getSlots,
    required super.place,
  })  : _reschedule = rescheduleBooking,
        super(
          serviceId: booking.serviceId,
          initialStaffId: booking.staffId,
          staffOptions: [
            if (booking.staffId != null) StaffBrief(id: booking.staffId!, name: booking.staffName ?? '', initials: (booking.staffName ?? '؟').substring(0, 1)),
          ],
        );

  final Booking booking;
  final RescheduleBooking _reschedule;

  final isSubmitting = false.obs;

  @override
  Future<void> submit() async {
    final slot = selectedSlot.value;
    if (slot == null || isSubmitting.value) return;
    isSubmitting.value = true;
    final result = await _reschedule((id: booking.id, startsAt: slot.startsAt, staffId: staffId.value));
    isSubmitting.value = false;
    result.fold(
      (failure) {
        AppFeedback.failure(failure);
        // The time may have just been taken; refresh what is available.
        reloadSlots();
      },
      (updated) {
        Get.back(result: updated);
        AppFeedback.success('تم تغيير الموعد');
      },
    );
  }
}
