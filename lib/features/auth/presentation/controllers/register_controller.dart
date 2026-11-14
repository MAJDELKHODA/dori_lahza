import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/auth/domain/usecases/auth_usecases.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RegisterController({required Register register, required SessionController session})
      : _register = register,
        _session = session;

  final Register _register;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();

  final isSubmitting = false.obs;
  final obscurePassword = true.obs;
  final fieldErrors = <String, String>{}.obs;

  void togglePassword() => obscurePassword.toggle();

  String? validateName(String? v) =>
      (v?.trim().length ?? 0) < 2 ? 'أدخل اسمك الكامل' : fieldErrors['name'];

  String? validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!GetUtils.isEmail(value)) return 'صيغة البريد غير صحيحة';
    return fieldErrors['email'];
  }

  String? validatePhone(String? v) {
    final digits = (v ?? '').replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.length < 9) return 'أدخل رقم هاتف صحيح';
    return fieldErrors['phone'];
  }

  String? validatePassword(String? v) =>
      (v?.length ?? 0) < 8 ? 'كلمة المرور 8 أحرف على الأقل' : fieldErrors['password'];

  String? validateConfirmation(String? v) =>
      v != password.text ? 'كلمتا المرور غير متطابقتين' : fieldErrors['password_confirmation'];

  void clearFieldError(String field) {
    if (fieldErrors.remove(field) != null) formKey.currentState?.validate();
  }

  Future<void> submit() async {
    fieldErrors.clear();
    if (!(formKey.currentState?.validate() ?? false) || isSubmitting.value) return;
    isSubmitting.value = true;
    final result = await _register(
      RegisterParams(
        name: name.text,
        email: email.text,
        phone: phone.text,
        password: password.text,
        passwordConfirmation: confirmation.text,
      ),
    );
    isSubmitting.value = false;
    result.fold(_onFailure, (user) {
      _session.signedIn(user);
      AppFeedback.success('تم إنشاء حسابك، أهلًا ${user.name}');
      // Close register and the login screen beneath it, reporting success.
      Get.back<void>();
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
    for (final c in [name, email, phone, password, confirmation]) {
      c.dispose();
    }
    super.onClose();
  }
}
