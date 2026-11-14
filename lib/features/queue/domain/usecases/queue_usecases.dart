import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';
import 'package:dori_lahza/features/queue/domain/repositories/queue_repository.dart';

class GetQueueBoard implements UseCase<QueueBoard, NoParams> {
  const GetQueueBoard(this._repository);
  final QueueRepository _repository;

  @override
  Future<Result<QueueBoard>> call([NoParams params = const NoParams()]) => _repository.board();
}

class TakeQueueTicket implements UseCase<QueueTicket, int?> {
  const TakeQueueTicket(this._repository);
  final QueueRepository _repository;

  /// [serviceId] is optional.
  @override
  Future<Result<QueueTicket>> call([int? serviceId]) => _repository.take(serviceId: serviceId);
}

class GetMyTicket implements UseCase<QueueTicket?, NoParams> {
  const GetMyTicket(this._repository);
  final QueueRepository _repository;

  @override
  Future<Result<QueueTicket?>> call([NoParams params = const NoParams()]) => _repository.myTicket();
}

class CancelQueueTicket implements UseCase<void, int> {
  const CancelQueueTicket(this._repository);
  final QueueRepository _repository;

  @override
  Future<Result<void>> call(int ticketId) => _repository.cancel(ticketId);
}
