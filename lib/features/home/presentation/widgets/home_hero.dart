import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/home/presentation/controllers/home_controller.dart';
import 'package:dori_lahza/features/notifications/presentation/controllers/notifications_controllers.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Top of home: the place cover edge to edge, and a white card overlapping
/// its bottom with the logo, name, tagline and status pills.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.controller});

  /// Visible cover height below the status bar.
  static const coverHeight = 230.0;

  /// How far the info card rises into the cover.
  static const cardOverlap = 96.0;
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
        final signedIn = session.user.value != null;
        return Stack(
          children: [
            _Cover(place: place, height: coverHeight + topInset),
            if (signedIn)
              PositionedDirectional(
                top: topInset + Gap.sm,
                end: Gap.page,
                child: _NotificationsButton(onTap: controller.openNotifications),
              ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                Gap.page,
                topInset + coverHeight - cardOverlap,
                Gap.page,
                0,
              ),
              child: _InfoCard(place: place, onTap: controller.openPlaceInfo),
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
          // A light shade at the top keeps the status bar readable on bright covers.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Colors.black.withValues(alpha: 0.35), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.place, required this.onTap});

  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final subtitle = place.tagline ?? place.description ?? (place.typeName.isEmpty ? null : place.typeName);
    return Material(
      color: p.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(Radii.xl),
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.xl),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.xl),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8)),
            ],
            color: p.surface,
          ),
          padding: const EdgeInsets.all(Gap.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _Logo(place: place),
                  const HSpace(Gap.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.headlineSmall,
                        ),
                        if (subtitle != null) ...[
                          const VSpace(Gap.xxs),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.bodyMedium?.copyWith(color: p.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const VSpace(Gap.md),
              Wrap(
                spacing: Gap.xs,
                runSpacing: Gap.xs,
                children: [
                  _StatusPill(
                    icon: Icons.circle,
                    iconSize: 10,
                    label: _openLabel(place),
                    fg: place.openNow ? p.success : p.danger,
                    bg: place.openNow ? p.successSoft : p.dangerSoft,
                  ),
                  if (place.rating.hasReviews)
                    _StatusPill(
                      icon: Icons.star_rounded,
                      label: '${Fmt.rating(place.rating.average)} (${place.rating.count})',
                      fg: p.warning,
                      bg: p.warningSoft,
                    ),
                  if (place.hasAudienceRestriction)
                    _StatusPill(
                      icon: Icons.verified_user_outlined,
                      label: place.audienceLabel!,
                      fg: p.strong,
                      bg: p.soft,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// `مفتوح الآن · حتى 17:00` / `مغلق الآن`.
  static String _openLabel(Place place) {
    if (!place.openNow) return 'مغلق الآن';
    final ranges = place.today?.ranges ?? const <String>[];
    final until = ranges.isEmpty ? null : ranges.last.split('-').last.trim();
    return until == null || until.isEmpty ? 'مفتوح الآن' : 'مفتوح الآن · حتى $until';
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const size = HomeHero.logoSize;
    if (place.logo != null) {
      return AppNetworkImage(url: place.logo, width: size, height: size, radius: Radii.lg);
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(Radii.lg)),
      child: Text(place.name.characters.first, style: context.text.headlineMedium?.copyWith(color: p.strong)),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label, required this.fg, required this.bg, this.iconSize = 18});

  final IconData icon;
  final String label;
  final Color fg;
  final Color bg;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: 7),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.pill)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: fg),
            const HSpace(6),
            Text(label, style: context.text.labelLarge?.copyWith(color: fg)),
          ],
        ),
      );
}

class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Obx(() {
        final p = context.palette;
        final unread = Get.find<UnreadBadgeController>().unread.value;
        return Material(
          color: p.surface,
          shape: const CircleBorder(),
          elevation: 2,
          shadowColor: Colors.black26,
          child: IconButton(
            tooltip: 'الإشعارات',
            onPressed: onTap,
            icon: Badge.count(
              count: unread,
              isLabelVisible: unread > 0,
              backgroundColor: p.danger,
              child: Icon(Icons.notifications_none_rounded, color: p.textPrimary),
            ),
          ),
        );
      });
}
