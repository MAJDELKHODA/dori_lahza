import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/usecases/bookings_usecases.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/bookings_list_controller.dart';
import 'package:dori_lahza/features/bookings/presentation/models/booking_details_args.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:get/get.dart';

/// Booking details with QR, timeline and the cancel / reschedule / review actions.
class BookingDetailsController extends GetxController {
  BookingDetailsController({
    required this.args,
    required GetBookingDetails getDetails,
    required CancelBooking cancelBooking,
    required ReviewBooking reviewBooking,
    required SessionController session,
    required PlaceController place,
  })  : _getDetails = getDetails,
        _cancel = cancelBooking,
        _review = reviewBooking,
        _session = session,
        _place = place,
        state = Rx<ViewState<Booking>>(args.initial == null ? const ViewLoading() : ViewSuccess(args.initial!));

  final BookingDetailsArgs args;
  final GetBookingDetails _getDetails;
  final CancelBooking _cancel;
  final ReviewBooking _review;
  final SessionController _session;
  final PlaceController _place;

  final Rx<ViewState<Booking>> state;
  final isCancelling = false.obs;
  final isReviewing = false.obs;

  /// Hides the review action once submitted in this session.
  final reviewed = false.obs;

  Booking? get booking => state.value.dataOrNull;
  int get cancelBeforeHours => _place.rules.cancelBeforeHours;

  @override
  void onReady() {
    super.onReady();
    unawaited(load(showLoading: args.initial == null));
  }

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) state.value = const ViewLoading();
    final result = await _getDetails(args.id);
    if (result.isSuccess || booking == null) state.value = ViewState.fromResult(result);
  }

  Future<bool> cancel(String? reason) async {
    if (isCancelling.value) return false;
    isCancelling.value = true;
    final result = await _cancel((id: args.id, reason: reason));
    isCancelling.value = false;
    return result.fold(
      (failure) {
        AppFeedback.failure(failure);
        return false;
      },
      (updated) {
        state.value = ViewSuccess(updated);
        AppFeedback.success('تم إلغاء الحجز');
        _afterChange();
        // A late cancellation changes the reliability score.
        unawaited(_session.refreshUser());
        return true;
      },
    );
  }

  Future<bool> submitReview(int rating, String comment) async {
    if (rating < 1 || isReviewing.value) return false;
    isReviewing.value = true;
    final result = await _review((id: args.id, rating: rating, comment: comment.trim().isEmpty ? null : comment.trim()));
    isReviewing.value = false;
    return result.fold(
      (failure) {
        AppFeedback.failure(failure);
        return false;
      },
      (_) {
        reviewed.value = true;
        AppFeedback.success('شكرًا لتقييمك!');
        unawaited(load(showLoading: false));
        return true;
      },
    );
  }

  Future<void> reschedule() async {
    final current = booking;
    if (current == null) return;
    final updated = await AppNav.reschedule(current);
    if (updated == null) return;
    state.value = ViewSuccess(updated);
    _afterChange();
  }

  /// Keeps the "حجوزاتي" tabs in sync after an action here.
  void _afterChange() {
    for (final scope in BookingScope.values) {
      if (Get.isRegistered<BookingsListController>(tag: scope.name)) {
        unawaited(Get.find<BookingsListController>(tag: scope.name).refreshList(showLoading: false));
      }
    }
  }
}
