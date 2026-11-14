import 'package:dori_lahza/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:dori_lahza/features/reviews/domain/usecases/reviews_usecases.dart';
import 'package:dori_lahza/features/services/domain/repositories/services_repository.dart';
import 'package:dori_lahza/features/services/domain/usecases/services_usecases.dart';
import 'package:dori_lahza/features/services/presentation/controllers/service_details_controller.dart';
import 'package:dori_lahza/features/services/presentation/controllers/services_controller.dart';
import 'package:dori_lahza/features/staff/domain/repositories/staff_repository.dart';
import 'package:dori_lahza/features/staff/domain/usecases/staff_usecases.dart';
import 'package:get/get.dart';

abstract final class ServicesDependencies {
  /// The services tab controller (lives with the shell).
  static void registerTab() => Get.lazyPut(
        () => ServicesController(
          searchServices: SearchServices(Get.find<ServicesRepository>()),
          getCategories: GetCategories(Get.find<ServicesRepository>()),
          getTeam: GetTeam(Get.find<StaffRepository>()),
        ),
        fenix: true,
      );
}

/// Details can be stacked (related services), so each page gets its own
/// controller tagged with the service id.
class ServiceDetailsBinding extends Bindings {
  ServiceDetailsBinding(this.serviceId);

  final int serviceId;

  @override
  void dependencies() => Get.lazyPut(
        () => ServiceDetailsController(
          serviceId: serviceId,
          getServiceDetails: GetServiceDetails(Get.find<ServicesRepository>()),
          getReviews: GetReviews(Get.find<ReviewsRepository>()),
        ),
        tag: '$serviceId',
      );
}
