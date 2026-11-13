import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register Repository first
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(
        AuthRepository(
          apiClient: Get.find<ApiClient>(),
          tokenStorage: Get.find<TokenStorage>(),
        ),
        permanent: true,
      );
    }

    // Then register Controller
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(
          repository: Get.find<AuthRepository>(),
          tokenStorage: Get.find<TokenStorage>(),
        ),
        permanent: true,
      );
    }
  }
}
