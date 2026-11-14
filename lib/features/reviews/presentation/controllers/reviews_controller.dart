import 'dart:async';

import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/state/paged_controller.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/features/reviews/domain/usecases/reviews_usecases.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';
import 'package:get/get.dart';

/// Paged reviews of the place or of one service, with the rating summary
/// from `meta`. Place reviews can be filtered by star.
class ReviewsController extends PagedController<Review> {
  ReviewsController({required ReviewsTarget target, required GetReviews getReviews})
      : _baseTarget = target,
        _getReviews = getReviews;

  final ReviewsTarget _baseTarget;
  final GetReviews _getReviews;

  final summary = const RatingSummary().obs;
  final distribution = <int, int>{}.obs;
  final starFilter = RxnInt();

  bool get canFilterByStar => _baseTarget is PlaceReviewsTarget;

  ReviewsTarget get _target => switch (_baseTarget) {
        PlaceReviewsTarget(:final staffId) => PlaceReviewsTarget(rating: starFilter.value, staffId: staffId),
        final other => other,
      };

  @override
  Future<Result<Paginated<Review>>> fetchPage(int page) async {
    final result = await _getReviews(GetReviewsParams(_target, page: page));
    return result.map((data) {
      // Keep the overall summary while a star filter is applied.
      if (page == 1 && starFilter.value == null) {
        summary.value = data.summary;
        distribution.assignAll(data.distribution);
      }
      return data.page;
    });
  }

  void filterByStar(int? star) {
    if (!canFilterByStar || starFilter.value == star) return;
    starFilter.value = star;
    unawaited(refreshList());
  }
}
