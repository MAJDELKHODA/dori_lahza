import 'package:dori_lahza/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:dori_lahza/features/reviews/domain/usecases/reviews_usecases.dart';
import 'package:dori_lahza/features/reviews/presentation/controllers/reviews_controller.dart';
import 'package:get/get.dart';

class ReviewsBinding extends Bindings {
  ReviewsBinding(this.target);

  final ReviewsTarget target;

  @override
  void dependencies() => Get.lazyPut(
        () => ReviewsController(target: target, getReviews: GetReviews(Get.find<ReviewsRepository>())),
      );
}
