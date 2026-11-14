import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:flutter/material.dart';

/// Loading layout that mirrors the home screen.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Skeleton(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(Gap.page),
          children: [
            const Row(
              children: [
                SkeletonBox.circle(size: 50),
                HSpace(Gap.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [SkeletonBox(width: 80, height: 12), VSpace(6), SkeletonBox(width: 150, height: 18)],
                ),
              ],
            ),
            const VSpace(Gap.lg),
            const SkeletonBox(height: 50, radius: Radii.md),
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
            const VSpace(Gap.xl),
            const SkeletonBox(width: 120, height: 16),
            const VSpace(Gap.sm),
            const Row(
              children: [
                Expanded(child: SkeletonBox(height: 210, radius: Radii.lg)),
                HSpace(Gap.sm),
                Expanded(child: SkeletonBox(height: 210, radius: Radii.lg)),
              ],
            ),
          ],
        ),
      );
}
