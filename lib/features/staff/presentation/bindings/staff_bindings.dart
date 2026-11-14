import 'package:dori_lahza/features/staff/domain/repositories/staff_repository.dart';
import 'package:dori_lahza/features/staff/domain/usecases/staff_usecases.dart';
import 'package:dori_lahza/features/staff/presentation/controllers/staff_controllers.dart';
import 'package:get/get.dart';

class TeamBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => TeamController(getTeam: GetTeam(Get.find<StaffRepository>())));
}

class StaffProfileBinding extends Bindings {
  StaffProfileBinding(this.staffId);

  final int staffId;

  @override
  void dependencies() => Get.lazyPut(
        () => StaffProfileController(
          staffId: staffId,
          getStaffProfile: GetStaffProfile(Get.find<StaffRepository>()),
        ),
        tag: '$staffId',
      );
}
