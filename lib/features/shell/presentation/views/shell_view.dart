import 'package:dori_lahza/features/account/presentation/views/account_view.dart';
import 'package:dori_lahza/features/bookings/presentation/views/my_bookings_view.dart';
import 'package:dori_lahza/features/home/presentation/views/home_view.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/services/presentation/views/services_view.dart';
import 'package:dori_lahza/features/shell/presentation/controllers/shell_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _TabSpec {
  const _TabSpec(this.tab, this.icon, this.selectedIcon, this.label, this.builder);

  final ShellTab tab;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Widget Function() builder;
}

/// Bottom-navigation shell. Each tab keeps its state (IndexedStack) and is
/// built only after its first visit.
class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = Get.find<PlaceController>().labels;
    final tabs = [
      const _TabSpec(ShellTab.home, Icons.home_outlined, Icons.home_rounded, 'الرئيسية', HomeView.new),
      _TabSpec(
        ShellTab.services,
        Icons.grid_view_outlined,
        Icons.grid_view_rounded,
        labels.servicePlural,
        ServicesView.new,
      ),
      const _TabSpec(
        ShellTab.bookings,
        Icons.event_note_outlined,
        Icons.event_note_rounded,
        'حجوزاتي',
        MyBookingsView.new,
      ),
      const _TabSpec(ShellTab.account, Icons.person_outline_rounded, Icons.person_rounded, 'حسابي', AccountView.new),
    ];

    return Obx(() {
      final current = controller.current.value;
      final index = tabs.indexWhere((t) => t.tab == current).clamp(0, tabs.length - 1);
      return PopScope(
        canPop: current == ShellTab.home,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) controller.handleBack();
        },
        child: Scaffold(
          body: IndexedStack(
            index: index,
            children: [
              for (final t in tabs)
                controller.visited.contains(t.tab) ? t.builder() : const SizedBox.shrink(),
            ],
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
            ),
            child: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) => controller.open(tabs[i].tab),
              destinations: [
                for (final t in tabs)
                  NavigationDestination(icon: Icon(t.icon), selectedIcon: Icon(t.selectedIcon), label: t.label),
              ],
            ),
          ),
        ),
      );
    });
  }
}
