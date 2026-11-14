import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/features/account/presentation/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الحساب')),
      bottomNavigationBar: BottomActionBar(
        child: Obx(() => LoadingButton(label: 'حفظ', loading: c.isSaving.value, onPressed: c.save)),
      ),
      body: Form(
        key: c.formKey,
        child: ListView(
          padding: const EdgeInsets.all(Gap.page),
          children: [
            TextFormField(
              controller: c.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'الاسم الكامل',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: c.validateName,
            ),
            const VSpace(Gap.md),
            TextFormField(
              controller: c.phone,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: c.validatePhone,
            ),
            const VSpace(Gap.md),
            TextFormField(
              initialValue: c.email,
              enabled: false,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                helperText: 'لا يمكن تغيير البريد الإلكتروني',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
