import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// White rounded card with a hairline border.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.md),
    this.onTap,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: color ?? p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: Radii.card,
        side: BorderSide(color: borderColor ?? p.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
    );
  }
}

/// Section title with an optional trailing action ("عرض الكل").
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction, this.padding});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? Gap.pagePadding,
        child: Row(
          children: [
            Expanded(child: Text(title, style: context.text.titleMedium)),
            if (actionLabel != null && onAction != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: Gap.xs),
                  minimumSize: const Size(0, 36),
                ),
                child: Text(actionLabel!),
              ),
          ],
        ),
      );
}

enum Tone { neutral, brand, success, warning, danger, info }

/// Small rounded label (booking status, "خصم 20%"...).
class Pill extends StatelessWidget {
  const Pill({super.key, required this.label, this.tone = Tone.neutral, this.icon});

  final String label;
  final Tone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (fg, bg) = switch (tone) {
      Tone.neutral => (p.textSecondary, p.surfaceMuted),
      Tone.brand => (p.strong, p.soft),
      Tone.success => (p.success, p.successSoft),
      Tone.warning => (p.warning, p.warningSoft),
      Tone.danger => (p.danger, p.dangerSoft),
      Tone.info => (p.info, p.infoSoft),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: fg), const HSpace(4)],
          Text(label, style: context.text.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Icon + label + value row used in detail cards.
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.label, required this.value, this.valueStyle});

  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(Radii.sm)),
            child: Icon(icon, size: 18, color: p.strong),
          ),
          const HSpace(Gap.sm),
          Expanded(child: Text(label, style: context.text.bodyMedium?.copyWith(color: p.textSecondary))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: valueStyle ?? context.text.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}

/// Filled button that shows a spinner and blocks taps while [loading].
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final style = destructive ? FilledButton.styleFrom(backgroundColor: p.danger) : null;
    final child = loading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: p.onStrong),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const HSpace(Gap.xs)],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    return FilledButton(
      style: style,
      onPressed: loading ? () {} : onPressed,
      child: AnimatedSwitcher(duration: const Duration(milliseconds: 180), child: child),
    );
  }
}

/// Bottom-pinned action area with a top hairline, for primary CTAs.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.page, Gap.sm, Gap.page, Gap.sm),
          child: child,
        ),
      ),
    );
  }
}

/// Standard body for modal bottom sheets: title, content, safe-area padding
/// and keyboard inset.
class SheetBody extends StatelessWidget {
  const SheetBody({super.key, required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
              if (subtitle != null) ...[
                const VSpace(Gap.xxs),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: context.text.bodyMedium?.copyWith(color: context.palette.textSecondary),
                ),
              ],
              const VSpace(Gap.lg),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
