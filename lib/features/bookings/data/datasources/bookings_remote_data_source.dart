import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/bookings/data/models/booking_model.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

class BookingsRemoteDataSource {
  const BookingsRemoteDataSource(this._client);

  final DioClient _client;

  Future<Paginated<Booking>> list(BookingScope scope, {required int page}) async {
    final res = await _client.get(ApiEndpoints.bookings, query: {'scope': scope.name, 'page': page});
    return Paginated.fromResponse(asListOf(res.data, BookingModel.fromJson), res.meta);
  }

  Future<Booking> details(int id) async =>
      BookingModel.fromJson((await _client.get(ApiEndpoints.booking(id))).json);

  Future<Booking?> reschedule(int id, {required String startsAt, int? staffId}) async {
    final res = await _client.post(ApiEndpoints.reschedule(id), body: {'starts_at': startsAt, 'staff_id': staffId});
    return _bookingOrNull(res.data);
  }

  Future<Booking?> cancel(int id, {String? reason}) async {
    final res = await _client.post(ApiEndpoints.cancelBooking(id), body: {'reason': reason});
    return _bookingOrNull(res.data);
  }

  Future<void> review(int id, {required int rating, String? comment}) =>
      _client.post(ApiEndpoints.reviewBooking(id), body: {'rating': rating, 'comment': comment});

  /// Actions may return the updated booking; when they do not, callers reload.
  static Booking? _bookingOrNull(Object? data) {
    final json = asJsonOrNull(data);
    if (json == null || !json.containsKey('status')) return null;
    return BookingModel.fromJson(json);
  }
}
