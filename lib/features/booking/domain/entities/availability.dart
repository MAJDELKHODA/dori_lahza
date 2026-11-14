import 'package:dori_lahza/shared/domain/entities/common.dart';

/// One day of the booking day strip (`GET /availability/days`).
class AvailabilityDay {
  const AvailabilityDay({
    required this.date,
    required this.dayKey,
    required this.label,
    required this.open,
    required this.slotsCount,
    this.firstTime,
  });

  /// `yyyy-MM-dd`, sent back as `date`.
  final String date;
  final String dayKey;
  final String label;
  final bool open;
  final int slotsCount;
  final String? firstTime;

  bool get isAvailable => open && slotsCount > 0;
  DateTime? get asDate => DateTime.tryParse(date);
}

/// A bookable time (`GET /availability/slots`).
class Slot {
  const Slot({
    required this.time,
    required this.startsAt,
    this.endsAt,
    this.staff = const [],
    this.seatsLeft,
  });

  /// Display time, e.g. `09:30`.
  final String time;

  /// Sent unchanged as `starts_at` when booking.
  final String startsAt;
  final String? endsAt;

  /// Who can serve you at this time.
  final List<StaffBrief> staff;

  /// Remaining seats for group sessions.
  final int? seatsLeft;

  DateTime? get start => DateTime.tryParse(startsAt)?.toLocal();
}

class DaySlots {
  const DaySlots({required this.date, required this.slots, required this.canJoinWaitlist});

  final String date;
  final List<Slot> slots;

  /// `meta.can_join_waitlist`: the day is full but a waitlist is open.
  final bool canJoinWaitlist;
}

/// `POST /coupons/check` result.
class CouponQuote {
  const CouponQuote({
    required this.code,
    required this.discount,
    required this.finalPrice,
    this.originalPrice,
    this.message,
  });

  final String code;
  final double discount;
  final double finalPrice;
  final double? originalPrice;
  final String? message;
}
