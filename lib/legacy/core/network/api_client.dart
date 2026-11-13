import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import '../storage/token_storage.dart';

class ApiClient {
  late final Dio dio;

  final TokenStorage _tokenStorage;

  ApiClient({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
      ),
    );

    // Authentication Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final requiresAuth = options.extra['requiresAuth'] == true;

            if (requiresAuth) {
              final token = await _tokenStorage.getToken();

              if (token == null || token.isEmpty) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    error: 'Authentication token is missing',
                  ),
                );
                return;
              }

              options.headers['Authorization'] = 'Bearer $token';
            }

            handler.next(options);
          } catch (error) {
            handler.reject(DioException(requestOptions: options, error: error));
          }
        },
      ),
    );

    // Logging Interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        error: true,
        requestHeader: false,
        responseHeader: false,
        requestBody: false,
        responseBody: false,
      ),
    );
  }
}
