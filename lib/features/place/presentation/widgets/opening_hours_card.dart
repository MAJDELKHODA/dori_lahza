import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';
import 'package:flutter/material.dart';

/// Weekly hours with today highlighted. Used for the place and staff profiles.
class OpeningHoursCard extends StatelessWidget {
  const OpeningHoursCard({super.key, required this.hours});

  final List<DayHours> hours;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.xs),
      child: Column(
        children: [
          for (final day in hours)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: 10),
              decoration: BoxDecoration(
                color: day.isToday ? p.soft : null,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Row(
                children: [
                  Text(
                    day.label,
                    style: context.text.labelLarge?.copyWith(
                      color: day.isToday ? p.strong : p.textPrimary,
                    ),
                  ),
                  if (day.isToday) ...[const HSpace(Gap.xs), const Pill(label: 'اليوم', tone: Tone.brand)],
                  const Spacer(),
                  Text(
                    day.open && day.ranges.isNotEmpty ? day.ranges.join('  ·  ') : 'مغلق',
                    textDirection: TextDirection.ltr,
                    style: context.text.labelLarge?.copyWith(
                      color: day.open ? p.textPrimary : p.danger,
                      fontWeight: FontWeight.w500,
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
