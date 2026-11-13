import 'package:dio/dio.dart';
import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/network/app_exception.dart';
import 'package:dori_lahza/core/utils/json.dart';

/// Normalizes every failure into an [AppException] carried by the
/// [DioException], including HTTP 200 responses whose envelope says
/// `success: false`.
class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map && body['success'] == false) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: AppException.fromDio(
            DioException(requestOptions: response.requestOptions, response: response),
          ),
        ),
        true,
      );
      return;
    }
    if (body is! Map) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: const AppException(
            message: 'استجابة غير متوقعة من الخادم',
            code: ErrorCodes.badResponse,
          ),
        ),
        true,
      );
      return;
    }
    response.data = asJson(body);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: AppException.fromDio(err)));
  }
}
