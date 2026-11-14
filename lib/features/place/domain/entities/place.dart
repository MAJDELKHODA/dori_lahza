import 'package:dori_lahza/shared/domain/entities/common.dart';

/// `GET /places/{slug}` — identity, branding, hours, booking rules and the
/// wording (`labels`) the whole app uses.
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.slug,
    this.tagline,
    this.description,
    this.logo,
    this.cover,
    required this.typeName,
    required this.labels,
    this.primaryColor,
    required this.contact,
    required this.openNow,
    required this.openingHours,
    required this.rating,
    required this.booking,
    required this.queueEnabled,
    required this.currency,
    required this.currencySymbol,
    required this.timezone,
  });

  final int id;
  final String name;
  final String slug;
  final String? tagline;
  final String? description;
  final String? logo;
  final String? cover;
  final String typeName;
  final PlaceLabels labels;

  /// `theme.primary_color`, `#RRGGBB`.
  final String? primaryColor;
  final PlaceContact contact;
  final bool openNow;
  final List<DayHours> openingHours;
  final RatingSummary rating;
  final BookingRules booking;
  final bool queueEnabled;
  final String currency;
  final String currencySymbol;
  final String timezone;

  DayHours? get today {
    for (final d in openingHours) {
      if (d.isToday) return d;
    }
    return null;
  }
}

/// Words that fit the place type ("طبيب", "مصففة", "ملعب"...).
class PlaceLabels {
  const PlaceLabels({
    this.staff = 'مقدّم الخدمة',
    this.staffPlural = 'الفريق',
    this.service = 'خدمة',
    this.servicePlural = 'الخدمات',
    this.customer = 'عميل',
    this.booking = 'موعد',
  });

  final String staff;
  final String staffPlural;
  final String service;
  final String servicePlural;
  final String customer;
  final String booking;
}

class PlaceContact {
  const PlaceContact({this.phone, this.whatsapp, this.address, this.latitude, this.longitude});

  final String? phone;
  final String? whatsapp;
  final String? address;
  final double? latitude;
  final double? longitude;

  bool get isEmpty => phone == null && whatsapp == null && address == null;
}

/// `booking` rules of the place.
class BookingRules {
  const BookingRules({
    this.windowDays = 14,
    this.minNoticeMinutes = 0,
    this.cancelBeforeHours = 0,
    this.maxActiveBookings,
    this.autoConfirm = true,
    this.intakeFields = const [],
  });

  final int windowDays;
  final int minNoticeMinutes;
  final int cancelBeforeHours;
  final int? maxActiveBookings;
  final bool autoConfirm;

  /// Questions asked when booking; answers go to `answers` keyed by [IntakeField.key].
  final List<IntakeField> intakeFields;
}

enum IntakeFieldType { text, textarea, number, phone, email, date, select, checkbox }

class IntakeField {
  const IntakeField({
    required this.key,
    required this.label,
    required this.type,
    this.required = false,
    this.options = const [],
    this.placeholder,
    this.help,
  });

  final String key;
  final String label;
  final IntakeFieldType type;
  final bool required;
  final List<IntakeOption> options;
  final String? placeholder;
  final String? help;
}

class IntakeOption {
  const IntakeOption({required this.value, required this.label});

  final String value;
  final String label;
}
