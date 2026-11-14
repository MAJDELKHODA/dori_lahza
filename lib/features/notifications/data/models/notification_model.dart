import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';

abstract final class NotificationModel {
  static AppNotification fromJson(Json json) {
    // Laravel database notifications nest the payload in `data`.
    final payload = asJson(json['data']);
    String? pick(String key) => asStringOrNull(json[key] ?? payload[key]);
    final type = pick('type') ?? '';
    return AppNotification(
      id: asString(json['id']),
      kind: _kind(type),
      title: pick('title') ?? pick('message') ?? 'إشعار',
      body: pick('body') ?? pick('message_body') ?? pick('text'),
      url: pick('url') ?? pick('link'),
      isRead: json.containsKey('is_read') ? asBool(json['is_read']) : json['read_at'] != null,
      createdAt: asDateTimeOrNull(json['created_at']),
    );
  }

  static NotificationKind _kind(String type) {
    final t = type.toLowerCase();
    if (t.contains('waitlist') || t.contains('offer')) return NotificationKind.waitlistOffer;
    if (t.contains('queue') || t.contains('turn') || t.contains('ticket')) return NotificationKind.queue;
    if (t.contains('review')) return NotificationKind.review;
    if (t.contains('booking')) return NotificationKind.booking;
    return NotificationKind.general;
  }
}
