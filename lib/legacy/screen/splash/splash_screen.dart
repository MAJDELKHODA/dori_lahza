import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Soft blue decoration
          Positioned(
            top: -95.h,
            right: -120.w,
            child: Container(
              width: 270.w,
              height: 270.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bluePale.withOpacity(0.55),
              ),
            ),
          ),

          // Soft pink decoration
          Positioned(
            bottom: -105.h,
            left: -85.w,
            child: Container(
              width: 290.w,
              height: 290.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.22),
              ),
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Logo and text centered together
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Image.asset(
                              'assets/images/lahza.png',
                              width: 270.w,
                              height: 270.w,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 65.sp,
                                  color: AppColors.primary,
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        Text(
                          'كل مناسبة... لحظة خاصة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        Text(
                          'خطّط لمناسبتك، واصنع ذكرى لا تُنسى',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Loading indicator fixed near the bottom
                Positioned(
                  bottom: 28.h,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 23.w,
                        height: 23.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          backgroundColor: AppColors.bluePale,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 14.h),

                      Text(
                        'لحظتك تبدأ من هنا',
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 11.sp,
                          color: AppColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
