import 'package:dori_lahza/core/error/failure.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Transient feedback (snackbars) triggered by controllers after actions.
abstract final class AppFeedback {
  static void success(String message) => _show(message, Icons.check_circle_rounded);

  static void info(String message) => _show(message, Icons.info_rounded);

  static void error(String message) => _show(message, Icons.error_rounded);

  static void failure(Failure failure) => error(failure.message);

  static void _show(String message, IconData icon) {
    final context = Get.key.currentContext;
    final messenger = context == null ? null : ScaffoldMessenger.maybeOf(context);
    if (messenger == null || message.isEmpty) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
