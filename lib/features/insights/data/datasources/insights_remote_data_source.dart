import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/features/insights/data/models/busy_hours_model.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';

class InsightsRemoteDataSource {
  const InsightsRemoteDataSource(this._client);

  final DioClient _client;

  Future<BusyHours> busyHours() async =>
      BusyHoursModel.fromJson((await _client.get(ApiEndpoints.busyHours)).json);
}
