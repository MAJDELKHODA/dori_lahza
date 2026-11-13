import 'package:dori_lahza/core/utils/json.dart';

/// Error codes returned by the API in `error.code`.
abstract final class ErrorCodes {
  static const unauthenticated = 'UNAUTHENTICATED';
  static const validation = 'VALIDATION_ERROR';
  static const notFound = 'NOT_FOUND';
  static const slotUnavailable = 'SLOT_UNAVAILABLE';
  static const slotTaken = 'SLOT_TAKEN';

  // Client-side codes (never sent by the server).
  static const network = 'NETWORK';
  static const timeout = 'TIMEOUT';
  static const cancelled = 'CANCELLED';
  static const badResponse = 'BAD_RESPONSE';
  static const unknown = 'UNKNOWN';
}

enum FailureKind { network, unauthorized, validation, notFound, conflict, server, unknown }

/// The single failure type that crosses from data to presentation.
///
/// Mirrors the API error envelope `{ message, error: { code, details } }` so
/// features can react to specific codes (e.g. [ErrorCodes.slotUnavailable])
/// and read structured [details] (e.g. `alternatives`).
class Failure {
  const Failure({
    required this.message,
    this.code = ErrorCodes.unknown,
    this.statusCode,
    this.details = const {},
  });

  final String message;
  final String code;
  final int? statusCode;
  final Json details;

  FailureKind get kind {
    if (code == ErrorCodes.network || code == ErrorCodes.timeout) return FailureKind.network;
    if (statusCode == 401 || code == ErrorCodes.unauthenticated) return FailureKind.unauthorized;
    if (statusCode == 422 || code == ErrorCodes.validation) return FailureKind.validation;
    if (statusCode == 404 || code == ErrorCodes.notFound) return FailureKind.notFound;
    if (statusCode == 409) return FailureKind.conflict;
    if (statusCode != null && statusCode! >= 500) return FailureKind.server;
    return FailureKind.unknown;
  }

  bool get isNetwork => kind == FailureKind.network;
  bool get isUnauthorized => kind == FailureKind.unauthorized;
  bool hasCode(String value) => code == value;

  /// Field errors of a 422 response: `{ "email": ["..."], ... }`.
  Map<String, String> get fieldErrors {
    if (kind != FailureKind.validation) return const {};
    final result = <String, String>{};
    details.forEach((field, messages) {
      final list = asStringList(messages);
      final text = list.isNotEmpty ? list.first : asString(messages);
      if (text.isNotEmpty) result[field] = text;
    });
    return result;
  }

  @override
  String toString() => 'Failure($code, $statusCode): $message';
}
