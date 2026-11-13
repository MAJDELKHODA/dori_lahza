import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/booking/availability_day_model.dart';
import '../../data/models/booking/availability_slot_model.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/models/booking/booking_model.dart';

class BookingController extends GetxController {
  final BookingRepository _repository;
  final int serviceId;

  BookingController({
    required BookingRepository repository,
    required this.serviceId,
  }) : _repository = repository;
  // Create Booking

  final RxBool isCreatingBooking = false.obs;

  final Rxn<BookingModel> createdBooking = Rxn<BookingModel>();

  final RxString createBookingError = ''.obs;

  // Days

  final RxList<AvailabilityDayModel> days = <AvailabilityDayModel>[].obs;

  final Rxn<AvailabilityDayModel> selectedDay = Rxn<AvailabilityDayModel>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Time Slots

  final RxList<AvailabilitySlotModel> slots = <AvailabilitySlotModel>[].obs;

  final Rxn<AvailabilitySlotModel> selectedSlot = Rxn<AvailabilitySlotModel>();

  final RxBool isLoadingSlots = false.obs;
  final RxString slotsError = ''.obs;

  // Selected Staff

  final RxnInt selectedStaffId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchAvailabilityDays();
  }

  // Fetch Days

  Future<void> fetchAvailabilityDays() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getAvailabilityDays(
        serviceId: serviceId,
        days: 14,
      );

      days.assignAll(result);

      AvailabilityDayModel? firstAvailable;

      for (final day in result) {
        if (day.isAvailable) {
          firstAvailable = day;
          break;
        }
      }

      selectedDay.value =
          firstAvailable ?? (result.isNotEmpty ? result.first : null);

      if (firstAvailable != null) {
        await fetchAvailabilitySlots(firstAvailable.date);
      }
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'حدث خطأ أثناء تحميل المواعيد';
    } finally {
      isLoading.value = false;
    }
  }

  // Select Day

  Future<void> selectDay(AvailabilityDayModel day) async {
    selectedDay.value = day;

    selectedSlot.value = null;
    selectedStaffId.value = null;
    slots.clear();
    slotsError.value = '';

    if (day.isAvailable) {
      await fetchAvailabilitySlots(day.date);
    }
  }

  // Fetch Slots

  Future<void> fetchAvailabilitySlots(String date, {int? staffId}) async {
    try {
      isLoadingSlots.value = true;
      slotsError.value = '';

      final result = await _repository.getAvailabilitySlots(
        serviceId: serviceId,
        date: date,
        staffId: staffId,
      );

      slots.assignAll(result);
    } on ApiException catch (error) {
      slotsError.value = error.message;
    } catch (_) {
      slotsError.value = 'حدث خطأ أثناء تحميل الأوقات';
    } finally {
      isLoadingSlots.value = false;
    }
  }

  // Select Slot
  void selectSlot(AvailabilitySlotModel slot) {
    selectedSlot.value = slot;

    if (slot.staff.length == 1) {
      selectedStaffId.value = slot.staff.first.id;
    } else {
      selectedStaffId.value = null;
    }
  }

  // Select Staff

  void selectStaff(int? staffId) {
    selectedStaffId.value = staffId;
  }

  // Clear Selection

  void clearSelection() {
    selectedSlot.value = null;
    selectedStaffId.value = null;
  }

  Future<bool> createBooking({
    required String startsAt,
    String? notes,
    Map<String, dynamic> answers = const {},
    String? couponCode,
    String paymentMethod = 'cash',
  }) async {
    if (isCreatingBooking.value) return false;

    try {
      isCreatingBooking.value = true;
      createBookingError.value = '';

      final result = await _repository.createBooking(
        serviceId: serviceId,
        staffId: selectedStaffId.value,
        startsAt: startsAt,
        notes: notes,
        answers: answers,
        couponCode: couponCode,
        paymentMethod: paymentMethod,
      );

      createdBooking.value = result;

      return true;
    } on ApiException catch (error) {
      createBookingError.value = error.message;
      return false;
    } catch (_) {
      createBookingError.value = 'حدث خطأ أثناء تأكيد الحجز';
      return false;
    } finally {
      isCreatingBooking.value = false;
    }
  }
}
