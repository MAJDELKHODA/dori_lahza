import 'package:get/get.dart';

import '../network/api_client.dart';
import '../storage/token_storage.dart';
import '../../controllers/auth/auth_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Secure Token Storage
    if (!Get.isRegistered<TokenStorage>()) {
      Get.put<TokenStorage>(TokenStorage(), permanent: true);
    }

    // API Client
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(
        ApiClient(tokenStorage: Get.find<TokenStorage>()),
        permanent: true,
      );
    }

    // Authentication
    AuthBinding().dependencies();
  }
}
