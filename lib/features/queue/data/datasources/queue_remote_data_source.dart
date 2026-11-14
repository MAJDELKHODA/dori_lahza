import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/queue/data/models/queue_model.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';

class QueueRemoteDataSource {
  const QueueRemoteDataSource(this._client);

  final DioClient _client;

  Future<QueueBoard> board() async => QueueModel.boardFromJson((await _client.get(ApiEndpoints.queue)).json);

  Future<QueueTicket> take({int? serviceId}) async =>
      QueueModel.ticketFromJson((await _client.post(ApiEndpoints.queueTickets, body: {'service_id': serviceId})).json);

  /// `data` is null when you have no ticket today.
  Future<QueueTicket?> myTicket() async {
    final json = asJsonOrNull((await _client.get(ApiEndpoints.myTicket)).data);
    return json == null || json.isEmpty ? null : QueueModel.ticketFromJson(json);
  }

  Future<void> cancel(int ticketId) => _client.post(ApiEndpoints.cancelTicket(ticketId));
}
