import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class PlaceReviewsScreen extends StatelessWidget {
  const PlaceReviewsScreen({super.key});

  static const List<Map<String, dynamic>> _reviews = [
    {
      'name': 'سارة أحمد',
      'initial': 'س',
      'time': 'قبل يومين',
      'rating': 5.0,
      'comment':
          'تجربة رائعة جدًا، التنسيق كان مرتب والمكان جميل وكل التفاصيل كانت مثل ما طلبنا.',
      'reply':
          'شكرًا إلك سارة، سعدنا كثيرًا إن مناسبتك كانت مميزة ونتمنى نشوفك بمناسبات أجمل.',
    },
    {
      'name': 'هبة خالد',
      'initial': 'هـ',
      'time': 'قبل 5 أيام',
      'rating': 5.0,
      'comment':
          'الخدمة ممتازة والفريق كان متعاون جدًا، وكل شيء كان جاهز قبل الموعد.',
      'reply': null,
    },
    {
      'name': 'ميس يوسف',
      'initial': 'م',
      'time': 'قبل أسبوع',
      'rating': 4.0,
      'comment':
          'الخدمة ممتازة والنتيجة حلوة، لكن التأخير كان أكثر شوي من المتوقع.',
      'reply':
          'نعتذر عن التأخير، وشكرًا لملاحظتك وسنعمل على تحسين الالتزام بالمواعيد.',
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
          'آراء العملاء',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 19.sp,
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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 28.h),
          children: [
            _buildSummaryCard(),

            SizedBox(height: 26.h),

            _buildSectionHeader(),

            SizedBox(height: 14.h),

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

  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.bluePale.withOpacity(0.65), AppColors.accentLight],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.surface.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Average rating
              Container(
                width: 115.w,
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 37.sp,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 9.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (_) => Icon(
                          Icons.star_rounded,
                          size: 15.sp,
                          color: const Color(0xFFE5A23C),
                        ),
                      ),
                    ),

                    SizedBox(height: 7.h),

                    Text(
                      '326 تقييم',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 17.w),

              // Rating distribution
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 248, 0.78),
                    _buildRatingBar(4, 52, 0.42),
                    _buildRatingBar(3, 16, 0.18),
                    _buildRatingBar(2, 6, 0.08),
                    _buildRatingBar(1, 4, 0.05),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count, double value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 26.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$stars',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.star_rounded,
                  size: 10.sp,
                  color: const Color(0xFFE5A23C),
                ),
              ],
            ),
          ),

          SizedBox(width: 5.w),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 7.h,
                backgroundColor: Colors.white.withOpacity(0.72),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary.withOpacity(0.78),
                ),
              ),
            ),
          ),

          SizedBox(width: 7.w),

          SizedBox(
            width: 26.w,
            child: Text(
              '$count',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 9.sp,
                color: AppColors.textSubtle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: Text(
            'تجارب العملاء',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.bluePale.withOpacity(0.55),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '326 رأي',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final double rating = review['rating'] as double;
    final String? reply = review['reply'] as String?;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border.withOpacity(0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.035),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewHeader(review, rating),

          SizedBox(height: 15.h),

          Text(
            review['comment'],
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 12.sp,
              height: 1.75,
              color: AppColors.textSecondary,
            ),
          ),

          if (reply != null) ...[SizedBox(height: 16.h), _buildReply(reply)],
        ],
      ),
    );
  }

  Widget _buildReviewHeader(Map<String, dynamic> review, double rating) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 47.w,
          height: 47.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.primary, AppColors.blueMedium],
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            review['initial'],
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
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
                  fontWeight: FontWeight.w800,
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

        _buildRatingBadge(rating),
      ],
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14.sp, color: const Color(0xFFE5A23C)),

          SizedBox(width: 4.w),

          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReply(String reply) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(
              Icons.reply_rounded,
              size: 17.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رد مزوّد الخدمة',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  reply,
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 11.sp,
                    height: 1.6,
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
}
