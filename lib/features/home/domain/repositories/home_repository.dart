import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';

abstract interface class HomeRepository {
  Future<Result<HomeFeed>> feed();
}
