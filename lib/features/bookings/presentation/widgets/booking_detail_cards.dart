import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Check-in QR (`qr`) with the human-readable `code`.
class BookingQrCard extends StatelessWidget {
  const BookingQrCard({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final data = booking.qr ?? booking.code;
    return AppCard(
      padding: const EdgeInsets.all(Gap.lg),
      child: Column(
        children: [
          Text('اعرض الرمز عند الوصول', style: context.text.bodySmall),
          const VSpace(Gap.sm),
          Container(
            padding: const EdgeInsets.all(Gap.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Radii.md),
              border: Border.all(color: p.border),
            ),
            child: QrImageView(
              data: data,
              size: 180,
              eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: p.textPrimary),
              dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: p.textPrimary),
            ),
          ),
          const VSpace(Gap.sm),
          InkWell(
            borderRadius: BorderRadius.circular(Radii.sm),
            onTap: () => Clipboard.setData(ClipboardData(text: booking.code)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: Gap.xxs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    booking.code,
                    textDirection: TextDirection.ltr,
                    style: context.text.titleLarge?.copyWith(letterSpacing: 3, color: p.strong),
                  ),
                  const HSpace(Gap.xs),
                  Icon(Icons.copy_rounded, size: 18, color: p.textMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical timeline of the booking's stages.
class BookingTimeline extends StatelessWidget {
  const BookingTimeline({super.key, required this.steps});

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: steps[i].done ? p.strong : p.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: steps[i].done ? p.strong : p.border, width: 2),
                          ),
                          child: steps[i].done ? Icon(Icons.check_rounded, size: 13, color: p.onStrong) : null,
                        ),
                        if (i < steps.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: steps[i + 1].done ? p.strong : p.border,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const HSpace(Gap.sm),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[i].label,
                            style: context.text.labelLarge?.copyWith(color: steps[i].done ? p.textPrimary : p.textMuted),
                          ),
                          if (steps[i].at != null)
                            Text('${Fmt.shortDate(steps[i].at!)} · ${Fmt.time(steps[i].at!)}', style: context.text.labelSmall),
                          if (steps[i].note != null) Text(steps[i].note!, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
