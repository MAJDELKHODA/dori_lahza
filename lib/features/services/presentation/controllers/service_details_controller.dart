import 'dart:async';

import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/features/reviews/domain/usecases/reviews_usecases.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/domain/usecases/services_usecases.dart';
import 'package:get/get.dart';

class ServiceDetailsController extends GetxController {
  ServiceDetailsController({
    required this.serviceId,
    required GetServiceDetails getServiceDetails,
    required GetReviews getReviews,
  })  : _getDetails = getServiceDetails,
        _getReviews = getReviews;

  final int serviceId;
  final GetServiceDetails _getDetails;
  final GetReviews _getReviews;

  final state = Rx<ViewState<Service>>(const ViewLoading());
  final reviews = Rx<ViewState<ReviewsPage>>(const ViewLoading());
  final galleryIndex = 0.obs;

  Service? get service => state.value.dataOrNull;

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load() async {
    state.value = const ViewLoading();
    reviews.value = const ViewLoading();
    final (details, page) = await (
      _getDetails(serviceId),
      _getReviews(GetReviewsParams(ServiceReviewsTarget(serviceId))),
    ).wait;
    state.value = ViewState.fromResult(details);
    reviews.value = ViewState.fromResult(page, isEmpty: (p) => p.page.items.isEmpty);
  }
}
