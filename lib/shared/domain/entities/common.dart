/// Value objects that several features share.
library;

class RatingSummary {
  const RatingSummary({this.average = 0, this.count = 0});

  final double average;
  final int count;

  bool get hasReviews => count > 0;
}

/// One day of opening hours (`opening_hours[]` / staff `hours[]`).
class DayHours {
  const DayHours({required this.day, required this.label, required this.open, required this.ranges});

  /// `sat`, `sun`, ...
  final String day;
  final String label;
  final bool open;

  /// e.g. `["09:00 - 17:00"]`.
  final List<String> ranges;

  bool get isToday => day == weekdayKey(DateTime.now());

  static String weekdayKey(DateTime date) =>
      const ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'][date.weekday - 1];
}

/// Short staff reference embedded in services, slots and bookings.
class StaffBrief {
  const StaffBrief({
    required this.id,
    required this.name,
    this.title,
    this.avatar,
    this.initials = '',
    this.color,
  });

  final int id;
  final String name;
  final String? title;
  final String? avatar;
  final String initials;

  /// `#RRGGBB`.
  final String? color;
}
