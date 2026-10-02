import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/widgets/amount_text.dart';

void main() {
  Widget buildHarness({
    required Money amount,
    BudgetStatus? status,
    bool showSign = false,
    TextStyle? style,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AmountText(
          amount: amount,
          status: status,
          showSign: showSign,
          style: style,
        ),
      ),
    );
  }

  group('AmountText (T04-4)', () {
    testWidgets(
      'T04-4: renders amount with tabular figures font feature enabled',
      (tester) async {
        await tester.pumpWidget(buildHarness(amount: const Money(1250)));

        final textFinder = find.byType(Text);
        expect(textFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.data, contains('12.50'));
        expect(
          textWidget.style?.fontFeatures,
          contains(const FontFeature.tabularFigures()),
        );
      },
    );

    testWidgets('T04-4: uses AppColors.onTrack when status is onTrack', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(amount: const Money(2500), status: BudgetStatus.onTrack),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, AppColors.onTrack);
    });

    testWidgets('T04-4: uses AppColors.caution when status is caution', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(amount: const Money(500), status: BudgetStatus.caution),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, AppColors.caution);
    });

    testWidgets('T04-4: uses AppColors.over when status is over', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(amount: const Money(-1000), status: BudgetStatus.over),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, AppColors.over);
    });

    testWidgets(
      'T04-4: defaults to AppColors.over when status is null and amount is negative',
      (tester) async {
        await tester.pumpWidget(buildHarness(amount: const Money(-250)));

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, AppColors.over);
      },
    );

    testWidgets(
      'T04-4: displays plus sign when showSign is true and amount is positive',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(amount: const Money(1500), showSign: true),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, startsWith('+'));
      },
    );
  });
}
