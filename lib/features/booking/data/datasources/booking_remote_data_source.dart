import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/booking/data/models/availability_model.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/booking/domain/repositories/booking_repository.dart';
import 'package:dori_lahza/features/bookings/data/models/booking_model.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

class BookingRemoteDataSource {
  const BookingRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<AvailabilityDay>> days({required int serviceId, int? staffId, required int days}) async {
    final res = await _client.get(
      ApiEndpoints.availabilityDays,
      query: {'service_id': serviceId, 'staff_id': staffId, 'days': days},
    );
    return asListOf(res.data, AvailabilityModel.dayFromJson);
  }

  Future<DaySlots> slots({required int serviceId, required String date, int? staffId}) async {
    final res = await _client.get(
      ApiEndpoints.availabilitySlots,
      query: {'service_id': serviceId, 'date': date, 'staff_id': staffId},
    );
    return AvailabilityModel.daySlots(res.data, res.meta, date);
  }

  Future<CouponQuote> checkCoupon({required String code, required int serviceId}) async {
    final res = await _client.post(ApiEndpoints.checkCoupon, body: {'code': code, 'service_id': serviceId});
    return AvailabilityModel.couponFromJson(res.json, code);
  }

  Future<Booking> create(NewBooking b) async {
    final res = await _client.post(
      ApiEndpoints.bookings,
      body: {
        'service_id': b.serviceId,
        'staff_id': b.staffId,
        'starts_at': b.startsAt,
        'notes': b.notes,
        'answers': b.answers,
        'coupon_code': b.couponCode,
        'payment_method': b.paymentMethod,
      },
    );
    return BookingModel.fromJson(res.json);
  }
}
