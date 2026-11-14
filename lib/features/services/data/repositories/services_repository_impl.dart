import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/services/data/datasources/services_remote_data_source.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  const ServicesRepositoryImpl(this._remote);

  final ServicesRemoteDataSource _remote;

  @override
  Future<Result<List<Category>>> categories() => guard(_remote.categories);

  @override
  Future<Result<Paginated<Service>>> services(ServiceFilter filter, {required int page}) =>
      guard(() => _remote.services(filter, page: page));

  @override
  Future<Result<Service>> service(int id) => guard(() => _remote.service(id));
}
