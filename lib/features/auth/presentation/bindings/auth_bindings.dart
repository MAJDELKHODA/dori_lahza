import 'package:dori_lahza/features/auth/domain/repositories/auth_repository.dart';
import 'package:dori_lahza/features/auth/domain/usecases/auth_usecases.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/login_controller.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/register_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(
        () => LoginController(login: Login(Get.find<AuthRepository>()), session: Get.find()),
      );
}

class RegisterBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(
        () => RegisterController(register: Register(Get.find<AuthRepository>()), session: Get.find()),
      );
}
