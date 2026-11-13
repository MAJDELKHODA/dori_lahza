import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class TimeConflictDialog extends StatefulWidget {
  const TimeConflictDialog({super.key});

  @override
  State<TimeConflictDialog> createState() => _TimeConflictDialogState();
}

class _TimeConflictDialogState extends State<TimeConflictDialog> {
  int? _selectedTimeIndex;

  final List<String> _availableTimes = const ['5:15 م', '6:00 م', '6:45 م'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 28.r,
              offset: Offset(0, 12.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),

            SizedBox(height: 14.h),

            Text(
              'سبقك أحدهم لهذا الوقت',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 7.h),

            Text(
              'هذا الموعد لم يعد متاحًا، اخترنا لك أقرب الأوقات المتاحة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: 22.h),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'أوقات قريبة متاحة',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            _buildTimes(),

            SizedBox(height: 20.h),

            if (_selectedTimeIndex != null) _buildConfirmAlternativeButton(),

            SizedBox(height: 8.h),

            TextButton(
              onPressed: () {
                Get.back(result: 'choose_another_time');
              },
              child: Text(
                'اختيار وقت آخر',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 54.w,
      height: 54.w,
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.schedule_rounded, size: 27.sp, color: AppColors.accent),
    );
  }

  Widget _buildTimes() {
    return Row(
      children: List.generate(_availableTimes.length, (index) {
        final selected = _selectedTimeIndex == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 46.h,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _availableTimes[index],
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildConfirmAlternativeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () {
          final selectedTime = _availableTimes[_selectedTimeIndex!];

          Get.back(result: selectedTime);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          'اعتماد هذا الوقت',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
