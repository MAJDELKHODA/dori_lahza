import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class WaitlistBottomSheet extends StatefulWidget {
  const WaitlistBottomSheet({super.key});

  @override
  State<WaitlistBottomSheet> createState() => _WaitlistBottomSheetState();
}

class _WaitlistBottomSheetState extends State<WaitlistBottomSheet> {
  final TextEditingController _notesController = TextEditingController();

  String _fromTime = '16:00';
  String _toTime = '20:00';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 22.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(),

            SizedBox(height: 18.h),

            _buildHeader(),

            SizedBox(height: 8.h),

            _buildDescription(),

            SizedBox(height: 22.h),

            _buildSectionTitle('النطاق الزمني المفضّل'),

            SizedBox(height: 12.h),

            _buildTimeRange(),

            SizedBox(height: 16.h),

            _buildNotesField(),

            SizedBox(height: 20.h),

            _buildJoinButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 42.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.textSubtle.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.notifications_active_outlined,
            size: 21.sp,
            color: AppColors.accent,
          ),
        ),

        SizedBox(width: 11.w),

        Expanded(
          child: Text(
            'قائمة الانتظار الذكية',
            style: TextStyle(
              fontFamily: 'Plex',
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      'إذا أصبح موعد متاحًا ضمن الوقت الذي تفضلينه، سنخبرك مباشرة.',
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 11.sp,
        height: 1.7,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTimeRange() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeSelector(
            label: 'من',
            time: _fromTime,
            onTap: () {
              _showTimePicker(
                currentTime: _fromTime,
                onSelected: (value) {
                  setState(() {
                    _fromTime = value;
                  });
                },
              );
            },
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: _buildTimeSelector(
            label: 'إلى',
            time: _toTime,
            onTap: () {
              _showTimePicker(
                currentTime: _toTime,
                onSelected: (value) {
                  setState(() {
                    _toTime = value;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.accent.withOpacity(0.45)),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule_rounded, size: 18.sp, color: AppColors.primary),

            SizedBox(width: 8.w),

            Text(
              '$label ',
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 10.sp,
                color: AppColors.textSubtle,
              ),
            ),

            Expanded(
              child: Text(
                time,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 2,
      textInputAction: TextInputAction.done,
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 12.sp,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'ملاحظات إضافية (اختياري)',
        hintStyle: TextStyle(
          fontFamily: 'Plex',
          fontSize: 11.sp,
          color: AppColors.textSubtle,
        ),
        prefixIcon: Icon(
          Icons.edit_note_rounded,
          size: 21.sp,
          color: AppColors.primary,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
          borderSide: BorderSide(color: AppColors.primary, width: 1.3),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: () {
          Get.back();

          Get.snackbar(
            'تم الانضمام',
            'سنخبرك فور توفر موعد مناسب.',
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16.r),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.r),
          ),
        ),
        child: Text(
          'انضمي لقائمة الانتظار',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker({
    required String currentTime,
    required ValueChanged<String> onSelected,
  }) async {
    final parts = currentTime.split(':');

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );

    if (picked == null) return;

    final hour = picked.hour.toString().padLeft(2, '0');
    final minute = picked.minute.toString().padLeft(2, '0');

    onSelected('$hour:$minute');
  }
}
