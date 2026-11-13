import 'package:dori_lahza/screen/booking/reschedule_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import 'widgets/booking_qr_card.dart';
import 'widgets/booking_timeline_card.dart';
import 'widgets/cancel_booking_dialog.dart';
import '../../data/models/booking/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});
  // هاي بدها تعديل ل التقييم لانو من خلال ال api حتظهر التقييم
  @override
  Widget build(BuildContext context) {
    // مؤقتًا لاختبار الـ UI
    // لاحقًا القيمة ستأتي من الـ API حسب حالة الحجز
    final bool isCompleted = booking.status == 'completed';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'تفاصيل الحجز',
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
                Icons.close_rounded,
                size: 23.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSuccessCard(isCompleted),

              SizedBox(height: 16.h),

              BookingQrCard(bookingNumber: booking.number, qrText: booking.qr),

              SizedBox(height: 16.h),

              _buildBookingInfoCard(isCompleted),

              SizedBox(height: 16.h),

              BookingTimelineCard(timeline: booking.timeline),

              SizedBox(height: 20.h),

              if (!isCompleted) ...[
                _buildChangeButton(),
                SizedBox(height: 10.h),
                _buildCancelButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard(bool isCompleted) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.bluePale.withOpacity(0.4)
            : const Color(0xFFEAF7EF),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isCompleted ? AppColors.bluePale : const Color(0xFFD1ECDD),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              isCompleted ? Icons.task_alt_rounded : Icons.check_circle_rounded,
              color: isCompleted ? AppColors.primary : AppColors.success,
              size: 23.sp,
            ),
          ),

          SizedBox(width: 11.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCompleted ? 'تم إكمال الحجز' : 'تم تأكيد حجزك بنجاح',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  isCompleted
                      ? 'نتمنى أن تكون تجربتك جميلة، ويمكنك الآن تقييمها.'
                      : 'احتفظي برقم الحجز أو رمز QR عند الحاجة.',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingInfoCard(bool isCompleted) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'الحالة',
            booking.statusLabel,
            valueColor: booking.status == 'completed'
                ? AppColors.primary
                : AppColors.success,
          ),

          Divider(height: 22.h, color: AppColors.border),

          _buildInfoRow('الخدمة', booking.serviceName),

          SizedBox(height: 12.h),

          _buildInfoRow('مزوّد الخدمة', booking.staffName ?? 'لم يحدد'),

          SizedBox(height: 12.h),

          _buildInfoRow(
            'الموعد',
            '${booking.dayLabel} ${booking.date} • ${booking.time}',
          ),

          SizedBox(height: 12.h),

          _buildInfoRow(
            'الإجمالي',
            '${booking.total} ${booking.currencySymbol}',
          ),

          SizedBox(height: 12.h),

          _buildInfoRow('طريقة الدفع', booking.paymentMethodLabel),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95.w,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 11.sp,
              color: AppColors.textSubtle,
            ),
          ),
        ),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton.icon(
        onPressed: () async {
          final result = await Get.to<Map<String, String>>(
            () => const RescheduleBookingScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
          );

          if (result == null) return;

          Get.snackbar(
            'تم اختيار الموعد الجديد',
            '${result['date']} • ${result['time']}',
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16.r),
            backgroundColor: AppColors.surface,
            colorText: AppColors.textPrimary,
          );
        },
        icon: Icon(Icons.event_repeat_rounded, size: 19.sp),
        label: Text(
          'تغيير الموعد',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary.withOpacity(0.35)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton.icon(
        onPressed: () async {
          final result = await Get.dialog<Map<String, dynamic>>(
            const CancelBookingDialog(),
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.55),
          );

          if (result == null) return;

          final bool confirmed = result['confirmed'] == true;

          if (!confirmed) return;

          final String reason = (result['reason'] ?? '').toString().trim();

          Get.snackbar(
            'تم إلغاء الحجز',
            reason.isEmpty
                ? 'تم إلغاء الحجز بنجاح.'
                : 'تم إلغاء الحجز. السبب: $reason',
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16.r),
            backgroundColor: AppColors.surface,
            colorText: AppColors.textPrimary,
          );
        },
        icon: Icon(Icons.cancel_outlined, size: 19.sp),
        label: Text(
          'إلغاء الحجز',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
