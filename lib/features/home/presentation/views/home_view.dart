import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';
import 'package:dori_lahza/features/home/presentation/controllers/home_controller.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_hero.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_highlights.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_sections.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_skeleton.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/reviews/presentation/widgets/review_widgets.dart';
import 'package:dori_lahza/features/services/presentation/widgets/service_cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return Scaffold(
      // No top SafeArea: the hero cover runs under the status bar.
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
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
                  HomeHero(controller: controller),
                  const VSpace(Gap.lg),
                  Padding(
                    padding: Gap.pagePadding,
                    child: SearchEntry(
                      hint: 'ابحث عن ${labels.service}...',
                      onTap: controller.openSearch,
                    ),
                  ),
                  const VSpace(Gap.lg),
                  QuickActions(controller: controller),
                  NextBookingCard(controller: controller),
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
                      height: 112,
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
                  if (feed.popular.isNotEmpty) ...[
                    const VSpace(Gap.xl),
                    SectionHeader(
                      title: 'الأكثر طلبًا',
                      actionLabel: 'كل ${labels.servicePlural}',
                      onAction: controller.openAllServices,
                    ),
                    const VSpace(Gap.xs),
                    HorizontalStrip(
                      height: 252,
                      itemCount: feed.popular.length,
                      itemBuilder: (_, i) {
                        final s = feed.popular[i];
                        return ServiceCard(service: s, onTap: () => AppNav.serviceDetails(s.id));
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
