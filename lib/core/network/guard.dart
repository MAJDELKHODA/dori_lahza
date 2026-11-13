import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/network/app_exception.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:flutter/foundation.dart';

/// Runs a data-layer call and converts any exception into a [Result].
/// Every repository implementation goes through this, so failures are
/// handled in exactly one way across the app.
Future<Result<T>> guard<T>(Future<T> Function() call) async {
  try {
    return Result.success(await call());
  } on AppException catch (e) {
    return Result.failure(e.toFailure());
  } catch (e, stack) {
    debugPrint('Unexpected data error: $e\n$stack');
    return const Result.failure(
      Failure(message: 'تعذّر قراءة البيانات، حاول مرة أخرى', code: ErrorCodes.badResponse),
    );
  }
}
