import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/features/booking/presentation/controllers/booking_confirm_controller.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// One input for a `booking.intake_fields` entry, by type.
class IntakeFieldInput extends StatelessWidget {
  const IntakeFieldInput({super.key, required this.field, required this.controller});

  final IntakeField field;
  final BookingConfirmController controller;

  String get _label => field.required ? '${field.label} *' : field.label;

  @override
  Widget build(BuildContext context) {
    return switch (field.type) {
      IntakeFieldType.select => Obx(
          () => DropdownButtonFormField<String>(
            initialValue: controller.choiceAnswers[field.key] as String?,
            isExpanded: true,
            decoration: InputDecoration(labelText: _label, helperText: field.help),
            items: [
              for (final o in field.options) DropdownMenuItem(value: o.value, child: Text(o.label)),
            ],
            onChanged: (v) => controller.setChoice(field.key, v),
            validator: (_) => controller.validateField(field, null),
          ),
        ),
      IntakeFieldType.checkbox => FormField<bool>(
          validator: (_) => controller.validateField(field, null),
          builder: (state) => Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: controller.choiceAnswers[field.key] == true,
                  onChanged: (v) {
                    controller.setChoice(field.key, v ?? false);
                    state.didChange(v);
                  },
                  title: Text(_label, style: context.text.bodyMedium),
                  subtitle: field.help == null ? null : Text(field.help!),
                ),
                if (state.hasError)
                  Text(state.errorText!, style: context.text.bodySmall?.copyWith(color: context.palette.danger)),
              ],
            ),
          ),
        ),
      IntakeFieldType.date => FormField<String>(
          validator: (_) => controller.validateField(field, null),
          builder: (state) => Obx(() {
            final value = controller.choiceAnswers[field.key] as String?;
            return InkWell(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 100),
                  lastDate: DateTime(now.year + 2),
                  initialDate: DateTime.tryParse(value ?? '') ?? now,
                );
                if (picked != null) {
                  controller.setChoice(field.key, Fmt.apiDate(picked));
                  state.didChange(Fmt.apiDate(picked));
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: _label,
                  helperText: field.help,
                  errorText: state.errorText,
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                ),
                child: Text(value == null ? '' : Fmt.fullDate(DateTime.parse(value))),
              ),
            );
          }),
        ),
      _ => TextFormField(
          controller: controller.textAnswers[field.key],
          maxLines: field.type == IntakeFieldType.textarea ? 3 : 1,
          keyboardType: switch (field.type) {
            IntakeFieldType.number => TextInputType.number,
            IntakeFieldType.phone => TextInputType.phone,
            IntakeFieldType.email => TextInputType.emailAddress,
            IntakeFieldType.textarea => TextInputType.multiline,
            _ => TextInputType.text,
          },
          inputFormatters: field.type == IntakeFieldType.number ? [FilteringTextInputFormatter.digitsOnly] : null,
          decoration: InputDecoration(labelText: _label, hintText: field.placeholder, helperText: field.help),
          validator: (v) => controller.validateField(field, v),
        ),
    };
  }
}
