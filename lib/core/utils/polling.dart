import 'dart:async';

import 'package:flutter/widgets.dart';

/// Periodic task that pauses while the app is in the background.
///
/// Used by the live queue (every 20 s). Call [start] in `onReady` and
/// [dispose] in `onClose`.
class Poller with WidgetsBindingObserver {
  Poller({required this.interval, required this.onTick});

  final Duration interval;
  final Future<void> Function() onTick;

  Timer? _timer;
  bool _running = false;
  bool _busy = false;

  void start({bool immediately = true}) {
    if (_running) return;
    _running = true;
    WidgetsBinding.instance.addObserver(this);
    if (immediately) unawaited(_tick());
    _schedule();
  }

  void stop() {
    _running = false;
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  void dispose() => stop();

  void _schedule() {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _tick());
  }

  Future<void> _tick() async {
    if (_busy) return;
    _busy = true;
    try {
      await onTick();
    } finally {
      _busy = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_running) return;
    if (state == AppLifecycleState.resumed) {
      unawaited(_tick());
      _schedule();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _timer?.cancel();
    }
  }
}

/// One-second countdown, e.g. for a waitlist offer's `seconds_left`.
class Countdown {
  Countdown({required this.onTick, required this.onDone});

  final void Function(int secondsLeft) onTick;
  final void Function() onDone;
  Timer? _timer;
  DateTime? _deadline;

  void start(int seconds) {
    cancel();
    _deadline = DateTime.now().add(Duration(seconds: seconds));
    onTick(seconds);
    if (seconds <= 0) {
      onDone();
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Derived from the deadline so a paused isolate does not drift.
      final left = _deadline!.difference(DateTime.now()).inSeconds;
      onTick(left < 0 ? 0 : left);
      if (left <= 0) {
        cancel();
        onDone();
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
