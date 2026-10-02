import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/features/root/controllers/root_shell_controller.dart';

void main() {
  group('RootShellController (T04-2)', () {
    late RootShellController controller;

    setUp(() {
      controller = RootShellController();
    });

    test('T04-2: initial tab index is 0 (Today tab)', () {
      expect(controller.tabIndex.value, 0);
    });

    test(
      'T04-2: changeTab updates tabIndex to valid tabs (1 = History, 2 = Plan, 0 = Today)',
      () {
        controller.changeTab(1);
        expect(controller.tabIndex.value, 1);

        controller.changeTab(2);
        expect(controller.tabIndex.value, 2);

        controller.changeTab(0);
        expect(controller.tabIndex.value, 0);
      },
    );

    test(
      'T04-2: changeTab ignores invalid tab indices (< 0 or > 2) to preserve state',
      () {
        controller.changeTab(1);
        expect(controller.tabIndex.value, 1);

        controller.changeTab(-1);
        expect(controller.tabIndex.value, 1);

        controller.changeTab(3);
        expect(controller.tabIndex.value, 1);
      },
    );

    test('T04-2: tabIndex is reactive and emits updates to listeners', () {
      var emittedIndex = -1;
      final subscription = controller.tabIndex.listen((index) {
        emittedIndex = index;
      });

      controller.changeTab(2);
      expect(emittedIndex, 2);

      subscription.cancel();
    });
  });
}
