import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';
import 'package:dori_lahza/features/queue/presentation/controllers/queue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// "الدور الحي" tab.
class QueueView extends GetView<QueueController> {
  const QueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدور الحي')),
      body: Obx(
        () => StateView<QueueBoard>(
          state: controller.board.value,
          loading: Skeleton(
            child: ListView(
              padding: const EdgeInsets.all(Gap.page),
              children: const [
                SkeletonBox(height: 190, radius: Radii.lg),
                VSpace(Gap.md),
                SkeletonBox(height: 90, radius: Radii.lg),
                VSpace(Gap.md),
                SkeletonBox(height: 120, radius: Radii.lg),
              ],
            ),
          ),
          onRetry: controller.retry,
          builder: (context, board) {
            if (!board.enabled) {
              return const EmptyView(
                icon: Icons.confirmation_number_outlined,
                title: 'الدور الحي غير مفعّل حاليًا',
                subtitle: 'احجز موعدًا مسبقًا، أو اعرف أهدأ الأوقات للزيارة',
                actionLabel: 'أفضل وقت للزيارة',
                onAction: AppNav.busyHours,
              );
            }
            return RefreshIndicator(
              onRefresh: controller.refreshAll,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
                children: [
                  Obx(() {
                    final ticket = controller.myTicket.value;
                    return ticket != null
                        ? _MyTicketCard(ticket: ticket, controller: controller)
                        : _TakeTicketCard(board: board, controller: controller);
                  }),
                  const VSpace(Gap.md),
                  _NowServing(board: board),
                  const VSpace(Gap.md),
                  _Stats(board: board),
                  if (board.next.isNotEmpty) ...[
                    const VSpace(Gap.lg),
                    const SectionHeader(title: 'التالي', padding: EdgeInsets.zero),
                    const VSpace(Gap.xs),
                    Wrap(
                      spacing: Gap.xs,
                      runSpacing: Gap.xs,
                      children: [for (final c in board.next) Pill(label: c.label, tone: Tone.neutral)],
                    ),
                  ],
                  const VSpace(Gap.lg),
                  Obx(
                    () => Text(
                      controller.lastUpdated.value == null
                          ? 'يتحدّث تلقائيًا كل ${QueueController.pollInterval.inSeconds} ثانية'
                          : 'آخر تحديث ${Fmt.time(controller.lastUpdated.value!)} · يتحدّث كل ${QueueController.pollInterval.inSeconds} ثانية',
                      textAlign: TextAlign.center,
                      style: context.text.labelSmall,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MyTicketCard extends StatelessWidget {
  const _MyTicketCard({required this.ticket, required this.controller});

  final QueueTicket ticket;
  final QueueController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final called = ticket.isCalled;
    final bg = called ? p.success : p.strong;
    return Container(
      padding: const EdgeInsets.all(Gap.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bg, Color.lerp(bg, Colors.black, 0.18)!]),
        borderRadius: Radii.card,
      ),
      child: Column(
        children: [
          Text(called ? 'جاء دورك! 🎉' : 'رقمك', style: context.text.titleSmall?.copyWith(color: Colors.white70)),
          Text(
            ticket.label,
            textDirection: TextDirection.ltr,
            style: context.text.displaySmall?.copyWith(color: Colors.white, fontSize: 48, letterSpacing: 2),
          ),
          if (called && ticket.counter != null)
            Text('توجّه إلى ${ticket.counter}', style: context.text.titleMedium?.copyWith(color: Colors.white)),
          if (!called) ...[
            const VSpace(Gap.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _whiteStat(context, '${ticket.ahead}', 'قبلك'),
                _whiteStat(context, Fmt.minutes(ticket.estimatedWaitMinutes), 'الانتظار المتوقع'),
              ],
            ),
          ],
          if (ticket.serviceName != null) ...[
            const VSpace(Gap.xs),
            Text(ticket.serviceName!, style: context.text.labelMedium?.copyWith(color: Colors.white70)),
          ],
          if (ticket.canCancel && !called) ...[
            const VSpace(Gap.md),
            Obx(
              () => TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: controller.isCancelling.value ? null : () => _confirmCancel(context),
                icon: const Icon(Icons.close_rounded),
                label: const Text('إلغاء رقمي'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _whiteStat(BuildContext context, String value, String label) => Column(
        children: [
          Text(value, style: context.text.titleLarge?.copyWith(color: Colors.white)),
          Text(label, style: context.text.labelSmall?.copyWith(color: Colors.white70)),
        ],
      );

  Future<void> _confirmCancel(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء رقمك؟'),
        content: const Text('ستفقد مكانك في الدور.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('تراجع')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: context.palette.danger),
            child: const Text('إلغاء الرقم'),
          ),
        ],
      ),
    );
    if (ok == true) await controller.cancelTicket();
  }
}

class _TakeTicketCard extends StatelessWidget {
  const _TakeTicketCard({required this.board, required this.controller});

  final QueueBoard board;
  final QueueController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final canTake = board.open && board.accepting;
    return AppCard(
      padding: const EdgeInsets.all(Gap.lg),
      child: Column(
        children: [
          Icon(Icons.confirmation_number_outlined, size: 44, color: canTake ? p.strong : p.textMuted),
          const VSpace(Gap.sm),
          Text(
            canTake ? 'خذ رقمك وانتظر براحتك' : (board.open ? 'لا يُستقبل أرقام جديدة الآن' : 'الدور مغلق الآن'),
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          const VSpace(Gap.xxs),
          Text(
            canTake
                ? 'الانتظار المتوقع حوالي ${Fmt.minutes(board.estimatedWaitMinutes)}'
                : 'يمكنك أخذ رقم خلال ساعات العمل',
            style: context.text.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (canTake) ...[
            const VSpace(Gap.md),
            Obx(
              () => LoadingButton(
                label: 'خذ رقمًا',
                icon: Icons.add_rounded,
                loading: controller.isTaking.value,
                onPressed: controller.takeTicket,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NowServing extends StatelessWidget {
  const _NowServing({required this.board});

  final QueueBoard board;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: board.open ? p.success : p.textMuted, shape: BoxShape.circle),
          ),
          const HSpace(Gap.xs),
          Text('يُخدم الآن', style: context.text.titleSmall),
          const Spacer(),
          if (board.nowServing.isEmpty)
            Text('—', style: context.text.titleLarge)
          else
            Wrap(
              spacing: Gap.xs,
              children: [
                for (final c in board.nowServing)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: Gap.xxs),
                    decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(Radii.sm)),
                    child: Column(
                      children: [
                        Text(c.label, textDirection: TextDirection.ltr, style: context.text.titleMedium?.copyWith(color: p.strong)),
                        if (c.counter != null) Text(c.counter!, style: context.text.labelSmall),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.board});

  final QueueBoard board;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.people_alt_outlined, '${board.waitingCount}', 'ينتظرون'),
      (Icons.timer_outlined, Fmt.minutes(board.averageMinutes), 'متوسط الخدمة'),
      (Icons.task_alt_rounded, '${board.servedToday}', 'خُدموا اليوم'),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const HSpace(Gap.sm),
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: Gap.md, horizontal: Gap.xs),
              child: Column(
                children: [
                  Icon(items[i].$1, color: context.palette.strong),
                  const VSpace(Gap.xxs),
                  Text(items[i].$2, style: context.text.titleSmall, textAlign: TextAlign.center),
                  Text(items[i].$3, style: context.text.labelSmall),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
