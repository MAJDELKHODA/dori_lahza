import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/slot_picker_controller.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/staff/presentation/widgets/staff_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Person chips, day strip and time grid bound to a [SlotPickerController].
/// [footer] is shown under the slots (e.g. a waitlist offer for full days).
class SlotPicker extends StatelessWidget {
  const SlotPicker({super.key, required this.controller, this.fullDayAction});

  final SlotPickerController controller;

  /// Shown when the selected day has no slots but `can_join_waitlist` is true.
  final Widget Function(AvailabilityDay day)? fullDayAction;

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return ListView(
      padding: const EdgeInsets.only(bottom: Gap.xxl),
      children: [
        if (controller.staffOptions.isNotEmpty) ...[
          SectionHeader(title: 'اختر ${labels.staff}'),
          const VSpace(Gap.xs),
          SizedBox(
            height: 48,
            child: Obx(
              () => ListView(
                scrollDirection: Axis.horizontal,
                padding: Gap.pagePadding,
                children: [
                  StaffChoice(
                    label: 'أي شخص متاح',
                    selected: controller.staffId.value == null,
                    onTap: () => controller.selectStaff(null),
                  ),
                  for (final s in controller.staffOptions) ...[
                    const HSpace(Gap.xs),
                    StaffChoice(
                      label: s.name,
                      avatar: s.avatar,
                      initials: s.initials,
                      selected: controller.staffId.value == s.id,
                      onTap: () => controller.selectStaff(s.id),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const VSpace(Gap.lg),
        ],
        const SectionHeader(title: 'اختر اليوم'),
        const VSpace(Gap.xs),
        SizedBox(height: 96, child: _DayStrip(controller: controller)),
        const VSpace(Gap.lg),
        const SectionHeader(title: 'اختر الوقت'),
        const VSpace(Gap.xs),
        Padding(padding: Gap.pagePadding, child: _SlotGrid(controller: controller, fullDayAction: fullDayAction)),
      ],
    );
  }
}

class _DayStrip extends StatelessWidget {
  const _DayStrip({required this.controller});

  final SlotPickerController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
        final p = context.palette;
        return switch (controller.days.value) {
          ViewLoading() => Skeleton(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: Gap.pagePadding,
                itemCount: 6,
                separatorBuilder: (_, _) => const HSpace(Gap.xs),
                itemBuilder: (_, _) => const SkeletonBox(width: 68, height: 96, radius: Radii.md),
              ),
            ),
          ViewError(:final failure) => ErrorView(failure: failure, onRetry: controller.loadDays, compact: true),
          ViewEmpty() => const EmptyView(title: 'لا توجد أيام متاحة', compact: true),
          ViewSuccess(:final data) => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: Gap.pagePadding,
              itemCount: data.length,
              separatorBuilder: (_, _) => const HSpace(Gap.xs),
              itemBuilder: (_, i) {
                final day = data[i];
                final selected = controller.selectedDay.value?.date == day.date;
                final enabled = day.open;
                final date = day.asDate;
                final fg = selected ? p.onStrong : (enabled ? p.textPrimary : p.textMuted);
                return Opacity(
                  opacity: enabled ? 1 : 0.5,
                  child: Material(
                    color: selected ? p.strong : p.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                      side: BorderSide(color: selected ? p.strong : p.border),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.md),
                      onTap: enabled ? () => controller.selectDay(day) : null,
                      child: SizedBox(
                        width: 68,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(day.label, style: context.text.labelSmall?.copyWith(color: fg)),
                            Text(
                              date == null ? '' : '${date.day}',
                              style: context.text.titleLarge?.copyWith(color: fg),
                            ),
                            Text(
                              !day.open ? 'مغلق' : (day.slotsCount == 0 ? 'ممتلئ' : '${day.slotsCount} وقت'),
                              style: context.text.labelSmall?.copyWith(
                                color: selected ? p.onStrong : (day.isAvailable ? p.success : p.danger),
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        };
      });
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({required this.controller, this.fullDayAction});

  final SlotPickerController controller;
  final Widget Function(AvailabilityDay day)? fullDayAction;

  @override
  Widget build(BuildContext context) => Obx(() {
        final p = context.palette;
        final day = controller.selectedDay.value;
        return switch (controller.slots.value) {
          ViewLoading() => Skeleton(
              child: Wrap(
                spacing: Gap.xs,
                runSpacing: Gap.xs,
                children: List.generate(9, (_) => const SkeletonBox(width: 100, height: 44, radius: Radii.md)),
              ),
            ),
          ViewError(:final failure) => ErrorView(failure: failure, onRetry: controller.reloadSlots, compact: true),
          ViewEmpty(:final data) => Column(
              children: [
                const EmptyView(
                  icon: Icons.event_busy_outlined,
                  title: 'لا توجد أوقات متاحة في هذا اليوم',
                  subtitle: 'جرّب يومًا آخر',
                  compact: true,
                ),
                if (day != null && (data?.canJoinWaitlist ?? false) && fullDayAction != null) fullDayAction!(day),
              ],
            ),
          ViewSuccess(:final data) => Wrap(
              spacing: Gap.xs,
              runSpacing: Gap.xs,
              children: [
                for (final slot in data.slots)
                  _SlotChip(
                    slot: slot,
                    selected: controller.selectedSlot.value?.startsAt == slot.startsAt,
                    onTap: () => controller.selectSlot(slot),
                    palette: p,
                  ),
              ],
            ),
        };
      });
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.slot, required this.selected, required this.onTap, required this.palette});

  final Slot slot;
  final bool selected;
  final VoidCallback onTap;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return SizedBox(
      width: 100,
      child: Material(
        color: selected ? p.strong : p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: BorderSide(color: selected ? p.strong : p.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.md),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  slot.time,
                  textDirection: TextDirection.ltr,
                  style: context.text.titleSmall?.copyWith(color: selected ? p.onStrong : p.textPrimary),
                ),
                if (slot.seatsLeft != null && slot.seatsLeft! > 1)
                  Text(
                    '${slot.seatsLeft} مقاعد',
                    style: context.text.labelSmall?.copyWith(color: selected ? p.onStrong : p.success),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
