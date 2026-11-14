import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/paged_list_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';
import 'package:dori_lahza/features/notifications/presentation/controllers/notifications_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          Obx(
            () => controller.hasUnread
                ? TextButton(
                    onPressed: controller.isMarking.value ? null : controller.markAllRead,
                    child: const Text('تعليم الكل كمقروء'),
                  )
                : const SizedBox.shrink(),
          ),
          const HSpace(Gap.xs),
        ],
      ),
      body: PagedListView<AppNotification>(
        controller: controller,
        loading: const SkeletonList(count: 7, thumbSize: 44),
        empty: const EmptyView(
          icon: Icons.notifications_none_rounded,
          title: 'لا توجد إشعارات',
          subtitle: 'ستصلك هنا تأكيدات الحجز وعروض الانتظار وتنبيهات الدور',
        ),
        separator: const VSpace(Gap.xs),
        itemBuilder: (_, n) => _NotificationTile(notification: n, onTap: () => controller.open(n)),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final n = notification;
    final (icon, color) = switch (n.kind) {
      NotificationKind.booking => (Icons.event_available_rounded, p.strong),
      NotificationKind.waitlistOffer => (Icons.bolt_rounded, p.warning),
      NotificationKind.queue => (Icons.confirmation_number_outlined, p.success),
      NotificationKind.review => (Icons.star_rounded, p.star),
      NotificationKind.general => (Icons.notifications_rounded, p.info),
    };
    return AppCard(
      onTap: onTap,
      color: n.isRead ? null : p.soft,
      borderColor: n.isRead ? null : p.brand.withValues(alpha: 0.5),
      padding: const EdgeInsets.all(Gap.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
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
                        n.title,
                        style: context.text.labelLarge?.copyWith(fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700),
                      ),
                    ),
                    if (n.createdAt != null) Text(Fmt.relative(n.createdAt!), style: context.text.labelSmall),
                  ],
                ),
                if (n.body != null) ...[
                  const VSpace(2),
                  Text(n.body!, style: context.text.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (!n.isRead) ...[
            const HSpace(Gap.xs),
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: p.strong, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }
}
