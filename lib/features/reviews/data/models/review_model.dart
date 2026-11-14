import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';

abstract final class ReviewModel {
  static Review fromJson(Json json) {
    final customer = asJson(json['customer'] ?? json['user']);
    final name = asString(
      json['customer_name'] ?? customer['name'] ?? json['name'],
      'عميل',
    );
    return Review(
      id: asInt(json['id']),
      rating: asInt(json['rating']).clamp(0, 5),
      comment: asStringOrNull(json['comment'] ?? json['body']),
      authorName: name,
      authorInitials: asString(json['initials'] ?? customer['initials'], name.substring(0, 1)),
      authorAvatar: asStringOrNull(customer['avatar'] ?? json['avatar']),
      createdAt: asDateTimeOrNull(json['created_at'] ?? json['date']),
      serviceName: asStringOrNull(json['service_name'] ?? asJson(json['service'])['name']),
      staffName: asStringOrNull(json['staff_name'] ?? asJson(json['staff'])['name']),
      reply: _reply(json['reply'], json['replied_at']),
    );
  }

  /// `reply` may be the text itself or `{ body|text|comment, created_at }`.
  static ReviewReply? _reply(Object? value, Object? repliedAt) {
    if (value is Map) {
      final json = asJson(value);
      final text = asStringOrNull(json['body'] ?? json['text'] ?? json['comment'] ?? json['reply']);
      return text == null ? null : ReviewReply(text: text, createdAt: asDateTimeOrNull(json['created_at']));
    }
    final text = asStringOrNull(value);
    return text == null ? null : ReviewReply(text: text, createdAt: asDateTimeOrNull(repliedAt));
  }

  static ReviewsPage pageFromResponse(Object? data, Json meta) {
    final items = asListOf(data, fromJson);
    final raw = asJson(meta['distribution']);
    return ReviewsPage(
      page: Paginated.fromResponse(items, meta),
      summary: RatingSummary(average: asDouble(meta['average']), count: asInt(meta['total'], items.length)),
      distribution: {for (var star = 5; star >= 1; star--) star: asInt(raw['$star'])},
    );
  }
}
