import 'package:dio/dio.dart';
import 'package:dori_lahza/core/storage/token_storage.dart';

/// Attaches the bearer token to every request when the user is signed in, and
/// reports a rejected token (401) so the session can be ended app-wide.
///
/// Public endpoints accept the token too, so there is no per-request flag.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required TokenStorage tokenStorage, required this.onUnauthorized})
      : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  /// Called once a request that carried a token comes back 401.
  final Future<void> Function() onUnauthorized;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.read();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final sentToken = err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && sentToken) {
      await _tokenStorage.clear();
      await onUnauthorized();
    }
    handler.next(err);
  }
}
