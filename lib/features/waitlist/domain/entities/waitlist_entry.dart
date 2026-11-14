enum WaitlistStatus { waiting, offered, booked, expired, cancelled, unknown }

/// A waitlist request for one service on one day (`/waitlist`).
class WaitlistEntry {
  const WaitlistEntry({
    required this.id,
    required this.status,
    this.statusLabel,
    required this.serviceId,
    required this.serviceName,
    this.staffName,
    required this.date,
    this.dayLabel,
    this.fromTime,
    this.toTime,
    this.notes,
    this.position,
    this.offer,
    this.bookingId,
    this.createdAt,
  });

  final int id;
  final WaitlistStatus status;
  final String? statusLabel;
  final int serviceId;
  final String serviceName;
  final String? staffName;

  /// `yyyy-MM-dd`.
  final String date;
  final String? dayLabel;
  final String? fromTime;
  final String? toTime;
  final String? notes;

  /// Place in the line, when the API reports it.
  final int? position;

  /// Present while [status] is [WaitlistStatus.offered].
  final WaitlistOffer? offer;

  /// Set once the offer was claimed.
  final int? bookingId;
  final DateTime? createdAt;

  bool get isActive => status == WaitlistStatus.waiting || status == WaitlistStatus.offered;
  bool get hasLiveOffer => status == WaitlistStatus.offered && offer != null && offer!.secondsLeft > 0;
}

/// A freed time offered to you; claim it before [secondsLeft] runs out.
class WaitlistOffer {
  const WaitlistOffer({required this.time, this.startsAt, required this.secondsLeft});

  final String time;
  final String? startsAt;
  final int secondsLeft;
}

class JoinWaitlistRequest {
  const JoinWaitlistRequest({
    required this.serviceId,
    required this.date,
    this.staffId,
    this.fromTime,
    this.toTime,
    this.notes,
  });

  final int serviceId;
  final String date;
  final int? staffId;

  /// `HH:mm`.
  final String? fromTime;
  final String? toTime;
  final String? notes;
}
