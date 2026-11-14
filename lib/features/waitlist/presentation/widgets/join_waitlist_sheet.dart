import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/waitlist/domain/repositories/waitlist_repository.dart';
import 'package:dori_lahza/features/waitlist/domain/usecases/waitlist_usecases.dart';
import 'package:dori_lahza/features/waitlist/presentation/controllers/join_waitlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinWaitlistSheet extends StatefulWidget {
  const JoinWaitlistSheet({super.key, required this.controller, required this.serviceName, required this.dayLabel});

  final JoinWaitlistController controller;
  final String serviceName;
  final String dayLabel;

  /// Signs in if needed, then opens the sheet with its own controller.
  static Future<void> show({
    required int serviceId,
    required String serviceName,
    required String date,
    required String dayLabel,
    int? staffId,
  }) async {
    if (!await Get.find<SessionController>().ensureSignedIn()) return;
    const tag = 'join-waitlist';
    final controller = Get.put(
      JoinWaitlistController(
        serviceId: serviceId,
        date: date,
        staffId: staffId,
        joinWaitlist: JoinWaitlist(Get.find<WaitlistRepository>()),
      ),
      tag: tag,
    );
    final joined = await Get.bottomSheet<bool>(
      JoinWaitlistSheet(controller: controller, serviceName: serviceName, dayLabel: dayLabel),
      isScrollControlled: true,
    );
    await Get.delete<JoinWaitlistController>(tag: tag);
    if (joined ?? false) {
      AppFeedback.success('انضممت لقائمة الانتظار، سنرسل لك إشعارًا عند توفر وقت');
      await AppNav.waitlist();
    }
  }

  @override
  State<JoinWaitlistSheet> createState() => _JoinWaitlistSheetState();
}

/// Owns the notes field so it is disposed with the sheet's route, after the
/// close animation, never while the TextField is still on screen.
class _JoinWaitlistSheetState extends State<JoinWaitlistSheet> {
  final _notes = TextEditingController();

  JoinWaitlistController get controller => widget.controller;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      borderRadius: Radii.sheet,
      child: SheetBody(
        title: 'قائمة الانتظار',
        subtitle: '${widget.serviceName} · ${widget.dayLabel}',
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('الوقت المناسب لك (اختياري)', style: context.text.titleSmall),
              const VSpace(Gap.xs),
              Row(
                children: [
                  Expanded(
                    child: _TimeField(
                      label: 'من',
                      value: controller.fromTime.value,
                      onPicked: controller.setFrom,
                    ),
                  ),
                  const HSpace(Gap.sm),
                  Expanded(
                    child: _TimeField(
                      label: 'إلى',
                      value: controller.toTime.value,
                      onPicked: controller.setTo,
                    ),
                  ),
                ],
              ),
              if (controller.rangeError.value != null) ...[
                const VSpace(Gap.xxs),
                Text(controller.rangeError.value!, style: context.text.bodySmall?.copyWith(color: p.danger)),
              ],
              const VSpace(Gap.md),
              TextField(
                controller: _notes,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'ملاحظات (اختياري)', hintText: 'مثال: أي وقت بعد الدوام'),
              ),
              const VSpace(Gap.md),
              Row(
                children: [
                  Icon(Icons.notifications_active_outlined, size: 18, color: p.strong),
                  const HSpace(Gap.xs),
                  Expanded(
                    child: Text(
                      'عند أي إلغاء يصلك عرض بوقت متاح، ولديك دقائق قليلة لتأكيده قبل أن ينتقل للتالي.',
                      style: context.text.bodySmall,
                    ),
                  ),
                ],
              ),
              const VSpace(Gap.lg),
              LoadingButton(
                label: 'انضم لقائمة الانتظار',
                loading: controller.isSubmitting.value,
                onPressed: () => controller.submit(_notes.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.label, required this.value, required this.onPicked});

  final String label;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?> onPicked;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: Radii.field,
        onTap: () async {
          final picked = await showTimePicker(context: context, initialTime: value ?? const TimeOfDay(hour: 16, minute: 0));
          if (picked != null) onPicked(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: value == null
                ? const Icon(Icons.schedule_rounded)
                : IconButton(
                    tooltip: 'مسح',
                    onPressed: () => onPicked(null),
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
          child: Text(value == null ? 'أي وقت' : value!.format(context)),
        ),
      );
}
