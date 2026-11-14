import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/booking_confirm_controller.dart';
import 'package:dori_lahza/features/booking/presentation/widgets/intake_field_input.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingConfirmView extends GetView<BookingConfirmController> {
  const BookingConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    final place = Get.find<PlaceController>();
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(title: Text('تأكيد ال${place.labels.booking}')),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => LoadingButton(
            label: 'تأكيد الحجز · ${place.price(controller.total)}',
            icon: Icons.check_circle_outline_rounded,
            loading: controller.isSubmitting.value,
            onPressed: controller.confirm,
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
          children: [
            Obx(() {
              final d = controller.draft.value;
              final start = d.slot.start;
              return AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppNetworkImage(url: d.service.thumb ?? d.service.image, width: 60, height: 60),
                        const HSpace(Gap.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.service.name, style: context.text.titleSmall),
                              Text(
                                d.service.durationLabel ?? Fmt.minutes(d.service.durationMinutes),
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const VSpace(Gap.sm),
                    const Divider(),
                    const VSpace(Gap.xs),
                    InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'اليوم',
                      value: start == null ? d.day.label : Fmt.dayMonth(start),
                    ),
                    InfoRow(icon: Icons.schedule_rounded, label: 'الوقت', value: d.slot.time),
                    InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: place.labels.staff,
                      value: d.staffName ?? (d.slot.staff.length == 1 ? d.slot.staff.first.name : 'أي شخص متاح'),
                    ),
                  ],
                ),
              );
            }),
            if (controller.intakeFields.isNotEmpty) ...[
              const VSpace(Gap.lg),
              const SectionHeader(title: 'معلومات إضافية', padding: EdgeInsets.zero),
              const VSpace(Gap.sm),
              for (final field in controller.intakeFields) ...[
                IntakeFieldInput(field: field, controller: controller),
                const VSpace(Gap.md),
              ],
            ],
            const VSpace(Gap.lg),
            TextFormField(
              controller: controller.notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                hintText: 'أي تفاصيل تود إخبارنا بها',
                alignLabelWithHint: true,
              ),
            ),
            const VSpace(Gap.lg),
            const SectionHeader(title: 'كوبون الخصم', padding: EdgeInsets.zero),
            const VSpace(Gap.xs),
            Obx(() {
              final applied = controller.coupon.value;
              if (applied != null) {
                return AppCard(
                  color: p.successSoft,
                  borderColor: p.success.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer_rounded, color: p.success),
                      const HSpace(Gap.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(applied.code, style: context.text.titleSmall?.copyWith(color: p.success)),
                            Text(
                              applied.message ?? 'وفّرت ${place.price(applied.discount)}',
                              style: context.text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      TextButton(onPressed: controller.removeCoupon, child: const Text('إزالة')),
                    ],
                  ),
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.couponText,
                      textCapitalization: TextCapitalization.characters,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        hintText: 'أدخل الكود',
                        prefixIcon: const Icon(Icons.local_offer_outlined),
                        errorText: controller.couponError.value,
                      ),
                      onSubmitted: (_) => controller.applyCoupon(),
                    ),
                  ),
                  const HSpace(Gap.xs),
                  SizedBox(
                    width: 96,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: controller.isCheckingCoupon.value ? null : controller.applyCoupon,
                      child: controller.isCheckingCoupon.value
                          ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('تطبيق'),
                    ),
                  ),
                ],
              );
            }),
            const VSpace(Gap.lg),
            AppCard(
              child: Obx(
                () => Column(
                  children: [
                    _PriceLine(label: 'السعر', value: place.price(controller.subtotal)),
                    if (controller.discount > 0)
                      _PriceLine(
                        label: 'الخصم',
                        value: '- ${place.price(controller.discount)}',
                        color: p.success,
                      ),
                    const Divider(height: Gap.lg),
                    _PriceLine(label: 'الإجمالي', value: place.price(controller.total), bold: true),
                    const VSpace(Gap.xs),
                    Row(
                      children: [
                        Icon(Icons.payments_outlined, size: 18, color: p.textMuted),
                        const HSpace(Gap.xs),
                        Text('الدفع نقدًا عند الحضور', style: context.text.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const VSpace(Gap.md),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: p.textMuted),
                const HSpace(Gap.xs),
                Expanded(
                  child: Text(
                    [
                      if (!controller.autoConfirm) 'يُراجع الحجز من المنشأة قبل تأكيده.',
                      if (place.rules.cancelBeforeHours > 0)
                        'يمكنك الإلغاء أو التعديل مجانًا قبل ${place.rules.cancelBeforeHours} ساعة من الموعد.',
                    ].join(' '),
                    style: context.text.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.label, required this.value, this.color, this.bold = false});

  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? context.text.titleMedium : context.text.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style?.copyWith(color: bold ? null : context.palette.textSecondary))),
          Text(value, style: style?.copyWith(color: color ?? (bold ? context.palette.strong : null))),
        ],
      ),
    );
  }
}
