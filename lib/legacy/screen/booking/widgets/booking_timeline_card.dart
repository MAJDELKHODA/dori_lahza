import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/booking/booking_model.dart';
import '../../../utils/app_colors.dart';

class BookingTimelineCard extends StatelessWidget {
  final List<BookingTimelineStep> timeline;

  const BookingTimelineCard({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مسار الحجز',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 18.h),

          if (timeline.isEmpty)
            Text(
              'لا توجد تفاصيل للمسار حاليًا',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            )
          else
            ...List.generate(timeline.length, (index) {
              final step = timeline[index];

              return _buildStep(
                title: step.label,
                subtitle: step.at != null
                    ? _formatDate(step.at!)
                    : (step.note ?? 'بانتظار التحديث'),
                completed: step.done,
                isLast: index == timeline.length - 1,
              );
            }),
        ],
      ),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value)?.toLocal();

    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} • $hour:$minute';
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required bool completed,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? AppColors.primary : AppColors.border,
              ),
            ),
            if (!isLast)
              Container(width: 2.w, height: 35.h, color: AppColors.bluePale),
          ],
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 9.sp,
                    color: AppColors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
