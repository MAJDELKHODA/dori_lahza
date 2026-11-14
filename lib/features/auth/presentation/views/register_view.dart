import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/register_controller.dart';
import 'package:dori_lahza/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return AuthScaffold(
      title: 'إنشاء حساب',
      subtitle: 'حساب واحد لحجز المواعيد ومتابعتها وتلقي التنبيهات',
      children: [
        Form(
          key: c.formKey,
          child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  controller: c.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: c.validateName,
                  onChanged: (_) => c.clearFieldError('name'),
                ),
                const VSpace(Gap.md),
                TextFormField(
                  controller: c.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.alternate_email_rounded),
                  ),
                  validator: c.validateEmail,
                  onChanged: (_) => c.clearFieldError('email'),
                ),
                const VSpace(Gap.md),
                TextFormField(
                  controller: c.phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                    hintText: '05xxxxxxxx',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: c.validatePhone,
                  onChanged: (_) => c.clearFieldError('phone'),
                ),
                const VSpace(Gap.md),
                Obx(
                  () => TextFormField(
                    controller: c.password,
                    obscureText: c.obscurePassword.value,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        tooltip: 'إظهار كلمة المرور',
                        onPressed: c.togglePassword,
                        icon: Icon(
                          c.obscurePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: c.validatePassword,
                    onChanged: (_) => c.clearFieldError('password'),
                  ),
                ),
                const VSpace(Gap.md),
                Obx(
                  () => TextFormField(
                    controller: c.confirmation,
                    obscureText: c.obscurePassword.value,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
                      prefixIcon: Icon(Icons.lock_reset_rounded),
                    ),
                    validator: c.validateConfirmation,
                    onFieldSubmitted: (_) => c.submit(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const VSpace(Gap.xl),
        Obx(() => LoadingButton(label: 'إنشاء الحساب', loading: c.isSubmitting.value, onPressed: c.submit)),
      ],
    );
  }
}
