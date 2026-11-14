import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/home/presentation/controllers/home_controller.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// "موعدك القادم": the signed-in user's soonest booking, linking to its
/// details (QR check-in). Hidden for guests and when there is none.
class NextBookingCard extends StatelessWidget {
  const NextBookingCard({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
        final booking = controller.nextBooking.value;
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: booking == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, 0),
                  child: _Card(booking: booking, onTap: controller.openNextBooking),
                ),
        );
      });
}

class _Card extends StatelessWidget {
  const _Card({required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final labels = Get.find<PlaceController>().labels;
    final start = booking.startsAt;
    const onCard = Colors.white;
    final muted = Colors.white.withValues(alpha: 0.78);
    return Material(
      borderRadius: Radii.card,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [p.strong, Color.lerp(p.strong, Colors.black, 0.25)!],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Gap.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.event_available_rounded, size: 18, color: muted),
                    const HSpace(Gap.xxs),
                    Text('${labels.booking}ك القادم', style: context.text.labelMedium?.copyWith(color: muted)),
                    const Spacer(),
                    if (start != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(Radii.pill),
                        ),
                        child: Text(
                          Fmt.until(start),
                          style: context.text.labelSmall?.copyWith(color: onCard, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                const VSpace(Gap.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.serviceName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleMedium?.copyWith(color: onCard),
                          ),
                          const VSpace(Gap.xxs),
                          Wrap(
                            spacing: Gap.sm,
                            runSpacing: 2,
                            children: [
                              _meta(
                                context,
                                Icons.calendar_today_rounded,
                                start == null ? booking.dayLabel : Fmt.dayMonth(start),
                                muted,
                              ),
                              _meta(context, Icons.schedule_rounded, booking.time, muted),
                              if (booking.staffName != null)
                                _meta(context, Icons.person_outline_rounded, booking.staffName!, muted),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const HSpace(Gap.sm),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: onCard, borderRadius: BorderRadius.circular(Radii.md)),
                      child: Icon(Icons.qr_code_2_rounded, color: p.strong, size: 30),
                    ),
                  ],
                ),
                if (booking.status == BookingStatus.pending) ...[
                  const VSpace(Gap.sm),
                  Text(
                    'بانتظار تأكيد المنشأة',
                    style: context.text.labelSmall?.copyWith(color: onCard, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _meta(BuildContext context, IconData icon, String text, Color color) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const HSpace(4),
          Text(text, style: context.text.labelMedium?.copyWith(color: color)),
        ],
      );
}

/// Row of shortcuts under the search field.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return Obx(() {
      final actions = [
        (Icons.event_available_rounded, 'احجز ${labels.booking}', controller.openAllServices),
        if (controller.queueEnabled) (Icons.confirmation_number_outlined, 'خذ رقمًا', controller.openQueue),
        (Icons.insights_rounded, 'أفضل وقت', controller.openBusyHours),
        (Icons.groups_2_outlined, labels.staffPlural, controller.openTeam),
      ];
      return Padding(
        padding: Gap.pagePadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const HSpace(Gap.xs),
              Expanded(child: _ActionTile(icon: actions[i].$1, label: actions[i].$2, onTap: actions[i].$3)),
            ],
          ],
        ),
      );
    });
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.xxs),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: p.soft,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(color: p.brand.withValues(alpha: 0.35)),
              ),
              child: Icon(icon, color: p.strong, size: 26),
            ),
            const VSpace(Gap.xs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.text.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
