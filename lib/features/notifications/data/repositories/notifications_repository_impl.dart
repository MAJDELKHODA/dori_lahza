import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';
import 'package:dori_lahza/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote;

  @override
  Future<Result<Paginated<AppNotification>>> list({required int page}) => guard(() => _remote.list(page: page));

  @override
  Future<Result<void>> readAll() => guard(_remote.readAll);
}
