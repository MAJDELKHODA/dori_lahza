import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class BookingReviewBottomSheet extends StatefulWidget {
  const BookingReviewBottomSheet({super.key});

  @override
  State<BookingReviewBottomSheet> createState() =>
      _BookingReviewBottomSheetState();
}

class _BookingReviewBottomSheetState extends State<BookingReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();

  int _selectedRating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 22.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),

            SizedBox(height: 18.h),

            Text(
              'كيف كانت تجربتك؟',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 18.h),

            _buildStars(),

            SizedBox(height: 20.h),

            _buildReviewField(),

            SizedBox(height: 18.h),

            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 42.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.textSubtle.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final selected = starValue <= _selectedRating;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = starValue;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 180),
              scale: selected ? 1.12 : 1,
              child: Icon(
                selected ? Icons.star_rounded : Icons.star_border_rounded,
                size: 34.sp,
                color: const Color(0xFFE5A23C),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReviewField() {
    return TextField(
      controller: _reviewController,
      minLines: 3,
      maxLines: 5,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 12.sp,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'شاركونا رأيكِ (اختياري)',
        hintStyle: TextStyle(
          fontFamily: 'Plex',
          fontSize: 11.sp,
          color: AppColors.textSubtle,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: EdgeInsets.all(14.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final bool canSubmit = _selectedRating > 0;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: canSubmit
            ? () {
                Get.back(
                  result: {
                    'rating': _selectedRating,
                    'review': _reviewController.text.trim(),
                  },
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textSubtle,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          'إرسال التقييم',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
