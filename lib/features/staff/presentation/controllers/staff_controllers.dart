import 'dart:async';

import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';
import 'package:dori_lahza/features/staff/domain/usecases/staff_usecases.dart';
import 'package:get/get.dart';

class TeamController extends GetxController {
  TeamController({required GetTeam getTeam}) : _getTeam = getTeam;

  final GetTeam _getTeam;

  final state = Rx<ViewState<List<StaffMember>>>(const ViewLoading());

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load() async {
    state.value = const ViewLoading();
    state.value = ViewState.fromResult(await _getTeam(), isEmpty: (t) => t.isEmpty);
  }
}

class StaffProfileController extends GetxController {
  StaffProfileController({required this.staffId, required GetStaffProfile getStaffProfile})
      : _getProfile = getStaffProfile;

  final int staffId;
  final GetStaffProfile _getProfile;

  final state = Rx<ViewState<StaffMember>>(const ViewLoading());

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load() async {
    state.value = const ViewLoading();
    state.value = ViewState.fromResult(await _getProfile(staffId));
  }
}
