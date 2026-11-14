import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/login_controller.dart';
import 'package:dori_lahza/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final place = Get.find<PlaceController>();
    return AuthScaffold(
      title: 'تسجيل الدخول',
      subtitle: 'أهلًا بك في ${place.place.value?.name ?? 'لحظة'}، سجّل دخولك لإدارة حجوزاتك',
      children: [
        Form(
          key: controller.formKey,
          child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.alternate_email_rounded),
                  ),
                  validator: controller.validateEmail,
                  onChanged: (_) => controller.clearFieldError('email'),
                ),
                const VSpace(Gap.md),
                Obx(
                  () => TextFormField(
                    controller: controller.password,
                    obscureText: controller.obscurePassword.value,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        tooltip: 'إظهار كلمة المرور',
                        onPressed: controller.togglePassword,
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: controller.validatePassword,
                    onChanged: (_) => controller.clearFieldError('password'),
                    onFieldSubmitted: (_) => controller.submit(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const VSpace(Gap.xl),
        Obx(
          () => LoadingButton(
            label: 'دخول',
            loading: controller.isSubmitting.value,
            onPressed: controller.submit,
          ),
        ),
        const VSpace(Gap.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ليس لديك حساب؟', style: context.text.bodyMedium?.copyWith(color: context.palette.textSecondary)),
            TextButton(
              onPressed: () => Get.toNamed<void>(AppRoutes.register),
              child: const Text('أنشئ حسابًا'),
            ),
          ],
        ),
      ],
    );
  }
}
