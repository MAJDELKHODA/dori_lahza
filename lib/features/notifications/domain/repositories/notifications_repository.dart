import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';

abstract interface class NotificationsRepository {
  /// `meta.unread_count` (when sent) is available on the page's `meta`.
  Future<Result<Paginated<AppNotification>>> list({required int page});

  Future<Result<void>> readAll();
}
