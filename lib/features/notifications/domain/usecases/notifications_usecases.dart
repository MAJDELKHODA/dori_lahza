import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';
import 'package:dori_lahza/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotifications implements UseCase<Paginated<AppNotification>, int> {
  const GetNotifications(this._repository);
  final NotificationsRepository _repository;

  @override
  Future<Result<Paginated<AppNotification>>> call(int page) => _repository.list(page: page);
}

class MarkAllNotificationsRead implements UseCase<void, NoParams> {
  const MarkAllNotificationsRead(this._repository);
  final NotificationsRepository _repository;

  @override
  Future<Result<void>> call([NoParams params = const NoParams()]) => _repository.readAll();
}

/// Unread count for the bell badge: `meta.unread_count` when the API sends
/// it, otherwise the unread items on the first page.
class GetUnreadCount implements UseCase<int, NoParams> {
  const GetUnreadCount(this._repository);
  final NotificationsRepository _repository;

  @override
  Future<Result<int>> call([NoParams params = const NoParams()]) async {
    final result = await _repository.list(page: 1);
    return result.map(
      (page) => asIntOrNull(page.meta['unread_count'] ?? page.meta['unread']) ?? page.items.where((n) => !n.isRead).length,
    );
  }
}
