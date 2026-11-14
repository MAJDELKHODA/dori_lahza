import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:dori_lahza/features/booking/data/models/availability_model.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/booking/domain/entities/booking_failures.dart';
import 'package:dori_lahza/features/booking/domain/repositories/booking_repository.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this._remote);

  final BookingRemoteDataSource _remote;

  @override
  Future<Result<List<AvailabilityDay>>> days({required int serviceId, int? staffId, required int days}) =>
      guard(() => _remote.days(serviceId: serviceId, staffId: staffId, days: days));

  @override
  Future<Result<DaySlots>> slots({required int serviceId, required String date, int? staffId}) =>
      guard(() => _remote.slots(serviceId: serviceId, date: date, staffId: staffId));

  @override
  Future<Result<CouponQuote>> checkCoupon({required String code, required int serviceId}) =>
      guard(() => _remote.checkCoupon(code: code, serviceId: serviceId));

  @override
  Future<Result<Booking>> create(NewBooking booking) async {
    final result = await guard(() => _remote.create(booking));
    final failure = result.failureOrNull;
    if (failure != null && failure.hasCode(ErrorCodes.slotUnavailable)) {
      return Result.failure(
        SlotUnavailableFailure(failure, AvailabilityModel.slotList(failure.details['alternatives'])),
      );
    }
    return result;
  }
}
