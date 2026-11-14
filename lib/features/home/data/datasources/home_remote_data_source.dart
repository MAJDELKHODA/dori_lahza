import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/features/home/data/models/home_feed_model.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';

class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._client);

  final DioClient _client;

  Future<HomeFeed> feed() async => HomeFeedModel.fromJson((await _client.get(ApiEndpoints.home)).json);
}
