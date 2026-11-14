import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/reviews/data/models/review_model.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';
import 'package:dori_lahza/shared/data/models/common_models.dart';

abstract final class StaffModel {
  static StaffMember fromJson(Json json) {
    final name = asString(json['name']);
    return StaffMember(
      id: asInt(json['id']),
      name: name,
      title: asStringOrNull(json['title']),
      bio: asStringOrNull(json['bio']),
      avatar: asStringOrNull(json['avatar']),
      initials: asString(json['initials'], name.isEmpty ? '' : name.substring(0, 1)),
      color: asStringOrNull(json['color']),
      hours: CommonMappers.hoursList(json['hours']),
      services: asListOf(
        json['services'],
        (s) => StaffService(
          id: asInt(s['id']),
          name: asString(s['name']),
          durationMinutes: asInt(s['duration_minutes']),
          finalPrice: asDouble(s['final_price'] ?? s['price']),
        ),
      ),
      rating: CommonMappers.rating(json['rating']),
      latestReviews: asListOf(json['latest_reviews'], ReviewModel.fromJson),
    );
  }
}
