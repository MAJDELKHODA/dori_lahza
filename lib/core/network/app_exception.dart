import 'package:dio/dio.dart';
import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/utils/json.dart';

/// Exception thrown inside the data layer. Repositories convert it to a
/// [Failure] through `guard`, so it never reaches the presentation layer.
class AppException implements Exception {
  const AppException({
    required this.message,
    this.code = ErrorCodes.unknown,
    this.statusCode,
    this.details = const {},
  });

  /// Builds from a [DioException], reading the API error envelope
  /// `{ success:false, message, error:{ code, details } }` when present.
  factory AppException.fromDio(DioException error) {
    final inner = error.error;
    if (inner is AppException) return inner;

    final response = error.response;
    final body = response?.data;
    if (body is Map) {
      final json = asJson(body);
      final err = asJson(json['error']);
      return AppException(
        message: asString(json['message'], _fallbackForStatus(response?.statusCode)),
        code: asString(err['code'], ErrorCodes.unknown),
        statusCode: response?.statusCode ?? asIntOrNull(json['status']),
        details: asJson(err['details']),
      );
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const AppException(message: 'انتهت مهلة الاتصال، حاول مرة أخرى', code: ErrorCodes.timeout),
      DioExceptionType.connectionError =>
        const AppException(message: 'لا يوجد اتصال بالإنترنت', code: ErrorCodes.network),
      DioExceptionType.cancel =>
        const AppException(message: 'تم إلغاء الطلب', code: ErrorCodes.cancelled),
      _ => AppException(
          message: _fallbackForStatus(response?.statusCode),
          statusCode: response?.statusCode,
        ),
    };
  }

  final String message;
  final String code;
  final int? statusCode;
  final Json details;

  Failure toFailure() =>
      Failure(message: message, code: code, statusCode: statusCode, details: details);

  static String _fallbackForStatus(int? status) => switch (status) {
        401 => 'يجب تسجيل الدخول أولًا',
        403 => 'لا تملك صلاحية لهذا الإجراء',
        404 => 'العنصر المطلوب غير موجود',
        422 => 'البيانات المدخلة غير صحيحة',
        429 => 'طلبات كثيرة، انتظر قليلًا ثم حاول',
        final int s when s >= 500 => 'الخادم غير متاح حاليًا، حاول لاحقًا',
        _ => 'حدث خطأ غير متوقع',
      };

  @override
  String toString() => 'AppException($code, $statusCode): $message';
}
