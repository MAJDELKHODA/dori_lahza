import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_hero.dart';
import 'package:flutter/material.dart';

/// Loading layout that mirrors the home screen (cover, logo, identity,
/// search, quick actions, banner, categories).
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SkeletonBox(height: HomeHero.coverHeight + top, radius: 0),
              const PositionedDirectional(
                start: Gap.page,
                bottom: -HomeHero.logoSize / 2,
                child: SkeletonBox.circle(size: HomeHero.logoSize + 8),
              ),
            ],
          ),
          const VSpace(HomeHero.logoSize / 2 + Gap.sm),
          Padding(
            padding: Gap.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(width: 70, height: 12),
                const VSpace(6),
                const SkeletonBox(width: 170, height: 22),
                const VSpace(Gap.sm),
                const Row(
                  children: [
                    SkeletonBox(width: 80, height: 24, radius: Radii.pill),
                    HSpace(Gap.xs),
                    SkeletonBox(width: 120, height: 24, radius: Radii.pill),
                  ],
                ),
                const VSpace(Gap.lg),
                const SkeletonBox(height: 50, radius: Radii.md),
                const VSpace(Gap.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (_) => const SkeletonBox(width: 56, height: 56, radius: Radii.lg)),
                ),
                const VSpace(Gap.lg),
                const SkeletonBox(height: 168, radius: Radii.lg),
                const VSpace(Gap.xl),
                const SkeletonBox(width: 120, height: 16),
                const VSpace(Gap.sm),
                Row(
                  children: List.generate(
                    4,
                    (_) => const Padding(
                      padding: EdgeInsetsDirectional.only(end: Gap.sm),
                      child: SkeletonBox(width: 64, height: 64, radius: Radii.lg),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
