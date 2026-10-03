import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/data/models/date_range.dart';
import 'package:safe_to_spend/features/onboarding/widgets/pay_schedule_step.dart';

void main() {
  Widget buildHarness({
    PayFrequency? selectedFrequency = PayFrequency.biweekly,
    LocalDate? nextPayday = const LocalDate(2026, 1, 15),
    Money? incomePerPaycheck = const Money(250000),
    Money? firstPeriodBalance = const Money(120000),
    Money? suggestedFirstPeriodBalance = const Money(120000),
    DateRange allowedPaydayRange = const DateRange(
      start: LocalDate(2026, 1, 1),
      end: LocalDate(2026, 1, 15),
    ),
    ValueChanged<PayFrequency>? onSelectFrequency,
    ValueChanged<LocalDate>? onSelectNextPayday,
    ValueChanged<Money>? onChangedIncome,
    ValueChanged<Money>? onChangedFirstPeriodBalance,
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
            child: PayScheduleStep(
              selectedFrequency: selectedFrequency,
              nextPayday: nextPayday,
              incomePerPaycheck: incomePerPaycheck,
              firstPeriodBalance: firstPeriodBalance,
              suggestedFirstPeriodBalance: suggestedFirstPeriodBalance,
              allowedPaydayRange: allowedPaydayRange,
              onSelectFrequency: onSelectFrequency ?? (_) {},
              onSelectNextPayday: onSelectNextPayday ?? (_) {},
              onChangedIncome: onChangedIncome ?? (_) {},
              onChangedFirstPeriodBalance:
                  onChangedFirstPeriodBalance ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  group('PayScheduleStep Widget Tests', () {
    testWidgets('renders all 4 question blocks and keypad', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(find.text('How often are you paid?'), findsOneWidget);
      expect(find.text('When is your next payday?'), findsOneWidget);
      expect(
        find.text('How much do you take home each paycheck?'),
        findsOneWidget,
      );
      expect(
        find.text('How much do you have to spend until then?'),
        findsOneWidget,
      );
      expect(find.textContaining('Suggested:'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // Keypad digit
    });

    testWidgets('selecting a pay frequency chip fires onSelectFrequency', (
      tester,
    ) async {
      PayFrequency? selected;

      await tester.pumpWidget(
        buildHarness(onSelectFrequency: (f) => selected = f),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Monthly'));
      await tester.pumpAndSettle();

      expect(selected, equals(PayFrequency.monthly));
    });

    testWidgets(
      'tapping amount tile switches active field and keypad changes value',
      (tester) async {
        Money? updatedIncome;
        Money? updatedBalance;

        await tester.pumpWidget(
          buildHarness(
            incomePerPaycheck: const Money(100000),
            firstPeriodBalance: const Money(50000),
            onChangedIncome: (m) => updatedIncome = m,
            onChangedFirstPeriodBalance: (m) => updatedBalance = m,
          ),
        );
        await tester.pumpAndSettle();

        // Scroll to keypad
        await tester.ensureVisible(find.text('5'));
        await tester.pumpAndSettle();

        // Income field is active by default; pressing '5' on keypad updates income
        await tester.tap(find.text('5'));
        await tester.pumpAndSettle();
        expect(updatedIncome, isNotNull);

        // Scroll to and tap balance tile to switch active focus
        final balanceTile = find.text('Spending balance for initial period');
        await tester.ensureVisible(balanceTile);
        await tester.pumpAndSettle();
        await tester.tap(balanceTile);
        await tester.pumpAndSettle();

        // Now pressing keypad updates first period balance
        await tester.ensureVisible(find.text('7'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('7'));
        await tester.pumpAndSettle();
        expect(updatedBalance, isNotNull);
      },
    );

    testWidgets('tapping payday card triggers date picker dialog', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_today_rounded));
      await tester.pumpAndSettle();

      // DatePicker dialog should be visible
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('Dynamic Type 2.0x renders without layout overflow', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness(textScale: 2));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('How often are you paid?'), findsOneWidget);
    });
  });
}
