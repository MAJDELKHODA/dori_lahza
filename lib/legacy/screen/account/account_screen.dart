import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import 'profile_edit_screen.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../routes/app_routes.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'حسابي',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 22.h),
          child: Column(
            children: [
              Obx(() => _buildProfileCard()),
              SizedBox(height: 18.h),
              _buildAccountMenu(),
              SizedBox(height: 16.h),
              _buildProviderCard(),
              SizedBox(height: 14.h),
              _buildLogoutButton(),
              SizedBox(height: 12.h),
              Text(
                'لحظة • منصة المناسبات',
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
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFF0F4), Color(0xFFFBE8EE)],
        ),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDCE5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final result = await Get.to<Map<String, String>>(
                      () => const ProfileEditScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );

                    if (result == null) return;

                    _showMessage(
                      'تم الحفظ',
                      'تم حفظ بيانات الحساب في الواجهة التجريبية.',
                    );
                  },
                  icon: Icon(
                    Icons.edit_rounded,
                    size: 19.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Get.find<AuthController>().user.value?.name ??
                          'مستخدم لحظة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      Get.find<AuthController>().user.value?.email ?? '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      Get.find<AuthController>().user.value?.phone ?? '',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF98516B), Color(0xFF70364F)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  Get.find<AuthController>().user.value?.initials ?? '',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '92 / 100',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF299C75),
                ),
              ),
              Text(
                'مؤشر الالتزام',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: 0.92,
              minHeight: 9.h,
              backgroundColor: const Color(0xFFEBDDE1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF299C75),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'الحضور في المواعيد وتجنّب الإلغاء المتأخر يرفع مؤشر الالتزام.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 9.sp,
              height: 1.5,
              color: AppColors.textSubtle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountMenu() {
    final items = [
      (Icons.notifications_none_rounded, 'الإشعارات', 'notifications'),
      (Icons.groups_rounded, 'الفريق', 'team'),
      (Icons.star_border_rounded, 'آراء العميلات', 'reviews'),
      (Icons.auto_awesome_rounded, 'أفضل وقت للزيارة', 'busy_hours'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(21.r),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return InkWell(
            onTap: () => _handleMenuTap(item.$3),
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 23.sp,
                    color: AppColors.textSecondary,
                  ),
                  const Spacer(),
                  Text(
                    item.$2,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(item.$1, size: 21.sp, color: AppColors.primary),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProviderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(21.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'صالون لمسة',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'صالون نسائي متكامل يقدم خدمات الشعر والمكياج والأظافر والعناية بالبشرة بأيدي خبيرات محترفات، في أجواء هادئة وراقية.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              height: 1.8,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          _buildProviderInfoRow(
            Icons.location_on_outlined,
            'رام الله - شارع الإرسال، عمارة النخيل، ط 2',
          ),
          SizedBox(height: 10.h),
          _buildProviderInfoRow(Icons.phone_outlined, '02 295 1234'),
        ],
      ),
    );
  }

  Widget _buildProviderInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Icon(icon, size: 17.sp, color: AppColors.primary),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton.icon(
        onPressed: _confirmLogout,
        icon: Icon(Icons.logout_rounded, size: 19.sp),
        label: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.border, width: 1.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  void _handleMenuTap(String destination) {
    switch (destination) {
      case 'notifications':
        _showMessage('الإشعارات', 'افتحي شاشة الإشعارات من جرس الهوم حاليًا.');
        break;

      case 'team':
        _showMessage('الفريق', 'سنربط شاشة الفريق عند تجهيز التنقلات.');
        break;

      case 'reviews':
        _showMessage('آراء العميلات', 'سنربط شاشة التقييمات لاحقًا.');
        break;

      case 'busy_hours':
        _showMessage('أفضل وقت للزيارة', 'سنربط شاشة أوقات الازدحام لاحقًا.');
        break;
    }
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'تسجيل الخروج',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'هل أنتِ متأكدة من رغبتك في تسجيل الخروج؟',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('تراجع')),
          TextButton(
            onPressed: () async {
              Get.back();
              await _performLogout();
            },
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontFamily: 'Plex',
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    final controller = Get.find<AuthController>();

    try {
      await controller.logout();

      Get.offAllNamed(AppRoutes.main);
    } catch (_) {
      Get.offAllNamed(AppRoutes.main);

      Get.snackbar(
        'تسجيل الخروج',
        'تم إنهاء الجلسة على الجهاز، لكن تعذر الاتصال بالسيرفر.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(14.r),
      );
    }
  }

  void _showMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: EdgeInsets.all(14.r),
      duration: const Duration(seconds: 2),
    );
  }
}
