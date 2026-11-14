import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';

abstract interface class InsightsRepository {
  Future<Result<BusyHours>> busyHours();
}
