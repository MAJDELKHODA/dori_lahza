import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:dori_lahza/features/waitlist/presentation/controllers/waitlist_controllers.dart';
import 'package:dori_lahza/features/waitlist/presentation/widgets/waitlist_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitlistView extends GetView<WaitlistController> {
  const WaitlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الانتظار')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.sm),
            child: Obx(
              () => SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('النشطة')),
                  ButtonSegment(value: false, label: Text('الكل')),
                ],
                selected: {controller.activeOnly.value},
                showSelectedIcon: false,
                onSelectionChanged: (s) => controller.setActiveOnly(s.first),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => StateView<List<WaitlistEntry>>(
                state: controller.state.value,
                loading: const SkeletonList(count: 4, thumbSize: 44),
                empty: const EmptyView(
                  icon: Icons.hourglass_empty_rounded,
                  title: 'لا توجد طلبات انتظار',
                  subtitle: 'عندما يكون اليوم ممتلئًا يمكنك الانضمام لقائمة الانتظار من صفحة الحجز',
                ),
                onRetry: controller.load,
                builder: (context, list) => RefreshIndicator(
                  onRefresh: () => controller.load(showLoading: false),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const VSpace(Gap.sm),
                    itemBuilder: (_, i) => WaitlistTile(
                      entry: list[i],
                      onTap: () async {
                        await AppNav.waitlistEntry(list[i].id);
                        await controller.load(showLoading: false);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
