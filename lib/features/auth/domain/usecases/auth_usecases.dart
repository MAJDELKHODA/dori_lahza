import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';
import 'package:dori_lahza/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}

class Login implements UseCase<User, LoginParams> {
  const Login(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User>> call(LoginParams p) =>
      _repository.login(email: p.email.trim(), password: p.password);
}

class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
}

class Register implements UseCase<User, RegisterParams> {
  const Register(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User>> call(RegisterParams p) => _repository.register(
        name: p.name.trim(),
        email: p.email.trim(),
        phone: p.phone.trim(),
        password: p.password,
        passwordConfirmation: p.passwordConfirmation,
      );
}

class GetCurrentUser implements UseCase<User, NoParams> {
  const GetCurrentUser(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User>> call([NoParams params = const NoParams()]) => _repository.me();
}

class UpdateProfileParams {
  const UpdateProfileParams({required this.name, required this.phone});
  final String name;
  final String phone;
}

class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  const UpdateProfile(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User>> call(UpdateProfileParams p) =>
      _repository.updateProfile(name: p.name.trim(), phone: p.phone.trim());
}

class Logout implements UseCase<void, NoParams> {
  const Logout(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<void>> call([NoParams params = const NoParams()]) async {
    await _repository.logout();
    return const Result.success(null);
  }
}
