import 'package:get/get.dart';

enum ShellTab { home, services, bookings, queue, account }

/// Bottom navigation state. Other features switch tabs through [open].
class ShellController extends GetxController {
  final current = ShellTab.home.obs;

  /// Tabs built at least once; unvisited tabs are not built, so their
  /// controllers do not fetch until first opened.
  final visited = <ShellTab>{ShellTab.home}.obs;

  void open(ShellTab tab) {
    visited.add(tab);
    current.value = tab;
  }

  /// Android back: return to home before leaving the app.
  bool handleBack() {
    if (current.value == ShellTab.home) return true;
    open(ShellTab.home);
    return false;
  }
}
