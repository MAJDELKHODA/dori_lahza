import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';

abstract interface class ServicesRepository {
  Future<Result<List<Category>>> categories();

  Future<Result<Paginated<Service>>> services(ServiceFilter filter, {required int page});

  Future<Result<Service>> service(int id);
}
