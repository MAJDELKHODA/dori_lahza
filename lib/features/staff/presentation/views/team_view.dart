import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';
import 'package:dori_lahza/features/staff/presentation/controllers/staff_controllers.dart';
import 'package:dori_lahza/features/staff/presentation/widgets/staff_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamView extends GetView<TeamController> {
  const TeamView({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return Scaffold(
      appBar: AppBar(title: Text(labels.staffPlural)),
      body: Obx(
        () => StateView<List<StaffMember>>(
          state: controller.state.value,
          loading: const SkeletonList(thumbSize: 56),
          empty: EmptyView(icon: Icons.groups_2_outlined, title: 'لا يوجد ${labels.staffPlural} بعد'),
          onRetry: controller.load,
          builder: (context, team) => RefreshIndicator(
            onRefresh: controller.load,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
              itemCount: team.length,
              separatorBuilder: (_, _) => const VSpace(Gap.sm),
              itemBuilder: (_, i) {
                final m = team[i];
                return StaffTile(
                  name: m.name,
                  title: m.title,
                  avatar: m.avatar,
                  initials: m.initials,
                  color: m.color,
                  rating: m.rating.average,
                  reviewsCount: m.rating.count,
                  onTap: () => AppNav.staffProfile(m.id),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
