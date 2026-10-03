import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/onboarding/widgets/income_mode_step.dart';

void main() {
  Widget buildHarness({
    required IncomeMode selectedMode,
    required ValueChanged<IncomeMode> onSelectMode,
    ThemeData? theme,
    double textScale = 1.0,
  }) {
    return MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: SingleChildScrollView(
            child: IncomeModeStep(
              selectedMode: selectedMode,
              onSelectMode: onSelectMode,
            ),
          ),
        ),
      ),
    );
  }

  group('IncomeModeStep Widget Tests', () {
    testWidgets('renders question title and both mode selection cards', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(selectedMode: IncomeMode.fixed, onSelectMode: (_) {}),
      );
      await tester.pumpAndSettle();

      expect(find.text('How do you get paid?'), findsOneWidget);
      expect(find.text('Same amount on a schedule'), findsOneWidget);
      expect(find.text('My income varies'), findsOneWidget);
    });

    testWidgets('tapping cards invokes onSelectMode callback', (tester) async {
      IncomeMode? selected;

      await tester.pumpWidget(
        buildHarness(
          selectedMode: IncomeMode.fixed,
          onSelectMode: (mode) => selected = mode,
        ),
      );
      await tester.pumpAndSettle();

      // Tap irregular income card
      await tester.tap(find.text('My income varies'));
      await tester.pumpAndSettle();
      expect(selected, equals(IncomeMode.irregular));

      // Tap fixed income card
      await tester.tap(find.text('Same amount on a schedule'));
      await tester.pumpAndSettle();
      expect(selected, equals(IncomeMode.fixed));
    });

    testWidgets('selected card has selected Semantics flag', (tester) async {
      await tester.pumpWidget(
        buildHarness(selectedMode: IncomeMode.fixed, onSelectMode: (_) {}),
      );
      await tester.pumpAndSettle();

      final fixedSemantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              (w.properties.label?.startsWith('Same amount on a schedule') ??
                  false),
        ),
      );
      expect(fixedSemantics.properties.selected, isTrue);

      final irregularSemantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              (w.properties.label?.startsWith('My income varies') ?? false),
        ),
      );
      expect(irregularSemantics.properties.selected, isFalse);
    });

    testWidgets('2.0x Dynamic Type renders without overflow', (tester) async {
      await tester.pumpWidget(
        buildHarness(
          selectedMode: IncomeMode.fixed,
          onSelectMode: (_) {},
          textScale: 2,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('How do you get paid?'), findsOneWidget);
    });
  });
}
