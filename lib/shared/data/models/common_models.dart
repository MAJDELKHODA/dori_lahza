import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';

abstract final class CommonMappers {
  static RatingSummary rating(Object? value) {
    final json = asJson(value);
    return RatingSummary(average: asDouble(json['average']), count: asInt(json['count']));
  }

  static DayHours dayHours(Json json) => DayHours(
        day: asString(json['day']),
        label: asString(json['label']),
        open: asBool(json['open']),
        ranges: asStringList(json['ranges']),
      );

  static List<DayHours> hoursList(Object? value) => asListOf(value, dayHours);

  static StaffBrief staff(Json json) {
    final name = asString(json['name']);
    return StaffBrief(
      id: asInt(json['id']),
      name: name,
      title: asStringOrNull(json['title']),
      avatar: asStringOrNull(json['avatar']),
      initials: asString(json['initials'], name.isEmpty ? '' : name.substring(0, 1)),
      color: asStringOrNull(json['color']),
    );
  }

  static List<StaffBrief> staffList(Object? value) => asListOf(value, staff);
}
