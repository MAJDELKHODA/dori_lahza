import 'package:get/get.dart';

import '../../data/models/team/team_member_model.dart';
import '../../data/repositories/team_repository.dart';
import '../../core/network/api_exceptions.dart';

class TeamController extends GetxController {
  final TeamRepository _repository;

  TeamController({required TeamRepository repository})
    : _repository = repository;

  final RxList<TeamMemberModel> members = <TeamMemberModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getTeamMembers();

      members.assignAll(result);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'حدث خطأ أثناء تحميل الفريق';
    } finally {
      isLoading.value = false;
    }
  }

  TeamMemberModel? getMemberById(int id) {
    for (final member in members) {
      if (member.id == id) {
        return member;
      }
    }

    return null;
  }
}
