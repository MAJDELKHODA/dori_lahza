import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';
import 'package:dori_lahza/features/insights/presentation/controllers/busy_hours_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// "أفضل وقت للزيارة": status now, the quietest times, a per-day hourly
/// chart and the full weekly heatmap.
class BusyHoursView extends GetView<BusyHoursController> {
  const BusyHoursView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أفضل وقت للزيارة')),
      body: Obx(
        () => StateView<BusyHours>(
          state: controller.state.value,
          loading: Skeleton(
            child: ListView(
              padding: const EdgeInsets.all(Gap.page),
              children: const [
                SkeletonBox(height: 90, radius: Radii.lg),
                VSpace(Gap.lg),
                SkeletonBox(height: 70, radius: Radii.lg),
                VSpace(Gap.lg),
                SkeletonBox(height: 220, radius: Radii.lg),
              ],
            ),
          ),
          empty: const EmptyView(
            icon: Icons.insights_rounded,
            title: 'لا توجد بيانات كافية بعد',
            subtitle: 'ستظهر أوقات الزحمة بعد تسجيل عدد من الزيارات',
          ),
          onRetry: controller.load,
          builder: (context, data) => RefreshIndicator(
            onRefresh: controller.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
              children: [
                _NowCard(now: data.now),
                if (data.bestTimes.isNotEmpty) ...[
                  const VSpace(Gap.lg),
                  const SectionHeader(title: 'أهدأ الأوقات', padding: EdgeInsets.zero),
                  const VSpace(Gap.xs),
                  Wrap(
                    spacing: Gap.xs,
                    runSpacing: Gap.xs,
                    children: [
                      for (final b in data.bestTimes)
                        Pill(label: '${b.dayLabel} · ${b.time}', tone: Tone.success, icon: Icons.spa_outlined),
                    ],
                  ),
                ],
                const VSpace(Gap.lg),
                const SectionHeader(title: 'الزحمة خلال اليوم', padding: EdgeInsets.zero),
                const VSpace(Gap.xs),
                _DayChart(controller: controller, data: data),
                const VSpace(Gap.lg),
                const SectionHeader(title: 'الأسبوع كاملًا', padding: EdgeInsets.zero),
                const VSpace(Gap.xs),
                _Heatmap(data: data),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NowCard extends StatelessWidget {
  const _NowCard({required this.now});

  final BusyNow now;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final level = now.level;
    final color = !now.open ? p.textMuted : (level == null ? p.strong : Color.lerp(p.success, p.danger, level)!);
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
            child: Icon(now.open ? Icons.sensors_rounded : Icons.nights_stay_outlined, color: color),
          ),
          const HSpace(Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الآن', style: context.text.bodySmall),
                Text(now.label, style: context.text.titleLarge?.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayChart extends StatelessWidget {
  const _DayChart({required this.controller, required this.data});

  final BusyHoursController controller;
  final BusyHours data;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      child: Obx(() {
        final day = controller.dayOf(data);
        return Column(
          children: [
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final d in data.days) ...[
                    ChoiceChip(
                      label: Text(d.label),
                      selected: d.day == day?.day,
                      onSelected: (_) => controller.selectDay(d.day),
                    ),
                    const HSpace(Gap.xxs),
                  ],
                ],
              ),
            ),
            const VSpace(Gap.lg),
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final h in day?.hours ?? const <BusyHour>[])
                    Expanded(
                      child: Tooltip(
                        message: h.open ? BusyHoursController.levelLabel(h.level) : 'مغلق',
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: h.open ? 10 + 110 * h.level : 6,
                              decoration: BoxDecoration(
                                color: h.open ? p.heat(h.level) : p.surfaceMuted,
                                borderRadius: BorderRadius.circular(Radii.sm),
                              ),
                            ),
                            const VSpace(Gap.xxs),
                            Text('${h.hour}', style: context.text.labelSmall),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.data});

  final BusyHours data;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const cell = 26.0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 64),
                    for (final h in data.hours)
                      SizedBox(
                        width: cell + 4,
                        child: Text('$h', textAlign: TextAlign.center, style: context.text.labelSmall),
                      ),
                  ],
                ),
                const VSpace(Gap.xxs),
                for (final day in data.days)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(width: 64, child: Text(day.label, style: context.text.labelMedium)),
                        for (final h in day.hours)
                          Container(
                            width: cell,
                            height: cell,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: h.open ? p.heat(h.level) : p.surfaceMuted,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const VSpace(Gap.md),
          Row(
            children: [
              Text('هادئ', style: context.text.labelSmall),
              const HSpace(Gap.xs),
              for (final l in const [0.0, 0.25, 0.5, 0.75, 1.0])
                Container(
                  width: 18,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(color: p.heat(l), borderRadius: BorderRadius.circular(3)),
                ),
              const HSpace(Gap.xs),
              Text('مزدحم', style: context.text.labelSmall),
              const Spacer(),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: p.surfaceMuted, borderRadius: BorderRadius.circular(3)),
              ),
              const HSpace(Gap.xxs),
              Text('مغلق', style: context.text.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
