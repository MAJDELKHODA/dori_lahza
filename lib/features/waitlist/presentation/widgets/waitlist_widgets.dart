import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:flutter/material.dart';

extension WaitlistStatusUi on WaitlistStatus {
  Tone get tone => switch (this) {
        WaitlistStatus.waiting => Tone.info,
        WaitlistStatus.offered => Tone.warning,
        WaitlistStatus.booked => Tone.success,
        WaitlistStatus.expired || WaitlistStatus.cancelled => Tone.neutral,
        WaitlistStatus.unknown => Tone.neutral,
      };

  String get fallbackLabel => switch (this) {
        WaitlistStatus.waiting => 'بالانتظار',
        WaitlistStatus.offered => 'عرض متاح',
        WaitlistStatus.booked => 'تم الحجز',
        WaitlistStatus.expired => 'انتهى',
        WaitlistStatus.cancelled => 'ملغى',
        WaitlistStatus.unknown => '',
      };
}

String waitlistWindow(WaitlistEntry e) {
  if (e.fromTime == null && e.toTime == null) return 'أي وقت';
  return '${e.fromTime ?? '...'} – ${e.toTime ?? '...'}';
}

String waitlistDay(WaitlistEntry e) {
  final date = DateTime.tryParse(e.date);
  return date == null ? (e.dayLabel ?? e.date) : Fmt.dayMonth(date);
}

class WaitlistTile extends StatelessWidget {
  const WaitlistTile({super.key, required this.entry, required this.onTap});

  final WaitlistEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final offered = entry.status == WaitlistStatus.offered;
    return AppCard(
      onTap: onTap,
      color: offered ? p.warningSoft : null,
      borderColor: offered ? p.warning.withValues(alpha: 0.4) : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: offered ? p.surface : p.soft, shape: BoxShape.circle),
            child: Icon(
              offered ? Icons.notifications_active_rounded : Icons.hourglass_top_rounded,
              color: offered ? p.warning : p.strong,
            ),
          ),
          const HSpace(Gap.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.serviceName, style: context.text.titleSmall),
                Text('${waitlistDay(entry)} · ${waitlistWindow(entry)}', style: context.text.bodySmall),
                if (offered && entry.offer != null)
                  Text(
                    'وقت متاح: ${entry.offer!.time} — اضغط للتأكيد',
                    style: context.text.labelMedium?.copyWith(color: p.warning),
                  ),
              ],
            ),
          ),
          Pill(label: entry.statusLabel ?? entry.status.fallbackLabel, tone: entry.status.tone),
        ],
      ),
    );
  }
}

/// Big ring countdown for a live offer.
class OfferCountdown extends StatelessWidget {
  const OfferCountdown({super.key, required this.secondsLeft, required this.total});

  final int secondsLeft;
  final int total;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ratio = total <= 0 ? 0.0 : (secondsLeft / total).clamp(0.0, 1.0);
    final color = ratio > 0.5 ? p.success : (ratio > 0.2 ? p.warning : p.danger);
    return SizedBox.square(
      dimension: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: ratio,
              strokeWidth: 9,
              strokeCap: StrokeCap.round,
              backgroundColor: p.surfaceMuted,
              color: color,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Fmt.countdown(secondsLeft),
                textDirection: TextDirection.ltr,
                style: context.text.headlineMedium?.copyWith(color: color, fontFeatures: const [FontFeature.tabularFigures()]),
              ),
              Text('متبقٍ للتأكيد', style: context.text.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
