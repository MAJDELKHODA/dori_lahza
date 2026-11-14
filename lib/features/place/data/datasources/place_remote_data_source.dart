import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/features/place/data/models/place_model.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';

class PlaceRemoteDataSource {
  const PlaceRemoteDataSource(this._client);

  final DioClient _client;

  Future<void> ping() => _client.get(ApiEndpoints.ping);

  Future<Place> getPlace() async =>
      PlaceModel.fromJson((await _client.get(ApiEndpoints.place)).json);
}
