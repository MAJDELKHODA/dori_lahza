import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/shared/data/models/common_models.dart';

abstract final class PlaceModel {
  static Place fromJson(Json json) {
    final theme = asJson(json['theme']);
    final type = asJson(json['type']);
    return Place(
      id: asInt(json['id']),
      name: asString(json['name']),
      slug: asString(json['slug']),
      tagline: asStringOrNull(json['tagline']),
      description: asStringOrNull(json['description']),
      logo: asStringOrNull(json['logo']),
      cover: asStringOrNull(json['cover']),
      typeName: asString(type['name']),
      labels: _labels(asJson(json['labels'])),
      primaryColor: asStringOrNull(theme['primary_color']),
      contact: _contact(asJson(json['contact'])),
      openNow: asBool(json['open_now']),
      openingHours: CommonMappers.hoursList(json['opening_hours']),
      rating: CommonMappers.rating(json['rating']),
      booking: _booking(asJson(json['booking'])),
      queueEnabled: asBool(asJson(json['queue'])['enabled']),
      currency: asString(json['currency'], 'ILS'),
      currencySymbol: asString(json['currency_symbol'], '₪'),
      timezone: asString(json['timezone']),
    );
  }

  static PlaceLabels _labels(Json json) {
    const d = PlaceLabels();
    return PlaceLabels(
      staff: asString(json['staff'], d.staff),
      staffPlural: asString(json['staff_plural'], d.staffPlural),
      service: asString(json['service'], d.service),
      servicePlural: asString(json['service_plural'], d.servicePlural),
      customer: asString(json['customer'], d.customer),
      booking: asString(json['booking'], d.booking),
    );
  }

  static PlaceContact _contact(Json json) => PlaceContact(
        phone: asStringOrNull(json['phone']),
        whatsapp: asStringOrNull(json['whatsapp']),
        address: asStringOrNull(json['address']),
        latitude: asDoubleOrNull(json['latitude']),
        longitude: asDoubleOrNull(json['longitude']),
      );

  static BookingRules _booking(Json json) => BookingRules(
        windowDays: asInt(json['window_days'], 14),
        minNoticeMinutes: asInt(json['min_notice_minutes']),
        cancelBeforeHours: asInt(json['cancel_before_hours']),
        maxActiveBookings: asIntOrNull(json['max_active_bookings']),
        autoConfirm: asBool(json['auto_confirm'], true),
        intakeFields: asListOf(json['intake_fields'], _field).where((f) => f.key.isNotEmpty).toList(),
      );

  static IntakeField _field(Json json) {
    final key = asString(json['key'] ?? json['name'] ?? json['id']);
    return IntakeField(
      key: key,
      label: asString(json['label'] ?? json['title'], key),
      type: _type(asString(json['type'])),
      required: asBool(json['required']),
      options: asList(json['options']).map(_option).toList(),
      placeholder: asStringOrNull(json['placeholder']),
      help: asStringOrNull(json['help'] ?? json['hint'] ?? json['description']),
    );
  }

  /// Options may be plain strings or `{ value, label }` objects.
  static IntakeOption _option(Object? value) {
    if (value is Map) {
      final json = asJson(value);
      final v = asString(json['value'] ?? json['key'] ?? json['label']);
      return IntakeOption(value: v, label: asString(json['label'], v));
    }
    final text = asString(value);
    return IntakeOption(value: text, label: text);
  }

  static IntakeFieldType _type(String type) => switch (type) {
        'textarea' || 'longtext' => IntakeFieldType.textarea,
        'number' || 'integer' || 'numeric' => IntakeFieldType.number,
        'phone' || 'tel' => IntakeFieldType.phone,
        'email' => IntakeFieldType.email,
        'date' => IntakeFieldType.date,
        'select' || 'radio' || 'choice' => IntakeFieldType.select,
        'checkbox' || 'boolean' || 'bool' => IntakeFieldType.checkbox,
        _ => IntakeFieldType.text,
      };
}
