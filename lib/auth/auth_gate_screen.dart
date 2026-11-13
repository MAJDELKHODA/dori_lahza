import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth/auth_controller.dart';
import '../routes/app_routes.dart';
import '../utils/app_colors.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  bool _navigationStarted = false;

  @override
  void initState() {
    super.initState();

    final controller = Get.find<AuthController>();

    ever<bool>(controller.isCheckingSession, (checking) {
      if (!checking) {
        _navigateUser(controller);
      }
    });

    if (!controller.isCheckingSession.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateUser(controller);
      });
    }
  }

  void _navigateUser(AuthController controller) {
    if (!mounted || _navigationStarted) return;

    _navigationStarted = true;

    final destination = AppRoutes.main;

    Get.offAllNamed(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
