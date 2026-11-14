import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/features/reviews/data/models/review_model.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';

class ReviewsRemoteDataSource {
  const ReviewsRemoteDataSource(this._client);

  final DioClient _client;

  Future<ReviewsPage> placeReviews({required int page, int? rating, int? staffId}) async {
    final res = await _client.get(
      ApiEndpoints.placeReviews,
      query: {'page': page, 'rating': rating, 'staff_id': staffId},
    );
    return ReviewModel.pageFromResponse(res.data, res.meta);
  }

  Future<ReviewsPage> serviceReviews(int serviceId, {required int page}) async {
    final res = await _client.get(ApiEndpoints.serviceReviews(serviceId), query: {'page': page});
    return ReviewModel.pageFromResponse(res.data, res.meta);
  }
}
