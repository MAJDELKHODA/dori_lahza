import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class CancelBookingDialog extends StatefulWidget {
  const CancelBookingDialog({super.key});

  @override
  State<CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<CancelBookingDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 20.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2F6),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 26.r,
              offset: Offset(0, 12.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'إلغاء الحجز',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Center(
              child: Text(
                'الإلغاء المتأخر قد يخضع لشروط الالتزام',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE7A34A),
                ),
              ),
            ),

            SizedBox(height: 18.h),

            TextField(
              controller: _reasonController,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 12.sp,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'سبب الإلغاء',
                hintStyle: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  color: AppColors.textSubtle,
                ),
                suffixIcon: Icon(
                  Icons.search_rounded,
                  size: 21.sp,
                  color: AppColors.textPrimary,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(
                          result: {
                            'confirmed': true,
                            'reason': _reasonController.text.trim(),
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9B4663),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'تأكيد الإلغاء',
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'تراجع',
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9B4663),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
