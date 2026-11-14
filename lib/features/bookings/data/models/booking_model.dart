import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

abstract final class BookingModel {
  static Booking fromJson(Json json) {
    final service = asJson(json['service']);
    final staff = asJson(json['staff']);
    final review = asJsonOrNull(json['review']);
    return Booking(
      id: asInt(json['id']),
      number: asString(json['number']),
      code: asString(json['code']),
      qr: asStringOrNull(json['qr']),
      status: _status(asString(json['status'])),
      statusLabel: asString(json['status_label']),
      startsAt: asDateTimeOrNull(json['starts_at']),
      endsAt: asDateTimeOrNull(json['ends_at']),
      dateLabel: asString(json['date']),
      dayLabel: asString(json['day_label']),
      time: asString(json['time']),
      endTime: asStringOrNull(json['end_time']),
      durationMinutes: asInt(json['duration_minutes']),
      serviceId: asInt(json['service_id'] ?? service['id']),
      serviceName: asString(json['service_name'] ?? service['name']),
      serviceImage: asStringOrNull(json['service_image'] ?? service['thumb'] ?? service['image']),
      staffId: asIntOrNull(json['staff_id'] ?? staff['id']),
      staffName: asStringOrNull(json['staff_name'] ?? staff['name']),
      price: asDouble(json['price']),
      discount: asDouble(json['discount']),
      total: asDouble(json['total'] ?? json['price']),
      currencySymbol: asString(json['currency_symbol'], '₪'),
      couponCode: asStringOrNull(json['coupon_code']),
      paymentMethodLabel: asStringOrNull(json['payment_method_label']),
      notes: asStringOrNull(json['notes']),
      answers: _answers(json['answers']),
      canCancel: asBool(json['can_cancel']),
      canReschedule: asBool(json['can_reschedule']),
      canReview: asBool(json['can_review']),
      cancelIsLate: asBool(json['cancel_is_late']),
      timeline: asListOf(
        json['timeline'],
        (t) => TimelineStep(
          status: asString(t['status']),
          label: asString(t['label']),
          done: asBool(t['done']),
          at: asDateTimeOrNull(t['at']),
          note: asStringOrNull(t['note']),
        ),
      ),
      review: review == null
          ? null
          : BookingReview(rating: asInt(review['rating']), comment: asStringOrNull(review['comment'])),
    );
  }

  /// `answers` may be `{key: value}` or `[{label, value}]`.
  static Map<String, String> _answers(Object? value) {
    if (value is Map) {
      return asJson(value).map((k, v) => MapEntry(k, asString(v)))..removeWhere((_, v) => v.isEmpty);
    }
    return {
      for (final a in asListOf(value, (j) => j))
        asString(a['label'] ?? a['key']): asString(a['value']),
    }..removeWhere((k, v) => k.isEmpty || v.isEmpty);
  }

  static BookingStatus _status(String value) => switch (value) {
        'pending' => BookingStatus.pending,
        'confirmed' => BookingStatus.confirmed,
        'checked_in' || 'arrived' || 'in_progress' => BookingStatus.checkedIn,
        'completed' || 'done' => BookingStatus.completed,
        'cancelled' || 'canceled' => BookingStatus.cancelled,
        'no_show' => BookingStatus.noShow,
        _ => BookingStatus.unknown,
      };
}
