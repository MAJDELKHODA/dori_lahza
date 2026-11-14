/// `GET /queue`: the public live-queue board.
class QueueBoard {
  const QueueBoard({
    required this.enabled,
    required this.open,
    required this.accepting,
    required this.nowServing,
    required this.next,
    required this.waitingCount,
    required this.servedToday,
    required this.averageMinutes,
    required this.counters,
    required this.estimatedWaitMinutes,
    this.updatedAt,
  });

  final bool enabled;
  final bool open;

  /// Whether new tickets can be taken right now.
  final bool accepting;
  final List<QueueCall> nowServing;
  final List<QueueCall> next;
  final int waitingCount;
  final int servedToday;
  final int averageMinutes;
  final int counters;
  final int estimatedWaitMinutes;
  final DateTime? updatedAt;
}

/// A ticket shown on the board (being served or coming next).
class QueueCall {
  const QueueCall({required this.label, this.counter, this.serviceName});
  final String label;
  final String? counter;
  final String? serviceName;
}

enum TicketStatus { waiting, called, serving, done, cancelled, skipped, unknown }

/// `GET /queue/my-ticket` / `POST /queue/tickets`.
class QueueTicket {
  const QueueTicket({
    required this.id,
    required this.label,
    required this.status,
    this.statusLabel,
    required this.ahead,
    required this.estimatedWaitMinutes,
    this.serviceName,
    this.counter,
    this.createdAt,
    this.canCancel = true,
  });

  final int id;

  /// e.g. `A-007`.
  final String label;
  final TicketStatus status;
  final String? statusLabel;

  /// People before you.
  final int ahead;
  final int estimatedWaitMinutes;
  final String? serviceName;
  final String? counter;
  final DateTime? createdAt;

  /// Cancelling is allowed before being called.
  final bool canCancel;

  bool get isActive =>
      status == TicketStatus.waiting || status == TicketStatus.called || status == TicketStatus.serving;
  bool get isCalled => status == TicketStatus.called || status == TicketStatus.serving;
}
