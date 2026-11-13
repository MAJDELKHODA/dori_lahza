import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/booking/booking_controller.dart';
import '../../data/models/booking/availability_day_model.dart';
import '../../utils/app_colors.dart';

import 'widgets/waitlist_bottom_sheet.dart';
import 'booking_confirm_screen.dart';

class AvailabilityScreen extends StatefulWidget {
  final int serviceId;

  const AvailabilityScreen({super.key, required this.serviceId});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  late final BookingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookingController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'حجز موعد',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 24.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.days.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.days.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value.isNotEmpty
                        ? controller.errorMessage.value
                        : 'لا توجد مواعيد متاحة',
                  ),
                  TextButton(
                    onPressed: controller.fetchAvailabilityDays,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final selectedDay = controller.selectedDay.value;

          if (selectedDay == null) {
            return const Center(child: Text('لا توجد أيام متاحة للحجز حاليًا'));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      _buildDays(),
                      SizedBox(height: 25.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: selectedDay.isAvailable
                            ? _buildAvailableContent(selectedDay)
                            : _buildUnavailableContent(),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomSection(selectedDay.isAvailable),
            ],
          );
        }),
      ),
    );
  }

  // ===========================
  // Days
  // ===========================

  Widget _buildDays() {
    return SizedBox(
      height: 92.h,
      child: Obx(() {
        final days = controller.days;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: days.length,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            final item = days[index];
            final selected = controller.selectedDay.value?.date == item.date;

            final dateNumber = item.date.split('-').last;

            return GestureDetector(
              onTap: () {
                controller.selectDay(item);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 72.w,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: selected
                      ? LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [AppColors.primary, AppColors.blueMedium],
                        )
                      : null,
                  color: selected ? null : AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: selected ? Colors.transparent : AppColors.border,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dateNumber,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: selected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      item.isAvailable ? '${item.slotsCount} أوقات' : 'ممتلئ',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 8.sp,
                        color: selected ? Colors.white70 : AppColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ===========================
  // Available
  // ===========================

  Widget _buildAvailableContent(AvailabilityDayModel day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'الأوقات المتاحة',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.bluePale.withOpacity(0.45),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${day.slotsCount} متاح',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 6.h),

        Text(
          'اختاري الموعد المناسب لكِ',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 11.sp,
            color: AppColors.textSubtle,
          ),
        ),

        SizedBox(height: 18.h),

        _buildTimeGrid(),

        Obx(() {
          if (controller.selectedSlot.value == null) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              SizedBox(height: 24.h),
              _buildStaffSelector(),
            ],
          );
        }),
      ],
    );
  }

  // ===========================
  // Times
  // ===========================

  Widget _buildTimeGrid() {
    return Obx(() {
      if (controller.isLoadingSlots.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.slotsError.value.isNotEmpty) {
        return Center(
          child: Column(
            children: [
              Text(controller.slotsError.value),
              TextButton(
                onPressed: () {
                  final day = controller.selectedDay.value;
                  if (day != null) {
                    controller.fetchAvailabilitySlots(day.date);
                  }
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }

      if (controller.slots.isEmpty) {
        return _buildUnavailableContent();
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.slots.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 11.h,
          childAspectRatio: 2.15,
        ),
        itemBuilder: (context, index) {
          final slot = controller.slots[index];

          final selected =
              controller.selectedSlot.value?.startsAt == slot.startsAt;

          return GestureDetector(
            onTap: () {
              controller.selectSlot(slot);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: selected
                    ? LinearGradient(
                        colors: [AppColors.primary, AppColors.blueMedium],
                      )
                    : null,
                color: selected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: selected ? Colors.transparent : AppColors.border,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selected) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 15.sp,
                      ),
                      SizedBox(width: 5.w),
                    ],
                    Text(
                      slot.time,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // ===========================
  // stafeeselector
  // ===========================

  Widget _buildStaffSelector() {
    return Obx(() {
      final slot = controller.selectedSlot.value;

      if (slot == null || slot.staff.isEmpty) {
        return const SizedBox.shrink();
      }

      final staff = slot.staff;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الموظف المتاح لهذا الموعد',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 7.h),

          Text(
            staff.length == 1
                ? 'الموظف المتاح لهذا الوقت'
                : 'اختاري الموظف المناسب لكِ',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 11.sp,
              color: AppColors.textSubtle,
            ),
          ),

          SizedBox(height: 13.h),

          ...staff.map((member) {
            final selected = controller.selectedStaffId.value == member.id;

            return Padding(
              padding: EdgeInsets.only(bottom: 9.h),
              child: InkWell(
                borderRadius: BorderRadius.circular(15.r),
                onTap: () {
                  controller.selectStaff(member.id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 13.h,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.bluePale.withValues(alpha: 0.5)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                      width: selected ? 1.4 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 19.r,
                        backgroundColor: AppColors.bluePale,
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 21.sp,
                        ),
                      ),

                      SizedBox(width: 11.w),

                      Expanded(
                        child: Text(
                          member.name,
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSubtle,
                        size: 21.sp,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  // ===========================
  // Unavailable
  // ===========================

  Widget _buildUnavailableContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 28.sp,
              color: AppColors.accent,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'مواعيد هذا اليوم ممتلئة',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 7.h),

          Text(
            'يمكنك اختيار يوم آخر أو الانضمام إلى قائمة الانتظار.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 11.sp,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 18.h),

          OutlinedButton.icon(
            onPressed: () {
              Get.bottomSheet(
                const WaitlistBottomSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withOpacity(0.45),
              );
            },
            icon: Icon(Icons.notifications_none_rounded, size: 19.sp),
            label: const Text('انضمي إلى قائمة الانتظار'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withOpacity(0.35)),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              textStyle: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================
  // Bottom Button
  // ===========================

  Widget _buildBottomSection(bool isAvailable) {
    final selectedDay = controller.selectedDay.value;
    final selectedSlot = controller.selectedSlot.value;

    if (!isAvailable ||
        selectedDay == null ||
        selectedSlot == null ||
        (selectedSlot.staff.isNotEmpty &&
            controller.selectedStaffId.value == null)) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'موعدك',
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 9.sp,
                      color: AppColors.textSubtle,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    '${selectedDay.label} • ${selectedSlot.time}',
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 14.w),

            SizedBox(
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  final slot = controller.selectedSlot.value;
                  final day = controller.selectedDay.value;

                  if (slot == null || day == null) return;

                  Get.to(
                    () => BookingConfirmScreen(
                      serviceId: widget.serviceId,
                      startsAt: slot.startsAt,
                      staffId: controller.selectedStaffId.value,
                      selectedDate: day.date,
                      selectedDayLabel: day.label,
                      selectedTime: slot.time,
                    ),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'تأكيد الموعد',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
