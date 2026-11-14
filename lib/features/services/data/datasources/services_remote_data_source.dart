import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/services/data/models/service_model.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';

class ServicesRemoteDataSource {
  const ServicesRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<Category>> categories() async =>
      asListOf((await _client.get(ApiEndpoints.categories)).data, ServiceModel.categoryFromJson);

  Future<Paginated<Service>> services(ServiceFilter filter, {required int page}) async {
    final res = await _client.get(
      ApiEndpoints.services,
      query: ServiceModel.filterToQuery(filter, page: page),
    );
    return Paginated.fromResponse(asListOf(res.data, ServiceModel.fromJson), res.meta);
  }

  Future<Service> service(int id) async =>
      ServiceModel.fromJson((await _client.get(ApiEndpoints.service(id))).json);
}
