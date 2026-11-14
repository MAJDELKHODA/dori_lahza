import 'package:dori_lahza/features/bookings/presentation/bindings/bookings_bindings.dart';
import 'package:dori_lahza/features/home/domain/repositories/home_repository.dart';
import 'package:dori_lahza/features/home/domain/usecases/get_home_feed.dart';
import 'package:dori_lahza/features/home/presentation/controllers/home_controller.dart';
import 'package:dori_lahza/features/services/presentation/bindings/services_bindings.dart';
import 'package:dori_lahza/features/shell/presentation/controllers/shell_controller.dart';
import 'package:get/get.dart';

/// The shell and its tab controllers. Tabs are built on first visit, so
/// each tab controller is created (and fetches) only when first opened.
class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(ShellController.new, fenix: true)
      ..lazyPut(
        () => HomeController(
          getHomeFeed: GetHomeFeed(Get.find<HomeRepository>()),
          place: Get.find(),
          shell: Get.find(),
        ),
        fenix: true,
      );
    ServicesDependencies.registerTab();
    BookingsDependencies.registerTab();
  }
}
