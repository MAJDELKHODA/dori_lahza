import 'package:dio/dio.dart';
import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/app_exception.dart';
import 'package:dori_lahza/core/network/interceptors/auth_interceptor.dart';
import 'package:dori_lahza/core/network/interceptors/error_interceptor.dart';
import 'package:dori_lahza/core/storage/token_storage.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:flutter/foundation.dart';

/// The `{ success, message, data, meta }` envelope after a successful call.
class ApiResponse {
  const ApiResponse({required this.data, required this.message, required this.meta});

  factory ApiResponse.fromJson(Json json) => ApiResponse(
        data: json['data'],
        message: asString(json['message']),
        meta: asJson(json['meta']),
      );

  final Object? data;
  final String message;
  final Json meta;

  Json get json => asJson(data);
  List<Object?> get list => asList(data);
}

/// Thin wrapper over [Dio]: configures base options and interceptors, unwraps
/// the envelope, and throws [AppException] on any failure.
class DioClient {
  DioClient({required TokenStorage tokenStorage, required Future<void> Function() onUnauthorized})
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: const {'Accept': 'application/json', 'Accept-Language': 'ar'},
            // Let the error interceptor read 4xx/5xx envelopes.
            validateStatus: (status) => status != null && status >= 200 && status < 300,
          ),
        ) {
    _dio.interceptors.addAll([
      AuthInterceptor(tokenStorage: tokenStorage, onUnauthorized: onUnauthorized),
      ErrorInterceptor(),
      if (kDebugMode)
        LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          logPrint: (line) => debugPrint(line.toString()),
        ),
    ]);
  }

  final Dio _dio;

  Future<ApiResponse> get(String path, {Map<String, Object?>? query, CancelToken? cancelToken}) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: _clean(query), cancelToken: cancelToken));

  Future<ApiResponse> post(String path, {Object? body, Map<String, Object?>? query}) =>
      _send(() => _dio.post<dynamic>(path, data: body, queryParameters: _clean(query)));

  Future<ApiResponse> put(String path, {Object? body}) =>
      _send(() => _dio.put<dynamic>(path, data: body));

  Future<ApiResponse> delete(String path, {Object? body}) =>
      _send(() => _dio.delete<dynamic>(path, data: body));

  Future<ApiResponse> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return ApiResponse.fromJson(asJson(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  /// Drops null and empty values so optional filters are not sent.
  static Map<String, Object?>? _clean(Map<String, Object?>? query) {
    if (query == null) return null;
    return Map.of(query)..removeWhere((_, v) => v == null || (v is String && v.isEmpty));
  }
}
