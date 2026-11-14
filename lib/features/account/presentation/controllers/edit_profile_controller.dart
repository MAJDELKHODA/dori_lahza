import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/auth/domain/usecases/auth_usecases.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  EditProfileController({required UpdateProfile updateProfile, required SessionController session})
      : _update = updateProfile,
        _session = session;

  final UpdateProfile _update;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  late final name = TextEditingController(text: _session.user.value?.name);
  late final phone = TextEditingController(text: _session.user.value?.phone);
  final isSaving = false.obs;
  final fieldErrors = <String, String>{}.obs;

  String get email => _session.user.value?.email ?? '';

  String? validateName(String? v) =>
      (v?.trim().length ?? 0) < 2 ? 'أدخل اسمك الكامل' : fieldErrors['name'];

  String? validatePhone(String? v) {
    final digits = (v ?? '').replaceAll(RegExp(r'[^0-9+]'), '');
    return digits.length < 9 ? 'أدخل رقم هاتف صحيح' : fieldErrors['phone'];
  }

  Future<void> save() async {
    fieldErrors.clear();
    if (!(formKey.currentState?.validate() ?? false) || isSaving.value) return;
    isSaving.value = true;
    final result = await _update(UpdateProfileParams(name: name.text, phone: phone.text));
    isSaving.value = false;
    result.fold(
      (failure) {
        fieldErrors.assignAll(failure.fieldErrors);
        formKey.currentState?.validate();
        AppFeedback.failure(failure);
      },
      (user) {
        _session.updateUser(user);
        Get.back<void>();
        AppFeedback.success('تم حفظ التعديلات');
      },
    );
  }

  @override
  void onClose() {
    name.dispose();
    phone.dispose();
    super.onClose();
  }
}
