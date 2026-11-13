import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // Create secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Token key
  static const String _tokenKey = 'auth_token';

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Read token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
