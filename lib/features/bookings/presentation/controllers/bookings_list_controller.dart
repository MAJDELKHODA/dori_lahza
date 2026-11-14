import 'dart:async';

import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/state/paged_controller.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/usecases/bookings_usecases.dart';
import 'package:get/get.dart';

/// One tab of "حجوزاتي" (upcoming or past). Loads only when signed in and
/// reloads when the session changes.
class BookingsListController extends PagedController<Booking> {
  BookingsListController({required this.scope, required GetMyBookings getMyBookings, required SessionController session})
      : _get = getMyBookings,
        _session = session;

  final BookingScope scope;
  final GetMyBookings _get;
  final SessionController _session;
  Worker? _sessionWorker;

  @override
  bool get loadOnReady => _session.isSignedIn;

  @override
  void onInit() {
    super.onInit();
    _sessionWorker = ever(_session.user, (user) {
      if (user != null) {
        unawaited(refreshList());
      } else {
        items.clear();
      }
    });
  }

  @override
  Future<Result<Paginated<Booking>>> fetchPage(int page) => _get((scope: scope, page: page));

  @override
  void onClose() {
    _sessionWorker?.dispose();
    super.onClose();
  }
}
