import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/place/data/datasources/place_remote_data_source.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  const PlaceRepositoryImpl(this._remote);

  final PlaceRemoteDataSource _remote;

  @override
  Future<Result<void>> ping() => guard(_remote.ping);

  @override
  Future<Result<Place>> getPlace() => guard(_remote.getPlace);
}
