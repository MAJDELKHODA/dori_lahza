import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/features/home/data/datasources/home_remote_data_source.dart';
import 'package:dori_lahza/features/home/data/repositories/home_repository_impl.dart';
import 'package:dori_lahza/features/home/domain/repositories/home_repository.dart';
import 'package:dori_lahza/features/insights/data/datasources/insights_remote_data_source.dart';
import 'package:dori_lahza/features/insights/data/repositories/insights_repository_impl.dart';
import 'package:dori_lahza/features/insights/domain/repositories/insights_repository.dart';
import 'package:dori_lahza/features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:dori_lahza/features/reviews/data/repositories/reviews_repository_impl.dart';
import 'package:dori_lahza/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:dori_lahza/features/services/data/datasources/services_remote_data_source.dart';
import 'package:dori_lahza/features/services/data/repositories/services_repository_impl.dart';
import 'package:dori_lahza/features/services/domain/repositories/services_repository.dart';
import 'package:dori_lahza/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:dori_lahza/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:dori_lahza/features/staff/domain/repositories/staff_repository.dart';
import 'package:get/get.dart';

/// Registers every feature repository lazily (`fenix` re-creates them after
/// disposal). Repositories are stateless, so sharing one instance is safe;
/// controllers are registered per screen in each feature's bindings.
abstract final class DataBinding {
  static void register() {
    DioClient client() => Get.find<DioClient>();

    Get
      ..lazyPut<HomeRepository>(() => HomeRepositoryImpl(HomeRemoteDataSource(client())), fenix: true)
      ..lazyPut<ServicesRepository>(
        () => ServicesRepositoryImpl(ServicesRemoteDataSource(client())),
        fenix: true,
      )
      ..lazyPut<StaffRepository>(() => StaffRepositoryImpl(StaffRemoteDataSource(client())), fenix: true)
      ..lazyPut<ReviewsRepository>(
        () => ReviewsRepositoryImpl(ReviewsRemoteDataSource(client())),
        fenix: true,
      )
      ..lazyPut<InsightsRepository>(
        () => InsightsRepositoryImpl(InsightsRemoteDataSource(client())),
        fenix: true,
      );
  }
}
