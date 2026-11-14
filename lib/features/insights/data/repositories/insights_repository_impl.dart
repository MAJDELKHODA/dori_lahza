import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/insights/data/datasources/insights_remote_data_source.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';
import 'package:dori_lahza/features/insights/domain/repositories/insights_repository.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  const InsightsRepositoryImpl(this._remote);

  final InsightsRemoteDataSource _remote;

  @override
  Future<Result<BusyHours>> busyHours() => guard(_remote.busyHours);
}
