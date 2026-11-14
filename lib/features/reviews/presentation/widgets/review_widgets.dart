import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review, this.maxLines, this.width});

  final Review review;

  /// Clamp the comment (horizontal previews); null shows all.
  final int? maxLines;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final context2 = [review.serviceName, review.staffName].whereType<String>().join(' · ');
    return SizedBox(
      width: width,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AppAvatar(url: review.authorAvatar, initials: review.authorInitials, size: 38),
                const HSpace(Gap.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.authorName, style: context.text.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (review.createdAt != null)
                        Text(Fmt.relative(review.createdAt!), style: context.text.labelSmall),
                    ],
                  ),
                ),
                RatingStars(rating: review.rating.toDouble(), size: 15),
              ],
            ),
            if (context2.isNotEmpty) ...[
              const VSpace(Gap.xs),
              Text(context2, style: context.text.labelSmall?.copyWith(color: p.strong)),
            ],
            if (review.comment != null) ...[
              const VSpace(Gap.xs),
              Text(
                review.comment!,
                maxLines: maxLines,
                overflow: maxLines == null ? null : TextOverflow.ellipsis,
                style: context.text.bodyMedium?.copyWith(height: 1.6),
              ),
            ],
            if (review.reply != null && maxLines == null) ...[
              const VSpace(Gap.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Gap.sm),
                decoration: BoxDecoration(
                  color: p.soft,
                  borderRadius: BorderRadius.circular(Radii.md),
                  border: BorderDirectional(start: BorderSide(color: p.strong, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.reply_rounded, size: 16, color: p.strong),
                        const HSpace(Gap.xxs),
                        Text('رد المنشأة', style: context.text.labelMedium?.copyWith(color: p.strong)),
                      ],
                    ),
                    const VSpace(Gap.xxs),
                    Text(review.reply!.text, style: context.text.bodyMedium?.copyWith(color: p.textSecondary)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Average score + distribution bars. Tapping a bar filters by that star
/// when [onStarTap] is provided.
class RatingSummaryCard extends StatelessWidget {
  const RatingSummaryCard({
    super.key,
    required this.summary,
    required this.distribution,
    this.selectedStar,
    this.onStarTap,
  });

  final RatingSummary summary;
  final Map<int, int> distribution;
  final int? selectedStar;
  final ValueChanged<int?>? onStarTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final total = distribution.values.fold<int>(0, (a, b) => a + b);
    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 104,
            child: Column(
              children: [
                Text(Fmt.rating(summary.average), style: context.text.displaySmall),
                RatingStars(rating: summary.average, size: 16),
                const VSpace(Gap.xxs),
                Text('${summary.count} تقييم', style: context.text.labelSmall),
              ],
            ),
          ),
          const HSpace(Gap.md),
          Expanded(
            child: Column(
              children: [
                for (var star = 5; star >= 1; star--)
                  _bar(context, p, star, distribution[star] ?? 0, total),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(BuildContext context, AppPalette p, int star, int count, int total) {
    final selected = selectedStar == star;
    final dimmed = selectedStar != null && !selected;
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.sm),
      onTap: onStarTap == null ? null : () => onStarTap!(selected ? null : star),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        child: Opacity(
          opacity: dimmed ? 0.4 : 1,
          child: Row(
            children: [
              SizedBox(width: 12, child: Text('$star', style: context.text.labelMedium)),
              Icon(Icons.star_rounded, size: 14, color: p.star),
              const HSpace(Gap.xs),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.pill),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : count / total,
                    minHeight: 8,
                    backgroundColor: p.surfaceMuted,
                    color: selected ? p.strong : p.star,
                  ),
                ),
              ),
              const HSpace(Gap.xs),
              SizedBox(
                width: 28,
                child: Text('$count', textAlign: TextAlign.end, style: context.text.labelSmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
