import 'dart:async';

import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/icon_mapper.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:flutter/material.dart';

/// Horizontally scrolling row with page gutters.
class HorizontalStrip extends StatelessWidget {
  const HorizontalStrip({
    super.key,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = Gap.sm,
  });

  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: Gap.pagePadding,
          itemCount: itemCount,
          separatorBuilder: (_, _) => HSpace(spacing),
          itemBuilder: itemBuilder,
        ),
      );
}

/// Read-only search field that opens the services tab.
class SearchEntry extends StatelessWidget {
  const SearchEntry({super.key, required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(borderRadius: Radii.field, side: BorderSide(color: p.border)),
      child: InkWell(
        onTap: onTap,
        customBorder: const RoundedRectangleBorder(borderRadius: Radii.field),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: p.textMuted),
              const HSpace(Gap.sm),
              Expanded(child: Text(hint, style: context.text.bodyMedium?.copyWith(color: p.textMuted))),
              Icon(Icons.tune_rounded, color: p.strong, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Auto-advancing banner pager with page dots.
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key, required this.banners, required this.onTap});

  final List<HomeBanner> banners;
  final ValueChanged<HomeBanner> onTap;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final _pager = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!_pager.hasClients) return;
        final next = (_index + 1) % widget.banners.length;
        unawaited(_pager.animateToPage(next, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic));
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _pager,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              final banner = widget.banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => widget.onTap(banner),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppNetworkImage(url: banner.image, radius: Radii.lg),
                      if (banner.title != null)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: Radii.card,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                            ),
                          ),
                        ),
                      if (banner.title != null)
                        PositionedDirectional(
                          start: Gap.md,
                          end: Gap.md,
                          bottom: Gap.md,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title!,
                                style: context.text.titleMedium?.copyWith(color: Colors.white),
                                maxLines: 2,
                              ),
                              if (banner.linkName != null)
                                Text(
                                  banner.linkName!,
                                  style: context.text.labelMedium?.copyWith(color: Colors.white70),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.banners.length > 1) ...[
          const VSpace(Gap.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.banners.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _index ? p.strong : p.border,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(Radii.lg)),
              clipBehavior: Clip.antiAlias,
              child: category.image != null
                  ? AppNetworkImage(url: category.image, radius: 0)
                  : Icon(IconMapper.fromName(category.icon), color: p.strong, size: 28),
            ),
            const VSpace(Gap.xs),
            Text(
              category.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall?.copyWith(color: p.textPrimary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Live-queue summary card linking to the queue tab.
class QueueTeaser extends StatelessWidget {
  const QueueTeaser({super.key, required this.board, required this.onTap});

  final QueueBoard board;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final serving = board.nowServing.isEmpty ? '—' : board.nowServing.first.label;
    return AppCard(
      onTap: onTap,
      color: p.strong,
      borderColor: p.strong,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Gap.sm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: const Icon(Icons.confirmation_number_outlined, color: Colors.white),
          ),
          const HSpace(Gap.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الدور الحي', style: context.text.labelMedium?.copyWith(color: Colors.white70)),
                Text(
                  'يُخدم الآن $serving · ينتظر ${board.waitingCount}',
                  style: context.text.titleSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Text(
            board.accepting ? 'خذ رقمًا' : 'تابع',
            style: context.text.labelLarge?.copyWith(color: Colors.white),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white),
        ],
      ),
    );
  }
}

class BusyHoursTeaser extends StatelessWidget {
  const BusyHoursTeaser({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      onTap: onTap,
      color: p.soft,
      borderColor: p.soft,
      child: Row(
        children: [
          Icon(Icons.insights_rounded, color: p.strong, size: 30),
          const HSpace(Gap.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أفضل وقت للزيارة', style: context.text.titleSmall),
                Text('اعرف الأوقات الهادئة وتجنّب الزحمة', style: context.text.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.strong),
        ],
      ),
    );
  }
}
