import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/features/reviews/domain/usecases/reviews_usecases.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:get/get.dart';

/// Typed navigation entry points, so callers never build route arguments by hand.
abstract final class AppNav {
  static Future<void>? serviceDetails(int serviceId) =>
      Get.toNamed<void>(AppRoutes.serviceDetails, arguments: serviceId, preventDuplicates: false);

  /// Starts booking: day strip → slots → confirm.
  static Future<void>? bookService(Service service) =>
      Get.toNamed<void>(AppRoutes.bookingSlots, arguments: service);

  static Future<void>? staffProfile(int staffId) =>
      Get.toNamed<void>(AppRoutes.staffProfile, arguments: staffId, preventDuplicates: false);

  static Future<void>? team() => Get.toNamed<void>(AppRoutes.team);

  static Future<void>? placeReviews() =>
      Get.toNamed<void>(AppRoutes.placeReviews, arguments: const PlaceReviewsTarget());

  static Future<void>? serviceReviews(int serviceId) =>
      Get.toNamed<void>(AppRoutes.serviceReviews, arguments: ServiceReviewsTarget(serviceId));

  static Future<void>? busyHours() => Get.toNamed<void>(AppRoutes.busyHours);

  static Future<void>? placeInfo() => Get.toNamed<void>(AppRoutes.placeInfo);
}
