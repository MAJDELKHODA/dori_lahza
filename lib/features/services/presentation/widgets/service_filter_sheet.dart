import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/presentation/controllers/services_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Sort + advanced filters, edited on the controller's draft and applied together.
class ServiceFilterSheet extends StatelessWidget {
  const ServiceFilterSheet({super.key, required this.controller});

  final ServicesController controller;

  static Future<void> show(BuildContext context, ServicesController controller) {
    controller.beginEditingFilters();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ServiceFilterSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return SheetBody(
      title: 'الفلاتر والترتيب',
      child: Obx(() {
        final d = controller.draft.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Label('الترتيب'),
            Wrap(
              spacing: Gap.xs,
              runSpacing: Gap.xs,
              children: [
                for (final sort in ServiceSort.values)
                  ChoiceChip(
                    label: Text(sort.label),
                    selected: d.sort == sort,
                    onSelected: (_) => controller.editDraft((f) => f.copyWith(sort: sort)),
                  ),
              ],
            ),
            const _Label('المدة القصوى'),
            Wrap(
              spacing: Gap.xs,
              runSpacing: Gap.xs,
              children: [
                ChoiceChip(
                  label: const Text('أي مدة'),
                  selected: d.maxDuration == null,
                  onSelected: (_) => controller.editDraft((f) => f.copyWith(maxDuration: () => null)),
                ),
                for (final minutes in ServicesController.durationOptions)
                  ChoiceChip(
                    label: Text('حتى ${Fmt.minutes(minutes)}'),
                    selected: d.maxDuration == minutes,
                    onSelected: (_) => controller.editDraft((f) => f.copyWith(maxDuration: () => minutes)),
                  ),
              ],
            ),
            _Label(labels.staff),
            switch (controller.team.value) {
              ViewLoading() => const Padding(
                  padding: EdgeInsets.all(Gap.sm),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
                ),
              ViewSuccess(:final data) => Wrap(
                  spacing: Gap.xs,
                  runSpacing: Gap.xs,
                  children: [
                    ChoiceChip(
                      label: const Text('الجميع'),
                      selected: d.staffId == null,
                      onSelected: (_) => controller.editDraft((f) => f.copyWith(staffId: () => null)),
                    ),
                    for (final m in data)
                      ChoiceChip(
                        label: Text(m.name),
                        selected: d.staffId == m.id,
                        onSelected: (_) => controller.editDraft((f) => f.copyWith(staffId: () => m.id)),
                      ),
                  ],
                ),
              _ => Text('تعذّر تحميل ${labels.staffPlural}', style: context.text.bodySmall),
            },
            const VSpace(Gap.md),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: d.featuredOnly,
              onChanged: (v) => controller.editDraft((f) => f.copyWith(featuredOnly: v)),
              title: Text('المميّزة فقط', style: context.text.labelLarge),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: d.groupOnly,
              onChanged: (v) => controller.editDraft((f) => f.copyWith(groupOnly: v)),
              title: Text('الجلسات الجماعية فقط', style: context.text.labelLarge),
            ),
            const VSpace(Gap.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: controller.resetDraft, child: const Text('إعادة تعيين')),
                ),
                const HSpace(Gap.sm),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {
                      controller.applyDraft();
                      Navigator.pop(context);
                    },
                    child: const Text('عرض النتائج'),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Gap.md, bottom: Gap.xs),
        child: Text(text, style: context.text.titleSmall?.copyWith(color: context.palette.textSecondary)),
      );
}
