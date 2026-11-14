import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:flutter/material.dart';

/// Avatar + name + title, for horizontal team strips.
class StaffBubble extends StatelessWidget {
  const StaffBubble({
    super.key,
    required this.name,
    this.title,
    this.avatar,
    required this.initials,
    this.color,
    required this.onTap,
  });

  final String name;
  final String? title;
  final String? avatar;
  final String initials;
  final String? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: SizedBox(
        width: 86,
        child: Column(
          children: [
            AppAvatar(url: avatar, initials: initials, color: AppPalette.parseHex(color), size: 64),
            const VSpace(Gap.xs),
            Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelMedium),
            if (title != null)
              Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelSmall),
          ],
        ),
      ),
    );
  }
}

/// Row for the team list.
class StaffTile extends StatelessWidget {
  const StaffTile({
    super.key,
    required this.name,
    this.title,
    this.avatar,
    required this.initials,
    this.color,
    this.rating,
    this.reviewsCount = 0,
    required this.onTap,
  });

  final String name;
  final String? title;
  final String? avatar;
  final String initials;
  final String? color;
  final double? rating;
  final int reviewsCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Gap.sm),
      child: Row(
        children: [
          AppAvatar(url: avatar, initials: initials, color: AppPalette.parseHex(color), size: 56),
          const HSpace(Gap.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: context.text.titleSmall),
                if (title != null) Text(title!, style: context.text.bodySmall),
                if (reviewsCount > 0 && rating != null) ...[
                  const VSpace(Gap.xxs),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 15, color: p.star),
                      const HSpace(3),
                      Text('${Fmt.rating(rating!)} ($reviewsCount)', style: context.text.labelSmall),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.textMuted),
        ],
      ),
    );
  }
}

/// Selectable staff option (booking: "أي شخص متاح" or a specific person).
class StaffChoice extends StatelessWidget {
  const StaffChoice({
    super.key,
    required this.label,
    this.avatar,
    this.initials,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? avatar;
  final String? initials;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: Gap.xs),
      color: selected ? p.soft : null,
      borderColor: selected ? p.strong : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (initials == null)
            Icon(Icons.groups_2_outlined, color: p.strong)
          else
            AppAvatar(url: avatar, initials: initials!, size: 30),
          const HSpace(Gap.xs),
          Text(label, style: context.text.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
