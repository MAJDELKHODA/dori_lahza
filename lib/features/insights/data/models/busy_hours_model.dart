import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';

abstract final class BusyHoursModel {
  static BusyHours fromJson(Json json) {
    final now = asJson(json['now']);
    return BusyHours(
      fromHour: asInt(json['from_hour']),
      toHour: asInt(json['to_hour']),
      days: asListOf(
        json['grid'],
        (d) => BusyDay(
          day: asString(d['day']),
          label: asString(d['label']),
          hours: asListOf(
            d['hours'],
            (h) => BusyHour(hour: asInt(h['hour']), open: asBool(h['open']), level: asDouble(h['level'])),
          ),
        ),
      ),
      bestTimes: asListOf(
        json['best_times'],
        (b) => BestTime(
          day: asString(b['day']),
          dayLabel: asString(b['label']),
          time: asString(b['time']),
          level: asDouble(b['level']),
        ),
      ),
      now: BusyNow(
        open: asBool(now['open']),
        level: asDoubleOrNull(now['level']),
        label: asString(now['label']),
      ),
    );
  }
}
