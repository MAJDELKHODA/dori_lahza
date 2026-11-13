import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exceptions.dart';
import '../models/service/service_details_model.dart';
import '../models/home/home_response.dart';

class ServiceRepository {
  final ApiClient _apiClient;

  ServiceRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<ServiceDetailsModel> getServiceDetails(int serviceId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.serviceDetails(serviceId),
      );

      if (response.data is! Map<String, dynamic>) {
        throw ApiException(message: 'استجابة السيرفر غير صحيحة');
      }

      return ServiceDetailsModel.fromResponse(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<HomeService>> getServices() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.services);

      final json = response.data as Map<String, dynamic>;

      if (json['success'] != true || json['data'] is! List) {
        throw ApiException(message: json['message'] ?? 'تعذر تحميل الخدمات');
      }

      return (json['data'] as List)
          .map((item) => HomeService.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
