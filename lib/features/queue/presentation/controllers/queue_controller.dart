import 'dart:async';

import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/core/utils/polling.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/queue/domain/entities/queue.dart';
import 'package:dori_lahza/features/queue/domain/usecases/queue_usecases.dart';
import 'package:dori_lahza/features/shell/presentation/controllers/shell_controller.dart';
import 'package:get/get.dart';

/// Live queue tab. Polls the board (and my ticket, when signed in) every
/// 20 s, only while this tab is visible and the app is in the foreground.
class QueueController extends GetxController {
  QueueController({
    required GetQueueBoard getBoard,
    required GetMyTicket getMyTicket,
    required TakeQueueTicket takeTicket,
    required CancelQueueTicket cancelTicket,
    required SessionController session,
    required ShellController shell,
  })  : _getBoard = getBoard,
        _getMyTicket = getMyTicket,
        _take = takeTicket,
        _cancel = cancelTicket,
        _session = session,
        _shell = shell;

  static const pollInterval = Duration(seconds: 20);

  final GetQueueBoard _getBoard;
  final GetMyTicket _getMyTicket;
  final TakeQueueTicket _take;
  final CancelQueueTicket _cancel;
  final SessionController _session;
  final ShellController _shell;

  final board = Rx<ViewState<QueueBoard>>(const ViewLoading());
  final myTicket = Rxn<QueueTicket>();
  final isTaking = false.obs;
  final isCancelling = false.obs;
  final lastUpdated = Rxn<DateTime>();

  late final Poller _poller = Poller(interval: pollInterval, onTick: refreshAll);
  final _workers = <Worker>[];

  bool get isSignedIn => _session.isSignedIn;

  @override
  void onInit() {
    super.onInit();
    _workers
      ..add(ever(_shell.current, (_) => _syncPolling()))
      ..add(ever(_session.user, (_) => unawaited(_loadTicket())));
  }

  @override
  void onReady() {
    super.onReady();
    _syncPolling();
  }

  void _syncPolling() {
    if (_shell.current.value == ShellTab.queue) {
      _poller.start();
    } else {
      _poller.stop();
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([_loadBoard(), _loadTicket()]);
    lastUpdated.value = DateTime.now();
  }

  Future<void> retry() async {
    board.value = const ViewLoading();
    await refreshAll();
  }

  Future<void> _loadBoard() async {
    final result = await _getBoard();
    // Keep the last good board on a transient polling failure.
    if (result.isSuccess || board.value is! ViewSuccess) board.value = ViewState.fromResult(result);
  }

  Future<void> _loadTicket() async {
    if (!isSignedIn) {
      myTicket.value = null;
      return;
    }
    final result = await _getMyTicket();
    result.fold((_) {}, (t) => myTicket.value = (t != null && t.isActive) ? t : null);
  }

  Future<void> takeTicket() async {
    if (isTaking.value) return;
    if (!await _session.ensureSignedIn()) return;
    isTaking.value = true;
    final result = await _take();
    isTaking.value = false;
    final ticket = result.dataOrNull;
    if (ticket == null) {
      AppFeedback.failure(result.failureOrNull!);
      return;
    }
    myTicket.value = ticket;
    AppFeedback.success('رقمك ${ticket.label}');
    await _loadBoard();
  }

  Future<void> cancelTicket() async {
    final ticket = myTicket.value;
    if (ticket == null || isCancelling.value) return;
    isCancelling.value = true;
    final result = await _cancel(ticket.id);
    isCancelling.value = false;
    if (result.failureOrNull case final failure?) {
      AppFeedback.failure(failure);
      return;
    }
    myTicket.value = null;
    AppFeedback.success('تم إلغاء رقمك');
    await _loadBoard();
  }

  @override
  void onClose() {
    for (final w in _workers) {
      w.dispose();
    }
    _poller.dispose();
    super.onClose();
  }
}
