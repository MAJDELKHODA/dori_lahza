import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';

abstract interface class QueueRepository {
  Future<Result<QueueBoard>> board();

  Future<Result<QueueTicket>> take({int? serviceId});

  Future<Result<QueueTicket?>> myTicket();

  Future<Result<void>> cancel(int ticketId);
}
