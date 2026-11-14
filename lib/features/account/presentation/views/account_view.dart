import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/features/account/presentation/widgets/reliability_card.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// "حسابي" tab: profile, reliability and links to the rest of the app.
class AccountView extends GetView<SessionController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: Obx(() {
        final user = controller.user.value;
        return RefreshIndicator(
          onRefresh: controller.refreshUser,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
            children: [
              if (user == null)
                AppCard(
                  child: EmptyView(
                    icon: Icons.person_outline_rounded,
                    title: 'سجّل دخولك',
                    subtitle: 'لحجز ${labels.booking} ومتابعة حجوزاتك وتلقّي التنبيهات',
                    actionLabel: 'تسجيل الدخول',
                    onAction: controller.ensureSignedIn,
                    compact: true,
                  ),
                )
              else ...[
                _ProfileHeader(user: user),
                if (user.reliability != null) ...[
                  const VSpace(Gap.md),
                  ReliabilityCard(reliability: user.reliability!),
                ],
              ],
              const VSpace(Gap.lg),
              _MenuGroup(
                children: [
                  if (user != null) ...[
                    _MenuTile(
                      icon: Icons.hourglass_top_rounded,
                      title: 'قائمة الانتظار',
                      onTap: () => Get.toNamed<void>(AppRoutes.waitlist),
                    ),
                    _MenuTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'الإشعارات',
                      onTap: () => Get.toNamed<void>(AppRoutes.notifications),
                    ),
                  ],
                  _MenuTile(
                    icon: Icons.insights_rounded,
                    title: 'أفضل وقت للزيارة',
                    onTap: () => Get.toNamed<void>(AppRoutes.busyHours),
                  ),
                  _MenuTile(
                    icon: Icons.groups_2_outlined,
                    title: labels.staffPlural,
                    onTap: () => Get.toNamed<void>(AppRoutes.team),
                  ),
                  _MenuTile(
                    icon: Icons.reviews_outlined,
                    title: 'التقييمات',
                    onTap: () => Get.toNamed<void>(AppRoutes.placeReviews),
                  ),
                  _MenuTile(
                    icon: Icons.storefront_outlined,
                    title: 'عن المنشأة وساعات العمل',
                    onTap: () => Get.toNamed<void>(AppRoutes.placeInfo),
                  ),
                ],
              ),
              if (user != null) ...[
                const VSpace(Gap.md),
                _MenuGroup(
                  children: [
                    _MenuTile(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      destructive: true,
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: context.palette.danger),
            child: const Text('خروج'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.signOut();
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      onTap: () => Get.toNamed<void>(AppRoutes.editProfile),
      child: Row(
        children: [
          AppAvatar(url: user.avatar, initials: user.initials, size: 60),
          const HSpace(Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: context.text.titleMedium),
                Text(user.email, style: context.text.bodySmall, textDirection: TextDirection.ltr),
                if (user.phone != null)
                  Text(user.phone!, style: context.text.bodySmall, textDirection: TextDirection.ltr),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color: p.textMuted, size: 20),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.symmetric(vertical: Gap.xxs),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(indent: 60),
              children[i],
            ],
          ],
        ),
      );
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.onTap, this.destructive = false});

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = destructive ? p.danger : p.strong;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: destructive ? p.dangerSoft : p.soft,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(
        title,
        style: context.text.labelLarge?.copyWith(color: destructive ? p.danger : p.textPrimary),
      ),
      trailing: destructive ? null : Icon(Icons.chevron_right_rounded, color: p.textMuted),
    );
  }
}
