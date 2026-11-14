import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/storage/token_storage.dart';
import 'package:dori_lahza/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dori_lahza/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dori_lahza/features/auth/domain/repositories/auth_repository.dart';
import 'package:dori_lahza/features/auth/domain/usecases/auth_usecases.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/place/data/datasources/place_remote_data_source.dart';
import 'package:dori_lahza/features/place/data/repositories/place_repository_impl.dart';
import 'package:dori_lahza/features/place/domain/repositories/place_repository.dart';
import 'package:dori_lahza/features/place/domain/usecases/place_usecases.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:get/get.dart';

/// App-lifetime dependencies: network, storage, the place configuration and
/// the session. Feature dependencies live in each feature's binding.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final tokens = Get.put(TokenStorage(), permanent: true);
    final client = Get.put(
      DioClient(
        tokenStorage: tokens,
        onUnauthorized: () => Get.find<SessionController>().onTokenRejected(),
      ),
      permanent: true,
    );

    final PlaceRepository placeRepo = PlaceRepositoryImpl(PlaceRemoteDataSource(client));
    Get.put(
      PlaceController(pingServer: PingServer(placeRepo), getPlace: GetPlace(placeRepo)),
      permanent: true,
    );

    final authRepo = Get.put<AuthRepository>(
      AuthRepositoryImpl(remote: AuthRemoteDataSource(client), tokenStorage: tokens),
      permanent: true,
    );
    Get.put(
      SessionController(
        repository: authRepo,
        getCurrentUser: GetCurrentUser(authRepo),
        logout: Logout(authRepo),
      ),
      permanent: true,
    );
  }
}
