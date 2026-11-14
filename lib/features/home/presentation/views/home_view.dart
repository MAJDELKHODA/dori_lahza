import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';
import 'package:dori_lahza/features/home/presentation/controllers/home_controller.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_header.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_sections.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_skeleton.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/reviews/presentation/widgets/review_widgets.dart';
import 'package:dori_lahza/features/services/presentation/widgets/service_cards.dart';
import 'package:dori_lahza/features/staff/presentation/widgets/staff_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => StateView<HomeFeed>(
            state: controller.state.value,
            loading: const HomeSkeleton(),
            onRetry: controller.load,
            builder: (context, feed) => RefreshIndicator(
              onRefresh: controller.refreshFeed,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: Gap.xxl),
                children: [
                  const HomeHeader(),
                  const VSpace(Gap.md),
                  Padding(
                    padding: Gap.pagePadding,
                    child: SearchEntry(
                      hint: 'ابحث عن ${labels.service}...',
                      onTap: controller.openSearch,
                    ),
                  ),
                  if (feed.banners.isNotEmpty) ...[
                    const VSpace(Gap.lg),
                    BannerCarousel(banners: feed.banners, onTap: controller.openBanner),
                  ],
                  if (feed.queue != null && feed.queue!.enabled) ...[
                    const VSpace(Gap.lg),
                    Padding(
                      padding: Gap.pagePadding,
                      child: QueueTeaser(board: feed.queue!, onTap: controller.openQueue),
                    ),
                  ],
                  if (feed.categories.isNotEmpty) ...[
                    const VSpace(Gap.xl),
                    SectionHeader(
                      title: 'التصنيفات',
                      actionLabel: 'الكل',
                      onAction: controller.openAllServices,
                    ),
                    const VSpace(Gap.xs),
                    HorizontalStrip(
                      height: 104,
                      itemCount: feed.categories.length,
                      itemBuilder: (_, i) {
                        final c = feed.categories[i];
                        return CategoryTile(category: c, onTap: () => controller.openCategory(c.id));
                      },
                    ),
                  ],
                  if (feed.featured.isNotEmpty) ...[
                    const VSpace(Gap.xl),
                    const SectionHeader(title: 'مميّزة لك'),
                    const VSpace(Gap.xs),
                    HorizontalStrip(
                      height: 252,
                      itemCount: feed.featured.length,
                      itemBuilder: (_, i) {
                        final s = feed.featured[i];
                        return ServiceCard(service: s, onTap: () => AppNav.serviceDetails(s.id));
                      },
                    ),
                  ],
                  const VSpace(Gap.xl),
                  const Padding(
                    padding: Gap.pagePadding,
                    child: BusyHoursTeaser(onTap: AppNav.busyHours),
                  ),
                  if (feed.popular.isNotEmpty) ...[
                    const VSpace(Gap.xl),
                    SectionHeader(
                      title: 'الأكثر طلبًا',
                      actionLabel: 'كل ${labels.servicePlural}',
                      onAction: controller.openAllServices,
                    ),
                    const VSpace(Gap.xs),
                    Padding(
                      padding: Gap.pagePadding,
                      child: Column(
                        children: [
                          for (final s in feed.popular.take(4)) ...[
                            ServiceTile(service: s, onTap: () => AppNav.serviceDetails(s.id)),
                            const VSpace(Gap.sm),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (feed.staff.isNotEmpty) ...[
                    const VSpace(Gap.lg),
                    SectionHeader(title: labels.staffPlural, actionLabel: 'الكل', onAction: AppNav.team),
                    const VSpace(Gap.xs),
                    HorizontalStrip(
                      height: 116,
                      spacing: Gap.xs,
                      itemCount: feed.staff.length,
                      itemBuilder: (_, i) {
                        final m = feed.staff[i];
                        return StaffBubble(
                          name: m.name,
                          title: m.title,
                          avatar: m.avatar,
                          initials: m.initials,
                          color: m.color,
                          onTap: () => AppNav.staffProfile(m.id),
                        );
                      },
                    ),
                  ],
                  const VSpace(Gap.xl),
                  const SectionHeader(title: 'آراء العملاء', actionLabel: 'الكل', onAction: AppNav.placeReviews),
                  const VSpace(Gap.xs),
                  if (feed.latestReviews.isEmpty)
                    Padding(
                      padding: Gap.pagePadding,
                      child: AppCard(
                        child: Row(
                          children: [
                            Icon(Icons.rate_review_outlined, color: context.palette.textMuted),
                            const HSpace(Gap.sm),
                            Expanded(
                              child: Text(
                                'لا توجد تقييمات بعد، كن أول من يقيّم بعد زيارتك',
                                style: context.text.bodyMedium?.copyWith(color: context.palette.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    HorizontalStrip(
                      height: 168,
                      itemCount: feed.latestReviews.length,
                      itemBuilder: (_, i) => ReviewCard(review: feed.latestReviews[i], maxLines: 3, width: 280),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
