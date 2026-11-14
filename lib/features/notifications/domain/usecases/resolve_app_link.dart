import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';

/// Parses a notification `url` (`bookings/12`, `/waitlist/5`, `queue`, or a
/// full URL ending in such a path) into an [AppLink]. Unknown paths → null.
class ResolveAppLink {
  const ResolveAppLink();

  AppLink? call(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final uri = Uri.tryParse(url.trim());
    final segments = (uri?.pathSegments ?? url.split('/')).where((s) => s.isNotEmpty).toList();
    // Drop API / place prefixes, e.g. `/places/la7za/bookings/12`.
    final start = segments.indexWhere(
      (s) => const {'bookings', 'booking', 'waitlist', 'queue', 'services', 'staff'}.contains(s),
    );
    if (start < 0) return null;
    final head = segments[start];
    final id = start + 1 < segments.length ? int.tryParse(segments[start + 1]) : null;
    return switch (head) {
      'bookings' || 'booking' => id == null ? const MyBookingsLink() : BookingLink(id),
      'waitlist' => id == null ? const WaitlistLink() : WaitlistEntryLink(id),
      'queue' => const QueueLink(),
      'services' when id != null => ServiceLink(id),
      'staff' when id != null => StaffLink(id),
      _ => null,
    };
  }
}
