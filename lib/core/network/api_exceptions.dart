import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDio(DioException error) {
    final response = error.response;

    if (response != null) {
      final data = response.data;

      final message = data is Map ? data['message']?.toString() : null;

      return ApiException(
        message: message ?? 'حدث خطأ في الطلب',
        statusCode: response.statusCode,
      );
    }

    return ApiException(
      message: switch (error.type) {
        DioExceptionType.connectionTimeout => 'انتهت مهلة الاتصال بالسيرفر',
        DioExceptionType.sendTimeout => 'انتهت مهلة إرسال البيانات',
        DioExceptionType.receiveTimeout => 'انتهت مهلة استقبال البيانات',
        DioExceptionType.connectionError => 'تعذر الاتصال بالإنترنت',
        _ => 'حدث خطأ غير متوقع',
      },
    );
  }

  @override
  String toString() => message;
}
