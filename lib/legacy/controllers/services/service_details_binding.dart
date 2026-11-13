import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../data/repositories/service_repository.dart';
import 'service_details_controller.dart';

class ServiceDetailsBinding extends Bindings {
  final int serviceId;

  ServiceDetailsBinding({required this.serviceId});

  @override
  void dependencies() {
    Get.lazyPut<ServiceRepository>(
      () => ServiceRepository(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<ServiceDetailsController>(
      () => ServiceDetailsController(
        repository: Get.find<ServiceRepository>(),
        serviceId: serviceId,
      ),
    );
  }
}
