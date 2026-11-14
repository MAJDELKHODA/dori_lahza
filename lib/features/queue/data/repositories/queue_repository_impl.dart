import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/queue/data/datasources/queue_remote_data_source.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';
import 'package:dori_lahza/features/queue/domain/repositories/queue_repository.dart';

class QueueRepositoryImpl implements QueueRepository {
  const QueueRepositoryImpl(this._remote);

  final QueueRemoteDataSource _remote;

  @override
  Future<Result<QueueBoard>> board() => guard(_remote.board);

  @override
  Future<Result<QueueTicket>> take({int? serviceId}) => guard(() => _remote.take(serviceId: serviceId));

  @override
  Future<Result<QueueTicket?>> myTicket() => guard(_remote.myTicket);

  @override
  Future<Result<void>> cancel(int ticketId) => guard(() => _remote.cancel(ticketId));
}
