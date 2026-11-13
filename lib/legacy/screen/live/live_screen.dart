import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  bool _showMakeupOffer = true;
  bool _showFlowerOffer = true;

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
          'المباشر',
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
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('الدور الحي', Icons.bolt_rounded),

              SizedBox(height: 14.h),

              _buildQueueSummary(),

              SizedBox(height: 12.h),

              _buildCurrentTicket(),

              SizedBox(height: 28.h),

              _buildWaitlistHeader(),

              SizedBox(height: 14.h),

              if (_showMakeupOffer) ...[
                _buildMakeupOffer(),
                SizedBox(height: 12.h),
              ],

              if (_showFlowerOffer) _buildFlowerOffer(),

              if (!_showMakeupOffer && !_showFlowerOffer) _buildEmptyWaitlist(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
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
        Icon(icon, size: 21.sp, color: AppColors.primary),
      ],
    );
  }

  Widget _buildQueueSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStat(value: '25 د', label: 'الانتظار'),
              ),

              Container(width: 1, height: 35.h, color: AppColors.border),

              Expanded(
                child: _buildStat(value: '4', label: 'بالانتظار'),
              ),

              Container(width: 1, height: 35.h, color: AppColors.border),

              Expanded(
                child: _buildStat(value: 'A-12', label: 'تقدم الآن'),
              ),
            ],
          ),

          SizedBox(height: 13.h),

          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF35B77F),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'الدور مفتوح للاستقبال',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF35A875),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 9.sp,
            color: AppColors.textSubtle,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTicket() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Color(0xFF783B56), Color(0xFF96516B)],
        ),
        borderRadius: BorderRadius.circular(21.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2 قبلك',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  '~ 15 دقيقة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                SizedBox(height: 12.h),

                TextButton(
                  onPressed: _cancelCurrentTicket,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                  ),
                  child: Text(
                    'إلغاء رقمي',
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
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
                'رقمك',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 10.sp,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                'A-15',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 27.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _cancelCurrentTicket() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
        ),
        title: Text(
          'إلغاء الدور',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'هل تريدين إلغاء رقمك الحالي من قائمة الانتظار؟',
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
            onPressed: () {
              Get.back();
              _showMessage(
                'تم إلغاء الدور',
                'هذه عملية تجريبية، وسيتم ربطها بالنظام لاحقًا.',
              );
            },
            child: Text(
              'تأكيد الإلغاء',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitlistHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'قائمة الانتظار',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        IconButton(
          onPressed: () {
            setState(() {
              _showMakeupOffer = true;
              _showFlowerOffer = true;
            });

            _showMessage('تم التحديث', 'تم تحديث قائمة الانتظار التجريبية.');
          },
          icon: Icon(
            Icons.refresh_rounded,
            size: 22.sp,
            color: AppColors.textSecondary,
          ),
        ),

        Icon(
          Icons.notifications_active_rounded,
          size: 20.sp,
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildMakeupOffer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF35B77F), width: 1.3),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBadge(
                'وصلك عرض!',
                const Color(0xFFE1F4EB),
                const Color(0xFF299C75),
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'مكياج سهرة',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 7.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            'الجمعه 24 أكتوبر',
                            style: TextStyle(
                              fontFamily: 'Plex',
                              fontSize: 9.sp,
                              color: AppColors.textSubtle,
                            ),
                          ),
                        ),

                        SizedBox(width: 5.w),

                        Icon(
                          Icons.calendar_month_rounded,
                          size: 13.sp,
                          color: AppColors.textSubtle,
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      '16:00 - 20:00',
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

          SizedBox(height: 13.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7F1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 23.sp,
                  color: const Color(0xFF35A875),
                ),

                SizedBox(width: 9.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'وقت متاح: 6:30 م',
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      Text(
                        'ينتهي خلال 04:32',
                        style: TextStyle(
                          fontFamily: 'Plex',
                          fontSize: 9.sp,
                          color: const Color(0xFF35A875),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showMakeupOffer = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.border),
                    minimumSize: Size(double.infinity, 45.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                  ),
                  child: Text(
                    'تجاهل',
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 9.w),

              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    _showMessage(
                      'حجز الوقت المعروض',
                      'سنربط قبول العرض وتأكيد الموعد لاحقًا.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 45.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                  ),
                  child: Text(
                    'احجزي الوقت المعروض',
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlowerOffer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBadge(
                'في الانتظار',
                const Color(0xFFFFF0D8),
                const Color(0xFFE6A23C),
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تنسيق باقات',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'السبت 25 أكتوبر',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 9.sp,
                        color: AppColors.textSubtle,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      '16:00 - 20:00',
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

          SizedBox(height: 10.h),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text('مغادرة قائمة الانتظار'),
                    content: const Text(
                      'هل تريدين مغادرة قائمة الانتظار لهذه الخدمة؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('تراجع'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          setState(() {
                            _showFlowerOffer = false;
                          });
                        },
                        child: Text(
                          'مغادرة القائمة',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout_rounded, size: 17.sp),
              label: Text(
                'مغادرة القائمة',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color background, Color foreground) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWaitlist() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            size: 35.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'قائمة الانتظار فارغة',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'ستظهر هنا الخدمات التي تنضمين لقائمة انتظارها.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
