import 'package:get/get.dart';

/// Controller managing the root shell's active tab index and tab transitions.
class RootShellController extends GetxController {
  /// The currently active tab index (0: Today, 1: History, 2: Plan).
  final RxInt tabIndex = 0.obs;

  /// Changes the active tab index if [index] is within valid bounds (0..2).
  void changeTab(int index) {
    if (index >= 0 && index <= 2) {
      tabIndex.value = index;
    }
  }
}
