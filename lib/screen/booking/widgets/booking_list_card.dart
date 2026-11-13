import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';

class BookingListCard extends StatelessWidget {
  final String serviceName;
  final String bookingNumber;
  final String date;
  final String time;
  final String status;
  final String price;
  final VoidCallback onDetailsTap;

  const BookingListCard({
    super.key,
    required this.serviceName,
    required this.bookingNumber,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
    required this.onDetailsTap,
  });

  Color get _statusColor {
    switch (status) {
      case 'مؤكد':
        return const Color(0xFF299C75);
      case 'مكتمل':
        return const Color(0xFF4779D0);
      case 'ملغي':
        return AppColors.error;
      default:
        return const Color(0xFFE6A23C);
    }
  }

  Color get _statusBackground {
    switch (status) {
      case 'مؤكد':
        return const Color(0xFFE1F4EB);
      case 'مكتمل':
        return const Color(0xFFE5EDFF);
      case 'ملغي':
        return const Color(0xFFFFE7E7);
      default:
        return const Color(0xFFFFF1D9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.035),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  serviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _statusBackground,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Text(
            'رقم الحجز: $bookingNumber',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              color: AppColors.textSubtle,
            ),
          ),

          SizedBox(height: 13.h),

          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 16.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 9.h),

          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  time,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                '$price ₪',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 13.h),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onDetailsTap,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                minimumSize: Size(0, 32.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'التفاصيل',
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(Icons.arrow_back_ios_rounded, size: 12.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
