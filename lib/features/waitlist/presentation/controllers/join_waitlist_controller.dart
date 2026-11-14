import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:dori_lahza/features/waitlist/domain/usecases/waitlist_usecases.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Join the waitlist for a full day, optionally within a time window.
class JoinWaitlistController extends GetxController {
  JoinWaitlistController({
    required this.serviceId,
    required this.date,
    this.staffId,
    required JoinWaitlist joinWaitlist,
  }) : _join = joinWaitlist;

  final int serviceId;
  final String date;
  final int? staffId;
  final JoinWaitlist _join;

  final fromTime = Rxn<TimeOfDay>();
  final toTime = Rxn<TimeOfDay>();
  final notes = TextEditingController();
  final isSubmitting = false.obs;
  final rangeError = RxnString();

  void setFrom(TimeOfDay? value) {
    fromTime.value = value;
    _validateRange();
  }

  void setTo(TimeOfDay? value) {
    toTime.value = value;
    _validateRange();
  }

  bool _validateRange() {
    final from = fromTime.value;
    final to = toTime.value;
    final invalid = from != null && to != null && (to.hour * 60 + to.minute) <= (from.hour * 60 + from.minute);
    rangeError.value = invalid ? 'وقت النهاية يجب أن يكون بعد البداية' : null;
    return !invalid;
  }

  Future<void> submit() async {
    if (!_validateRange() || isSubmitting.value) return;
    isSubmitting.value = true;
    final result = await _join(
      JoinWaitlistRequest(
        serviceId: serviceId,
        date: date,
        staffId: staffId,
        fromTime: _fmt(fromTime.value),
        toTime: _fmt(toTime.value),
        notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
      ),
    );
    isSubmitting.value = false;
    result.fold(AppFeedback.failure, (_) {
      Get.back<void>();
      AppFeedback.success('انضممت لقائمة الانتظار، سنرسل لك إشعارًا عند توفر وقت');
      Get.toNamed<void>(AppRoutes.waitlist);
    });
  }

  static String? _fmt(TimeOfDay? t) =>
      t == null ? null : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  void onClose() {
    notes.dispose();
    super.onClose();
  }
}
