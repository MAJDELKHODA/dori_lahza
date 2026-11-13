import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';

class BookingQrCard extends StatelessWidget {
  final String bookingNumber;
  final String qrText;

  const BookingQrCard({
    super.key,
    required this.bookingNumber,
    required this.qrText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'رقم الحجز $bookingNumber',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 14.h),

          Container(
            width: 145.w,
            height: 145.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.qr_code_2_rounded,
              size: 125.sp,
              color: Colors.black,
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            'كود الوصول: $qrText',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
