import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';

abstract final class QueueModel {
  static QueueBoard boardFromJson(Json json) => QueueBoard(
        enabled: asBool(json['enabled']),
        open: asBool(json['open']),
        accepting: asBool(json['accepting']),
        nowServing: asList(json['now_serving']).map(_call).whereType<QueueCall>().toList(),
        next: asList(json['next']).map(_call).whereType<QueueCall>().toList(),
        waitingCount: asInt(json['waiting_count']),
        servedToday: asInt(json['served_today']),
        averageMinutes: asInt(json['average_minutes']),
        counters: asInt(json['counters'], 1),
        estimatedWaitMinutes: asInt(json['estimated_wait_minutes']),
        updatedAt: asDateTimeOrNull(json['updated_at']),
      );

  /// Board entries may be a bare label or a ticket object.
  static QueueCall? _call(Object? value) {
    if (value is Map) {
      final json = asJson(value);
      final label = asString(json['label'] ?? json['number'] ?? json['code']);
      if (label.isEmpty) return null;
      return QueueCall(
        label: label,
        counter: asStringOrNull(json['counter_label'] ?? json['counter']),
        serviceName: asStringOrNull(json['service_name'] ?? asJson(json['service'])['name']),
      );
    }
    final label = asString(value);
    return label.isEmpty ? null : QueueCall(label: label);
  }

  static QueueTicket ticketFromJson(Json json) {
    final status = _status(asString(json['status']));
    return QueueTicket(
      id: asInt(json['id']),
      label: asString(json['label'] ?? json['number']),
      status: status,
      statusLabel: asStringOrNull(json['status_label']),
      ahead: asInt(json['ahead']),
      estimatedWaitMinutes: asInt(json['estimated_wait_minutes']),
      serviceName: asStringOrNull(json['service_name'] ?? asJson(json['service'])['name']),
      counter: asStringOrNull(json['counter_label'] ?? json['counter']),
      createdAt: asDateTimeOrNull(json['created_at']),
      canCancel: asBool(json['can_cancel'], status == TicketStatus.waiting),
    );
  }

  static TicketStatus _status(String value) => switch (value) {
        'waiting' || 'pending' => TicketStatus.waiting,
        'called' || 'calling' => TicketStatus.called,
        'serving' || 'in_service' => TicketStatus.serving,
        'done' || 'served' || 'completed' => TicketStatus.done,
        'cancelled' || 'canceled' => TicketStatus.cancelled,
        'skipped' || 'no_show' => TicketStatus.skipped,
        _ => TicketStatus.unknown,
      };
}
