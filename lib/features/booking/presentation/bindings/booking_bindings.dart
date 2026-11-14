import 'package:dori_lahza/features/booking/domain/repositories/booking_repository.dart';
import 'package:dori_lahza/features/booking/domain/usecases/booking_usecases.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/booking_confirm_controller.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/booking_slots_controller.dart';
import 'package:dori_lahza/features/booking/presentation/models/booking_draft.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:get/get.dart';

class BookingSlotsBinding extends Bindings {
  BookingSlotsBinding(this.service);

  final Service service;

  @override
  void dependencies() {
    final repo = Get.find<BookingRepository>();
    Get.lazyPut(
      () => BookingSlotsController(
        service: service,
        getDays: GetAvailableDays(repo),
        getSlots: GetDaySlots(repo),
        place: Get.find(),
      ),
    );
  }
}

class BookingConfirmBinding extends Bindings {
  BookingConfirmBinding(this.draft);

  final BookingDraft draft;

  @override
  void dependencies() {
    final repo = Get.find<BookingRepository>();
    Get.lazyPut(
      () => BookingConfirmController(
        draft: draft,
        checkCoupon: CheckCoupon(repo),
        createBooking: CreateBooking(repo),
        place: Get.find(),
        session: Get.find(),
      ),
    );
  }
}
