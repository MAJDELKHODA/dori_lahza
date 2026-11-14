import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/shared/data/models/common_models.dart';

abstract final class AvailabilityModel {
  static AvailabilityDay dayFromJson(Json json) => AvailabilityDay(
        date: asString(json['date']),
        dayKey: asString(json['day']),
        label: asString(json['label']),
        open: asBool(json['open']),
        slotsCount: asInt(json['slots_count']),
        firstTime: asStringOrNull(json['first_time']),
      );

  /// Accepts a slot object or a bare `starts_at` string (alternatives).
  static Slot? slotFrom(Object? value) {
    if (value is Map) {
      final json = asJson(value);
      final startsAt = asString(json['starts_at']);
      if (startsAt.isEmpty) return null;
      return Slot(
        time: asString(json['time'], _hhmm(startsAt)),
        startsAt: startsAt,
        endsAt: asStringOrNull(json['ends_at']),
        staff: CommonMappers.staffList(json['staff']),
        seatsLeft: asIntOrNull(json['seats_left']),
      );
    }
    final startsAt = asString(value);
    return startsAt.isEmpty ? null : Slot(time: _hhmm(startsAt), startsAt: startsAt);
  }

  static List<Slot> slotList(Object? value) => asList(value).map(slotFrom).whereType<Slot>().toList();

  static DaySlots daySlots(Object? data, Json meta, String date) => DaySlots(
        date: asString(meta['date'], date),
        slots: slotList(data),
        canJoinWaitlist: asBool(meta['can_join_waitlist']),
      );

  static CouponQuote couponFromJson(Json json, String code) {
    final original = asDoubleOrNull(json['price'] ?? json['subtotal'] ?? json['original_price']);
    final discount = asDouble(json['discount'] ?? json['discount_amount']);
    return CouponQuote(
      code: asString(json['code'], code),
      discount: discount,
      originalPrice: original,
      finalPrice: asDouble(
        json['final_price'] ?? json['total'] ?? json['price_after_discount'],
        (original ?? 0) - discount,
      ),
      message: asStringOrNull(json['message'] ?? json['description'] ?? json['label']),
    );
  }

  static String _hhmm(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
