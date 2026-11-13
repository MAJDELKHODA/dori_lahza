import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      title: 'تم تأكيد حجزك',
      message: 'موعدك القادم لتنسيق الحفلات يوم الخميس، الساعة 4:30 م.',
      time: 'منذ 5 دقائق',
      icon: Icons.event_available_rounded,
      isRead: false,
    ),
    _NotificationItem(
      title: 'وصلك عرض من قائمة الانتظار',
      message: 'أصبح هناك موعد متاح يناسب طلبك. تحققي من التفاصيل.',
      time: 'منذ 12 ساعة',
      icon: Icons.notifications_active_rounded,
      isRead: false,
    ),
    _NotificationItem(
      title: 'جاء دورك!',
      message: 'أنتِ الآن ضمن الأدوار المتاحة. تفقدي قائمة الانتظار.',
      time: 'قبل يومين',
      icon: Icons.hourglass_bottom_rounded,
      isRead: true,
    ),
    _NotificationItem(
      title: 'شكرًا لزيارتك',
      message: 'نتمنى أن تكون تجربتك جميلة. شاركينا رأيك بالتقييم.',
      time: 'قبل 3 أيام',
      icon: Icons.favorite_rounded,
      isRead: true,
    ),
    _NotificationItem(
      title: 'تذكير بموعدك',
      message: 'نذكّرك بموعدك القادم. نتمنى لكِ تجربة رائعة.',
      time: 'قبل 4 أيام',
      icon: Icons.alarm_rounded,
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((item) => !item.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification.isRead = true;
      }
    });

    Get.snackbar(
      'تم التحديث',
      'تم تعليم جميع الإشعارات كمقروءة.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: EdgeInsets.all(14.r),
    );
  }

  void _openNotification(_NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    Get.snackbar(
      notification.title,
      notification.message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: EdgeInsets.all(14.r),
      duration: const Duration(seconds: 3),
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
            size: 23.sp,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'الإشعارات',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 19.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (_unreadCount > 0)
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: TextButton(
                onPressed: _markAllAsRead,
                child: Text(
                  'تعليم الكل كمقروء',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _notifications.isEmpty
            ? _buildEmptyState()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummary(),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];

                        return _buildNotificationCard(notification);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 10.h),
      child: Row(
        children: [
          Container(
            width: 43.w,
            height: 43.w,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
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
                  'كل جديد في لحظة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  _unreadCount == 0
                      ? 'أنتِ مطّلعة على كل إشعاراتك'
                      : 'لديكِ $_unreadCount إشعارات غير مقروءة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(_NotificationItem notification) {
    return Material(
      color: notification.isRead
          ? AppColors.surface
          : AppColors.accentLight.withOpacity(0.65),
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: () => _openNotification(notification),
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.border.withOpacity(0.6)
                  : AppColors.accent.withOpacity(0.12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 39.w,
                height: 39.w,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  notification.icon,
                  size: 21.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 10.sp,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 9.h),
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 9.sp,
                        color: AppColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 7.w),
              if (!notification.isRead)
                Container(
                  width: 7.w,
                  height: 7.w,
                  margin: EdgeInsets.only(top: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84.w,
              height: 84.w,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 37.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'لا توجد إشعارات حتى الآن',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'ستصلكِ هنا تحديثات حجوزاتك وكل جديد يخص مناسباتك.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 11.sp,
                height: 1.7,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  bool isRead;

  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.isRead,
  });
}
