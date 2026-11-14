import 'package:dori_lahza/features/splash/presentation/controllers/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() =>
      Get.lazyPut(() => SplashController(place: Get.find(), session: Get.find()));
}
