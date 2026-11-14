import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/home/data/datasources/home_remote_data_source.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';
import 'package:dori_lahza/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remote);

  final HomeRemoteDataSource _remote;

  @override
  Future<Result<HomeFeed>> feed() => guard(_remote.feed);
}
