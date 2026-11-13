
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../controllers/booking/booking_controller.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../routes/app_routes.dart';
import 'booking_details_screen.dart';
import 'widgets/booking_summary_card.dart';
import 'widgets/price_summary_card.dart';

class BookingConfirmScreen extends StatefulWidget {
  final int serviceId;
  final String startsAt;
  final int? staffId;
  final String selectedDate;
  final String selectedDayLabel;
  final String selectedTime;

  const BookingConfirmScreen({
    super.key,
    required this.serviceId,
    required this.startsAt,
    this.staffId,
    required this.selectedDate,
    required this.selectedDayLabel,
    required this.selectedTime,
  });

  @override
  State<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState
    extends State<BookingConfirmScreen> {
  final TextEditingController _notesController =
  TextEditingController();

  final TextEditingController _couponController =
  TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  // Login Required Dialog
  Future<void> _showLoginRequiredDialog() async {
    final result = await Get.dialog<String>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('خطوة أخيرة لإتمام حجزك!'),
        content: const Text(
          'يجب تسجيل الدخول أو إنشاء حساب أولًا حتى نتمكن من تأكيد حجزك.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: 'login'),
            child: const Text('تسجيل الدخول'),
          ),
          TextButton(
            onPressed: () => Get.back(result: 'register'),
            child: const Text('إنشاء حساب جديد'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ليس الآن'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (!mounted || result == null) return;

    if (result == 'login') {
      await Get.toNamed(
        AppRoutes.login,
        arguments: {'returnToBooking': true},
      );
    } else if (result == 'register') {
      await Get.toNamed(
        AppRoutes.register,
        arguments: {'returnToBooking': true},
      );
    }
  }

  // Main Screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تأكيد الحجز',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 24.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  18.w,
                  8.h,
                  18.w,
                  24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSummaryCard(
                      serviceName: 'الخدمة المختارة',
                      date:
                      '${widget.selectedDayLabel} ${widget.selectedDate}',
                      time: widget.selectedTime,
                      duration: 'حسب مدة الخدمة',
                    ),

                    SizedBox(height: 24.h),

                    _buildSectionTitle('معلومات إضافية'),

                    SizedBox(height: 12.h),

                    _buildInfoField(),

                    SizedBox(height: 24.h),

                    _buildSectionTitle('ملاحظات'),

                    SizedBox(height: 12.h),

                    _buildNotesField(),

                    SizedBox(height: 24.h),

                    _buildSectionTitle('كوبون خصم'),

                    SizedBox(height: 12.h),

                    _buildCouponField(),

                    SizedBox(height: 24.h),

                    _buildSectionTitle('طريقة الدفع'),

                    SizedBox(height: 12.h),

                    _buildPaymentCard(),

                    SizedBox(height: 24.h),

                    const PriceSummaryCard(
                      price: 340,
                      discount: 34,
                      total: 306,
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  // Section Title

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 19.h,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // Additional Information

  Widget _buildInfoField() {
    return TextField(
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 12.sp,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'هل لديك حساسية من أي شيء؟',
        hintStyle: TextStyle(
          fontFamily: 'Plex',
          fontSize: 11.sp,
          color: AppColors.textSubtle,
        ),
        prefixIcon: Icon(
          Icons.info_outline_rounded,
          color: AppColors.primary,
          size: 20.sp,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  // Notes

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      minLines: 3,
      maxLines: 5,
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 12.sp,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'مثلاً: ألوان مفضلة أو تفاصيل مهمة...',
        hintStyle: TextStyle(
          fontFamily: 'Plex',
          fontSize: 11.sp,
          color: AppColors.textSubtle,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  // Coupon

  Widget _buildCouponField() {
    return SizedBox(
      height: 54.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 12.sp,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'أدخلي الكوبون',
                hintStyle: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  color: AppColors.textSubtle,
                ),
                prefixIcon: Icon(
                  Icons.local_offer_outlined,
                  size: 19.sp,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 10.w),

          SizedBox(
            width: 82.w,
            child: ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentLight,
                foregroundColor: AppColors.primary,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'تطبيق',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Payment

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.bluePale.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.payments_outlined,
              size: 21.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الدفع عند تقديم الخدمة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'لا يلزم الدفع الآن',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    color: AppColors.textSubtle,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.check_circle_rounded,
            size: 21.sp,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // Confirm Button

  Widget _buildConfirmButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        18.w,
        10.h,
        18.w,
        16.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: Obx(() {
            final controller = Get.find<BookingController>();
            final loading = controller.isCreatingBooking.value;

            return ElevatedButton(
              onPressed: loading
                  ? null
                  : _handleConfirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.r),
                ),
              ),
              child: loading
                  ? SizedBox(
                width: 23.w,
                height: 23.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'تأكيد الحجز',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Handle Confirmation

  Future<void> _handleConfirmBooking() async {
    FocusScope.of(context).unfocus();

    final authController = Get.find<AuthController>();

    // Guest user: request authentication first.
    if (!authController.isLoggedIn.value) {
      await _showLoginRequiredDialog();
      return;
    }

    final controller = Get.find<BookingController>();

    final success = await controller.createBooking(
      startsAt: widget.startsAt,
      notes: _notesController.text.trim(),
      couponCode: _couponController.text.trim().isEmpty
          ? null
          : _couponController.text.trim(),
      paymentMethod: 'cash',
    );

    if (!mounted) return;

    if (!success) {
      Get.snackbar(
        'تعذر تأكيد الحجز',
        controller.createBookingError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(16.r),
      );
      return;
    }

    final booking = controller.createdBooking.value;

    if (booking == null) {
      Get.snackbar(
        'تنبيه',
        'تم إرسال الطلب لكن لم نستطع قراءة بيانات الحجز.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.off(
          () => BookingDetailsScreen(booking: booking),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
