import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';

abstract interface class PlaceRepository {
  Future<Result<void>> ping();

  Future<Result<Place>> getPlace();
}
