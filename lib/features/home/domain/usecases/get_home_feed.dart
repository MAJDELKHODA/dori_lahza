import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';
import 'package:dori_lahza/features/home/domain/repositories/home_repository.dart';

class GetHomeFeed implements UseCase<HomeFeed, NoParams> {
  const GetHomeFeed(this._repository);
  final HomeRepository _repository;

  @override
  Future<Result<HomeFeed>> call([NoParams params = const NoParams()]) => _repository.feed();
}
