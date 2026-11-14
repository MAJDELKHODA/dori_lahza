import 'package:dori_lahza/features/insights/domain/repositories/insights_repository.dart';
import 'package:dori_lahza/features/insights/domain/usecases/get_busy_hours.dart';
import 'package:dori_lahza/features/insights/presentation/controllers/busy_hours_controller.dart';
import 'package:get/get.dart';

class BusyHoursBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(
        () => BusyHoursController(getBusyHours: GetBusyHours(Get.find<InsightsRepository>())),
      );
}
