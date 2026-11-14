import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/utils/icon_mapper.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Final price, with the original struck through when discounted.
class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.service, this.large = false});

  final Service service;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final place = Get.find<PlaceController>();
    return Wrap(
      spacing: Gap.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          place.price(service.finalPrice),
          style: (large ? context.text.titleLarge : context.text.titleSmall)?.copyWith(color: p.strong),
        ),
        if (service.hasDiscount)
          Text(
            place.price(service.price),
            style: context.text.bodySmall?.copyWith(
              color: p.textMuted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}

/// Duration · group · rating meta line.
class ServiceMeta extends StatelessWidget {
  const ServiceMeta({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final style = context.text.bodySmall;
    return Wrap(
      spacing: Gap.sm,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _meta(Icons.schedule_rounded, service.durationLabel ?? Fmt.minutes(service.durationMinutes), p.textMuted, style),
        if (service.isGroup) _meta(Icons.groups_2_outlined, 'جماعية · ${service.capacity}', p.textMuted, style),
        if (service.rating.hasReviews)
          _meta(Icons.star_rounded, Fmt.rating(service.rating.average), p.star, style),
      ],
    );
  }

  Widget _meta(IconData icon, String text, Color color, TextStyle? style) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 15, color: color), const HSpace(3), Text(text, style: style)],
      );
}

/// Vertical card for horizontal carousels (featured).
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, required this.onTap, this.width = 230});

  final Service service;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppCard(
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppNetworkImage(url: service.thumb ?? service.image, height: 130, width: width, radius: 0),
                if (service.discountPercent != null && service.hasDiscount)
                  PositionedDirectional(
                    top: Gap.xs,
                    start: Gap.xs,
                    child: Pill(label: 'خصم ${service.discountPercent}%', tone: Tone.danger),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(Gap.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.titleSmall),
                  const VSpace(Gap.xxs),
                  ServiceMeta(service: service),
                  const VSpace(Gap.xs),
                  PriceTag(service: service),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal row for lists (search results, popular).
class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.service, required this.onTap});

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(Gap.sm),
      onTap: onTap,
      child: Row(
        children: [
          AppNetworkImage(url: service.thumb ?? service.image, width: 84, height: 84),
          const HSpace(Gap.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (service.category != null)
                  Text(service.category!.name, style: context.text.labelSmall?.copyWith(color: p.strong)),
                Text(service.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.titleSmall),
                const VSpace(Gap.xxs),
                ServiceMeta(service: service),
                const VSpace(Gap.xxs),
                Row(
                  children: [
                    Expanded(child: PriceTag(service: service)),
                    if (service.hasDiscount && service.discountPercent != null)
                      Pill(label: '-${service.discountPercent}%', tone: Tone.danger),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceTileSkeleton extends StatelessWidget {
  const ServiceTileSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) => SkeletonList(count: count, thumbSize: 84);
}

/// Category chip with icon, used in home and the services filter bar.
class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label, this.icon, required this.selected, required this.onTap, this.count});

  final String label;
  final String? icon;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: selected ? p.strong : p.surface,
      shape: StadiumBorder(side: BorderSide(color: selected ? p.strong : p.border)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(IconMapper.fromName(icon), size: 18, color: selected ? p.onStrong : p.strong),
                const HSpace(6),
              ],
              Text(
                label,
                style: context.text.labelMedium?.copyWith(
                  color: selected ? p.onStrong : p.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (count != null) ...[
                const HSpace(6),
                Text(
                  '$count',
                  style: context.text.labelSmall?.copyWith(color: selected ? p.onStrong : p.textMuted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
