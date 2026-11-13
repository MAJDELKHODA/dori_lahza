import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/network/api_endpoints.dart';

import '../models/booking/availability_day_model.dart';
import '../models/booking/availability_slot_model.dart';
import '../models/booking/booking_model.dart';

class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // Get Available Days

  Future<List<AvailabilityDayModel>> getAvailabilityDays({
    required int serviceId,
    int days = 14,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.availabilityDays(serviceId),
        queryParameters: {'service_id': serviceId, 'days': days},
      );

      if (response.data is! Map) {
        throw ApiException(message: 'استجابة السيرفر غير صحيحة');
      }

      final json = Map<String, dynamic>.from(response.data as Map);

      if (json['success'] != true || json['data'] is! List) {
        throw ApiException(
          message: json['message']?.toString() ?? 'تعذر تحميل المواعيد',
        );
      }

      return (json['data'] as List)
          .map(
            (item) => AvailabilityDayModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  // Get Available Time Slots

  Future<List<AvailabilitySlotModel>> getAvailabilitySlots({
    required int serviceId,
    required String date,
    int? staffId,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.availabilitySlots,
        queryParameters: {
          'service_id': serviceId,
          'date': date,
          if (staffId != null) 'staff_id': staffId,
        },
      );

      if (response.data is! Map) {
        throw ApiException(message: 'استجابة السيرفر غير صحيحة');
      }

      final json = Map<String, dynamic>.from(response.data as Map);

      if (json['success'] != true || json['data'] is! List) {
        throw ApiException(
          message: json['message']?.toString() ?? 'تعذر تحميل الأوقات المتاحة',
        );
      }

      return (json['data'] as List)
          .map(
            (item) => AvailabilitySlotModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<BookingModel> createBooking({
    required int serviceId,
    int? staffId,
    required String startsAt,
    String? notes,
    Map<String, dynamic> answers = const {},
    String? couponCode,
    String paymentMethod = 'cash',
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.bookings,
        options: Options(extra: {'requiresAuth': true}),
        data: {
          'service_id': serviceId,
          'staff_id': staffId,
          'starts_at': startsAt,
          'notes': notes,
          'answers': answers,
          'coupon_code': couponCode,
          'payment_method': paymentMethod,
        },
      );

      if (response.data is! Map) {
        throw ApiException(message: 'استجابة السيرفر غير صحيحة');
      }

      final json = Map<String, dynamic>.from(response.data as Map);

      if (json['success'] != true || json['data'] is! Map) {
        throw ApiException(
          message: json['message']?.toString() ?? 'تعذر تأكيد الحجز',
        );
      }

      return BookingModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
