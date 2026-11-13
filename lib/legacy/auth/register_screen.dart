
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:dori_lahza/legacy/utils/app_colors.dart';
import 'package:dori_lahza/legacy/controllers/auth/auth_controller.dart';
import 'package:dori_lahza/legacy/routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  // Check booking return

  bool get _returnToBooking {
    final args = Get.arguments;
    return args is Map && args['returnToBooking'] == true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Register

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      Get.snackbar(
        'تنبيه',
        'يرجى الموافقة على الشروط والأحكام للمتابعة.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.bluePale,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(16.r),
      );
      return;
    }

    final authController = Get.find<AuthController>();

    final success = await authController.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Get.snackbar(
        'أهلًا بك في لحظة ❤️',
        'تم إنشاء حسابك بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.bluePale,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(16.r),
      );

      if (_returnToBooking) {
        // If registration came from login screen,
        // return to booking confirmation directly.
        if (Get.previousRoute == AppRoutes.login) {
          Get.back();
          Get.back();
        } else {
          Get.back();
        }
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } else {
      Get.snackbar(
        'تعذر إنشاء الحساب',
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
          // Blue decoration

          Positioned(
            top: -100.h,
            right: -120.w,
            child: Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bluePale.withOpacity(0.42),
              ),
            ),
          ),

          // Pink decoration

          Positioned(
            bottom: -120.h,
            left: -100.w,
            child: Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.14),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 26.w,
                vertical: 18.h,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.textPrimary,
                          size: 24.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Logo

                    Center(
                      child: Image.asset(
                        'assets/images/lahza.png',
                        width: 115.w,
                        height: 100.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'أنشئ حسابك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'ابدأ رحلتك نحو أجمل اللحظات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 26.h),

                    // Full name

                    _buildLabel('الاسم الكامل'),

                    SizedBox(height: 8.h),

                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        hint: 'أدخل اسمك الكامل',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الاسم الكامل';
                        }

                        if (value.trim().length < 2) {
                          return 'الاسم قصير جدًا';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 17.h),

                    // Email

                    _buildLabel('البريد الإلكتروني'),

                    SizedBox(height: 8.h),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        hint: 'example@email.com',
                        icon: Icons.email_outlined,
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

                    SizedBox(height: 17.h),

                    // Phone number

                    _buildLabel('رقم الهاتف'),

                    SizedBox(height: 8.h),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      autofillHints: const [
                        AutofillHints.telephoneNumber,
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        hint: '059XXXXXXX',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (value) {
                        final phone = value?.trim() ?? '';

                        if (phone.isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        }

                        if (!RegExp(
                          r'^[0-9+ ]{8,15}$',
                        ).hasMatch(phone)) {
                          return 'يرجى إدخال رقم هاتف صحيح';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 17.h),

                    // Password

                    _buildLabel('كلمة المرور'),

                    SizedBox(height: 8.h),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.newPassword,
                      ],
                      decoration: _inputDecoration(
                        hint: 'أنشئ كلمة مرور',
                        icon: Icons.lock_outline_rounded,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
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

                        if (value.length < 8) {
                          return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 17.h),

                    // Confirm password

                    _buildLabel('تأكيد كلمة المرور'),

                    SizedBox(height: 8.h),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [
                        AutofillHints.newPassword,
                      ],
                      onFieldSubmitted: (_) => _register(),
                      decoration: _inputDecoration(
                        hint: 'أعد إدخال كلمة المرور',
                        icon: Icons.lock_reset_rounded,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى تأكيد كلمة المرور';
                        }

                        if (value != _passwordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),

                    // Terms and conditions

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          activeColor: AppColors.primary,
                          side: BorderSide(
                            color: AppColors.blueMedium,
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                        ),

                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'أوافق على ',
                                style: TextStyle(
                                  fontFamily: 'Plex',
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    'الشروط والأحكام',
                                    'سنضيف صفحة الشروط والأحكام لاحقًا.',
                                  );
                                },
                                child: Text(
                                  'الشروط والأحكام',
                                  style: TextStyle(
                                    fontFamily: 'Plex',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Create account button

                    Obx(() {
                      final authController =
                      Get.find<AuthController>();

                      final loading =
                          authController.isLoading.value;

                      return SizedBox(
                        height: 53.h,
                        child: FilledButton(
                          onPressed: loading ? null : _register,
                          child: loading
                              ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text('إنشاء حساب'),
                        ),
                      );
                    }),

                    SizedBox(height: 22.h),

                    // Login link

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟ ',
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 35.h),
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontFamily: 'Plex',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                  ],
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

  // Input Decoration

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: AppColors.blueMedium,
      ),
      suffixIcon: suffix,
    );
  }
}
