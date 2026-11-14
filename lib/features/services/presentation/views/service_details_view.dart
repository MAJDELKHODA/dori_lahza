import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_sections.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/reviews/presentation/widgets/review_widgets.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/presentation/controllers/service_details_controller.dart';
import 'package:dori_lahza/features/services/presentation/widgets/service_cards.dart';
import 'package:dori_lahza/features/staff/presentation/widgets/staff_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceDetailsView extends GetView<ServiceDetailsController> {
  const ServiceDetailsView({super.key, required this.serviceId});

  final int serviceId;

  @override
  String? get tag => '$serviceId';

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return Obx(
      () => Scaffold(
        appBar: controller.state.value is ViewSuccess ? null : AppBar(),
        bottomNavigationBar: switch (controller.state.value) {
          ViewSuccess(:final data) => BottomActionBar(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('السعر', style: context.text.labelSmall),
                        PriceTag(service: data, large: true),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: FilledButton.icon(
                      onPressed: () => AppNav.bookService(data),
                      icon: const Icon(Icons.event_available_rounded),
                      label: Text('احجز ${labels.booking}'),
                    ),
                  ),
                ],
              ),
            ),
          _ => null,
        },
        body: StateView<Service>(
          state: controller.state.value,
          loading: const _DetailsSkeleton(),
          onRetry: controller.load,
          builder: (context, service) => _Body(service: service, controller: controller),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.service, required this.controller});

  final Service service;
  final ServiceDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final labels = Get.find<PlaceController>().labels;
    final images = service.gallery.isNotEmpty ? service.gallery : [service.image];
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          stretch: true,
          backgroundColor: p.surface,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (i) => controller.galleryIndex.value = i,
                  itemBuilder: (_, i) => AppNetworkImage(url: images[i], radius: 0),
                ),
                if (images.length > 1)
                  PositionedDirectional(
                    bottom: Gap.md,
                    end: Gap.md,
                    child: Obx(
                      () => Pill(label: '${controller.galleryIndex.value + 1} / ${images.length}'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, Gap.md),
          sliver: SliverList.list(
            children: [
              Wrap(
                spacing: Gap.xs,
                runSpacing: Gap.xs,
                children: [
                  if (service.category != null) Pill(label: service.category!.name, tone: Tone.brand),
                  if (service.isFeatured) const Pill(label: 'مميّزة', tone: Tone.warning, icon: Icons.bolt_rounded),
                  if (service.hasDiscount && service.discountPercent != null)
                    Pill(label: 'خصم ${service.discountPercent}%', tone: Tone.danger),
                ],
              ),
              const VSpace(Gap.sm),
              Text(service.name, style: context.text.headlineSmall),
              if (service.rating.hasReviews) ...[
                const VSpace(Gap.xxs),
                Row(
                  children: [
                    RatingStars(rating: service.rating.average),
                    const HSpace(Gap.xs),
                    Text(
                      '${Fmt.rating(service.rating.average)} (${service.rating.count} تقييم)',
                      style: context.text.labelMedium,
                    ),
                  ],
                ),
              ],
              const VSpace(Gap.lg),
              Row(
                children: [
                  _Fact(
                    icon: Icons.schedule_rounded,
                    label: 'المدة',
                    value: service.durationLabel ?? Fmt.minutes(service.durationMinutes),
                  ),
                  const HSpace(Gap.sm),
                  if (service.isGroup)
                    _Fact(icon: Icons.groups_2_outlined, label: 'جلسة جماعية', value: '${service.capacity} مقعد')
                  else
                    const _Fact(icon: Icons.person_outline_rounded, label: 'النوع', value: 'فردية'),
                  const HSpace(Gap.sm),
                  _Fact(icon: Icons.trending_up_rounded, label: 'حُجزت', value: '${service.bookingsCount} مرة'),
                ],
              ),
              if (service.description != null) ...[
                const VSpace(Gap.xl),
                Text('عن ال${labels.service}', style: context.text.titleMedium),
                const VSpace(Gap.xs),
                Text(
                  service.description!,
                  style: context.text.bodyMedium?.copyWith(color: p.textSecondary, height: 1.75),
                ),
              ],
              if (service.attributes.isNotEmpty) ...[
                const VSpace(Gap.lg),
                AppCard(
                  child: Column(
                    children: [
                      for (final a in service.attributes)
                        InfoRow(icon: Icons.check_circle_outline_rounded, label: a.label, value: a.value),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (service.staff.isNotEmpty)
          SliverList.list(
            children: [
              const VSpace(Gap.sm),
              const SectionHeader(title: 'يقدّمها'),
              const VSpace(Gap.xs),
              HorizontalStrip(
                height: 124,
                spacing: Gap.xs,
                itemCount: service.staff.length,
                itemBuilder: (_, i) {
                  final s = service.staff[i];
                  return StaffBubble(
                    name: s.name,
                    title: s.title,
                    avatar: s.avatar,
                    initials: s.initials,
                    color: s.color,
                    onTap: () => AppNav.staffProfile(s.id),
                  );
                },
              ),
            ],
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, 0),
          sliver: SliverToBoxAdapter(child: _ReviewsPreview(controller: controller)),
        ),
        if (service.related.isNotEmpty)
          SliverList.list(
            children: [
              const VSpace(Gap.xl),
              SectionHeader(title: '${labels.servicePlural} مشابهة'),
              const VSpace(Gap.xs),
              HorizontalStrip(
                height: 252,
                itemCount: service.related.length,
                itemBuilder: (_, i) {
                  final s = service.related[i];
                  return ServiceCard(service: s, onTap: () => AppNav.serviceDetails(s.id));
                },
              ),
            ],
          ),
        const SliverToBoxAdapter(child: VSpace(Gap.xxl)),
      ],
    );
  }
}

class _ReviewsPreview extends StatelessWidget {
  const _ReviewsPreview({required this.controller});

  final ServiceDetailsController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
        final state = controller.reviews.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'التقييمات',
              padding: EdgeInsets.zero,
              actionLabel: state is ViewSuccess ? 'الكل' : null,
              onAction: () => AppNav.serviceReviews(controller.serviceId),
            ),
            const VSpace(Gap.xs),
            switch (state) {
              ViewLoading() => const Skeleton(child: SkeletonBox(height: 120, radius: Radii.lg)),
              ViewSuccess(:final data) => Column(
                  children: [
                    RatingSummaryCard(summary: data.summary, distribution: data.distribution),
                    for (final r in data.page.items.take(2)) ...[
                      const VSpace(Gap.sm),
                      ReviewCard(review: r, maxLines: 4),
                    ],
                  ],
                ),
              _ => AppCard(
                  child: Text(
                    'لا توجد تقييمات لهذه الخدمة بعد',
                    style: context.text.bodyMedium?.copyWith(color: context.palette.textSecondary),
                  ),
                ),
            },
          ],
        );
      });
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Gap.sm, horizontal: Gap.xs),
        decoration: BoxDecoration(
          color: p.surface,
          border: Border.all(color: p.border),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Column(
          children: [
            Icon(icon, color: p.strong, size: 22),
            const VSpace(Gap.xxs),
            Text(label, style: context.text.labelSmall),
            Text(value, style: context.text.labelLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) => const Skeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 260, radius: 0),
            Padding(
              padding: EdgeInsets.all(Gap.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 90, height: 22, radius: Radii.pill),
                  VSpace(Gap.sm),
                  SkeletonBox(width: 220, height: 24),
                  VSpace(Gap.lg),
                  Row(
                    children: [
                      Expanded(child: SkeletonBox(height: 80, radius: Radii.md)),
                      HSpace(Gap.sm),
                      Expanded(child: SkeletonBox(height: 80, radius: Radii.md)),
                      HSpace(Gap.sm),
                      Expanded(child: SkeletonBox(height: 80, radius: Radii.md)),
                    ],
                  ),
                  VSpace(Gap.lg),
                  SkeletonBox(height: 14),
                  VSpace(Gap.xs),
                  SkeletonBox(height: 14),
                  VSpace(Gap.xs),
                  SkeletonBox(width: 200, height: 14),
                ],
              ),
            ),
          ],
        ),
      );
}
