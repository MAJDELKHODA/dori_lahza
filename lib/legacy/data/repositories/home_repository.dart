import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exceptions.dart';
import '../models/home/home_response.dart';

class HomeRepository {
  final ApiClient _apiClient;

  HomeRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<HomeResponse> getHomeData() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.home);

      if (response.data is! Map<String, dynamic>) {
        throw ApiException(message: 'صيغة بيانات الصفحة الرئيسية غير صحيحة');
      }

      final json = response.data as Map<String, dynamic>;

      if (json['success'] != true || json['data'] is! Map) {
        throw ApiException(
          message: json['message']?.toString() ?? 'تعذر تحميل الصفحة الرئيسية',
        );
      }

      return HomeResponse.fromJson(json);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
