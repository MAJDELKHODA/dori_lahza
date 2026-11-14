import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/waitlist/data/datasources/waitlist_remote_data_source.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:dori_lahza/features/waitlist/domain/repositories/waitlist_repository.dart';

class WaitlistRepositoryImpl implements WaitlistRepository {
  const WaitlistRepositoryImpl(this._remote);

  final WaitlistRemoteDataSource _remote;

  @override
  Future<Result<WaitlistEntry>> join(JoinWaitlistRequest request) => guard(() => _remote.join(request));

  @override
  Future<Result<List<WaitlistEntry>>> list({bool activeOnly = true}) =>
      guard(() => _remote.list(activeOnly: activeOnly));

  @override
  Future<Result<WaitlistEntry>> entry(int id) => guard(() => _remote.entry(id));

  @override
  Future<Result<int?>> claim(int id) => guard(() => _remote.claim(id));

  @override
  Future<Result<void>> leave(int id) => guard(() => _remote.leave(id));
}
