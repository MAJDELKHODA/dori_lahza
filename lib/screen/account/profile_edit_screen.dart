import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../controllers/auth/auth_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    final user = Get.find<AuthController>().user.value;

    _nameController = TextEditingController(text: user?.name ?? '');

    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<AuthController>();

    final success = await controller.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Get.back();

      Get.snackbar(
        'تم التحديث بنجاح',
        'تم حفظ بيانات حسابك',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(14.r),
      );
    } else {
      Get.snackbar(
        'تعذر التحديث',
        controller.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(14.r),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 23.sp,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'تعديل الحساب',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 19.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNameField(),

                SizedBox(height: 12.h),

                _buildPhoneField(),

                SizedBox(height: 20.h),

                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      textInputAction: TextInputAction.next,
      style: _inputTextStyle(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال الاسم';
        }

        return null;
      },
      decoration: _inputDecoration(
        label: 'الاسم',
        icon: Icons.person_outline_rounded,
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      textInputAction: TextInputAction.done,
      style: _inputTextStyle(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال رقم الهاتف';
        }

        if (value.replaceAll(RegExp(r'\D'), '').length < 9) {
          return 'يرجى إدخال رقم هاتف صحيح';
        }

        return null;
      },
      decoration: _inputDecoration(
        label: 'رقم الهاتف',
        icon: Icons.phone_outlined,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: 'Plex',
        fontSize: 11.sp,
        color: AppColors.textSecondary,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: Icon(icon, size: 20.sp, color: AppColors.textSecondary),
      filled: true,
      fillColor: const Color(0xFFFFFBFA),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.error),
      ),
    );
  }

  TextStyle _inputTextStyle() {
    return TextStyle(
      fontFamily: 'Plex',
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: AppColors.primary.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(
          'حفظ',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
