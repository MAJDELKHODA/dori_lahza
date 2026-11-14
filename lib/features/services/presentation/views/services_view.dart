import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/paged_list_view.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/presentation/controllers/services_controller.dart';
import 'package:dori_lahza/features/services/presentation/widgets/service_cards.dart';
import 'package:dori_lahza/features/services/presentation/widgets/service_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Services tab: search, categories, filters and paged results.
class ServicesView extends GetView<ServicesController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(title: Text(labels.servicePlural)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xxs, Gap.page, Gap.sm),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => TextField(
                      controller: controller.searchText,
                      focusNode: controller.searchFocus,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن ${labels.service}...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: controller.hasQuery.value
                            ? IconButton(
                                tooltip: 'مسح',
                                onPressed: controller.clearSearch,
                                icon: const Icon(Icons.close_rounded),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const HSpace(Gap.xs),
                Obx(() {
                  final count = controller.filter.value.activeCount;
                  return Badge.count(
                    count: count,
                    isLabelVisible: count > 0,
                    backgroundColor: p.strong,
                    child: IconButton.filledTonal(
                      tooltip: 'الفلاتر والترتيب',
                      style: IconButton.styleFrom(
                        minimumSize: const Size(52, 52),
                        backgroundColor: p.surface,
                        side: BorderSide(color: p.border),
                        shape: const RoundedRectangleBorder(borderRadius: Radii.field),
                      ),
                      onPressed: () => ServiceFilterSheet.show(context, controller),
                      icon: Icon(Icons.tune_rounded, color: p.strong),
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 44, child: _CategoryBar(controller: controller)),
          const VSpace(Gap.xs),
          Expanded(
            child: PagedListView<Service>(
              controller: controller,
              loading: const ServiceTileSkeleton(),
              empty: Obx(
                () => EmptyView(
                  icon: Icons.search_off_rounded,
                  title: 'لا توجد نتائج',
                  subtitle: 'جرّب كلمات أخرى أو غيّر الفلاتر',
                  actionLabel: controller.filter.value.activeCount > 0 ? 'مسح الفلاتر' : null,
                  onAction: controller.clearFilters,
                ),
              ),
              itemBuilder: (_, s) => ServiceTile(service: s, onTap: () => AppNav.serviceDetails(s.id)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.controller});

  final ServicesController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
        final selected = controller.filter.value.categoryId;
        final categories = switch (controller.categories.value) {
          ViewSuccess(:final data) => data,
          _ => const <Category>[],
        };
        return ListView(
          scrollDirection: Axis.horizontal,
          padding: Gap.pagePadding,
          children: [
            CategoryChip(label: 'الكل', selected: selected == null, onTap: () => controller.selectCategory(null)),
            for (final c in categories) ...[
              const HSpace(Gap.xs),
              CategoryChip(
                label: c.name,
                icon: c.icon,
                count: c.servicesCount,
                selected: selected == c.id,
                onTap: () => controller.selectCategory(c.id),
              ),
            ],
          ],
        );
      });
}
