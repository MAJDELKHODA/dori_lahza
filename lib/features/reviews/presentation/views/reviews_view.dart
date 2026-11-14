import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/core/widgets/paged_list_view.dart';
import 'package:dori_lahza/core/widgets/skeleton.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/features/reviews/presentation/controllers/reviews_controller.dart';
import 'package:dori_lahza/features/reviews/presentation/widgets/review_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Place or service reviews (decided by the route argument).
class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final header = Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RatingSummaryCard(
            summary: controller.summary.value,
            distribution: Map.of(controller.distribution),
            selectedStar: controller.starFilter.value,
            onStarTap: controller.canFilterByStar ? controller.filterByStar : null,
          ),
          if (controller.starFilter.value != null) ...[
            const VSpace(Gap.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: InputChip(
                label: Text('${controller.starFilter.value} نجوم فقط'),
                onDeleted: () => controller.filterByStar(null),
              ),
            ),
          ],
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('التقييمات')),
      body: PagedListView<Review>(
        controller: controller,
        header: header,
        loading: Skeleton(
          child: ListView(
            padding: const EdgeInsets.all(Gap.page),
            children: const [
              SkeletonBox(height: 130, radius: Radii.lg),
              VSpace(Gap.sm),
              SkeletonBox(height: 110, radius: Radii.lg),
              VSpace(Gap.sm),
              SkeletonBox(height: 110, radius: Radii.lg),
            ],
          ),
        ),
        empty: Obx(
          () => EmptyView(
            icon: Icons.rate_review_outlined,
            title: controller.starFilter.value == null ? 'لا توجد تقييمات بعد' : 'لا توجد تقييمات بهذا التصنيف',
            subtitle: controller.starFilter.value == null ? 'ستظهر هنا آراء العملاء بعد زياراتهم' : null,
          ),
        ),
        itemBuilder: (_, review) => ReviewCard(review: review),
      ),
      backgroundColor: context.palette.background,
    );
  }
}
