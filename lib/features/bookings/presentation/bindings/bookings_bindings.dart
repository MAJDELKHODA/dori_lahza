import 'package:dori_lahza/features/booking/domain/repositories/booking_repository.dart';
import 'package:dori_lahza/features/booking/domain/usecases/booking_usecases.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:dori_lahza/features/bookings/domain/usecases/bookings_usecases.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/booking_details_controller.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/bookings_list_controller.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/reschedule_controller.dart';
import 'package:dori_lahza/features/bookings/presentation/models/booking_details_args.dart';
import 'package:get/get.dart';

abstract final class BookingsDependencies {
  /// "حجوزاتي" tab: one list controller per scope, tagged by scope name.
  static void registerTab() {
    for (final scope in BookingScope.values) {
      Get.lazyPut(
        () => BookingsListController(
          scope: scope,
          getMyBookings: GetMyBookings(Get.find<BookingsRepository>()),
          session: Get.find(),
        ),
        tag: scope.name,
        fenix: true,
      );
    }
  }
}

/// Tagged by booking id: details can open on top of another details page
/// (e.g. from a notification).
class BookingDetailsBinding extends Bindings {
  BookingDetailsBinding(this.args);

  final BookingDetailsArgs args;

  @override
  void dependencies() {
    final repo = Get.find<BookingsRepository>();
    Get.lazyPut(
      () => BookingDetailsController(
        args: args,
        getDetails: GetBookingDetails(repo),
        cancelBooking: CancelBooking(repo),
        reviewBooking: ReviewBooking(repo),
        session: Get.find(),
        place: Get.find(),
      ),
      tag: '${args.id}',
    );
  }
}

class RescheduleBinding extends Bindings {
  RescheduleBinding(this.booking);

  final Booking booking;

  @override
  void dependencies() {
    final availability = Get.find<BookingRepository>();
    Get.lazyPut(
      () => RescheduleController(
        booking: booking,
        rescheduleBooking: RescheduleBooking(Get.find<BookingsRepository>()),
        getDays: GetAvailableDays(availability),
        getSlots: GetDaySlots(availability),
        place: Get.find(),
      ),
    );
  }
}
