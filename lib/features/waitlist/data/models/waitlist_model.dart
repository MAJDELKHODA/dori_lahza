import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';

abstract final class WaitlistModel {
  static WaitlistEntry fromJson(Json json) {
    final service = asJson(json['service']);
    final staff = asJson(json['staff']);
    final offer = asJsonOrNull(json['offer']);
    final booking = asJsonOrNull(json['booking']);
    return WaitlistEntry(
      id: asInt(json['id']),
      status: _status(asString(json['status'])),
      statusLabel: asStringOrNull(json['status_label']),
      serviceId: asInt(json['service_id'] ?? service['id']),
      serviceName: asString(json['service_name'] ?? service['name']),
      staffName: asStringOrNull(json['staff_name'] ?? staff['name']),
      date: asString(json['date']),
      dayLabel: asStringOrNull(json['day_label']),
      fromTime: _hhmm(json['from_time']),
      toTime: _hhmm(json['to_time']),
      notes: asStringOrNull(json['notes']),
      position: asIntOrNull(json['position']),
      offer: offer == null
          ? null
          : WaitlistOffer(
              time: asString(offer['time']),
              startsAt: asStringOrNull(offer['starts_at']),
              secondsLeft: asInt(offer['seconds_left']),
            ),
      bookingId: asIntOrNull(json['booking_id'] ?? booking?['id']),
      createdAt: asDateTimeOrNull(json['created_at']),
    );
  }

  static Map<String, Object?> toJson(JoinWaitlistRequest r) => {
        'service_id': r.serviceId,
        'staff_id': r.staffId,
        'date': r.date,
        'from_time': r.fromTime,
        'to_time': r.toTime,
        'notes': r.notes,
      };

  /// `16:00:00` → `16:00`.
  static String? _hhmm(Object? value) {
    final text = asStringOrNull(value);
    if (text == null) return null;
    return text.length >= 5 ? text.substring(0, 5) : text;
  }

  static WaitlistStatus _status(String value) => switch (value) {
        'waiting' => WaitlistStatus.waiting,
        'offered' => WaitlistStatus.offered,
        'booked' => WaitlistStatus.booked,
        'expired' => WaitlistStatus.expired,
        'cancelled' || 'canceled' => WaitlistStatus.cancelled,
        _ => WaitlistStatus.unknown,
      };
}
