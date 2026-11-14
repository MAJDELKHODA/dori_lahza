import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';

abstract interface class ReviewsRepository {
  Future<Result<ReviewsPage>> placeReviews({required int page, int? rating, int? staffId});

  Future<Result<ReviewsPage>> serviceReviews(int serviceId, {required int page});
}
