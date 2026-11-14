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

  /// Closes the sheet with `true` on success; the caller navigates once the
  /// sheet has fully animated out.
  Future<void> submit(String notes) async {
    if (!_validateRange() || isSubmitting.value) return;
    isSubmitting.value = true;
    final result = await _join(
      JoinWaitlistRequest(
        serviceId: serviceId,
        date: date,
        staffId: staffId,
        fromTime: _fmt(fromTime.value),
        toTime: _fmt(toTime.value),
        notes: notes.trim().isEmpty ? null : notes.trim(),
      ),
    );
    isSubmitting.value = false;
    result.fold(AppFeedback.failure, (_) => Get.back<bool>(result: true));
  }

  static String? _fmt(TimeOfDay? t) =>
      t == null ? null : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
