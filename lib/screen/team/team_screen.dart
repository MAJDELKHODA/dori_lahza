import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/team/team_controller.dart';
import '../../data/models/team/team_member_model.dart';
import '../../utils/app_colors.dart';
import 'team_member_profile_screen.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

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
          'الفريق',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.members.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.members.isEmpty) {
            return _buildEmptyState(controller);
          }

          return RefreshIndicator(
            onRefresh: controller.fetchTeamMembers,
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 24.h),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.members.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final member = controller.members[index];

                return _buildTeamCard(member);
              },
            ),
          );
        }),
      ),
    );
  }

  // Team Card

  Widget _buildTeamCard(TeamMemberModel member) {
    return InkWell(
      onTap: () {
        Get.to(
          () => TeamMemberProfileScreen(staffId: member.id),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: _memberColor(member.color),
              backgroundImage:
                  member.avatar != null && member.avatar!.isNotEmpty
                  ? NetworkImage(member.avatar!)
                  : null,
              child: member.avatar == null || member.avatar!.isEmpty
                  ? Text(
                      member.initials.isNotEmpty ? member.initials : '؟',
                      style: TextStyle(
                        fontFamily: 'Plex',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),

            SizedBox(width: 14.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    member.title,
                    style: TextStyle(
                      fontFamily: 'Plex',
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 7.h),

                  _buildRating(member),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 17.sp,
              color: AppColors.textSubtle,
            ),
          ],
        ),
      ),
    );
  }

  // Rating

  Widget _buildRating(TeamMemberModel member) {
    if (member.ratingCount == 0) {
      return Text(
        'لا توجد تقييمات بعد',
        style: TextStyle(
          fontFamily: 'Plex',
          fontSize: 9.sp,
          color: AppColors.textSubtle,
        ),
      );
    }

    return Row(
      children: [
        Text(
          member.ratingAverage.toStringAsFixed(1),
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(width: 5.w),

        Icon(Icons.star_rounded, size: 14.sp, color: const Color(0xFFE5A23C)),

        SizedBox(width: 6.w),

        Text(
          '(${member.ratingCount})',
          style: TextStyle(
            fontFamily: 'Plex',
            fontSize: 9.sp,
            color: AppColors.textSubtle,
          ),
        ),
      ],
    );
  }

  // Member Color

  Color _memberColor(String? color) {
    if (color == null || color.isEmpty) {
      return AppColors.primary;
    }

    try {
      final hex = color.replaceFirst('#', '');

      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  // Empty And Error State

  Widget _buildEmptyState(TeamController controller) {
    final hasError = controller.errorMessage.value.isNotEmpty;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasError ? Icons.cloud_off_rounded : Icons.groups_outlined,
              size: 55.sp,
              color: AppColors.textSubtle,
            ),

            SizedBox(height: 15.h),

            Text(
              hasError
                  ? controller.errorMessage.value
                  : 'لا يوجد أعضاء فريق حاليًا',
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
}
