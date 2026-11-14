import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/booking_slots_controller.dart';
import 'package:dori_lahza/features/booking/presentation/widgets/slot_picker.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/services/presentation/widgets/service_cards.dart';
import 'package:dori_lahza/features/waitlist/presentation/widgets/join_waitlist_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingSlotsView extends GetView<BookingSlotsController> {
  const BookingSlotsView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final labels = Get.find<PlaceController>().labels;
    final service = controller.service;
    return Scaffold(
      appBar: AppBar(title: Text('حجز ${labels.booking}')),
      bottomNavigationBar: BottomActionBar(
        child: Obx(() {
          final slot = controller.selectedSlot.value;
          final day = controller.selectedDay.value;
          return Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(slot == null ? 'لم تختر وقتًا بعد' : 'الموعد المختار', style: context.text.labelSmall),
                    if (slot != null && day != null)
                      Text(
                        '${day.label} · ${slot.time}',
                        style: context.text.titleSmall?.copyWith(color: p.strong),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 150,
                child: FilledButton(
                  onPressed: controller.canContinue ? controller.submit : null,
                  child: const Text('متابعة'),
                ),
              ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.md),
            child: AppCard(
              padding: const EdgeInsets.all(Gap.sm),
              child: Row(
                children: [
                  AppNetworkImage(url: service.thumb ?? service.image, width: 56, height: 56),
                  const HSpace(Gap.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          service.durationLabel ?? Fmt.minutes(service.durationMinutes),
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  PriceTag(service: service),
                ],
              ),
            ),
          ),
          Expanded(
            child: SlotPicker(
              controller: controller,
              fullDayAction: (day) => Padding(
                padding: const EdgeInsets.only(top: Gap.sm),
                child: AppCard(
                  color: p.soft,
                  borderColor: p.soft,
                  child: Column(
                    children: [
                      Text('اليوم ممتلئ؟ انضم لقائمة الانتظار', style: context.text.titleSmall),
                      const VSpace(Gap.xxs),
                      Text(
                        'نرسل لك عرضًا فور إلغاء أي موعد في هذا اليوم',
                        textAlign: TextAlign.center,
                        style: context.text.bodySmall,
                      ),
                      const VSpace(Gap.sm),
                      FilledButton.tonalIcon(
                        onPressed: () => JoinWaitlistSheet.show(
                          serviceId: service.id,
                          serviceName: service.name,
                          date: day.date,
                          dayLabel: day.label,
                          staffId: controller.staffId.value,
                        ),
                        icon: const Icon(Icons.hourglass_top_rounded),
                        label: const Text('انضم لقائمة الانتظار'),
                      ),
                    ],
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
