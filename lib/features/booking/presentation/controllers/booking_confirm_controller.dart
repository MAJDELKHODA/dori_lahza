import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/booking/domain/entities/booking_failures.dart';
import 'package:dori_lahza/features/booking/domain/repositories/booking_repository.dart';
import 'package:dori_lahza/features/booking/domain/usecases/booking_usecases.dart';
import 'package:dori_lahza/features/booking/presentation/models/booking_draft.dart';
import 'package:dori_lahza/features/booking/presentation/widgets/alternatives_sheet.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Confirm step: intake answers, notes, coupon, then `POST /bookings`.
class BookingConfirmController extends GetxController {
  BookingConfirmController({
    required BookingDraft draft,
    required CheckCoupon checkCoupon,
    required CreateBooking createBooking,
    required PlaceController place,
    required SessionController session,
  })  : draft = draft.obs,
        _checkCoupon = checkCoupon,
        _create = createBooking,
        _place = place,
        _session = session;

  final Rx<BookingDraft> draft;
  final CheckCoupon _checkCoupon;
  final CreateBooking _create;
  final PlaceController _place;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final notes = TextEditingController();
  final couponText = TextEditingController();

  /// Text controllers for text-like intake fields, keyed by field key.
  final Map<String, TextEditingController> textAnswers = {};

  /// Values of select / checkbox / date intake fields.
  final choiceAnswers = <String, Object?>{}.obs;

  final coupon = Rxn<CouponQuote>();
  final couponError = RxnString();
  final isCheckingCoupon = false.obs;
  final isSubmitting = false.obs;

  List<IntakeField> get intakeFields => _place.rules.intakeFields;
  bool get autoConfirm => _place.rules.autoConfirm;

  double get subtotal => draft.value.service.finalPrice;
  double get discount => coupon.value?.discount ?? 0;
  double get total => coupon.value?.finalPrice ?? subtotal;

  @override
  void onInit() {
    super.onInit();
    for (final f in intakeFields) {
      if (f.type != IntakeFieldType.select && f.type != IntakeFieldType.checkbox && f.type != IntakeFieldType.date) {
        textAnswers[f.key] = TextEditingController();
      }
    }
  }

  void setChoice(String key, Object? value) => choiceAnswers[key] = value;

  String? validateField(IntakeField field, String? value) {
    if (!field.required) return null;
    final v = switch (field.type) {
      IntakeFieldType.select || IntakeFieldType.date => choiceAnswers[field.key]?.toString(),
      IntakeFieldType.checkbox => choiceAnswers[field.key] == true ? 'yes' : null,
      _ => value,
    };
    return (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;
  }

  Future<void> applyCoupon() async {
    final code = couponText.text.trim();
    if (code.isEmpty || isCheckingCoupon.value) return;
    if (!await _session.ensureSignedIn()) return;
    isCheckingCoupon.value = true;
    couponError.value = null;
    final result = await _checkCoupon((code: code, serviceId: draft.value.service.id));
    isCheckingCoupon.value = false;
    result.fold(
      (failure) {
        coupon.value = null;
        couponError.value = failure.fieldErrors['code'] ?? failure.message;
      },
      (quote) => coupon.value = quote,
    );
  }

  void removeCoupon() {
    coupon.value = null;
    couponError.value = null;
    couponText.clear();
  }

  Future<void> confirm() async {
    if (!(formKey.currentState?.validate() ?? true) || isSubmitting.value) return;
    if (!await _session.ensureSignedIn()) return;
    isSubmitting.value = true;
    final d = draft.value;
    final result = await _create(
      NewBooking(
        serviceId: d.service.id,
        staffId: d.staffId,
        startsAt: d.slot.startsAt,
        notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
        answers: _answers(),
        couponCode: coupon.value?.code,
      ),
    );
    isSubmitting.value = false;
    await result.fold(
      (failure) async {
        if (failure is SlotUnavailableFailure) {
          await _offerAlternatives(failure);
        } else {
          AppFeedback.failure(failure);
        }
      },
      (booking) async {
        AppFeedback.success(booking.statusLabel.isEmpty ? 'تم الحجز بنجاح' : 'تم الحجز · ${booking.statusLabel}');
        await AppNav.bookingCreated(booking);
      },
    );
  }

  Future<void> _offerAlternatives(SlotUnavailableFailure failure) async {
    final picked = await Get.bottomSheet<Slot>(
      AlternativesSheet(message: failure.message, alternatives: failure.alternatives),
      isScrollControlled: true,
    );
    if (picked == null) return;
    draft.value = draft.value.withSlot(picked);
    await confirm();
  }

  Map<String, Object?> _answers() => {
        for (final e in textAnswers.entries)
          if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim(),
        for (final e in choiceAnswers.entries)
          if (e.value != null) e.key: e.value,
      };

  @override
  void onClose() {
    notes.dispose();
    couponText.dispose();
    for (final c in textAnswers.values) {
      c.dispose();
    }
    super.onClose();
  }
}
