import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/features/reviews/domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  const ReviewsRepositoryImpl(this._remote);

  final ReviewsRemoteDataSource _remote;

  @override
  Future<Result<ReviewsPage>> placeReviews({required int page, int? rating, int? staffId}) =>
      guard(() => _remote.placeReviews(page: page, rating: rating, staffId: staffId));

  @override
  Future<Result<ReviewsPage>> serviceReviews(int serviceId, {required int page}) =>
      guard(() => _remote.serviceReviews(serviceId, page: page));
}
