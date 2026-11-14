import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/place/presentation/widgets/opening_hours_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// About the place: description, opening hours, contact and booking rules.
class PlaceInfoView extends GetView<PlaceController> {
  const PlaceInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(title: const Text('عن المنشأة')),
      body: Obx(() {
        final place = controller.current;
        final rules = place.booking;
        return ListView(
          padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
          children: [
            AppCard(
              child: Row(
                children: [
                  AppAvatar(url: place.logo, initials: place.name.characters.first, size: 60),
                  const HSpace(Gap.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(place.name, style: context.text.titleLarge),
                        if (place.typeName.isNotEmpty)
                          Text(place.typeName, style: context.text.bodySmall),
                        const VSpace(Gap.xs),
                        Pill(
                          label: place.openNow ? 'مفتوح الآن' : 'مغلق الآن',
                          tone: place.openNow ? Tone.success : Tone.danger,
                          icon: Icons.circle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (place.description != null) ...[
              const VSpace(Gap.md),
              AppCard(
                child: Text(
                  place.description!,
                  style: context.text.bodyMedium?.copyWith(color: p.textSecondary, height: 1.7),
                ),
              ),
            ],
            const VSpace(Gap.lg),
            const SectionHeader(title: 'ساعات العمل', padding: EdgeInsets.zero),
            const VSpace(Gap.xs),
            OpeningHoursCard(hours: place.openingHours),
            if (!place.contact.isEmpty) ...[
              const VSpace(Gap.lg),
              const SectionHeader(title: 'التواصل', padding: EdgeInsets.zero),
              const VSpace(Gap.xs),
              _ContactCard(contact: place.contact),
            ],
            const VSpace(Gap.lg),
            SectionHeader(title: 'سياسة ${controller.labels.booking}', padding: EdgeInsets.zero),
            const VSpace(Gap.xs),
            AppCard(
              child: Column(
                children: [
                  InfoRow(
                    icon: Icons.event_available_outlined,
                    label: 'الحجز متاح مسبقًا حتى',
                    value: '${rules.windowDays} يوم',
                  ),
                  if (rules.minNoticeMinutes > 0)
                    InfoRow(
                      icon: Icons.timer_outlined,
                      label: 'أقل مدة قبل الموعد',
                      value: _hours(rules.minNoticeMinutes),
                    ),
                  if (rules.cancelBeforeHours > 0)
                    InfoRow(
                      icon: Icons.event_busy_outlined,
                      label: 'الإلغاء والتعديل مجانًا قبل',
                      value: '${rules.cancelBeforeHours} ساعة',
                    ),
                  if (rules.maxActiveBookings != null)
                    InfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'أقصى عدد حجوزات نشطة',
                      value: '${rules.maxActiveBookings}',
                    ),
                  InfoRow(
                    icon: Icons.verified_outlined,
                    label: 'التأكيد',
                    value: rules.autoConfirm ? 'فوري' : 'بعد مراجعة المنشأة',
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  static String _hours(int minutes) =>
      minutes % 60 == 0 ? '${minutes ~/ 60} ساعة' : '$minutes دقيقة';
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact});

  final PlaceContact contact;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          children: [
            if (contact.phone != null)
              InfoRow(icon: Icons.call_outlined, label: 'الهاتف', value: contact.phone!),
            if (contact.whatsapp != null)
              InfoRow(icon: Icons.chat_outlined, label: 'واتساب', value: contact.whatsapp!),
            if (contact.address != null)
              InfoRow(icon: Icons.location_on_outlined, label: 'العنوان', value: contact.address!),
          ],
        ),
      );
}
