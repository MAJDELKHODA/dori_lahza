import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/repositories/bookings_repository.dart';

class GetMyBookings implements UseCase<Paginated<Booking>, ({BookingScope scope, int page})> {
  const GetMyBookings(this._repository);
  final BookingsRepository _repository;

  @override
  Future<Result<Paginated<Booking>>> call(({BookingScope scope, int page}) p) =>
      _repository.list(p.scope, page: p.page);
}

/// The soonest upcoming active booking (pending / confirmed), or null.
class GetNextBooking implements UseCase<Booking?, NoParams> {
  const GetNextBooking(this._repository);
  final BookingsRepository _repository;

  @override
  Future<Result<Booking?>> call([NoParams params = const NoParams()]) async {
    final result = await _repository.list(BookingScope.upcoming, page: 1);
    return result.map((page) {
      final active = page.items.where((b) => b.isActive && b.startsAt != null).toList()
        ..sort((a, b) => a.startsAt!.compareTo(b.startsAt!));
      return active.isEmpty ? null : active.first;
    });
  }
}

class GetBookingDetails implements UseCase<Booking, int> {
  const GetBookingDetails(this._repository);
  final BookingsRepository _repository;

  @override
  Future<Result<Booking>> call(int id) => _repository.details(id);
}

class RescheduleBooking implements UseCase<Booking, ({int id, String startsAt, int? staffId})> {
  const RescheduleBooking(this._repository);
  final BookingsRepository _repository;

  @override
  Future<Result<Booking>> call(({int id, String startsAt, int? staffId}) p) =>
      _repository.reschedule(p.id, startsAt: p.startsAt, staffId: p.staffId);
}

class CancelBooking implements UseCase<Booking, ({int id, String? reason})> {
  const CancelBooking(this._repository);
  final BookingsRepository _repository;

  @override
  Future<Result<Booking>> call(({int id, String? reason}) p) => _repository.cancel(p.id, reason: p.reason);
}

class ReviewBooking implements UseCase<void, ({int id, int rating, String? comment})> {
  const ReviewBooking(this._repository);
  final BookingsRepository _repository;

  @override
  Future<Result<void>> call(({int id, int rating, String? comment}) p) =>
      _repository.review(p.id, rating: p.rating, comment: p.comment);
}
