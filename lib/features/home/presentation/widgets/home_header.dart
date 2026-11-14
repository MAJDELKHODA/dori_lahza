import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Greeting, place identity with open/closed state, and the notifications bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final placeController = Get.find<PlaceController>();
    final session = Get.find<SessionController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.page, Gap.md, Gap.page, 0),
      child: Obx(() {
        final place = placeController.current;
        final user = session.user.value;
        final today = place.today;
        return Row(
          children: [
            InkWell(
              onTap: AppNav.placeInfo,
              customBorder: const CircleBorder(),
              child: AppAvatar(url: place.logo, initials: place.name.characters.first, size: 50),
            ),
            const HSpace(Gap.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user == null ? 'أهلًا بك 👋' : 'أهلًا، ${user.name.split(' ').first} 👋',
                    style: context.text.bodySmall,
                  ),
                  Text(place.name, style: context.text.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const VSpace(2),
                  Row(
                    children: [
                      Pill(
                        label: place.openNow ? 'مفتوح الآن' : 'مغلق الآن',
                        tone: place.openNow ? Tone.success : Tone.danger,
                      ),
                      if (today != null && today.open && today.ranges.isNotEmpty) ...[
                        const HSpace(Gap.xs),
                        Flexible(
                          child: Text(
                            today.ranges.join(' ، '),
                            textDirection: TextDirection.ltr,
                            style: context.text.labelSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (user != null)
              IconButton.filledTonal(
                tooltip: 'الإشعارات',
                style: IconButton.styleFrom(backgroundColor: p.surface, side: BorderSide(color: p.border)),
                onPressed: () => Get.toNamed<void>(AppRoutes.notifications),
                icon: Icon(Icons.notifications_none_rounded, color: p.textPrimary),
              ),
          ],
        );
      }),
    );
  }
}
