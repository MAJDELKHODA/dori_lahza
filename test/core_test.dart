import 'package:dio/dio.dart';
import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/network/app_exception.dart';
import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('json helpers', () {
    test('read numbers from num or string, with fallback', () {
      expect(asInt('12'), 12);
      expect(asInt(3.9), 3);
      expect(asInt(null, 7), 7);
      expect(asDouble('1600.5'), 1600.5);
      expect(asBool(1), isTrue);
      expect(asBool('false'), isFalse);
    });

    test('asListOf skips non-map entries', () {
      final list = asListOf<int>([
        {'id': 1},
        'x',
        {'id': 2},
      ], (j) => asInt(j['id']));
      expect(list, [1, 2]);
    });
  });

  group('AppException.fromDio', () {
    test('reads the API error envelope', () {
      final options = RequestOptions(path: '/x');
      final error = DioException(
        requestOptions: options,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 422,
          data: {
            'success': false,
            'message': 'البيانات المدخلة غير صحيحة',
            'error': {
              'code': 'VALIDATION_ERROR',
              'details': {
                'email': ['حقل البريد الإلكتروني مطلوب.'],
              },
            },
          },
        ),
      );
      final failure = AppException.fromDio(error).toFailure();
      expect(failure.code, ErrorCodes.validation);
      expect(failure.kind, FailureKind.validation);
      expect(failure.fieldErrors['email'], 'حقل البريد الإلكتروني مطلوب.');
    });

    test('maps connection errors to a network failure', () {
      final error = DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError);
      expect(AppException.fromDio(error).toFailure().isNetwork, isTrue);
    });
  });

  test('Paginated reads meta', () {
    final page = Paginated.fromResponse([1, 2, 3], {'page': 1, 'last_page': 2, 'total': 6});
    expect(page.hasMore, isTrue);
    expect(page.total, 6);
  });
}
