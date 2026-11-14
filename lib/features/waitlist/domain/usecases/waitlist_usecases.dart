import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:dori_lahza/features/waitlist/domain/repositories/waitlist_repository.dart';

class JoinWaitlist implements UseCase<WaitlistEntry, JoinWaitlistRequest> {
  const JoinWaitlist(this._repository);
  final WaitlistRepository _repository;

  @override
  Future<Result<WaitlistEntry>> call(JoinWaitlistRequest request) => _repository.join(request);
}

class GetMyWaitlist implements UseCase<List<WaitlistEntry>, bool> {
  const GetMyWaitlist(this._repository);
  final WaitlistRepository _repository;

  /// [activeOnly] limits to `waiting` / `offered`.
  @override
  Future<Result<List<WaitlistEntry>>> call(bool activeOnly) => _repository.list(activeOnly: activeOnly);
}

class GetWaitlistEntry implements UseCase<WaitlistEntry, int> {
  const GetWaitlistEntry(this._repository);
  final WaitlistRepository _repository;

  @override
  Future<Result<WaitlistEntry>> call(int id) => _repository.entry(id);
}

class ClaimWaitlistOffer implements UseCase<int?, int> {
  const ClaimWaitlistOffer(this._repository);
  final WaitlistRepository _repository;

  @override
  Future<Result<int?>> call(int id) => _repository.claim(id);
}

class LeaveWaitlist implements UseCase<void, int> {
  const LeaveWaitlist(this._repository);
  final WaitlistRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.leave(id);
}
