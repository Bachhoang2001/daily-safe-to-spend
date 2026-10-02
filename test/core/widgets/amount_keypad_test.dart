import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/widgets/amount_keypad.dart';

void main() {
  Widget buildHarness({
    required ValueChanged<Money> onChanged,
    int initialCents = 0,
    int maxCents = 99999999,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AmountKeypad(
          initialCents: initialCents,
          maxCents: maxCents,
          onChanged: onChanged,
        ),
      ),
    );
  }

  group('AmountKeypad (T04-3)', () {
    testWidgets(
      r'T04-3: typing 1, 2, 5, 0 shifts decimal: 1 -> 12 -> 125 -> 1250 cents ($12.50)',
      (tester) async {
        final emittedValues = <Money>[];

        await tester.pumpWidget(buildHarness(onChanged: emittedValues.add));

        // Tap '1'
        await tester.tap(find.text('1'));
        await tester.pumpAndSettle();
        expect(emittedValues.last.cents, 1);

        // Tap '2'
        await tester.tap(find.text('2'));
        await tester.pumpAndSettle();
        expect(emittedValues.last.cents, 12);

        // Tap '5'
        await tester.tap(find.text('5'));
        await tester.pumpAndSettle();
        expect(emittedValues.last.cents, 125);

        // Tap '0'
        await tester.tap(find.text('0'));
        await tester.pumpAndSettle();
        expect(emittedValues.last.cents, 1250);
        expect(emittedValues.last, const Money(1250));
      },
    );

    testWidgets(
      r'T04-3: tapping backspace drops last digit ($12.50 -> $1.25)',
      (tester) async {
        Money? latest;

        await tester.pumpWidget(
          buildHarness(
            initialCents: 1250,
            onChanged: (money) => latest = money,
          ),
        );

        // Tap backspace
        await tester.tap(find.byKey(const Key('amount_keypad_backspace')));
        await tester.pumpAndSettle();

        expect(latest?.cents, 125);
      },
    );

    testWidgets(r'T04-3: long pressing backspace clears to zero ($0.00)', (
      tester,
    ) async {
      Money? latest;

      await tester.pumpWidget(
        buildHarness(initialCents: 1250, onChanged: (money) => latest = money),
      );

      // Long press backspace
      await tester.longPress(find.byKey(const Key('amount_keypad_backspace')));
      await tester.pumpAndSettle();

      expect(latest?.cents, 0);
    });

    testWidgets('T04-3: tapping 00 multiplies by 100', (tester) async {
      Money? latest;

      await tester.pumpWidget(
        buildHarness(initialCents: 125, onChanged: (money) => latest = money),
      );

      await tester.tap(find.text('00'));
      await tester.pumpAndSettle();

      expect(latest?.cents, 12500);
    });

    testWidgets('T04-3: typing does not exceed maxCents limit (99,999,999)', (
      tester,
    ) async {
      Money? latest;

      await tester.pumpWidget(
        buildHarness(
          initialCents: 99999990,
          onChanged: (money) => latest = money,
        ),
      );

      // Tapping '9' would make 999999909 > 99999999
      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();

      expect(latest?.cents ?? 99999990, lessThanOrEqualTo(99999999));
    });

    testWidgets('T04-3: all keypad buttons have accessible semantics labels', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness(onChanged: (_) {}));

      expect(find.bySemanticsLabel('1'), findsOneWidget);
      expect(find.bySemanticsLabel('2'), findsOneWidget);
      expect(find.bySemanticsLabel('3'), findsOneWidget);
      expect(find.bySemanticsLabel('4'), findsOneWidget);
      expect(find.bySemanticsLabel('5'), findsOneWidget);
      expect(find.bySemanticsLabel('6'), findsOneWidget);
      expect(find.bySemanticsLabel('7'), findsOneWidget);
      expect(find.bySemanticsLabel('8'), findsOneWidget);
      expect(find.bySemanticsLabel('9'), findsOneWidget);
      expect(find.bySemanticsLabel('0'), findsOneWidget);
      expect(find.bySemanticsLabel('Double zero'), findsOneWidget);
      expect(find.bySemanticsLabel('Backspace'), findsOneWidget);
    });

    testWidgets(
      'T04-3: when enabled is false, tapping digits or backspace does nothing',
      (tester) async {
        final emittedValues = <Money>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AmountKeypad(
                enabled: false,
                initialCents: 500,
                onChanged: emittedValues.add,
              ),
            ),
          ),
        );

        // Tap '1'
        await tester.tap(find.text('1'));
        await tester.pumpAndSettle();
        expect(emittedValues, isEmpty);

        // Tap backspace
        await tester.tap(find.byKey(const Key('amount_keypad_backspace')));
        await tester.pumpAndSettle();
        expect(emittedValues, isEmpty);

        // Long press backspace
        await tester.longPress(
          find.byKey(const Key('amount_keypad_backspace')),
        );
        await tester.pumpAndSettle();
        expect(emittedValues, isEmpty);
      },
    );
  });
}
