import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer wrapper; place [SkeletonBox]es inside to sketch the real layout.
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Shimmer.fromColors(
      baseColor: p.surfaceMuted,
      highlightColor: p.surface,
      period: const Duration(milliseconds: 1300),
      child: child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 14, this.radius = Radii.sm});

  const SkeletonBox.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = Radii.pill;

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.palette.surfaceMuted,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

/// Generic list skeleton: [count] rows of thumbnail + two text lines.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 6, this.thumbSize = 64, this.padding});

  final int count;
  final double thumbSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Skeleton(
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: padding ?? const EdgeInsets.all(Gap.page),
          itemCount: count,
          separatorBuilder: (_, _) => const VSpace(Gap.md),
          itemBuilder: (_, _) => Row(
            children: [
              SkeletonBox(width: thumbSize, height: thumbSize, radius: Radii.md),
              const HSpace(Gap.sm),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 160, height: 14),
                    VSpace(Gap.xs),
                    SkeletonBox(width: 100, height: 12),
                    VSpace(Gap.xs),
                    SkeletonBox(width: 70, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
