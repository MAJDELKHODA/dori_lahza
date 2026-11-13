import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class RescheduleBookingScreen extends StatefulWidget {
  const RescheduleBookingScreen({super.key});

  @override
  State<RescheduleBookingScreen> createState() =>
      _RescheduleBookingScreenState();
}

class _RescheduleBookingScreenState extends State<RescheduleBookingScreen> {
  int _selectedDayIndex = 0;
  int? _selectedTimeIndex;

  final List<_DayOption> _days = [
    _DayOption(dayName: 'الثلاثاء', dayNumber: '27', month: 'أكتوبر'),
    _DayOption(dayName: 'الأربعاء', dayNumber: '28', month: 'أكتوبر'),
    _DayOption(dayName: 'الخميس', dayNumber: '29', month: 'أكتوبر'),
    _DayOption(dayName: 'الجمعة', dayNumber: '30', month: 'أكتوبر'),
    _DayOption(dayName: 'السبت', dayNumber: '31', month: 'أكتوبر'),
  ];

  final List<String> _availableTimes = const [
    '10:00 ص',
    '11:30 ص',
    '1:00 م',
    '3:00 م',
    '4:30 م',
    '6:00 م',
  ];

  void _confirmReschedule() {
    if (_selectedTimeIndex == null) {
      Get.snackbar(
        'اختاري الوقت',
        'يرجى اختيار الموعد الجديد أولًا.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.textPrimary,
        margin: EdgeInsets.all(16.r),
      );
      return;
    }

    final day = _days[_selectedDayIndex];
    final time = _availableTimes[_selectedTimeIndex!];

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
        ),
        title: Text(
          'تأكيد تعديل الموعد',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'هل تريدين تعديل موعدك إلى يوم ${day.dayName} ${day.dayNumber} أكتوبر، الساعة $time؟',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            height: 1.7,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'رجوع',
              style: TextStyle(
                fontFamily: 'Plex',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();

              Get.back(
                result: <String, String>{
                  'date': '${day.dayName} ${day.dayNumber} ${day.month}',
                  'time': time,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text(
              'تأكيد التعديل',
              style: TextStyle(
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
            color: AppColors.textPrimary,
            size: 23.sp,
          ),
        ),
        title: Text(
          'تعديل الموعد',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 19.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentBookingCard(),

                    SizedBox(height: 25.h),

                    _buildSectionTitle('اختاري اليوم الجديد'),

                    SizedBox(height: 14.h),

                    _buildDaySelector(),

                    SizedBox(height: 26.h),

                    _buildSectionTitle('الأوقات المتاحة'),

                    SizedBox(height: 14.h),

                    _buildTimeSelector(),

                    SizedBox(height: 18.h),

                    _buildNote(),
                  ],
                ),
              ),
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBookingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43.w,
                height: 43.w,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  Icons.event_note_rounded,
                  color: AppColors.primary,
                  size: 23.sp,
                ),
              ),

              SizedBox(width: 11.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الحجز الحالي',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      'تنسيق وديكور المناسبات',
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
            ],
          ),

          SizedBox(height: 15.h),

          Divider(color: AppColors.border),

          SizedBox(height: 8.h),

          _buildCurrentInfo(
            Icons.calendar_month_rounded,
            'الموعد الحالي',
            'الخميس 23 أكتوبر • 4:30 م',
          ),

          SizedBox(height: 12.h),

          _buildCurrentInfo(
            Icons.confirmation_number_outlined,
            'رقم الحجز',
            'LHZ-24817',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 17.sp, color: AppColors.primary),

        SizedBox(width: 8.w),

        Text(
          '$label:',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 10.sp,
            color: AppColors.textSecondary,
          ),
        ),

        SizedBox(width: 6.w),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        separatorBuilder: (_, __) => SizedBox(width: 9.w),
        itemBuilder: (context, index) {
          final day = _days[index];
          final selected = index == _selectedDayIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
                _selectedTimeIndex = null;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 65.w,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.dayName,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    day.dayNumber,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    day.month,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 8.sp,
                      color: selected
                          ? Colors.white.withOpacity(0.85)
                          : AppColors.textSubtle,
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

  Widget _buildTimeSelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _availableTimes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 9.w,
        mainAxisSpacing: 10.h,
        mainAxisExtent: 43.h,
      ),
      itemBuilder: (context, index) {
        final selected = index == _selectedTimeIndex;
        final time = _availableTimes[index];

        return InkWell(
          onTap: () {
            setState(() {
              _selectedTimeIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(13.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNote() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.accentLight.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18.sp,
            color: AppColors.primary,
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Text(
              'سيتم التحقق من توفر الموعد الجديد قبل اعتماد التعديل.',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 51.h,
          child: ElevatedButton(
            onPressed: _confirmReschedule,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'تأكيد تعديل الموعد',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DayOption {
  final String dayName;
  final String dayNumber;
  final String month;

  const _DayOption({
    required this.dayName,
    required this.dayNumber,
    required this.month,
  });
}
