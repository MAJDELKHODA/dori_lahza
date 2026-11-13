import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Centered icon + title + subtitle + optional action. Base of the error and
/// empty views.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconBackground,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final Color? iconBackground;

  /// Smaller variant for use inside sections instead of full screens.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final size = compact ? 56.0 : 84.0;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Gap.xxl, vertical: compact ? Gap.lg : Gap.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(color: iconBackground ?? p.soft, shape: BoxShape.circle),
              child: Icon(icon, size: size * 0.46, color: iconColor ?? p.strong),
            ),
            VSpace(compact ? Gap.sm : Gap.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: compact ? context.text.titleSmall : context.text.titleMedium,
            ),
            if (subtitle != null) ...[
              const VSpace(Gap.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(color: p.textSecondary),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              VSpace(compact ? Gap.sm : Gap.xl),
              SizedBox(
                width: compact ? null : 220,
                child: FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.failure, this.onRetry, this.compact = false});

  final Failure failure;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (icon, title) = switch (failure.kind) {
      FailureKind.network => (Icons.wifi_off_rounded, 'لا يوجد اتصال'),
      FailureKind.notFound => (Icons.search_off_rounded, 'غير موجود'),
      FailureKind.unauthorized => (Icons.lock_outline_rounded, 'يلزم تسجيل الدخول'),
      FailureKind.server => (Icons.cloud_off_rounded, 'الخادم غير متاح'),
      _ => (Icons.error_outline_rounded, 'حدث خطأ'),
    };
    return MessageView(
      icon: icon,
      title: title,
      subtitle: failure.message,
      iconColor: p.danger,
      iconBackground: p.dangerSoft,
      actionLabel: onRetry == null ? null : 'إعادة المحاولة',
      onAction: onRetry,
      compact: compact,
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) => MessageView(
        icon: icon,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
        compact: compact,
      );
}
