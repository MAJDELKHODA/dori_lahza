import 'package:get/get.dart';

import '../../core/storage/token_storage.dart';
import '../../core/network/api_exceptions.dart';
import '../../data/auth/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;
  final TokenStorage _tokenStorage;

  AuthController({
    required AuthRepository repository,
    required TokenStorage tokenStorage,
  }) : _repository = repository,
       _tokenStorage = tokenStorage;

  final Rxn<UserModel> user = Rxn<UserModel>();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isCheckingSession = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  // Restore Session

  Future<void> restoreSession() async {
    try {
      isCheckingSession.value = true;

      final token = await _tokenStorage.getToken();

      if (token == null || token.isEmpty) {
        user.value = null;
        isLoggedIn.value = false;
        return;
      }

      final result = await _repository.getCurrentUser();

      user.value = result;
      isLoggedIn.value = true;
    } catch (_) {
      user.value = null;
      isLoggedIn.value = false;
    } finally {
      isCheckingSession.value = false;
    }
  }

  // Register

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      user.value = result;
      isLoggedIn.value = true;

      return true;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (_) {
      errorMessage.value = 'حدث خطأ أثناء إنشاء الحساب';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login

  Future<bool> login({required String email, required String password}) async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.login(email: email, password: password);

      user.value = result;
      isLoggedIn.value = true;

      return true;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (_) {
      errorMessage.value = 'حدث خطأ أثناء تسجيل الدخول';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout

  Future<void> logout() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _repository.logout();
    } catch (_) {
      errorMessage.value = 'تعذر الاتصال بالسيرفر';
      rethrow;
    } finally {
      user.value = null;
      isLoggedIn.value = false;
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedUser = await _repository.updateProfile(
        name: name,
        phone: phone,
      );

      user.value = updatedUser;

      return true;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (_) {
      errorMessage.value = 'حدث خطأ أثناء تحديث الحساب';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
