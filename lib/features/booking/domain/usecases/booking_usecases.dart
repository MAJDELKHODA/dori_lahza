import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/booking/domain/repositories/booking_repository.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

class AvailabilityQuery {
  const AvailabilityQuery({required this.serviceId, this.staffId, this.days = 14, this.date});

  final int serviceId;
  final int? staffId;
  final int days;

  /// Required for slots.
  final String? date;
}

class GetAvailableDays implements UseCase<List<AvailabilityDay>, AvailabilityQuery> {
  const GetAvailableDays(this._repository);
  final BookingRepository _repository;

  @override
  Future<Result<List<AvailabilityDay>>> call(AvailabilityQuery q) =>
      _repository.days(serviceId: q.serviceId, staffId: q.staffId, days: q.days);
}

class GetDaySlots implements UseCase<DaySlots, AvailabilityQuery> {
  const GetDaySlots(this._repository);
  final BookingRepository _repository;

  @override
  Future<Result<DaySlots>> call(AvailabilityQuery q) =>
      _repository.slots(serviceId: q.serviceId, date: q.date!, staffId: q.staffId);
}

class CheckCoupon implements UseCase<CouponQuote, ({String code, int serviceId})> {
  const CheckCoupon(this._repository);
  final BookingRepository _repository;

  @override
  Future<Result<CouponQuote>> call(({String code, int serviceId}) p) =>
      _repository.checkCoupon(code: p.code.trim().toUpperCase(), serviceId: p.serviceId);
}

class CreateBooking implements UseCase<Booking, NewBooking> {
  const CreateBooking(this._repository);
  final BookingRepository _repository;

  @override
  Future<Result<Booking>> call(NewBooking booking) => _repository.create(booking);
}
