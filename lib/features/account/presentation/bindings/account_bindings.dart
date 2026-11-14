import 'package:dori_lahza/features/account/presentation/controllers/edit_profile_controller.dart';
import 'package:dori_lahza/features/auth/domain/repositories/auth_repository.dart';
import 'package:dori_lahza/features/auth/domain/usecases/auth_usecases.dart';
import 'package:get/get.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(
        () => EditProfileController(
          updateProfile: UpdateProfile(Get.find<AuthRepository>()),
          session: Get.find(),
        ),
      );
}
