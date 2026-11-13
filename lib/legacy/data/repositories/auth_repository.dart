import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/storage/token_storage.dart';
import '../auth/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage;

  // Register

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': password,
          'device_name': 'La7za App',
        },
      );

      return await _handleAuthResponse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }


  // Login


  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
          'device_name': 'La7za App',
        },
      );

      return await _handleAuthResponse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }


  // Handle Authentication Response

  Future<UserModel> _handleAuthResponse(dynamic responseData) async {
    if (responseData is! Map) {
      throw ApiException(message: 'استجابة السيرفر غير صحيحة');
    }

    final json = Map<String, dynamic>.from(responseData);
    final data = json['data'];

    if (json['success'] != true || data is! Map) {
      throw ApiException(
        message: json['message']?.toString() ?? 'تعذر إتمام العملية',
      );
    }

    final authData = Map<String, dynamic>.from(data);
    final token = authData['token'];
    final userData = authData['user'];

    if (token is! String || token.isEmpty || userData is! Map) {
      throw ApiException(message: 'بيانات الحساب المستلمة غير مكتملة');
    }

    final user = UserModel.fromJson(Map<String, dynamic>.from(userData));

    await _tokenStorage.saveToken(token);

    return user;
  }

  // Logout

  Future<void> logout() async {
    try {
      await _apiClient.dio.post(
        ApiEndpoints.logout,
        options: Options(extra: {'requiresAuth': true}),
      );
    } finally {
      await _tokenStorage.deleteToken();
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.profile,
        options: Options(extra: {'requiresAuth': true}),
      );

      if (response.data is! Map) {
        throw ApiException(message: 'استجابة السيرفر غير صحيحة');
      }

      final json = Map<String, dynamic>.from(response.data as Map);

      if (json['success'] != true || json['data'] is! Map) {
        throw ApiException(
          message: json['message']?.toString() ?? 'تعذر تحميل بيانات المستخدم',
        );
      }

      final data = Map<String, dynamic>.from(json['data'] as Map);

      return UserModel.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _tokenStorage.deleteToken();
      }

      throw ApiException.fromDio(error);
    }
  }

  Future<UserModel> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateProfile,
        options: Options(extra: {'requiresAuth': true}),
        data: {'name': name, 'phone': phone},
      );

      if (response.data is! Map) {
        throw ApiException(message: 'استجابة السيرفر غير صحيحة');
      }

      final json = Map<String, dynamic>.from(response.data as Map);

      if (json['success'] != true || json['data'] is! Map) {
        throw ApiException(
          message: json['message']?.toString() ?? 'تعذر تحديث الملف الشخصي',
        );
      }

      return UserModel.fromJson(Map<String, dynamic>.from(json['data'] as Map));
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
