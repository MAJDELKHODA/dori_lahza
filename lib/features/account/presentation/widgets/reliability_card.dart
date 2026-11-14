import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

/// The commitment score (0–100) as a ring, with what lowers it.
class ReliabilityCard extends StatelessWidget {
  const ReliabilityCard({super.key, required this.reliability});

  final Reliability reliability;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (color, soft, title) = switch (reliability.level) {
      ReliabilityLevel.high => (p.success, p.successSoft, 'ملتزم جدًا'),
      ReliabilityLevel.medium => (p.warning, p.warningSoft, 'التزام جيد'),
      ReliabilityLevel.low => (p.danger, p.dangerSoft, 'التزام منخفض'),
    };
    final stats = <(String, int)>[
      if (reliability.completed != null) ('زيارات مكتملة', reliability.completed!),
      if (reliability.cancelledLate != null) ('إلغاء متأخر', reliability.cancelledLate!),
      if (reliability.noShows != null) ('عدم حضور', reliability.noShows!),
    ];
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: 76,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: reliability.score / 100),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 7,
                          strokeCap: StrokeCap.round,
                          backgroundColor: soft,
                          color: color,
                        ),
                      ),
                      Text('${(value * 100).round()}', style: context.text.titleLarge?.copyWith(color: color)),
                    ],
                  ),
                ),
              ),
              const HSpace(Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مؤشر الالتزام', style: context.text.bodySmall),
                    Text(reliability.label ?? title, style: context.text.titleMedium?.copyWith(color: color)),
                    const VSpace(Gap.xxs),
                    Text(
                      'الإلغاء المتأخر وعدم الحضور يخفّضان المؤشر، والالتزام بالمواعيد يرفعه.',
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (stats.isNotEmpty) ...[
            const VSpace(Gap.md),
            const Divider(),
            const VSpace(Gap.sm),
            Row(
              children: [
                for (final (label, value) in stats)
                  Expanded(
                    child: Column(
                      children: [
                        Text('$value', style: context.text.titleMedium),
                        Text(label, style: context.text.labelSmall),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
