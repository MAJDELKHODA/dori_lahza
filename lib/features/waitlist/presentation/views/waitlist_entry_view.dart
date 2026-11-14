import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:dori_lahza/features/waitlist/presentation/controllers/waitlist_controllers.dart';
import 'package:dori_lahza/features/waitlist/presentation/widgets/waitlist_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitlistEntryView extends GetView<WaitlistEntryController> {
  const WaitlistEntryView({super.key, required this.entryId});

  final int entryId;

  @override
  String? get tag => '$entryId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب الانتظار')),
      body: Obx(
        () => StateView<WaitlistEntry>(
          state: controller.state.value,
          loading: const Skeleton(
            child: Padding(
              padding: EdgeInsets.all(Gap.page),
              child: Column(
                children: [SkeletonBox(height: 220, radius: Radii.lg), VSpace(Gap.md), SkeletonBox(height: 140, radius: Radii.lg)],
              ),
            ),
          ),
          onRetry: controller.load,
          builder: (context, e) => RefreshIndicator(
            onRefresh: () => controller.load(showLoading: false),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
              children: [
                _StatusCard(entry: e, controller: controller),
                const VSpace(Gap.md),
                AppCard(
                  child: Column(
                    children: [
                      InfoRow(icon: Icons.spa_outlined, label: 'الخدمة', value: e.serviceName),
                      InfoRow(icon: Icons.calendar_today_outlined, label: 'اليوم', value: waitlistDay(e)),
                      InfoRow(icon: Icons.schedule_rounded, label: 'الوقت المفضّل', value: waitlistWindow(e)),
                      if (e.staffName != null) InfoRow(icon: Icons.person_outline_rounded, label: 'مع', value: e.staffName!),
                      if (e.position != null) InfoRow(icon: Icons.format_list_numbered_rounded, label: 'ترتيبك', value: '${e.position}'),
                      if (e.notes != null) InfoRow(icon: Icons.sticky_note_2_outlined, label: 'ملاحظات', value: e.notes!),
                    ],
                  ),
                ),
                if (e.isActive) ...[
                  const VSpace(Gap.lg),
                  Obx(
                    () => OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: context.palette.danger),
                      onPressed: controller.isLeaving.value ? null : controller.leave,
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('مغادرة قائمة الانتظار'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.entry, required this.controller});

  final WaitlistEntry entry;
  final WaitlistEntryController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    if (entry.status == WaitlistStatus.offered && entry.offer != null) {
      return AppCard(
        padding: const EdgeInsets.all(Gap.lg),
        child: Obx(() {
          final left = controller.secondsLeft.value;
          return Column(
            children: [
              Text('توفّر وقت لك!', style: context.text.titleLarge),
              const VSpace(Gap.xxs),
              Text('الساعة ${entry.offer!.time}', style: context.text.headlineSmall?.copyWith(color: p.strong)),
              const VSpace(Gap.lg),
              OfferCountdown(secondsLeft: left, total: entry.offer!.secondsLeft),
              const VSpace(Gap.lg),
              SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  label: left > 0 ? 'احجز هذا الوقت' : 'انتهت مهلة العرض',
                  icon: Icons.bolt_rounded,
                  loading: controller.isClaiming.value,
                  onPressed: left > 0 ? controller.claim : null,
                ),
              ),
              const VSpace(Gap.xs),
              Text(
                'إن لم تؤكد قبل انتهاء الوقت ينتقل العرض للشخص التالي.',
                textAlign: TextAlign.center,
                style: context.text.bodySmall,
              ),
            ],
          );
        }),
      );
    }
    final (icon, title, subtitle) = switch (entry.status) {
      WaitlistStatus.waiting => (
          Icons.hourglass_top_rounded,
          'أنت في قائمة الانتظار',
          'سنرسل لك إشعارًا فور توفر وقت مناسب',
        ),
      WaitlistStatus.booked => (Icons.task_alt_rounded, 'تم تحويل العرض إلى حجز', 'تجده في حجوزاتي'),
      WaitlistStatus.expired => (Icons.timer_off_outlined, 'انتهى الطلب', 'يمكنك الانضمام من جديد ليوم آخر'),
      _ => (Icons.cancel_outlined, entry.statusLabel ?? 'ملغى', null),
    };
    return AppCard(
      padding: const EdgeInsets.all(Gap.lg),
      child: Column(
        children: [
          Icon(icon, size: 48, color: p.strong),
          const VSpace(Gap.sm),
          Text(title, style: context.text.titleMedium, textAlign: TextAlign.center),
          if (subtitle != null) Text(subtitle, style: context.text.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
