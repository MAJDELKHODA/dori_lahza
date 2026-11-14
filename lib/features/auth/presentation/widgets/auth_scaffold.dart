import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shared frame of the login and register screens: brand header with the
/// place logo, then a scrollable form.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.title, required this.subtitle, required this.children});

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final place = Get.find<PlaceController>().place.value;
    return Scaffold(
      backgroundColor: p.surface,
      appBar: AppBar(backgroundColor: p.soft),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.xxl),
              decoration: BoxDecoration(
                color: p.soft,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Radii.xl)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Gap.xxs),
                    decoration: BoxDecoration(
                      color: p.surface,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: p.strong.withValues(alpha: 0.12), blurRadius: 24)],
                    ),
                    child: AppAvatar(
                      url: place?.logo,
                      initials: place?.name.characters.first ?? 'ل',
                      size: 76,
                    ),
                  ),
                  const VSpace(Gap.md),
                  Text(title, style: context.text.headlineSmall),
                  const VSpace(Gap.xxs),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: context.text.bodyMedium?.copyWith(color: p.textSecondary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xl, Gap.page, Gap.xl),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
            ),
          ],
        ),
      ),
    );
  }
}
