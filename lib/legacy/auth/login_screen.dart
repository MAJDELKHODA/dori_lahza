
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'register_screen.dart';
import '../utils/app_colors.dart';
import '../controllers/auth/auth_controller.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  // Check if login started from booking confirmation.
  bool get _returnToBooking {
    final args = Get.arguments;
    return args is Map && args['returnToBooking'] == true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final authController = Get.find<AuthController>();

    final success = await authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    debugPrint('LOGIN SUCCESS: $success');
    debugPrint('IS LOGGED IN: ${authController.isLoggedIn.value}');
    debugPrint('RETURN TO BOOKING: $_returnToBooking');
    debugPrint('PREVIOUS ROUTE: ${Get.previousRoute}');
    debugPrint('CURRENT ROUTE: ${Get.currentRoute}');

    if (!mounted) return;

    if (success) {
      debugPrint('LOGIN NAVIGATION: SUCCESS');
      Get.snackbar(
        'أهلًا بعودتك',
        'تم تسجيل الدخول بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.bluePale,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(16.r),
      );

      // Return to booking confirmation if requested.
      if (_returnToBooking) {
        debugPrint('LOGIN: Returning to booking');

        Navigator.of(context).pop();

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        debugPrint('AFTER BACK: ${Get.currentRoute}');
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } else {
      debugPrint('LOGIN NAVIGATION: FAILED');
      debugPrint('LOGIN ERROR: ${authController.errorMessage.value}');
      Get.snackbar(
        'تعذر تسجيل الدخول',

        authController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accentLight,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(16.r),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Decorative blue circle

          Positioned(
            top: -100.h,
            right: -120.w,
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                color: AppColors.bluePale.withOpacity(0.45),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Decorative pink circle

          Positioned(
            bottom: -120.h,
            left: -100.w,
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 26.w,
                  vertical: 24.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo

                      Center(
                        child: Image.asset(
                          'assets/images/lahza.png',
                          width: 145.w,
                          height: 145.w,
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        'مرحبًا بعودتك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        'سجّل دخولك واكتشف أجمل لحظاتك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Email

                      _buildLabel('البريد الإلكتروني'),

                      SizedBox(height: 9.h),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        decoration: const InputDecoration(
                          hintText: 'example@email.com',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.blueMedium,
                          ),
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';

                          if (email.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }

                          if (!RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(email)) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }

                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Password

                      _buildLabel('كلمة المرور'),

                      SizedBox(height: 9.h),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                        decoration: InputDecoration(
                          hintText: 'أدخل كلمة المرور',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.blueMedium,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }

                          if (value.length < 6) {
                            return 'كلمة المرور قصيرة جدًا';
                          }

                          return null;
                        },
                      ),

                      SizedBox(height: 12.h),

                      // Remember me and forgot password

                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5.r),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),

                          SizedBox(width: 6.w),

                          Expanded(
                            child: Text(
                              'تذكّرني',
                              style: TextStyle(
                                fontFamily: 'Plex',
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'نسيت كلمة المرور؟',
                                'سنضيف شاشة استعادة كلمة المرور لاحقًا.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                            ),
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                fontFamily: 'Plex',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Login Button

                      Obx(() {
                        final authController =
                        Get.find<AuthController>();

                        final loading =
                            authController.isLoading.value;

                        return SizedBox(
                          height: 53.h,
                          child: FilledButton(
                            onPressed: loading ? null : _login,
                            child: loading
                                ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child:
                              const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Text('تسجيل الدخول'),
                          ),
                        );
                      }),

                      SizedBox(height: 22.h),

                      // Register Link

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب؟ ',
                            style: TextStyle(
                              fontFamily: 'Plex',
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Get.toNamed(
                                AppRoutes.register,
                                arguments: {
                                  'returnToBooking':
                                  _returnToBooking,
                                },
                                preventDuplicates: false,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 35.h),
                              tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'إنشاء حساب',
                              style: TextStyle(
                                fontFamily: 'Plex',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Label

  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
