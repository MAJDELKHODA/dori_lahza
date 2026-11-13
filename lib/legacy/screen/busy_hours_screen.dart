import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class BusyHoursScreen extends StatefulWidget {
  const BusyHoursScreen({super.key});

  @override
  State<BusyHoursScreen> createState() => _BusyHoursScreenState();
}

class _BusyHoursScreenState extends State<BusyHoursScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  int _selectedDayIndex = 0;

  final List<String> _hours = const [
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
  ];

  final List<Map<String, dynamic>> _weekData = const [
    {
      'day': 'السبت',
      'bestTime': '10:00 - 12:00 ص',
      'values': [1, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    },
    {
      'day': 'الأحد',
      'bestTime': '1:00 - 3:00 م',
      'values': [2, 2, 2, 1, 1, 2, 3, 4, 4, 5],
    },
    {
      'day': 'الإثنين',
      'bestTime': '10:00 - 12:00 ص',
      'values': [1, 1, 2, 2, 2, 3, 3, 4, 4, 4],
    },
    {
      'day': 'الثلاثاء',
      'bestTime': '12:00 - 2:00 م',
      'values': [2, 2, 2, 1, 1, 2, 3, 3, 4, 4],
    },
    {
      'day': 'الأربعاء',
      'bestTime': '10:00 - 11:00 ص',
      'values': [1, 2, 2, 2, 3, 3, 3, 4, 4, 5],
    },
    {
      'day': 'الخميس',
      'bestTime': '10:00 - 12:00 ص',
      'values': [2, 2, 3, 3, 3, 4, 4, 5, 5, 5],
    },
    {
      'day': 'الجمعة',
      'bestTime': 'مغلق',
      'values': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
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
    final selectedDay = _weekData[_selectedDayIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'أفضل وقت للزيارة',
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCurrentStatus(),

                  SizedBox(height: 24.h),

                  _buildSectionTitle(
                    'اختاري اليوم',
                    'شوفي الأوقات الأقل ازدحامًا',
                  ),

                  SizedBox(height: 13.h),

                  _buildDaysSelector(),

                  SizedBox(height: 18.h),

                  _buildSelectedDayCard(selectedDay),

                  SizedBox(height: 26.h),

                  _buildSectionTitle(
                    'خريطة الازدحام',
                    'مقارنة أسبوعية حسب الساعة',
                  ),

                  SizedBox(height: 14.h),

                  _buildHeatmapCard(),

                  SizedBox(height: 17.h),

                  _buildLegend(),

                  SizedBox(height: 22.h),

                  _buildTipCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStatus() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFFFFEFF4), AppColors.accentLight],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule_rounded,
              size: 24.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 13.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوضع الآن',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  'ازدحام متوسط',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  'الانتظار المتوقع حوالي 15 دقيقة',
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'متوسط',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),

        SizedBox(width: 9.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 3.h),

            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                color: AppColors.textSubtle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysSelector() {
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _weekData.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final selected = index == _selectedDayIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                _weekData[index]['day'],
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedDayCard(Map<String, dynamic> day) {
    final bool isClosed = day['bestTime'] == 'مغلق';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isClosed ? const Color(0xFFFFEEEE) : const Color(0xFFEAF7EF),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isClosed ? const Color(0xFFFFD7D7) : const Color(0xFFD4ECDD),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43.w,
            height: 43.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              isClosed ? Icons.event_busy_rounded : Icons.check_circle_rounded,
              color: isClosed
                  ? const Color(0xFFD95C5C)
                  : const Color(0xFF36A56D),
              size: 23.sp,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${day['day']}',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  isClosed
                      ? 'لا توجد مواعيد متاحة'
                      : 'أفضل وقت: ${day['bestTime']}',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: isClosed
                        ? const Color(0xFFD95C5C)
                        : const Color(0xFF2E7D57),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 18.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHoursHeader(),

          SizedBox(height: 13.h),

          ...List.generate(
            _weekData.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 9.h),
              child: _buildHeatmapRow(_weekData[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursHeader() {
    return Row(
      children: [
        SizedBox(width: 50.w),

        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _hours.map((hour) {
              return SizedBox(
                width: 20.w,
                child: Text(
                  hour,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSubtle,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapRow(Map<String, dynamic> dayData, int index) {
    final bool selected = index == _selectedDayIndex;
    final List<int> values = List<int>.from(dayData['values']);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.symmetric(
        horizontal: selected ? 5.w : 0,
        vertical: selected ? 5.h : 0,
      ),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.bluePale.withOpacity(0.25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50.w,
            child: Text(
              dayData['day'],
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: values.map((value) {
                return Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: _getHeatColor(value),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.border.withOpacity(0.65)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'هادئ',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(width: 8.w),

            ...[1, 2, 3, 4, 5].map(
              (value) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Container(
                  width: 21.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: _getHeatColor(value),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),

            SizedBox(width: 8.w),

            Text(
              'مزدحم',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.bluePale.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 20.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 11.w),

          Expanded(
            child: Text(
              'نصيحة لحظة: اختاري الوقت الأنسب لكِ؛ الأوقات الهادئة تعني انتظارًا أقل وتجربة أكثر سلاسة، بينما جودة الخدمة تبقى ثابتة في جميع الأوقات.',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getHeatColor(int level) {
    switch (level) {
      case 5:
        return const Color(0xFFF16464);

      case 4:
        return const Color(0xFFE39B82);

      case 3:
        return const Color(0xFFC8B29A);

      case 2:
        return const Color(0xFFB9C9A4);

      case 1:
        return const Color(0xFFA8DDB5);

      default:
        return const Color(0xFFF0E7EB);
    }
  }
}
