import 'package:dori_lahza/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:dori_lahza/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:dori_lahza/features/notifications/domain/usecases/resolve_app_link.dart';
import 'package:dori_lahza/features/notifications/presentation/controllers/notifications_controllers.dart';
import 'package:get/get.dart';

abstract final class NotificationsDependencies {
  /// The bell badge lives with the shell.
  static void registerBadge() => Get.lazyPut(
        () => UnreadBadgeController(
          getUnreadCount: GetUnreadCount(Get.find<NotificationsRepository>()),
          session: Get.find(),
        ),
        fenix: true,
      );
}

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    final repo = Get.find<NotificationsRepository>();
    Get.lazyPut(
      () => NotificationsController(
        getNotifications: GetNotifications(repo),
        markAllRead: MarkAllNotificationsRead(repo),
        resolveLink: const ResolveAppLink(),
        badge: Get.find(),
      ),
    );
  }
}
