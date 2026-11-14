import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/features/reviews/domain/repositories/reviews_repository.dart';

/// Which reviews to list: the whole place (optionally by star / staff) or one service.
sealed class ReviewsTarget {
  const ReviewsTarget();
}

final class PlaceReviewsTarget extends ReviewsTarget {
  const PlaceReviewsTarget({this.rating, this.staffId});
  final int? rating;
  final int? staffId;
}

final class ServiceReviewsTarget extends ReviewsTarget {
  const ServiceReviewsTarget(this.serviceId);
  final int serviceId;
}

class GetReviewsParams {
  const GetReviewsParams(this.target, {this.page = 1});
  final ReviewsTarget target;
  final int page;
}

class GetReviews implements UseCase<ReviewsPage, GetReviewsParams> {
  const GetReviews(this._repository);
  final ReviewsRepository _repository;

  @override
  Future<Result<ReviewsPage>> call(GetReviewsParams p) => switch (p.target) {
        PlaceReviewsTarget(:final rating, :final staffId) =>
          _repository.placeReviews(page: p.page, rating: rating, staffId: staffId),
        ServiceReviewsTarget(:final serviceId) => _repository.serviceReviews(serviceId, page: p.page),
      };
}
