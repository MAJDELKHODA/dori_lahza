import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';
import 'package:dori_lahza/features/insights/presentation/controllers/busy_hours_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// "أفضل وقت للزيارة": a calm summary first (status now + suggestion), then
/// the quietest times, the selected day's hours, and the full week on demand.
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
                SkeletonBox(height: 120, radius: Radii.xl),
                VSpace(Gap.xl),
                SkeletonBox(height: 150, radius: Radii.lg),
                VSpace(Gap.xl),
                SkeletonBox(height: 230, radius: Radii.lg),
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
                _Summary(now: data.now, suggestion: controller.suggestion(data), todayKey: controller.todayKey),
                if (data.bestTimes.isNotEmpty) ...[
                  const VSpace(Gap.xl),
                  const _Title('أهدأ الأوقات', 'أوقات تقل فيها الزحمة عادةً'),
                  const VSpace(Gap.sm),
                  _QuietList(times: data.bestTimes),
                ],
                const VSpace(Gap.xl),
                const _Title('خلال اليوم', 'اختر يومًا لترى كيف تتغير الزحمة'),
                const VSpace(Gap.sm),
                _DayChart(controller: controller, data: data),
                const VSpace(Gap.lg),
                _Week(controller: controller, data: data),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.text.titleMedium),
          Text(subtitle, style: context.text.bodySmall),
        ],
      );
}

/// Status now and the friendliest next step.
class _Summary extends StatelessWidget {
  const _Summary({required this.now, required this.suggestion, required this.todayKey});

  final BusyNow now;
  final BestTime? suggestion;
  final String todayKey;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final s = suggestion;
    final hint = s == null
        ? null
        : s.day == todayKey
            ? 'أنسب وقت اليوم الساعة ${s.time}'
            : 'أهدأ وقت قادم: ${s.dayLabel} الساعة ${s.time}';
    return Container(
      padding: const EdgeInsets.all(Gap.lg),
      decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(Radii.xl)),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: p.surface, shape: BoxShape.circle),
            child: Icon(now.open ? Icons.spa_outlined : Icons.nights_stay_outlined, color: p.strong, size: 28),
          ),
          const HSpace(Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(now.label, style: context.text.titleLarge?.copyWith(color: p.strong)),
                if (hint != null) ...[
                  const VSpace(2),
                  Text(hint, style: context.text.bodyMedium?.copyWith(color: p.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuietList extends StatelessWidget {
  const _QuietList({required this.times});

  final List<BestTime> times;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.xxs),
      child: Column(
        children: [
          for (var i = 0; i < times.length; i++) ...[
            if (i > 0) const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Gap.sm),
              child: Row(
                children: [
                  Icon(Icons.eco_outlined, size: 20, color: p.strong),
                  const HSpace(Gap.sm),
                  Expanded(child: Text(times[i].dayLabel, style: context.text.labelLarge)),
                  Text(times[i].time, textDirection: TextDirection.ltr, style: context.text.titleSmall),
                  const HSpace(Gap.sm),
                  Pill(label: BusyHoursController.levelLabel(times[i].level), tone: Tone.brand),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayChart extends StatelessWidget {
  const _DayChart({required this.controller, required this.data});

  final BusyHoursController controller;
  final BusyHours data;

  static const _maxBar = 110.0;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(Gap.md),
      child: Obx(() {
        final day = controller.dayOf(data);
        final (:quiet, :peak) = controller.extremes(day);
        final open = day?.hours.any((h) => h.open) ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.days.length,
                separatorBuilder: (_, _) => const HSpace(Gap.xxs),
                itemBuilder: (_, i) {
                  final d = data.days[i];
                  return ChoiceChip(
                    label: Text(d.day == controller.todayKey ? 'اليوم' : d.label),
                    selected: d.day == day?.day,
                    onSelected: (_) => controller.selectDay(d.day),
                  );
                },
              ),
            ),
            const VSpace(Gap.lg),
            if (!open)
              SizedBox(
                height: _maxBar + 24,
                child: Center(
                  child: Text('مغلق في هذا اليوم', style: context.text.bodyMedium?.copyWith(color: p.textMuted)),
                ),
              )
            else
              SizedBox(
                height: _maxBar + 24,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final h in day!.hours)
                      Expanded(
                        child: Tooltip(
                          message: h.open ? '${Fmt.hour(h.hour)} · ${BusyHoursController.levelLabel(h.level)}' : 'مغلق',
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: h.open ? 10 + (_maxBar - 10) * h.level : 4,
                                decoration: BoxDecoration(
                                  color: !h.open
                                      ? p.surfaceMuted
                                      : h == quiet
                                          ? p.success.withValues(alpha: 0.55)
                                          : p.heat(h.level),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8), bottom: Radius.circular(3)),
                                ),
                              ),
                              const VSpace(6),
                              Text('${h.hour % 12 == 0 ? 12 : h.hour % 12}', style: context.text.labelSmall),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (open && quiet != null) ...[
              const VSpace(Gap.md),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      color: p.success.withValues(alpha: 0.55),
                      label: 'الأهدأ',
                      value: Fmt.hour(quiet.hour),
                    ),
                  ),
                  if (peak != null)
                    Expanded(child: _Stat(color: p.strong, label: 'الأزحم', value: Fmt.hour(peak.hour))),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.color, required this.label, required this.value});

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const HSpace(Gap.xs),
          Text('$label: ', style: context.text.bodySmall),
          Text(value, style: context.text.labelLarge),
        ],
      );
}

/// The whole week as a soft heatmap, folded by default.
class _Week extends StatelessWidget {
  const _Week({required this.controller, required this.data});

  final BusyHoursController controller;
  final BusyHours data;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Obx(() {
      final expanded = controller.showWeek.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: controller.toggleWeek,
            icon: Icon(expanded ? Icons.expand_less_rounded : Icons.calendar_view_week_rounded),
            label: Text(expanded ? 'إخفاء الأسبوع' : 'عرض الأسبوع كاملًا'),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: !expanded
                ? const SizedBox(width: double.infinity)
                : AppCard(
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
                                      width: 30,
                                      child: Text(
                                        '${h % 12 == 0 ? 12 : h % 12}',
                                        textAlign: TextAlign.center,
                                        style: context.text.labelSmall,
                                      ),
                                    ),
                                ],
                              ),
                              const VSpace(Gap.xxs),
                              for (final day in data.days)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 64, child: Text(day.label, style: context.text.labelMedium)),
                                      for (final h in day.hours)
                                        Container(
                                          width: 24,
                                          height: 24,
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          decoration: BoxDecoration(
                                            color: h.open ? p.heat(h.level) : p.surfaceMuted,
                                            borderRadius: BorderRadius.circular(8),
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
                            Expanded(
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Radii.pill),
                                  // Directional so "هادئ" (start) sits on the light end in RTL.
                                  gradient: LinearGradient(
                                    begin: AlignmentDirectional.centerStart,
                                    end: AlignmentDirectional.centerEnd,
                                    colors: [p.heat(0), p.heat(0.5), p.heat(1)],
                                  ),
                                ),
                              ),
                            ),
                            const HSpace(Gap.xs),
                            Text('مزدحم', style: context.text.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    });
  }
}
