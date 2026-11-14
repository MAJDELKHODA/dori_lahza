import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/core/utils/polling.dart';
import 'package:dori_lahza/features/shell/presentation/controllers/shell_controller.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:dori_lahza/features/waitlist/domain/usecases/waitlist_usecases.dart';
import 'package:get/get.dart';

/// "قائمة الانتظار": my requests, active or all.
class WaitlistController extends GetxController {
  WaitlistController({required GetMyWaitlist getMyWaitlist, required LeaveWaitlist leaveWaitlist})
      : _get = getMyWaitlist,
        _leave = leaveWaitlist;

  final GetMyWaitlist _get;
  final LeaveWaitlist _leave;

  final state = Rx<ViewState<List<WaitlistEntry>>>(const ViewLoading());
  final activeOnly = true.obs;
  final leavingId = RxnInt();

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) state.value = const ViewLoading();
    state.value = ViewState.fromResult(await _get(activeOnly.value), isEmpty: (l) => l.isEmpty);
  }

  void setActiveOnly(bool value) {
    if (activeOnly.value == value) return;
    activeOnly.value = value;
    unawaited(load());
  }

  Future<void> leave(int id) async {
    leavingId.value = id;
    final result = await _leave(id);
    leavingId.value = null;
    result.fold(AppFeedback.failure, (_) {
      AppFeedback.success('غادرت قائمة الانتظار');
      unawaited(load(showLoading: false));
    });
  }
}

/// One request: live offer countdown, claim and leave. While waiting, the
/// status is re-checked every 30 s so a new offer shows up without a push.
class WaitlistEntryController extends GetxController {
  WaitlistEntryController({
    required this.entryId,
    required GetWaitlistEntry getEntry,
    required ClaimWaitlistOffer claimOffer,
    required LeaveWaitlist leaveWaitlist,
  })  : _get = getEntry,
        _claim = claimOffer,
        _leave = leaveWaitlist;

  final int entryId;
  final GetWaitlistEntry _get;
  final ClaimWaitlistOffer _claim;
  final LeaveWaitlist _leave;

  final state = Rx<ViewState<WaitlistEntry>>(const ViewLoading());
  final secondsLeft = 0.obs;
  final isClaiming = false.obs;
  final isLeaving = false.obs;

  late final Countdown _countdown = Countdown(
    onTick: (s) => secondsLeft.value = s,
    onDone: () => unawaited(load(showLoading: false)),
  );
  late final Poller _poller = Poller(interval: const Duration(seconds: 30), onTick: () => load(showLoading: false));

  WaitlistEntry? get entry => state.value.dataOrNull;

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) state.value = const ViewLoading();
    final result = await _get(entryId);
    if (result.isSuccess || entry == null) state.value = ViewState.fromResult(result);
    _sync(result.dataOrNull);
  }

  void _sync(WaitlistEntry? value) {
    if (value == null) return;
    if (value.hasLiveOffer) {
      _countdown.start(value.offer!.secondsLeft);
    } else {
      _countdown.cancel();
      secondsLeft.value = 0;
    }
    if (value.status == WaitlistStatus.waiting) {
      _poller.start(immediately: false);
    } else {
      _poller.stop();
    }
  }

  Future<void> claim() async {
    if (isClaiming.value || secondsLeft.value <= 0) return;
    isClaiming.value = true;
    final result = await _claim(entryId);
    isClaiming.value = false;
    await result.fold(
      (failure) async {
        AppFeedback.error(
          failure.hasCode(ErrorCodes.slotTaken) ? 'سبقك أحد إلى هذا الوقت، وما زلت في مكانك بالقائمة' : failure.message,
        );
        await load(showLoading: false);
      },
      (bookingId) async {
        AppFeedback.success('تم تحويل العرض إلى حجز 🎉');
        if (bookingId != null) {
          await AppNav.bookingCreatedById(bookingId);
        } else {
          Get.until((route) => route.isFirst);
          Get.find<ShellController>().open(ShellTab.bookings);
        }
      },
    );
  }

  Future<void> leave() async {
    if (isLeaving.value) return;
    isLeaving.value = true;
    final result = await _leave(entryId);
    isLeaving.value = false;
    result.fold(AppFeedback.failure, (_) {
      Get.back<bool>(result: true);
      AppFeedback.success('غادرت قائمة الانتظار');
    });
  }

  @override
  void onClose() {
    _countdown.cancel();
    _poller.dispose();
    super.onClose();
  }
}
