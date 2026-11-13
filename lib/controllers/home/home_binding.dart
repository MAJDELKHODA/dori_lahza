import 'package:get/get.dart';

import '../../core/storage/token_storage.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/home_repository.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Token Storage
    Get.lazyPut<TokenStorage>(() => TokenStorage());

    // API Client
    Get.lazyPut<ApiClient>(
      () => ApiClient(tokenStorage: Get.find<TokenStorage>()),
    );

    // Home Repository
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(apiClient: Get.find<ApiClient>()),
    );

    // Home Controller
    Get.lazyPut<HomeController>(
      () => HomeController(repository: Get.find<HomeRepository>()),
    );
  }
}
