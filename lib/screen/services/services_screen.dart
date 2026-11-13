import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/services/services_binding.dart';
import '../../controllers/services/services_controller.dart';
import '../../controllers/services/service_details_binding.dart';
import '../../data/models/home/home_response.dart';
import '../../utils/app_colors.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  final String? initialCategoryName;

  const ServicesScreen({super.key, this.initialCategoryName});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late final ServicesController controller;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ServicesController>()) {
      ServicesBinding().dependencies();
    }

    controller = Get.find<ServicesController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final category = widget.initialCategoryName;

      if (category != null) {
        controller.selectCategory(category);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilters() {
    const options = [
      'الأكثر طلبًا',
      'السعر: الأقل أولًا',
      'السعر: الأعلى أولًا',
      'الأقصر مدة',
      'الاسم',
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSubtle,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 18.h),
              ...options.map((option) {
                return Obx(() {
                  final selected = controller.selectedSort.value == option;

                  return InkWell(
                    onTap: () {
                      controller.selectSort(option);
                      Navigator.pop(sheetContext);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Plex',
                                fontSize: 13.sp,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),
            ],
          ),
        );
      },
    );
  }

  void _openService(HomeService service) {
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
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),

            SizedBox(height: 12.h),

            Obx(() {
              if (controller.isLoading.value && controller.services.isEmpty) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.services.isEmpty) {
                return Expanded(child: _buildErrorState());
              }

              return Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.fetchServices,
                  child: Column(
                    children: [
                      _buildCategoryFilters(),
                      Expanded(child: _buildServicesList()),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 18.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'الخدمات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Material(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(13.r),
            child: InkWell(
              onTap: _openFilters,
              borderRadius: BorderRadius.circular(13.r),
              child: SizedBox(
                width: 42.w,
                height: 44.h,
                child: Icon(
                  Icons.tune_rounded,
                  size: 21.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                onChanged: controller.search,
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحثي في الخدمات',
                  hintStyle: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 11.sp,
                    color: AppColors.textSubtle,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 21.sp,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 10.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Obx(() {
      final categories = controller.categories;

      return SizedBox(
        height: 48.h,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, _) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final category = categories[index];
            final selected = controller.selectedCategory.value == category;

            return ChoiceChip(
              label: Text(category),
              selected: selected,
              onSelected: (_) {
                controller.selectCategory(category);
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
              showCheckmark: false,
            );
          },
        ),
      );
    });
  }

  Widget _buildServicesList() {
    final services = controller.filteredServices;

    if (services.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: services.length,
      separatorBuilder: (_, _) => SizedBox(height: 9.h),
      itemBuilder: (context, index) {
        return _buildServiceCard(services[index]);
      },
    );
  }

  Widget _buildServiceCard(HomeService service) {
    return InkWell(
      onTap: () => _openService(service),
      borderRadius: BorderRadius.circular(17.r),
      child: Container(
        height: 105.h,
        padding: EdgeInsets.all(9.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(17.r),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.75)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.025),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: service.image != null && service.image!.isNotEmpty
                  ? Image.network(
                      service.image!,
                      width: 78.w,
                      height: 85.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),

            SizedBox(width: 11.w),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 9.sp,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Row(
                    children: [
                      _infoPill(
                        Icons.access_time_rounded,
                        service.durationLabel,
                      ),

                      const Spacer(),

                      Text(
                        '${service.finalPrice.toStringAsFixed(0)} ₪',
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
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

  Widget _imagePlaceholder() {
    return Container(
      width: 78.w,
      height: 85.h,
      color: AppColors.bluePale,
      child: Icon(
        Icons.celebration_rounded,
        size: 30.sp,
        color: AppColors.primary,
      ),
    );
  }

  Widget _infoPill(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: AppColors.textSecondary),
          SizedBox(width: 3.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 8.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 54.sp,
              color: AppColors.blueMedium,
            ),
            SizedBox(height: 14.h),
            Text(
              'ما لقينا خدمات مطابقة',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              'جرّبي اسمًا آخر أو غيّري التصنيف.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: () {
                _searchController.clear();
                controller.search('');
                controller.selectCategory('الكل');
              },
              child: const Text('عرض كل الخدمات'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 50.sp,
              color: AppColors.textSubtle,
            ),
            SizedBox(height: 12.h),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 15.h),
            FilledButton(
              onPressed: controller.fetchServices,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
