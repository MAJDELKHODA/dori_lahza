import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:flutter/material.dart';

extension BookingStatusUi on BookingStatus {
  Tone get tone => switch (this) {
        BookingStatus.pending => Tone.warning,
        BookingStatus.confirmed => Tone.brand,
        BookingStatus.checkedIn => Tone.info,
        BookingStatus.completed => Tone.success,
        BookingStatus.cancelled || BookingStatus.noShow => Tone.danger,
        BookingStatus.unknown => Tone.neutral,
      };

  IconData get icon => switch (this) {
        BookingStatus.pending => Icons.hourglass_top_rounded,
        BookingStatus.confirmed => Icons.event_available_rounded,
        BookingStatus.checkedIn => Icons.how_to_reg_rounded,
        BookingStatus.completed => Icons.task_alt_rounded,
        BookingStatus.cancelled => Icons.event_busy_rounded,
        BookingStatus.noShow => Icons.person_off_outlined,
        BookingStatus.unknown => Icons.event_note_rounded,
      };
}

/// Row in "حجوزاتي": date block, service, time, person and status.
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final start = booking.startsAt;
    final faded = booking.status == BookingStatus.cancelled || booking.status == BookingStatus.noShow;
    return Opacity(
      opacity: faded ? 0.75 : 1,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(Gap.sm),
        child: Row(
          children: [
            Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: Gap.sm),
              decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(Radii.md)),
              child: Column(
                children: [
                  Text(booking.dayLabel, style: context.text.labelSmall?.copyWith(color: p.strong)),
                  Text(start == null ? '' : '${start.day}', style: context.text.headlineSmall?.copyWith(color: p.strong)),
                  Text(start == null ? '' : Fmt.shortDate(start).split(' ').last, style: context.text.labelSmall),
                ],
              ),
            ),
            const HSpace(Gap.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          booking.serviceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.titleSmall,
                        ),
                      ),
                      Pill(label: booking.statusLabel, tone: booking.status.tone),
                    ],
                  ),
                  const VSpace(Gap.xxs),
                  _line(context, Icons.schedule_rounded, booking.endTime == null ? booking.time : '${booking.time} – ${booking.endTime}'),
                  if (booking.staffName != null) _line(context, Icons.person_outline_rounded, booking.staffName!),
                  _line(context, Icons.confirmation_number_outlined, '#${booking.number}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(BuildContext context, IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          children: [
            Icon(icon, size: 15, color: context.palette.textMuted),
            const HSpace(Gap.xxs),
            Expanded(child: Text(text, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
      );
}

/// Large status banner at the top of the details page.
class BookingStatusHeader extends StatelessWidget {
  const BookingStatusHeader({super.key, required this.booking, required this.justCreated});

  final Booking booking;
  final bool justCreated;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (fg, bg) = switch (booking.status.tone) {
      Tone.success => (p.success, p.successSoft),
      Tone.warning => (p.warning, p.warningSoft),
      Tone.danger => (p.danger, p.dangerSoft),
      Tone.info => (p.info, p.infoSoft),
      _ => (p.strong, p.soft),
    };
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(color: bg, borderRadius: Radii.card),
      child: Row(
        children: [
          Icon(justCreated ? Icons.celebration_rounded : booking.status.icon, color: fg, size: 34),
          const HSpace(Gap.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  justCreated ? 'تم الحجز بنجاح!' : booking.statusLabel,
                  style: context.text.titleMedium?.copyWith(color: fg),
                ),
                Text(
                  justCreated
                      ? (booking.status == BookingStatus.pending
                          ? 'بانتظار تأكيد المنشأة، سنرسل لك إشعارًا'
                          : 'اعرض رمز الحجز عند وصولك')
                      : 'رقم الحجز #${booking.number}',
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Service image + name for the details page.
class BookingServiceTile extends StatelessWidget {
  const BookingServiceTile({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          AppNetworkImage(url: booking.serviceImage, width: 52, height: 52),
          const HSpace(Gap.sm),
          Expanded(child: Text(booking.serviceName, style: context.text.titleSmall)),
        ],
      );
}
