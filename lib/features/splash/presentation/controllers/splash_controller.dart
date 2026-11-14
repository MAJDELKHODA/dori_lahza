import 'dart:async';

import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:get/get.dart';

/// Startup: ping → place (labels, colors, rules) → restore session → shell.
class SplashController extends GetxController {
  SplashController({required PlaceController place, required SessionController session})
      : _place = place,
        _session = session;

  final PlaceController _place;
  final SessionController _session;

  final failure = Rxn<Failure>();

  @override
  void onReady() {
    super.onReady();
    unawaited(start());
  }

  Future<void> start() async {
    failure.value = null;
    final (placeResult, _, _) = await (
      _place.load(),
      _session.restore(),
      // Keep the brand moment visible briefly even on fast networks.
      Future<void>.delayed(const Duration(milliseconds: 700)),
    ).wait;
    final error = placeResult.failureOrNull;
    if (error != null) {
      failure.value = error;
      return;
    }
    unawaited(Get.offAllNamed<void>(AppRoutes.shell));
  }
}
