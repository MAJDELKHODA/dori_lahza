import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/home/home_controller.dart';
import '../../controllers/services/service_details_binding.dart';
import '../../controllers/team/team_binding.dart';
import '../../controllers/team/team_controller.dart';
import '../../data/models/home/home_response.dart';
import '../../utils/app_colors.dart';

import '../notifications/notifications_screen.dart';
import '../services/services_screen.dart';
import '../services/service_details_screen.dart';
import '../team/team_member_profile_screen.dart';
import '../team/team_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenServices;
  final ValueChanged<String>? onOpenCategory;
  final VoidCallback? onOpenTeam;

  const HomeScreen({
    super.key,
    this.onOpenServices,
    this.onOpenCategory,
    this.onOpenTeam,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find<HomeController>();

  void _showMessage(String message) {
    Get.snackbar(
      'لحظة',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.bluePale,
      colorText: AppColors.textPrimary,
      margin: EdgeInsets.all(14.r),
      duration: const Duration(seconds: 2),
    );
  }

  // Notifications

  void _openNotifications() {
    Get.to(
      () => const NotificationsScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Services Navigation

  void _openServices() {
    final callback = widget.onOpenServices;

    if (callback != null) {
      callback();
      return;
    }

    Get.to(
      () => const ServicesScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Team Navigation

  void _openTeam() {
    final callback = widget.onOpenTeam;

    if (callback != null) {
      callback();
      return;
    }

    Get.to(
      () => const TeamScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Team Member Profile

  void _openTeamMember(HomeStaff member) {
    if (!Get.isRegistered<TeamController>()) {
      TeamBinding().dependencies();
    }

    Get.to(
      () => TeamMemberProfileScreen(staffId: member.id),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Service Details

  void _openServiceDetails(HomeService service) {
    Get.to(
      () => ServiceDetailsScreen(serviceId: service.id),
      binding: ServiceDetailsBinding(serviceId: service.id),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: -95.h,
              right: -115.w,
              child: Container(
                width: 230.w,
                height: 230.w,
                decoration: BoxDecoration(
                  color: AppColors.bluePale.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Obx(() {
              final home = controller.homeData.value;

              if (controller.isLoading.value && home == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (home == null) {
                return _buildErrorState();
              }

              return _buildHomeContent(home);
            }),
          ],
        ),
      ),
    );
  }

  // Error State

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 55.sp,
              color: AppColors.textSubtle,
            ),
            SizedBox(height: 15.h),
            Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'تعذر تحميل الصفحة الرئيسية',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton.icon(
              onPressed: controller.fetchHomeData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  // Home Content

  Widget _buildHomeContent(HomeResponse home) {
    return RefreshIndicator(
      onRefresh: controller.fetchHomeData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 110.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(),
                SizedBox(height: 18.h),

                _buildSearch(),
                SizedBox(height: 20.h),

                _buildWelcomeCard(),
                SizedBox(height: 22.h),

                _buildOfferBanner(home),
                SizedBox(height: 26.h),

                _buildSectionTitle('المناسبات', 'اكتشفي المزيد'),
                SizedBox(height: 14.h),

                _buildCategories(home.categories),
                SizedBox(height: 26.h),

                _buildSectionTitle('خدمات مميزة', 'عرض الكل'),
                SizedBox(height: 14.h),

                _buildServicesGrid(home.featured),
                SizedBox(height: 26.h),

                _buildSectionTitle('الأكثر طلبًا', 'عرض الكل'),
                SizedBox(height: 14.h),

                _buildPopularServices(home.popular),
                SizedBox(height: 22.h),

                _buildInspirationBanner(),
                SizedBox(height: 26.h),

                _buildSectionTitle('فريقنا', 'عرض الكل', onTap: _openTeam),
                SizedBox(height: 14.h),

                _buildStaff(home.staff),
                SizedBox(height: 26.h),

                _buildSectionTitle('الأعلى تقييمًا', 'عرض الكل'),
                SizedBox(height: 14.h),

                _buildRatingCard(),
                SizedBox(height: 18.h),

                _buildMainButton(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Header

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 45.w,
          height: 45.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            onPressed: _openNotifications,
            icon: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
        ),
        SizedBox(width: 11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أهلًا بك في لحظة 👋',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'خلّينا نرتّب مناسبتك القادمة',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 43.w,
          height: 43.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.bluePale, width: 1.5),
          ),
          child: Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 25.sp,
          ),
        ),
      ],
    );
  }

  // Search

  Widget _buildSearch() {
    return Container(
      height: 49.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        onSubmitted: (_) {
          _showMessage('البحث سنربطه بالخدمات لاحقًا');
        },
        decoration: InputDecoration(
          hintText: 'ابحثي عن قاعة، ديكور، أو خدمة...',
          hintStyle: TextStyle(
            fontFamily: 'Plex',
            fontSize: 11.sp,
            color: AppColors.textSubtle,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 23.sp,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  // Welcome Card

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(17.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF6D8CBE), Color(0xFF9EB8D2)],
        ),
        borderRadius: BorderRadius.circular(21.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 16.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'صنعي لحظتك الخاصة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'كل ما تحتاجينه لمناسبتك في مكان واحد',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                SizedBox(height: 13.h),
                SizedBox(
                  height: 34.h,
                  child: FilledButton(
                    onPressed: _openServices,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11.r),
                      ),
                    ),
                    child: Text(
                      'ابدئي التخطيط',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 88.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.19),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 67.sp,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }

  // API Banners

  Widget _buildOfferBanner(HomeResponse home) {
    if (home.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 170.h,
      child: PageView.builder(
        itemCount: home.banners.length,
        itemBuilder: (context, index) {
          final banner = home.banners[index];

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.bluePale,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  banner.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.bluePale,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 45.sp,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
                if (banner.title != null && banner.title!.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(13.r),
                      color: Colors.black.withValues(alpha: 0.42),
                      child: Text(
                        banner.title!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Section Title

  Widget _buildSectionTitle(
    String title,
    String action, {
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 19.h,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap ?? _openServices,
          child: Text(
            action,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // API Categories

  Widget _buildCategories(List<HomeCategory> categories) {
    if (categories.isEmpty) {
      return _buildEmptySection('لا توجد تصنيفات حاليًا');
    }

    return SizedBox(
      height: 104.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return SizedBox(width: 15.w);
        },
        itemBuilder: (context, index) {
          final category = categories[index];

          return InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              widget.onOpenCategory?.call(category.name);
            },
            child: SizedBox(
              width: 68.w,
              child: Column(
                children: [
                  Container(
                    width: 61.w,
                    height: 61.w,
                    decoration: BoxDecoration(
                      color: AppColors.bluePale,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: category.image != null && category.image!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.network(
                              category.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  _categoryIcon(category.icon),
                                  size: 29.sp,
                                  color: AppColors.primary,
                                );
                              },
                            ),
                          )
                        : Icon(
                            _categoryIcon(category.icon),
                            size: 29.sp,
                            color: AppColors.primary,
                          ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _categoryIcon(String? icon) {
    switch (icon) {
      case 'building-2':
        return Icons.business_rounded;
      case 'camera':
        return Icons.camera_alt_rounded;
      case 'store':
        return Icons.storefront_rounded;
      case 'clock':
        return Icons.celebration_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  // Featured Services

  Widget _buildServicesGrid(List<HomeService> services) {
    if (services.isEmpty) {
      return _buildEmptySection('لا توجد خدمات مميزة حاليًا');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 225.h,
      ),
      itemBuilder: (context, index) {
        return _serviceCard(services[index]);
      },
    );
  }

  // Popular Services

  Widget _buildPopularServices(List<HomeService> services) {
    if (services.isEmpty) {
      return _buildEmptySection('لا توجد خدمات حاليًا');
    }

    return SizedBox(
      height: 185.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (context, index) {
          return SizedBox(width: 12.w);
        },
        itemBuilder: (context, index) {
          return SizedBox(width: 150.w, child: _serviceCard(services[index]));
        },
      ),
    );
  }

  // Service Card

  Widget _serviceCard(HomeService service) {
    return InkWell(
      onTap: () => _openServiceDetails(service),
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.035),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: service.image != null && service.image!.isNotEmpty
                        ? Image.network(
                            service.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _serviceImagePlaceholder();
                            },
                          )
                        : _serviceImagePlaceholder(),
                  ),
                  if (service.discountPercent != null &&
                      service.discountPercent! > 0)
                    Positioned(
                      top: 9.h,
                      left: 9.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'خصم ${service.discountPercent}%',
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 11.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    service.durationLabel,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 9.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    children: [
                      Text(
                        '${service.finalPrice.toStringAsFixed(0)} ₪',
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      if (service.salePrice != null &&
                          service.salePrice! < service.price)
                        Text(
                          '${service.price.toStringAsFixed(0)} ₪',
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 9.sp,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textSubtle,
                          ),
                        ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14.sp,
                        color: AppColors.textSubtle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceImagePlaceholder() {
    return Container(
      color: AppColors.bluePale,
      child: Icon(
        Icons.celebration_rounded,
        size: 50.sp,
        color: AppColors.primary,
      ),
    );
  }

  // Team Members

  Widget _buildStaff(List<HomeStaff> staff) {
    if (staff.isEmpty) {
      return _buildEmptySection('لا يوجد أعضاء فريق حاليًا');
    }

    return SizedBox(
      height: 115.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: staff.length,
        separatorBuilder: (context, index) {
          return SizedBox(width: 13.w);
        },
        itemBuilder: (context, index) {
          final member = staff[index];

          return InkWell(
            borderRadius: BorderRadius.circular(15.r),
            onTap: () => _openTeamMember(member),
            child: SizedBox(
              width: 76.w,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.bluePale,
                    backgroundImage:
                        member.avatar != null && member.avatar!.isNotEmpty
                        ? NetworkImage(member.avatar!)
                        : null,
                    child: member.avatar == null || member.avatar!.isEmpty
                        ? Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: 30.sp,
                          )
                        : null,
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    member.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 8.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Inspiration Banner

  Widget _buildInspirationBanner() {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(17.r),
      ),
      child: Row(
        children: [
          Container(
            width: 43.w,
            height: 43.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ألهمي لحظتك القادمة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'أفكار جميلة تساعدك على اختيار التفاصيل',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 9.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15.sp,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // Rating Card

  Widget _buildRatingCard() {
    return Container(
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 65.w,
            height: 65.w,
            decoration: BoxDecoration(
              color: AppColors.bluePale,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.primary,
              size: 34.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'خدمات تستحق التجربة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 15.sp,
                      color: const Color(0xFFE5A23C),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'اكتشفي الخدمات الأعلى تقييمًا',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 9.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  'اختاري ما يناسب مناسبتك وميزانيتك',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 9.sp,
                    color: AppColors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Empty Section

  Widget _buildEmptySection(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Plex',
          fontSize: 11.sp,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  // Main Button

  Widget _buildMainButton() {
    return SizedBox(
      height: 51.h,
      child: FilledButton.icon(
        onPressed: _openServices,
        icon: const Icon(Icons.grid_view_rounded),
        label: Text(
          'تصفّحي كل الخدمات',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
