import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';

class BookingSummaryCard extends StatelessWidget {
  final String serviceName;
  final String date;
  final String time;
  final String duration;

  const BookingSummaryCard({
    super.key,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.bluePale.withOpacity(0.45), AppColors.accentLight],
        ),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          _buildRow(Icons.celebration_rounded, serviceName),

          SizedBox(height: 12.h),

          _buildRow(Icons.calendar_month_rounded, date),

          SizedBox(height: 12.h),

          _buildRow(Icons.schedule_rounded, '$time • $duration'),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primary),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
