import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/services/service_details_controller.dart';
import '../../data/models/service/service_details_model.dart';
import '../../utils/app_colors.dart';
import '../booking/availability_screen.dart';
import '../reviews/service_reviews_screen.dart';
import '../../controllers/booking/booking_binding.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final int serviceId;

  const ServiceDetailsScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceDetailsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final service = controller.service.value;

          if (controller.isLoading.value && service == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (service == null) {
            return _buildError(controller);
          }

          return Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeroImage(service)),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(18.w, 17.h, 18.w, 110.h),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildTitleAndPrice(service),
                        SizedBox(height: 17.h),
                        _buildDescription(service),
                        SizedBox(height: 18.h),
                        _buildFeatures(service),
                        SizedBox(height: 22.h),
                        _buildProvider(service),
                        SizedBox(height: 24.h),
                        if (service.related.isNotEmpty) ...[
                          _buildSectionTitle('قد يعجبك أيضًا'),
                          SizedBox(height: 13.h),
                          _buildRelatedServices(service),
                        ],
                        SizedBox(height: 15.h),
                      ]),
                    ),
                  ),
                ],
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBookingBar(service),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Error State

  Widget _buildError(ServiceDetailsController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 50.sp,
              color: AppColors.textSubtle,
            ),
            SizedBox(height: 14.h),
            Text(
              controller.errorMessage.value.isEmpty
                  ? 'تعذر تحميل تفاصيل الخدمة'
                  : controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: controller.fetchServiceDetails,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  // Hero Image

  Widget _buildHeroImage(ServiceDetailsModel service) {
    final images = service.images
        .map((image) => image.url)
        .where((url) => url.isNotEmpty)
        .toList();

    if (images.isEmpty && service.image != null && service.image!.isNotEmpty) {
      images.add(service.image!);
    }

    return SizedBox(
      height: 225.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (images.isNotEmpty)
            PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _imagePlaceholder(),
                );
              },
            )
          else
            _imagePlaceholder(),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 75.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.textPrimary.withValues(alpha: 0.28),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 10.h,
            right: 15.w,
            child: _roundIconButton(Icons.favorite_border_rounded, () {
              Get.snackbar(
                'المفضلة',
                'سنربط المفضلة لاحقًا.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }),
          ),

          Positioned(
            top: 10.h,
            left: 15.w,
            child: _roundIconButton(
              Icons.arrow_forward_rounded,
              () => Get.back(),
            ),
          ),

          Positioned(
            bottom: 14.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => const ServiceReviewsScreen(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFE5A23C),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${service.ratingAverage.toStringAsFixed(1)} '
                      '(${service.ratingCount} تقييم)',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
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

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.bluePale,
      child: Icon(
        Icons.spa_rounded,
        size: 95.sp,
        color: AppColors.primary.withValues(alpha: 0.35),
      ),
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 39.w,
          height: 39.w,
          child: Icon(icon, size: 21.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  // Title And Price

  Widget _buildTitleAndPrice(ServiceDetailsModel service) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.name,
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 15.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    service.durationLabel,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                service.categoryName,
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 10.sp,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'السعر',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                color: AppColors.textSubtle,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${service.finalPrice.toStringAsFixed(0)} ₪',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            if (service.salePrice != null)
              Text(
                '${service.price.toStringAsFixed(0)} ₪',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 10.sp,
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.textSubtle,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Description

  Widget _buildDescription(ServiceDetailsModel service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('عن الخدمة'),
        SizedBox(height: 9.h),
        Text(
          service.description,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            height: 1.8,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // Features

  Widget _buildFeatures(ServiceDetailsModel service) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('تفاصيل الخدمة'),
          SizedBox(height: 12.h),
          _featureRow(
            Icons.schedule_rounded,
            'مدة الخدمة: ${service.durationLabel}',
          ),
          _featureRow(
            Icons.groups_rounded,
            'عدد مقدمي الخدمة: ${service.staff.length}',
          ),
          _featureRow(
            Icons.event_available_rounded,
            service.isGroup ? 'خدمة جماعية' : 'حجز فردي',
          ),
          _featureRow(
            Icons.confirmation_number_outlined,
            'السعة: ${service.capacity}',
          ),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 17.sp, color: AppColors.primary),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Service Providers

  Widget _buildProvider(ServiceDetailsModel service) {
    return Container(
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        color: AppColors.bluePale.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('مقدمو الخدمة'),
          SizedBox(height: 13.h),

          if (service.staff.isEmpty)
            Text(
              'لا يوجد مقدمو خدمة محددون',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ),

          ...service.staff.map(
            (member) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.surface,
                    backgroundImage:
                        member.avatar != null && member.avatar!.isNotEmpty
                        ? NetworkImage(member.avatar!)
                        : null,
                    child: member.avatar == null || member.avatar!.isEmpty
                        ? Icon(Icons.person_rounded, color: AppColors.primary)
                        : null,
                  ),
                  SizedBox(width: 11.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          member.title,
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Title

  Widget _buildSectionTitle(String title) {
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
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // Related Services

  Widget _buildRelatedServices(ServiceDetailsModel service) {
    return SizedBox(
      height: 165.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: service.related.length,
        separatorBuilder: (context, index) {
          return SizedBox(width: 12.w);
        },
        itemBuilder: (context, index) {
          final item = service.related[index];

          return Container(
            width: 145.w,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: item.image != null && item.image!.isNotEmpty
                        ? Image.network(
                            item.image!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) {
                              return _imagePlaceholder();
                            },
                          )
                        : _imagePlaceholder(),
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${item.finalPrice.toStringAsFixed(0)} ₪',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Booking Bar

  Widget _buildBookingBar(ServiceDetailsModel service) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 14.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: FilledButton.icon(
                  onPressed: () {
                    Get.to(
                      () => AvailabilityScreen(serviceId: service.id),
                      binding: BookingBinding(serviceId: service.id),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  icon: Icon(Icons.calendar_month_rounded, size: 19.sp),
                  label: Text(
                    'احجزي الآن',
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'السعر الإجمالي',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    color: AppColors.textSubtle,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${service.finalPrice.toStringAsFixed(0)} ₪',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
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
