enum NotificationKind { booking, waitlistOffer, queue, review, general }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    this.body,
    this.url,
    required this.isRead,
    this.createdAt,
  });

  final String id;
  final NotificationKind kind;
  final String title;
  final String? body;

  /// In-app path such as `bookings/12`.
  final String? url;
  final bool isRead;
  final DateTime? createdAt;

  AppNotification markRead() =>
      AppNotification(id: id, kind: kind, title: title, body: body, url: url, isRead: true, createdAt: createdAt);
}

/// Where an in-app `url` leads.
sealed class AppLink {
  const AppLink();
}

final class BookingLink extends AppLink {
  const BookingLink(this.id);
  final int id;
}

final class WaitlistEntryLink extends AppLink {
  const WaitlistEntryLink(this.id);
  final int id;
}

final class WaitlistLink extends AppLink {
  const WaitlistLink();
}

final class QueueLink extends AppLink {
  const QueueLink();
}

final class MyBookingsLink extends AppLink {
  const MyBookingsLink();
}

final class ServiceLink extends AppLink {
  const ServiceLink(this.id);
  final int id;
}

final class StaffLink extends AppLink {
  const StaffLink(this.id);
  final int id;
}
