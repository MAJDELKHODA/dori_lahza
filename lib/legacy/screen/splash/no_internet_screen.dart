import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Blue circle at the top-right
          Positioned(
            top: -95.h,
            right: -120.w,
            child: Container(
              width: 270.w,
              height: 270.w,
              decoration: BoxDecoration(
                color: AppColors.bluePale.withOpacity(0.55),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Pink circle at the bottom-left
          Positioned(
            bottom: -105.h,
            left: -85.w,
            child: Container(
              width: 290.w,
              height: 290.w,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Connection icon
                    Container(
                      width: 104.w,
                      height: 104.w,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.10),
                            blurRadius: 25.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 43.sp,
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // Title
                    Text(
                      'لا يوجد اتصال بالإنترنت',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // Description
                    Text(
                      'تحقّق من اتصالك وحاول مرة أخرى.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 13.sp,
                        height: 1.8,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // Retry button
                    SizedBox(
                      width: 205.w,
                      height: 50.h,
                      child: FilledButton.icon(
                        onPressed: onRetry,
                        icon: Icon(Icons.refresh_rounded, size: 20.sp),
                        label: Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
