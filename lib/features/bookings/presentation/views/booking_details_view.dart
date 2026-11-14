import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/core/widgets/state_view.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/booking_details_controller.dart';
import 'package:dori_lahza/features/bookings/presentation/widgets/booking_action_sheets.dart';
import 'package:dori_lahza/features/bookings/presentation/widgets/booking_card.dart';
import 'package:dori_lahza/features/bookings/presentation/widgets/booking_detail_cards.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailsView extends GetView<BookingDetailsController> {
  const BookingDetailsView({super.key, required this.bookingId});

  final int bookingId;

  @override
  String? get tag => '$bookingId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحجز')),
      bottomNavigationBar: Obx(() {
        final b = controller.booking;
        if (b == null) return const SizedBox.shrink();
        final canReview = b.canReview && !controller.reviewed.value;
        if (!b.canCancel && !b.canReschedule && !canReview) return const SizedBox.shrink();
        return BottomActionBar(
          child: Row(
            children: [
              if (b.canCancel)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: context.palette.danger),
                    onPressed: () => _showSheet(context, CancelBookingSheet(controller: controller, isLate: b.cancelIsLate)),
                    child: const Text('إلغاء'),
                  ),
                ),
              if (b.canCancel && (b.canReschedule || canReview)) const HSpace(Gap.sm),
              if (b.canReschedule)
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: controller.reschedule,
                    icon: const Icon(Icons.edit_calendar_rounded),
                    label: const Text('تغيير الموعد'),
                  ),
                ),
              if (canReview)
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () => _showSheet(context, ReviewBookingSheet(controller: controller)),
                    icon: const Icon(Icons.star_rounded),
                    label: const Text('قيّم زيارتك'),
                  ),
                ),
            ],
          ),
        );
      }),
      body: Obx(
        () => StateView<Booking>(
          state: controller.state.value,
          loading: Skeleton(
            child: ListView(
              padding: const EdgeInsets.all(Gap.page),
              children: const [
                SkeletonBox(height: 72, radius: Radii.lg),
                VSpace(Gap.md),
                SkeletonBox(height: 280, radius: Radii.lg),
                VSpace(Gap.md),
                SkeletonBox(height: 180, radius: Radii.lg),
              ],
            ),
          ),
          onRetry: controller.load,
          builder: (context, b) => RefreshIndicator(
            onRefresh: () => controller.load(showLoading: false),
            child: _Body(booking: b, justCreated: controller.args.justCreated),
          ),
        ),
      ),
    );
  }

  Future<void> _showSheet(BuildContext context, Widget sheet) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => sheet,
      );
}

class _Body extends StatelessWidget {
  const _Body({required this.booking, required this.justCreated});

  final Booking booking;
  final bool justCreated;

  @override
  Widget build(BuildContext context) {
    final place = Get.find<PlaceController>();
    final b = booking;
    final showQr = b.isActive || b.status == BookingStatus.checkedIn;
    String price(double v) => Fmt.price(v, b.currencySymbol);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Gap.page, Gap.xs, Gap.page, Gap.xxl),
      children: [
        BookingStatusHeader(booking: b, justCreated: justCreated),
        if (showQr && b.code.isNotEmpty) ...[
          const VSpace(Gap.md),
          BookingQrCard(booking: b),
        ],
        const VSpace(Gap.md),
        AppCard(
          child: Column(
            children: [
              BookingServiceTile(booking: b),
              const VSpace(Gap.sm),
              const Divider(),
              const VSpace(Gap.xs),
              InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'التاريخ',
                value: b.startsAt == null ? b.dateLabel : Fmt.dayMonth(b.startsAt!),
              ),
              InfoRow(
                icon: Icons.schedule_rounded,
                label: 'الوقت',
                value: b.endTime == null ? b.time : '${b.time} – ${b.endTime}',
              ),
              InfoRow(icon: Icons.timelapse_rounded, label: 'المدة', value: Fmt.minutes(b.durationMinutes)),
              if (b.staffName != null)
                InfoRow(icon: Icons.person_outline_rounded, label: place.labels.staff, value: b.staffName!),
              InfoRow(icon: Icons.tag_rounded, label: 'رقم الحجز', value: '#${b.number}'),
            ],
          ),
        ),
        if (b.answers.isNotEmpty || b.notes != null) ...[
          const VSpace(Gap.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final e in b.answers.entries)
                  InfoRow(icon: Icons.question_answer_outlined, label: e.key, value: e.value),
                if (b.notes != null) InfoRow(icon: Icons.sticky_note_2_outlined, label: 'ملاحظات', value: b.notes!),
              ],
            ),
          ),
        ],
        const VSpace(Gap.md),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.sell_outlined, label: 'السعر', value: price(b.price)),
              if (b.discount > 0)
                InfoRow(
                  icon: Icons.local_offer_outlined,
                  label: b.couponCode == null ? 'الخصم' : 'الخصم (${b.couponCode})',
                  value: '- ${price(b.discount)}',
                  valueStyle: context.text.labelLarge?.copyWith(color: context.palette.success),
                ),
              InfoRow(
                icon: Icons.payments_outlined,
                label: b.paymentMethodLabel == null ? 'الإجمالي' : 'الإجمالي · ${b.paymentMethodLabel}',
                value: price(b.total),
                valueStyle: context.text.titleMedium?.copyWith(color: context.palette.strong),
              ),
            ],
          ),
        ),
        if (b.review != null) ...[
          const VSpace(Gap.md),
          AppCard(
            child: Row(
              children: [
                Icon(Icons.star_rounded, color: context.palette.star),
                const HSpace(Gap.xs),
                Expanded(
                  child: Text(
                    b.review!.comment ?? 'قيّمت هذه الزيارة بـ ${b.review!.rating} نجوم',
                    style: context.text.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (b.timeline.isNotEmpty) ...[
          const VSpace(Gap.lg),
          const SectionHeader(title: 'مراحل الحجز', padding: EdgeInsets.zero),
          const VSpace(Gap.xs),
          BookingTimeline(steps: b.timeline),
        ],
        if (b.canCancel && place.rules.cancelBeforeHours > 0) ...[
          const VSpace(Gap.md),
          Text(
            b.cancelIsLate
                ? 'الإلغاء الآن يُعدّ متأخرًا ويخفّض مؤشر الالتزام.'
                : 'يمكنك الإلغاء أو تغيير الموعد مجانًا حتى ${place.rules.cancelBeforeHours} ساعة قبل الموعد.',
            textAlign: TextAlign.center,
            style: context.text.bodySmall,
          ),
        ],
      ],
    );
  }
}
