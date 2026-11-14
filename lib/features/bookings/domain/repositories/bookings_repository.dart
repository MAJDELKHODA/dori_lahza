import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

abstract interface class BookingsRepository {
  Future<Result<Paginated<Booking>>> list(BookingScope scope, {required int page});

  Future<Result<Booking>> details(int id);

  /// Returns the updated booking (reloaded when the action response omits it).
  Future<Result<Booking>> reschedule(int id, {required String startsAt, int? staffId});

  Future<Result<Booking>> cancel(int id, {String? reason});

  Future<Result<void>> review(int id, {required int rating, String? comment});
}
