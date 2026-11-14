import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/auth/domain/usecases/auth_usecases.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController({required Login login, required SessionController session})
      : _login = login,
        _session = session;

  final Login _login;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  final isSubmitting = false.obs;
  final obscurePassword = true.obs;
  final fieldErrors = <String, String>{}.obs;

  void togglePassword() => obscurePassword.toggle();

  String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!GetUtils.isEmail(v)) return 'صيغة البريد غير صحيحة';
    return fieldErrors['email'];
  }

  String? validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'كلمة المرور مطلوبة';
    return fieldErrors['password'];
  }

  void clearFieldError(String field) {
    if (fieldErrors.remove(field) != null) formKey.currentState?.validate();
  }

  Future<void> submit() async {
    fieldErrors.clear();
    if (!(formKey.currentState?.validate() ?? false) || isSubmitting.value) return;
    isSubmitting.value = true;
    final result = await _login(LoginParams(email: email.text, password: password.text));
    isSubmitting.value = false;
    result.fold(_onFailure, (user) {
      _session.signedIn(user);
      AppFeedback.success('أهلًا ${user.name}');
      Get.back<bool>(result: true);
    });
  }

  void _onFailure(Failure failure) {
    if (failure.fieldErrors.isNotEmpty) {
      fieldErrors.assignAll(failure.fieldErrors);
      formKey.currentState?.validate();
    }
    AppFeedback.failure(failure);
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
