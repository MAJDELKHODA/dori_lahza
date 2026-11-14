import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/state/paged_controller.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';
import 'package:dori_lahza/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:dori_lahza/features/notifications/domain/usecases/resolve_app_link.dart';
import 'package:dori_lahza/features/shell/presentation/controllers/shell_controller.dart';
import 'package:get/get.dart';

/// Unread count for the bell badge (home header, account menu).
class UnreadBadgeController extends GetxController {
  UnreadBadgeController({required GetUnreadCount getUnreadCount, required SessionController session})
      : _get = getUnreadCount,
        _session = session;

  final GetUnreadCount _get;
  final SessionController _session;
  final unread = 0.obs;
  Worker? _worker;

  @override
  void onInit() {
    super.onInit();
    _worker = ever(_session.user, (_) => unawaited(refreshCount()));
  }

  @override
  void onReady() {
    super.onReady();
    unawaited(refreshCount());
  }

  Future<void> refreshCount() async {
    if (!_session.isSignedIn) {
      unread.value = 0;
      return;
    }
    final result = await _get();
    result.fold((_) {}, (count) => unread.value = count);
  }

  void clear() => unread.value = 0;

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }
}

class NotificationsController extends PagedController<AppNotification> {
  NotificationsController({
    required GetNotifications getNotifications,
    required MarkAllNotificationsRead markAllRead,
    required ResolveAppLink resolveLink,
    required UnreadBadgeController badge,
  })  : _get = getNotifications,
        _markAll = markAllRead,
        _resolve = resolveLink,
        _badge = badge;

  final GetNotifications _get;
  final MarkAllNotificationsRead _markAll;
  final ResolveAppLink _resolve;
  final UnreadBadgeController _badge;

  final isMarking = false.obs;

  bool get hasUnread => items.any((n) => !n.isRead);

  @override
  Future<Result<Paginated<AppNotification>>> fetchPage(int page) => _get(page);

  Future<void> markAllRead() async {
    if (isMarking.value || !hasUnread) return;
    isMarking.value = true;
    final result = await _markAll();
    isMarking.value = false;
    result.fold(AppFeedback.failure, (_) {
      replaceWhere((n) => !n.isRead, (n) => n.markRead());
      _badge.clear();
    });
  }

  /// Follows the notification's in-app `url`.
  Future<void> open(AppNotification n) async {
    final link = _resolve(n.url);
    switch (link) {
      case BookingLink(:final id):
        await AppNav.bookingDetails(id);
      case WaitlistEntryLink(:final id):
        await AppNav.waitlistEntry(id);
      case WaitlistLink():
        await AppNav.waitlist();
      case QueueLink():
        _openTab(ShellTab.queue);
      case MyBookingsLink():
        _openTab(ShellTab.bookings);
      case ServiceLink(:final id):
        await AppNav.serviceDetails(id);
      case StaffLink(:final id):
        await AppNav.staffProfile(id);
      case null:
        break;
    }
  }

  void _openTab(ShellTab tab) {
    Get.until((route) => route.isFirst);
    Get.find<ShellController>().open(tab);
  }

  @override
  void onClose() {
    unawaited(_badge.refreshCount());
    super.onClose();
  }
}
