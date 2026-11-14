import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/place/presentation/widgets/opening_hours_card.dart';
import 'package:dori_lahza/features/reviews/presentation/widgets/review_widgets.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';
import 'package:dori_lahza/features/staff/presentation/controllers/staff_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Bio, working hours, services and latest reviews of one person.
class StaffProfileView extends GetView<StaffProfileController> {
  const StaffProfileView({super.key, required this.staffId});

  final int staffId;

  @override
  String? get tag => '$staffId';

  @override
  Widget build(BuildContext context) {
    final place = Get.find<PlaceController>();
    return Scaffold(
      appBar: AppBar(title: Text(place.labels.staff)),
      body: Obx(
        () => StateView<StaffMember>(
          state: controller.state.value,
          loading: const _ProfileSkeleton(),
          onRetry: controller.load,
          builder: (context, m) {
            final p = context.palette;
            final brand = AppPalette.parseHex(m.color) ?? p.strong;
            return ListView(
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
              children: [
                AppCard(
                  padding: const EdgeInsets.all(Gap.lg),
                  child: Column(
                    children: [
                      AppAvatar(url: m.avatar, initials: m.initials, color: brand, size: 96),
                      const VSpace(Gap.sm),
                      Text(m.name, style: context.text.titleLarge),
                      if (m.title != null) Text(m.title!, style: context.text.bodyMedium?.copyWith(color: brand)),
                      if (m.rating.hasReviews) ...[
                        const VSpace(Gap.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingStars(rating: m.rating.average),
                            const HSpace(Gap.xs),
                            Text('${Fmt.rating(m.rating.average)} (${m.rating.count})', style: context.text.labelMedium),
                          ],
                        ),
                      ],
                      if (m.bio != null) ...[
                        const VSpace(Gap.md),
                        Text(
                          m.bio!,
                          textAlign: TextAlign.center,
                          style: context.text.bodyMedium?.copyWith(color: p.textSecondary, height: 1.7),
                        ),
                      ],
                    ],
                  ),
                ),
                if (m.services.isNotEmpty) ...[
                  const VSpace(Gap.lg),
                  SectionHeader(title: place.labels.servicePlural, padding: EdgeInsets.zero),
                  const VSpace(Gap.xs),
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: Gap.xxs),
                    child: Column(
                      children: [
                        for (var i = 0; i < m.services.length; i++) ...[
                          if (i > 0) const Divider(indent: Gap.md, endIndent: Gap.md),
                          ListTile(
                            onTap: () => AppNav.serviceDetails(m.services[i].id),
                            title: Text(m.services[i].name, style: context.text.labelLarge),
                            subtitle: Text(Fmt.minutes(m.services[i].durationMinutes), style: context.text.bodySmall),
                            trailing: Text(
                              place.price(m.services[i].finalPrice),
                              style: context.text.titleSmall?.copyWith(color: p.strong),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                if (m.hours.isNotEmpty) ...[
                  const VSpace(Gap.lg),
                  const SectionHeader(title: 'ساعات العمل', padding: EdgeInsets.zero),
                  const VSpace(Gap.xs),
                  OpeningHoursCard(hours: m.hours),
                ],
                if (m.latestReviews.isNotEmpty) ...[
                  const VSpace(Gap.lg),
                  const SectionHeader(title: 'آخر التقييمات', padding: EdgeInsets.zero),
                  for (final r in m.latestReviews) ...[
                    const VSpace(Gap.sm),
                    ReviewCard(review: r),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) => const Skeleton(
        child: Padding(
          padding: EdgeInsets.all(Gap.page),
          child: Column(
            children: [
              SkeletonBox(height: 240, radius: Radii.lg),
              VSpace(Gap.lg),
              SkeletonBox(height: 180, radius: Radii.lg),
            ],
          ),
        ),
      );
}
