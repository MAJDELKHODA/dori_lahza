import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';

abstract final class UserModel {
  static User fromJson(Json json) {
    final name = asString(json['name']);
    return User(
      id: asInt(json['id']),
      name: name,
      email: asString(json['email']),
      phone: asStringOrNull(json['phone']),
      avatar: asStringOrNull(json['avatar']),
      initials: asString(json['initials'], name.isEmpty ? '؟' : name.substring(0, 1)),
      reliability: _reliability(json['reliability']),
    );
  }

  /// `reliability` is documented as a 0–100 score; accept either the bare
  /// number or an object around it.
  static Reliability? _reliability(Object? value) {
    if (value == null) return null;
    if (value is num || value is String) {
      final score = asIntOrNull(value);
      return score == null ? null : Reliability(score: score.clamp(0, 100));
    }
    final json = asJson(value);
    final score = asIntOrNull(json['score'] ?? json['value'] ?? json['percent']);
    if (score == null) return null;
    return Reliability(
      score: score.clamp(0, 100),
      label: asStringOrNull(json['label']),
      completed: asIntOrNull(json['completed'] ?? json['completed_count']),
      cancelledLate: asIntOrNull(json['late_cancellations'] ?? json['cancelled_late']),
      noShows: asIntOrNull(json['no_shows'] ?? json['no_show']),
    );
  }
}
