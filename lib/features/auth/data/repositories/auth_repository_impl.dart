import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/storage/token_storage.dart';
import 'package:dori_lahza/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';
import 'package:dori_lahza/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDataSource remote, required TokenStorage tokenStorage})
      : _remote = remote,
        _tokens = tokenStorage;

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokens;

  @override
  Future<bool> hasSession() => _tokens.hasToken();

  @override
  Future<Result<User>> login({required String email, required String password}) => guard(() async {
        final payload = await _remote.login(email: email, password: password);
        await _tokens.save(payload.token);
        return payload.user;
      });

  @override
  Future<Result<User>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) =>
      guard(() async {
        final payload = await _remote.register(
          name: name,
          email: email,
          phone: phone,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );
        await _tokens.save(payload.token);
        return payload.user;
      });

  @override
  Future<Result<User>> me() => guard(_remote.me);

  @override
  Future<Result<User>> updateProfile({required String name, required String phone}) =>
      guard(() => _remote.updateProfile(name: name, phone: phone));

  @override
  Future<void> logout() async {
    await guard(_remote.logout);
    await _tokens.clear();
  }

  @override
  Future<void> clearSession() => _tokens.clear();
}
