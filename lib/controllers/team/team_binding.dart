import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../data/repositories/team_repository.dart';
import 'team_controller.dart';

class TeamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamRepository>(
      () => TeamRepository(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<TeamController>(
      () => TeamController(repository: Get.find<TeamRepository>()),
    );
  }
}
