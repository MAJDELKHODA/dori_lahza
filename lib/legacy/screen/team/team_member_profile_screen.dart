import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/team/team_controller.dart';
import '../../data/models/team/team_member_model.dart';
import '../../utils/app_colors.dart';

class TeamMemberProfileScreen extends StatelessWidget {
  final int staffId;

  const TeamMemberProfileScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ملف الفريق',
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
        child: Obx(() {
          final member = controller.getMemberById(staffId);

          if (controller.isLoading.value && member == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (member == null) {
            return _buildErrorState(controller);
          }

          return _buildProfile(member);
        }),
      ),
    );
  }

  // Error State

  Widget _buildErrorState(TeamController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 55.sp,
              color: AppColors.textSubtle,
            ),
            SizedBox(height: 15.h),
            Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'لم يتم العثور على بيانات العضو',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plex',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton.icon(
              onPressed: controller.fetchTeamMembers,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Content

  Widget _buildProfile(TeamMemberModel member) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileHeader(member),

          SizedBox(height: 26.h),

          _buildSectionTitle('نبذة'),

          SizedBox(height: 10.h),

          _buildBio(member),

          SizedBox(height: 28.h),

          _buildSectionTitle('ساعات العمل'),

          SizedBox(height: 12.h),

          _buildWorkingHoursCard(member),
        ],
      ),
    );
  }

  // Profile Header

  Widget _buildProfileHeader(TeamMemberModel member) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48.r,
          backgroundColor: AppColors.primary,
          backgroundImage: member.avatar != null && member.avatar!.isNotEmpty
              ? NetworkImage(member.avatar!)
              : null,
          child: member.avatar == null || member.avatar!.isEmpty
              ? Text(
                  member.initials.isNotEmpty ? member.initials : '؟',
                  style: TextStyle(
                    fontFamily: 'Plex',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                )
              : null,
        ),

        SizedBox(height: 14.h),

        Text(
          member.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 21.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: 5.h),

        Text(
          member.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),

        SizedBox(height: 12.h),

        _buildRating(member),
      ],
    );
  }

  // Rating

  Widget _buildRating(TeamMemberModel member) {
    if (member.ratingCount == 0) {
      return Text(
        'لا توجد تقييمات بعد',
        style: TextStyle(
          fontFamily: 'Plex',
          fontSize: 11.sp,
          color: AppColors.textSubtle,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          member.ratingAverage.toStringAsFixed(1),
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 6.w),
        ...List.generate(
          5,
          (index) => Icon(
            Icons.star_rounded,
            size: 17.sp,
            color: const Color(0xFFE5A23C),
          ),
        ),
        SizedBox(width: 7.w),
        Text(
          '(${member.ratingCount})',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 10.sp,
            color: AppColors.textSubtle,
          ),
        ),
      ],
    );
  }

  // Biography

  Widget _buildBio(TeamMemberModel member) {
    return Text(
      member.bio.isNotEmpty ? member.bio : 'لا توجد نبذة تعريفية متاحة حاليًا.',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: 'Plex',
        fontSize: 13.sp,
        height: 1.8,
        color: AppColors.textSecondary,
      ),
    );
  }

  // Section Title

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 19.h,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // Working Hours

  Widget _buildWorkingHoursCard(TeamMemberModel member) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: member.hours.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'لا توجد ساعات عمل متاحة حاليًا',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plex',
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : Column(
              children: List.generate(member.hours.length, (index) {
                final hour = member.hours[index];

                final isClosed = !hour.isOpen || hour.ranges.isEmpty;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == member.hours.length - 1 ? 0 : 16.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          hour.label,
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          isClosed ? 'مغلق' : hour.ranges.join(' • '),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: 'Plex',
                            fontSize: 11.sp,
                            fontWeight: isClosed
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isClosed
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}
