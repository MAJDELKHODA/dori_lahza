import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/services/services_controller.dart';
import '../controllers/services/services_binding.dart';
import '../controllers/team/team_binding.dart';
import '../widget/app_bottom_nav.dart';

import 'booking/my_bookings_screen.dart';
import 'home/home_screen.dart';
import 'services/services_screen.dart';
import 'live/live_screen.dart';
import 'account/account_screen.dart';
import 'team/team_screen.dart';
import '../controllers/auth/auth_controller.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    HomeScreen(
      onOpenServices: _openServices,
      onOpenCategory: _openCategory,
      onOpenTeam: _openTeam,
    ),
    const ServicesScreen(),
    Obx(
          () => MyBookingsScreen(
        isLoggedIn: Get.find<AuthController>().isLoggedIn.value,
      ),
    ),
    const LiveScreen(),
    const AccountScreen(),
  ];

  // Open Services Tab

  void _openServices() {
    setState(() {
      _currentIndex = 1;
    });
  }

  // Open Services With Selected Category

  void _openCategory(String categoryName) {
    if (!Get.isRegistered<ServicesController>()) {
      ServicesBinding().dependencies();
    }

    final controller = Get.find<ServicesController>();

    controller.selectCategory(categoryName);

    setState(() {
      _currentIndex = 1;
    });
  }

  // Open Team Screen

  void _openTeam() {
    Get.to(
      () => const TeamScreen(),
      binding: TeamBinding(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex == index) return;

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
