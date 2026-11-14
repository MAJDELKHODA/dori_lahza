import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/domain/repositories/services_repository.dart';

class GetCategories implements UseCase<List<Category>, NoParams> {
  const GetCategories(this._repository);
  final ServicesRepository _repository;

  @override
  Future<Result<List<Category>>> call([NoParams params = const NoParams()]) =>
      _repository.categories();
}

class SearchServicesParams {
  const SearchServicesParams(this.filter, {this.page = 1});
  final ServiceFilter filter;
  final int page;
}

/// Category listing, text search and filters all go through `GET /services`.
class SearchServices implements UseCase<Paginated<Service>, SearchServicesParams> {
  const SearchServices(this._repository);
  final ServicesRepository _repository;

  @override
  Future<Result<Paginated<Service>>> call(SearchServicesParams p) =>
      _repository.services(p.filter, page: p.page);
}

class GetServiceDetails implements UseCase<Service, int> {
  const GetServiceDetails(this._repository);
  final ServicesRepository _repository;

  @override
  Future<Result<Service>> call(int serviceId) => _repository.service(serviceId);
}
