import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

/// Body of `POST /bookings`.
class NewBooking {
  const NewBooking({
    required this.serviceId,
    required this.startsAt,
    this.staffId,
    this.notes,
    this.answers = const {},
    this.couponCode,
    this.paymentMethod = 'cash',
  });

  final int serviceId;
  final String startsAt;

  /// null = "أي شخص متاح".
  final int? staffId;
  final String? notes;

  /// Answers to `booking.intake_fields`, keyed by field key.
  final Map<String, Object?> answers;
  final String? couponCode;
  final String paymentMethod;
}

abstract interface class BookingRepository {
  Future<Result<List<AvailabilityDay>>> days({required int serviceId, int? staffId, required int days});

  Future<Result<DaySlots>> slots({required int serviceId, required String date, int? staffId});

  Future<Result<CouponQuote>> checkCoupon({required String code, required int serviceId});

  /// Fails with `SlotUnavailableFailure` when the time was taken meanwhile.
  Future<Result<Booking>> create(NewBooking booking);
}
