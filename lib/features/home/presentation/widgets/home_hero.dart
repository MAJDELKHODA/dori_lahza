import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/home/presentation/controllers/home_controller.dart';
import 'package:dori_lahza/features/notifications/presentation/controllers/notifications_controllers.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Top of home: the place cover (`cover`) edge to edge, the logo overlapping
/// its bottom edge, then name, type, rating, open state and today's hours.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.controller});

  static const coverHeight = 190.0;
  static const logoSize = 84.0;

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final placeController = Get.find<PlaceController>();
    final session = Get.find<SessionController>();
    final topInset = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Obx(() {
        final place = placeController.current;
        final user = session.user.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _Cover(place: place, height: coverHeight + topInset),
                PositionedDirectional(
                  top: topInset + Gap.xs,
                  start: Gap.md,
                  end: Gap.md,
                  child: Row(
                    children: [
                      _GlassButton(
                        icon: Icons.info_outline_rounded,
                        tooltip: 'عن المنشأة',
                        onTap: controller.openPlaceInfo,
                      ),
                      const Spacer(),
                      if (user != null) _NotificationsButton(onTap: controller.openNotifications),
                    ],
                  ),
                ),
                PositionedDirectional(
                  start: Gap.page,
                  bottom: -logoSize / 2,
                  child: GestureDetector(
                    onTap: controller.openPlaceInfo,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.palette.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 18, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: AppAvatar(url: place.logo, initials: place.name.characters.first, size: logoSize),
                    ),
                  ),
                ),
                if (place.rating.hasReviews)
                  PositionedDirectional(
                    end: Gap.page,
                    bottom: Gap.sm,
                    child: _RatingBadge(average: place.rating.average, count: place.rating.count),
                  ),
              ],
            ),
            const VSpace(logoSize / 2 + Gap.sm),
            Padding(
              padding: Gap.pagePadding,
              child: _Identity(place: place, greetingName: user?.name.split(' ').first),
            ),
          ],
        );
      }),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.place, required this.height});

  final Place place;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (place.cover != null)
            AppNetworkImage(url: place.cover, radius: 0)
          else
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [p.brand, p.strong],
                ),
              ),
            ),
          // Darkens the top for the status bar and buttons, and the bottom
          // edge so the overlapping logo reads cleanly.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.35, 0.7, 1],
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.05),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.place, this.greetingName});

  final Place place;
  final String? greetingName;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final today = place.today;
    final hours = today != null && today.open && today.ranges.isNotEmpty ? today.ranges.join(' ، ') : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greetingName == null ? 'أهلًا بك 👋' : 'أهلًا، $greetingName 👋',
          style: context.text.bodySmall,
        ),
        Text(place.name, style: context.text.headlineSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        if (place.tagline != null || place.typeName.isNotEmpty)
          Text(
            place.tagline ?? place.typeName,
            style: context.text.bodyMedium?.copyWith(color: p.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const VSpace(Gap.sm),
        Wrap(
          spacing: Gap.xs,
          runSpacing: Gap.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Pill(
              label: place.openNow ? 'مفتوح الآن' : 'مغلق الآن',
              tone: place.openNow ? Tone.success : Tone.danger,
              icon: Icons.circle,
            ),
            if (hours != null)
              Pill(label: 'اليوم $hours', icon: Icons.schedule_rounded)
            else if (today != null && !today.open)
              const Pill(label: 'إجازة اليوم', icon: Icons.event_busy_outlined),
          ],
        ),
      ],
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.average, required this.count});

  final double average;
  final int count;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: 6),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(Radii.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 18, color: p.star),
          const HSpace(4),
          Text(Fmt.rating(average), style: context.text.labelLarge),
          const HSpace(4),
          Text('($count)', style: context.text.labelSmall),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.tooltip, required this.onTap, this.child});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  /// Replaces the icon (e.g. an icon with a badge).
  final Widget? child;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black.withValues(alpha: 0.28),
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: tooltip,
          onPressed: onTap,
          icon: child ?? Icon(icon, color: Colors.white),
        ),
      );
}

class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Obx(() {
        final unread = Get.find<UnreadBadgeController>().unread.value;
        return _GlassButton(
          icon: Icons.notifications_none_rounded,
          tooltip: 'الإشعارات',
          onTap: onTap,
          child: Badge.count(
            count: unread,
            isLabelVisible: unread > 0,
            backgroundColor: context.palette.danger,
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
          ),
        );
      });
}
