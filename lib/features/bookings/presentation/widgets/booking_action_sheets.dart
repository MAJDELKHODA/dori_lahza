import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/layout.dart';
import 'package:dori_lahza/core/widgets/media.dart';
import 'package:dori_lahza/features/bookings/presentation/controllers/booking_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Cancel confirmation with a reason and the late-cancellation warning.
class CancelBookingSheet extends StatefulWidget {
  const CancelBookingSheet({super.key, required this.controller, required this.isLate});

  final BookingDetailsController controller;
  final bool isLate;

  static const reasons = ['ظرف طارئ', 'تغيّر موعدي', 'وجدت موعدًا أنسب', 'لم أعد بحاجة للخدمة'];

  @override
  State<CancelBookingSheet> createState() => _CancelBookingSheetState();
}

/// Local state is only the in-progress form input of this sheet.
class _CancelBookingSheetState extends State<CancelBookingSheet> {
  final _other = TextEditingController();
  String? _reason;

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  String? get _finalReason => _reason == 'other' ? _other.text.trim() : _reason;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SheetBody(
      title: 'إلغاء الحجز',
      subtitle: 'ما سبب الإلغاء؟',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.isLate) ...[
            Container(
              padding: const EdgeInsets.all(Gap.sm),
              decoration: BoxDecoration(color: p.warningSoft, borderRadius: BorderRadius.circular(Radii.md)),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: p.warning),
                  const HSpace(Gap.xs),
                  Expanded(
                    child: Text(
                      'هذا إلغاء متأخر${widget.controller.cancelBeforeHours > 0 ? ' (أقل من ${widget.controller.cancelBeforeHours} ساعة قبل الموعد)' : ''} وسيخفّض مؤشر التزامك.',
                      style: context.text.bodySmall?.copyWith(color: p.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const VSpace(Gap.md),
          ],
          Wrap(
            spacing: Gap.xs,
            runSpacing: Gap.xs,
            children: [
              for (final r in CancelBookingSheet.reasons)
                ChoiceChip(label: Text(r), selected: _reason == r, onSelected: (_) => setState(() => _reason = r)),
              ChoiceChip(
                label: const Text('سبب آخر'),
                selected: _reason == 'other',
                onSelected: (_) => setState(() => _reason = 'other'),
              ),
            ],
          ),
          if (_reason == 'other') ...[
            const VSpace(Gap.sm),
            TextField(controller: _other, maxLines: 2, decoration: const InputDecoration(hintText: 'اكتب السبب')),
          ],
          const VSpace(Gap.lg),
          Obx(
            () => LoadingButton(
              label: 'تأكيد الإلغاء',
              destructive: true,
              loading: widget.controller.isCancelling.value,
              onPressed: () async {
                final ok = await widget.controller.cancel(_finalReason);
                if (ok && context.mounted) Navigator.pop(context);
              },
            ),
          ),
          const VSpace(Gap.xs),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('تراجع')),
        ],
      ),
    );
  }
}

/// Star rating + comment after a completed visit.
class ReviewBookingSheet extends StatefulWidget {
  const ReviewBookingSheet({super.key, required this.controller});

  final BookingDetailsController controller;

  @override
  State<ReviewBookingSheet> createState() => _ReviewBookingSheetState();
}

class _ReviewBookingSheetState extends State<ReviewBookingSheet> {
  final _comment = TextEditingController();
  int _rating = 0;

  static const _hints = ['', 'سيئة', 'مقبولة', 'جيدة', 'جيدة جدًا', 'ممتازة'];

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SheetBody(
      title: 'قيّم زيارتك',
      subtitle: 'رأيك يساعدنا ويساعد غيرك',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RatingInput(value: _rating, onChanged: (v) => setState(() => _rating = v)),
          SizedBox(
            height: 24,
            child: Text(_hints[_rating], textAlign: TextAlign.center, style: context.text.labelLarge),
          ),
          const VSpace(Gap.sm),
          TextField(
            controller: _comment,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'اكتب تعليقك (اختياري)'),
          ),
          const VSpace(Gap.lg),
          Obx(
            () => LoadingButton(
              label: 'إرسال التقييم',
              loading: widget.controller.isReviewing.value,
              onPressed: _rating == 0
                  ? null
                  : () async {
                      final ok = await widget.controller.submitReview(_rating, _comment.text);
                      if (ok && context.mounted) Navigator.pop(context);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
