import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/bookings/data/datasources/bookings_remote_data_source.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/repositories/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  const BookingsRepositoryImpl(this._remote);

  final BookingsRemoteDataSource _remote;

  @override
  Future<Result<Paginated<Booking>>> list(BookingScope scope, {required int page}) =>
      guard(() => _remote.list(scope, page: page));

  @override
  Future<Result<Booking>> details(int id) => guard(() => _remote.details(id));

  @override
  Future<Result<Booking>> reschedule(int id, {required String startsAt, int? staffId}) => guard(
        () async => await _remote.reschedule(id, startsAt: startsAt, staffId: staffId) ?? await _remote.details(id),
      );

  @override
  Future<Result<Booking>> cancel(int id, {String? reason}) =>
      guard(() async => await _remote.cancel(id, reason: reason) ?? await _remote.details(id));

  @override
  Future<Result<void>> review(int id, {required int rating, String? comment}) =>
      guard(() => _remote.review(id, rating: rating, comment: comment));
}
