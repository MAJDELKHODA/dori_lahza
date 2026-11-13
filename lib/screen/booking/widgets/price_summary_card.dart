import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';

class PriceSummaryCard extends StatelessWidget {
  final double price;
  final double discount;
  final double total;

  const PriceSummaryCard({
    super.key,
    required this.price,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _buildPriceRow('السعر', '${price.toStringAsFixed(0)} ₪'),

          SizedBox(height: 10.h),

          _buildPriceRow(
            'الخصم',
            '-${discount.toStringAsFixed(0)} ₪',
            color: AppColors.success,
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1.h, color: AppColors.border),
          ),

          Row(
            children: [
              Text(
                'الإجمالي',
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              const Spacer(),

              Text(
                '${total.toStringAsFixed(0)} ₪',
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
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? color}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 11.sp,
            color: AppColors.textSecondary,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
