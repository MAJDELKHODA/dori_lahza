import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class ServiceReviewsScreen extends StatelessWidget {
  const ServiceReviewsScreen({super.key});

  static const List<Map<String, dynamic>> _reviews = [
    {
      'name': 'سارة أحمد',
      'initial': 'س',
      'time': 'قبل يومين',
      'rating': 5.0,
      'comment':
          'التنسيق كان جميل جدًا وكل التفاصيل كانت مرتبة مثل ما طلبت تمامًا. التجربة كانت مريحة من البداية للنهاية.',
      'reply':
          'شكرًا إلك سارة، سعدنا كثيرًا إن لحظتك كانت مميزة ونتمنى نشوفك بمناسبات أجمل.',
    },
    {
      'name': 'هبة خالد',
      'initial': 'هـ',
      'time': 'قبل 5 أيام',
      'rating': 5.0,
      'comment':
          'الديكور كان أنيق جدًا والألوان متناسقة، وفريق العمل كان متعاون وسريع.',
      'reply': null,
    },
    {
      'name': 'ميس يوسف',
      'initial': 'م',
      'time': 'قبل أسبوع',
      'rating': 4.0,
      'comment':
          'الخدمة ممتازة والنتيجة جميلة جدًا، فقط كنت أتمنى أن يبدأ التجهيز قبل الموعد بوقت أكبر.',
      'reply':
          'نعتذر عن التأخير البسيط، وشكرًا لملاحظتك وسنعمل على تحسين تجربة المواعيد.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تقييمات الخدمة',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 23.sp,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 24.h),
          children: [
            Text(
              'تقييمات: تنسيق وديكور المناسبات',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 18.h),

            ..._reviews.map(
              (review) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: _buildReviewCard(review),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final double rating = review['rating'] as double;
    final String? reply = review['reply'] as String?;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(review),

          SizedBox(height: 13.h),

          _buildRating(rating),

          SizedBox(height: 14.h),

          Text(
            review['comment'],
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 12.sp,
              height: 1.7,
              color: AppColors.textSecondary,
            ),
          ),

          if (reply != null) ...[
            SizedBox(height: 14.h),
            _buildProviderReply(reply),
          ],
        ],
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> review) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.primary,
          child: Text(
            review['initial'],
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review['name'],
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                review['time'],
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 10.sp,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(width: 8.w),

        ...List.generate(5, (index) {
          final bool isFilled = index < rating.round();

          return Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_border_rounded,
              size: 17.sp,
              color: const Color(0xFFE5A23C),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProviderReply(String reply) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.reply_rounded, size: 18.sp, color: AppColors.primary),

          SizedBox(width: 8.w),

          Expanded(
            child: Text(
              reply,
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
}
