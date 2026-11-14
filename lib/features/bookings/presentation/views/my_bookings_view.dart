import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/paged_list_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/bookings_list_controller.dart';
import 'package:dori_lahza/features/bookings/presentation/widgets/booking_card.dart';
import 'package:dori_lahza/features/shell/presentation/controllers/shell_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// "حجوزاتي" tab: upcoming and past bookings.
class MyBookingsView extends StatelessWidget {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حجوزاتي'),
          bottom: const TabBar(tabs: [Tab(text: 'القادمة'), Tab(text: 'السابقة')]),
        ),
        body: Obx(
          () => !session.isSignedIn
              ? EmptyView(
                  icon: Icons.event_note_outlined,
                  title: 'سجّل دخولك لعرض حجوزاتك',
                  actionLabel: 'تسجيل الدخول',
                  onAction: session.ensureSignedIn,
                )
              : const TabBarView(
                  children: [_BookingsList(scope: BookingScope.upcoming), _BookingsList(scope: BookingScope.past)],
                ),
        ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  const _BookingsList({required this.scope});

  final BookingScope scope;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingsListController>(tag: scope.name);
    return PagedListView<Booking>(
      controller: controller,
      loading: const SkeletonList(count: 5, thumbSize: 64),
      empty: scope == BookingScope.upcoming
          ? EmptyView(
              icon: Icons.event_available_outlined,
              title: 'لا توجد حجوزات قادمة',
              subtitle: 'احجز موعدك القادم بخطوات بسيطة',
              actionLabel: 'تصفّح الخدمات',
              onAction: () => Get.find<ShellController>().open(ShellTab.services),
            )
          : const EmptyView(icon: Icons.history_rounded, title: 'لا توجد حجوزات سابقة'),
      separator: const VSpace(Gap.sm),
      itemBuilder: (_, b) => BookingCard(booking: b, onTap: () => AppNav.bookingDetails(b.id, initial: b)),
    );
  }
}
