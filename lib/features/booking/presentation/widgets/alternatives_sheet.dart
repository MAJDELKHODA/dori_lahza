import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shown on `SLOT_UNAVAILABLE`: pick one of the nearby alternatives or go back.
/// Pops with the chosen [Slot].
class AlternativesSheet extends StatelessWidget {
  const AlternativesSheet({super.key, required this.message, required this.alternatives});

  final String message;
  final List<Slot> alternatives;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      borderRadius: Radii.sheet,
      child: SheetBody(
        title: 'سبقك أحد إلى هذا الوقت',
        subtitle: message,
        child: alternatives.isEmpty
            ? Column(
                children: [
                  const EmptyView(icon: Icons.event_busy_outlined, title: 'لا توجد أوقات بديلة قريبة', compact: true),
                  OutlinedButton(onPressed: () => Get.back<void>(), child: const Text('اختيار وقت آخر')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('أوقات بديلة قريبة:', style: context.text.titleSmall),
                  const VSpace(Gap.sm),
                  for (final slot in alternatives) ...[
                    AppCard(
                      onTap: () => Get.back(result: slot),
                      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
                      child: Row(
                        children: [
                          Icon(Icons.schedule_rounded, color: p.strong),
                          const HSpace(Gap.sm),
                          Expanded(
                            child: Text(
                              slot.start == null ? slot.time : '${Fmt.dayMonth(slot.start!)} · ${slot.time}',
                              style: context.text.labelLarge,
                            ),
                          ),
                          if (slot.staff.isNotEmpty)
                            Text(slot.staff.first.name, style: context.text.labelSmall),
                          const HSpace(Gap.xs),
                          Icon(Icons.chevron_right_rounded, color: p.textMuted),
                        ],
                      ),
                    ),
                    const VSpace(Gap.xs),
                  ],
                  const VSpace(Gap.xs),
                  OutlinedButton(onPressed: () => Get.back<void>(), child: const Text('اختيار وقت آخر بنفسي')),
                ],
              ),
      ),
    );
  }
}
