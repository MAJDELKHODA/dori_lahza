import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';
import 'package:dori_lahza/features/insights/domain/repositories/insights_repository.dart';

class GetBusyHours implements UseCase<BusyHours, NoParams> {
  const GetBusyHours(this._repository);
  final InsightsRepository _repository;

  @override
  Future<Result<BusyHours>> call([NoParams params = const NoParams()]) => _repository.busyHours();
}
