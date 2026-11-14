enum BookingStatus { pending, confirmed, checkedIn, completed, cancelled, noShow, unknown }

enum BookingScope { upcoming, past }

class Booking {
  const Booking({
    required this.id,
    required this.number,
    required this.code,
    this.qr,
    required this.status,
    required this.statusLabel,
    required this.startsAt,
    this.endsAt,
    required this.dateLabel,
    required this.dayLabel,
    required this.time,
    this.endTime,
    required this.durationMinutes,
    required this.serviceId,
    required this.serviceName,
    this.serviceImage,
    this.staffId,
    this.staffName,
    required this.price,
    required this.discount,
    required this.total,
    required this.currencySymbol,
    this.couponCode,
    this.paymentMethodLabel,
    this.notes,
    this.answers = const {},
    required this.canCancel,
    required this.canReschedule,
    required this.canReview,
    required this.cancelIsLate,
    this.timeline = const [],
    this.review,
  });

  final int id;
  final String number;

  /// Check-in code; [qr] is its QR payload.
  final String code;
  final String? qr;
  final BookingStatus status;
  final String statusLabel;
  final DateTime? startsAt;
  final DateTime? endsAt;

  /// `yyyy-MM-dd` from the API.
  final String dateLabel;
  final String dayLabel;
  final String time;
  final String? endTime;
  final int durationMinutes;
  final int serviceId;
  final String serviceName;
  final String? serviceImage;
  final int? staffId;
  final String? staffName;
  final double price;
  final double discount;
  final double total;
  final String currencySymbol;
  final String? couponCode;
  final String? paymentMethodLabel;
  final String? notes;
  final Map<String, String> answers;
  final bool canCancel;
  final bool canReschedule;
  final bool canReview;

  /// Cancelling now counts as late and lowers the reliability score.
  final bool cancelIsLate;
  final List<TimelineStep> timeline;
  final BookingReview? review;

  bool get isActive => status == BookingStatus.pending || status == BookingStatus.confirmed;
}

class TimelineStep {
  const TimelineStep({required this.status, required this.label, required this.done, this.at, this.note});

  final String status;
  final String label;
  final bool done;
  final DateTime? at;
  final String? note;
}

class BookingReview {
  const BookingReview({required this.rating, this.comment});
  final int rating;
  final String? comment;
}
