import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/widgets/message_view.dart';
import 'package:dori_lahza/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      backgroundColor: p.surface,
      body: SafeArea(
        child: Obx(() {
          final failure = controller.failure.value;
          if (failure != null) {
            return ErrorView(failure: failure, onRetry: controller.start);
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.85, end: 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutBack,
                  builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
                  child: Image.asset('assets/images/lahza.png', width: 140, height: 140),
                ),
                const VSpace(Gap.xl),
                SizedBox.square(
                  dimension: 26,
                  child: CircularProgressIndicator(strokeWidth: 2.6, color: p.strong),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
