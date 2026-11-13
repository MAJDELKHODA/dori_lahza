import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/login_screen.dart';
import '../../utils/app_colors.dart';
import '../services/services_screen.dart';
import '../booking/booking_details_screen.dart';
import 'widgets/booking_list_card.dart';

class MyBookingsScreen extends StatefulWidget {
  final bool isLoggedIn;

  const MyBookingsScreen({super.key, this.isLoggedIn = true});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int _selectedTab = 0;

  final List<_BookingData> _upcomingBookings = [
    _BookingData(
      serviceName: 'تنسيق حفلات',
      bookingNumber: 'LHZ-24817',
      date: 'الخميس 23 أكتوبر',
      time: '4:30 م',
      status: 'مؤكد',
      price: '340',
    ),
    _BookingData(
      serviceName: 'مكياج سهرة',
      bookingNumber: 'LHZ-24903',
      date: 'الجمعة 31 أكتوبر',
      time: '6:00 م',
      status: 'بانتظار التأكيد',
      price: '250',
    ),
    _BookingData(
      serviceName: 'مانيكير جل',
      bookingNumber: 'LHZ-25011',
      date: 'الأحد 9 نوفمبر',
      time: '11:00 ص',
      status: 'مؤكد',
      price: '90',
    ),
  ];

  final List<_BookingData> _previousBookings = [
    _BookingData(
      serviceName: 'قص وتصفيف الشعر',
      bookingNumber: 'LHZ-23120',
      date: 'السبت 4 أكتوبر',
      time: '12:00 م',
      status: 'مكتمل',
      price: '120',
    ),
    _BookingData(
      serviceName: 'جلسة عناية بالبشرة',
      bookingNumber: 'LHZ-22456',
      date: 'الأربعاء 24 سبتمبر',
      time: '3:00 م',
      status: 'ملغي',
      price: '180',
    ),
    _BookingData(
      serviceName: 'مانيكير جل',
      bookingNumber: 'LHZ-21987',
      date: 'الخميس 18 سبتمبر',
      time: '5:30 م',
      status: 'مكتمل',
      price: '90',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'حجوزاتي',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: widget.isLoggedIn
            ? Column(
                children: [
                  _buildTabs(),
                  Expanded(child: _buildBookingContent()),
                ],
              )
            : _buildLoginState(),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(children: [_buildTab('القادمة', 0), _buildTab('السابقة', 1)]),
    );
  }

  Widget _buildTab(String title, int index) {
    final bool selected = _selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 2.5 : 1,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 12.sp,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.textSubtle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingContent() {
    final bookings = _selectedTab == 0 ? _upcomingBookings : _previousBookings;

    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return BookingListCard(
          serviceName: booking.serviceName,
          bookingNumber: booking.bookingNumber,
          date: booking.date,
          time: booking.time,
          status: booking.status,
          price: booking.price,
          onDetailsTap: () {
            Get.snackbar(
              'تفاصيل الحجز',
              'سيتم ربط تفاصيل الحجوزات بعد ربط قائمة حجوزاتي بالسيرفر.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final bool isUpcoming = _selectedTab == 0;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming
                    ? Icons.event_available_rounded
                    : Icons.history_rounded,
                size: 36.sp,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              isUpcoming ? 'لا توجد حجوزات قادمة' : 'لا توجد حجوزات سابقة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              isUpcoming
                  ? 'ابدئي التخطيط لمناسبتك القادمة واختاري الخدمات التي تناسبك.'
                  : 'ستظهر هنا حجوزاتك السابقة بعد إتمامها.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                height: 1.7,
                color: AppColors.textSecondary,
              ),
            ),

            if (isUpcoming) ...[
              SizedBox(height: 20.h),
              FilledButton.icon(
                onPressed: _openServices,
                icon: const Icon(Icons.add_rounded),
                label: const Text('احجزي موعدًا'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 13.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoginState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_person_rounded,
                size: 36.sp,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 18.h),

            Text(
              'حجوزاتك بانتظارك',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'سجّلي الدخول لعرض حجوزاتك وإدارتها.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: 20.h),

            FilledButton(
              onPressed: () {
                Get.to(
                  () => const LoginScreen(),
                  transition: Transition.rightToLeft,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }

  void _openServices() {
    Get.to(
      () => const ServicesScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _BookingData {
  final String serviceName;
  final String bookingNumber;
  final String date;
  final String time;
  final String status;
  final String price;

  const _BookingData({
    required this.serviceName,
    required this.bookingNumber,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
  });
}
