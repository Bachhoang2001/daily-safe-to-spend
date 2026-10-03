import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/onboarding/widgets/irregular_balance_step.dart';

void main() {
  Widget buildHarness({
    Money? startingBalance = const Money(75000),
    int? safetyHorizonDays = 14,
    ValueChanged<Money>? onChangedBalance,
    ValueChanged<int>? onSelectHorizon,
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
            child: IrregularBalanceStep(
              startingBalance: startingBalance,
              safetyHorizonDays: safetyHorizonDays,
              onChangedBalance: onChangedBalance ?? (_) {},
              onSelectHorizon: onSelectHorizon ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  group('IrregularBalanceStep Widget Tests', () {
    testWidgets('renders balance question and horizon cards (7, 14, 30 days)', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(
        find.text('How much money do you have right now?'),
        findsOneWidget,
      );
      expect(find.text('Available spending money'), findsOneWidget);
      expect(find.text('Plan ahead for how many days?'), findsOneWidget);
      expect(find.text('7 days'), findsOneWidget);
      expect(find.text('14 days'), findsOneWidget);
      expect(find.text('30 days'), findsOneWidget);
      expect(find.text('Recommended'), findsOneWidget);
    });

    testWidgets('tapping horizon cards calls onSelectHorizon', (tester) async {
      int? selectedDays;

      await tester.pumpWidget(
        buildHarness(onSelectHorizon: (d) => selectedDays = d),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('7 days'));
      await tester.pumpAndSettle();
      expect(selectedDays, equals(7));

      await tester.tap(find.text('30 days'));
      await tester.pumpAndSettle();
      expect(selectedDays, equals(30));

      await tester.tap(find.text('14 days'));
      await tester.pumpAndSettle();
      expect(selectedDays, equals(14));
    });

    testWidgets('entering digits on keypad calls onChangedBalance', (
      tester,
    ) async {
      Money? newBalance;

      await tester.pumpWidget(
        buildHarness(
          startingBalance: const Money(100),
          onChangedBalance: (m) => newBalance = m,
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('9'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();

      expect(newBalance, isNotNull);
    });

    testWidgets('Dynamic Type 2.0x renders without layout overflow', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness(textScale: 2));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Plan ahead for how many days?'), findsOneWidget);
    });
  });
}
