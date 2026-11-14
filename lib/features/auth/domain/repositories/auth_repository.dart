import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<bool> hasSession();

  Future<Result<User>> login({required String email, required String password});

  Future<Result<User>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<Result<User>> me();

  Future<Result<User>> updateProfile({required String name, required String phone});

  /// Always clears the local token, even if the server call fails.
  Future<void> logout();

  Future<void> clearSession();
}
