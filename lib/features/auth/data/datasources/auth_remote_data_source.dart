import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/app_exception.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/auth/data/models/user_model.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';

typedef AuthPayload = ({String token, User user});

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  static const _deviceName = 'La7za App';

  final DioClient _client;

  Future<AuthPayload> login({required String email, required String password}) async {
    final res = await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password, 'device_name': _deviceName},
    );
    return _payload(res.json);
  }

  Future<AuthPayload> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await _client.post(
      ApiEndpoints.register,
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_name': _deviceName,
      },
    );
    return _payload(res.json);
  }

  Future<User> me() async => UserModel.fromJson((await _client.get(ApiEndpoints.me)).json);

  Future<User> updateProfile({required String name, required String phone}) async {
    final res = await _client.put(ApiEndpoints.profile, body: {'name': name, 'phone': phone});
    return UserModel.fromJson(res.json);
  }

  Future<void> logout() => _client.post(ApiEndpoints.logout);

  AuthPayload _payload(Json data) {
    final token = asString(data['token']);
    final user = asJsonOrNull(data['user']);
    if (token.isEmpty || user == null) {
      throw const AppException(message: 'بيانات الحساب غير مكتملة', code: ErrorCodes.badResponse);
    }
    return (token: token, user: UserModel.fromJson(user));
  }
}
