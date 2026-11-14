import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/domain/repositories/place_repository.dart';

class PingServer implements UseCase<void, NoParams> {
  const PingServer(this._repository);

  final PlaceRepository _repository;

  @override
  Future<Result<void>> call([NoParams params = const NoParams()]) => _repository.ping();
}

class GetPlace implements UseCase<Place, NoParams> {
  const GetPlace(this._repository);

  final PlaceRepository _repository;

  @override
  Future<Result<Place>> call([NoParams params = const NoParams()]) => _repository.getPlace();
}
