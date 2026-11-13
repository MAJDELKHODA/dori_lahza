import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../data/repositories/booking_repository.dart';
import 'booking_controller.dart';

class BookingBinding extends Bindings {
  final int serviceId;

  BookingBinding({required this.serviceId});

  @override
  void dependencies() {
    Get.lazyPut<BookingRepository>(
      () => BookingRepository(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<BookingController>(
      () => BookingController(
        repository: Get.find<BookingRepository>(),
        serviceId: serviceId,
      ),
    );
  }
}
