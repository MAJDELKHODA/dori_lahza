/// `GET /insights/busy-hours`: a weekly heatmap of how busy the place is.
class BusyHours {
  const BusyHours({
    required this.fromHour,
    required this.toHour,
    required this.days,
    required this.bestTimes,
    required this.now,
  });

  final int fromHour;
  final int toHour;
  final List<BusyDay> days;

  /// The quietest times, best first.
  final List<BestTime> bestTimes;
  final BusyNow now;

  List<int> get hours => [for (var h = fromHour; h <= toHour; h++) h];

  bool get isEmpty => days.isEmpty;
}

class BusyDay {
  const BusyDay({required this.day, required this.label, required this.hours});
  final String day;
  final String label;
  final List<BusyHour> hours;
}

class BusyHour {
  const BusyHour({required this.hour, required this.open, required this.level});
  final int hour;
  final bool open;

  /// 0 (quiet) → 1 (busy).
  final double level;
}

class BestTime {
  const BestTime({required this.day, required this.dayLabel, required this.time, required this.level});
  final String day;
  final String dayLabel;
  final String time;
  final double level;
}

class BusyNow {
  const BusyNow({required this.open, this.level, required this.label});
  final bool open;
  final double? level;

  /// e.g. "هادئ الآن".
  final String label;
}
