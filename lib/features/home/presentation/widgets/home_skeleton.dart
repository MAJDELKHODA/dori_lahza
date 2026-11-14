import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_hero.dart';
import 'package:flutter/material.dart';

/// Loading layout that mirrors the home screen: cover with the overlapping
/// info card, search, quick actions, banner and categories.
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
            children: [
              SkeletonBox(height: HomeHero.coverHeight + top, radius: 0),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  Gap.page,
                  top + HomeHero.coverHeight - HomeHero.cardOverlap,
                  Gap.page,
                  0,
                ),
                child: const SkeletonBox(height: 170, radius: Radii.xl),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
