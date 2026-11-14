import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/notifications/data/models/notification_model.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';

class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource(this._client);

  final DioClient _client;

  Future<Paginated<AppNotification>> list({required int page}) async {
    final res = await _client.get(ApiEndpoints.notifications, query: {'page': page});
    return Paginated.fromResponse(asListOf(res.data, NotificationModel.fromJson), res.meta);
  }

  Future<void> readAll() => _client.post(ApiEndpoints.readAllNotifications);
}
