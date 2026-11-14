import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/booking/presentation/widgets/slot_picker.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/reschedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescheduleView extends GetView<RescheduleController> {
  const RescheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final b = controller.booking;
    return Scaffold(
      appBar: AppBar(title: const Text('تغيير الموعد')),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => LoadingButton(
            label: controller.selectedSlot.value == null
                ? 'اختر وقتًا جديدًا'
                : 'تأكيد الموعد الجديد · ${controller.selectedDay.value?.label ?? ''} ${controller.selectedSlot.value!.time}',
            loading: controller.isSubmitting.value,
            onPressed: controller.canContinue ? controller.submit : null,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.md),
            child: AppCard(
              color: p.surfaceMuted,
              child: Row(
                children: [
                  Icon(Icons.event_rounded, color: p.textMuted),
                  const HSpace(Gap.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الموعد الحالي', style: context.text.labelSmall),
                        Text('${b.serviceName} · ${b.dayLabel} ${b.time}', style: context.text.labelLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: SlotPicker(controller: controller)),
        ],
      ),
    );
  }
}
