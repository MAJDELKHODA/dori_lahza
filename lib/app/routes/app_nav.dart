import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/presentation/models/booking_details_args.dart';
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

  /// After `POST /bookings`: replace the booking flow with the new booking's details.
  static Future<void>? bookingCreated(Booking booking) => Get.offNamedUntil<void>(
        AppRoutes.bookingDetails,
        (route) => route.settings.name == AppRoutes.shell,
        arguments: BookingDetailsArgs(booking.id, initial: booking, justCreated: true),
      );

  static Future<void>? bookingDetails(int bookingId, {Booking? initial}) => Get.toNamed<void>(
        AppRoutes.bookingDetails,
        arguments: BookingDetailsArgs(bookingId, initial: initial),
        preventDuplicates: false,
      );

  /// Returns the updated booking when the time was changed.
  static Future<Booking?>? reschedule(Booking booking) =>
      Get.toNamed<Booking>(AppRoutes.reschedule, arguments: booking);

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
