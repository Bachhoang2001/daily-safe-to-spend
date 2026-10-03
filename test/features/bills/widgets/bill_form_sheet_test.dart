import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/features/bills/widgets/bill_form_sheet.dart';

class _FakeUuidGenerator implements UuidGenerator {
  const _FakeUuidGenerator(this.fixedId);
  final String fixedId;

  @override
  String generate() => fixedId;
}

void main() {
  const testCurrency = 'USD';
  const initialDate = LocalDate(2026, 1, 1);

  Widget buildHarness({
    required ValueChanged<OnboardingBillDraft> onSave,
    OnboardingBillDraft? initialBill,
    String? suggestedName,
    ThemeData? theme,
    double textScale = 1.0,
    UuidGenerator uuidGenerator = const _FakeUuidGenerator('fixed-uuid-1'),
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
          data: MediaQueryData(
            textScaler: TextScaler.linear(textScale),
            size: const Size(430, 932),
          ),
          child: BillFormSheet(
            currency: testCurrency,
            initialDate: initialDate,
            initialBill: initialBill,
            suggestedName: suggestedName,
            onSave: onSave,
            uuidGenerator: uuidGenerator,
          ),
        ),
      ),
    );
  }

  group('BillFormSheet Widget & Validation Tests (T08-3)', () {
    testWidgets(
      'T08-3: renders form with all elements, prefilled name, default monthly recurrence',
      (tester) async {
        OnboardingBillDraft? saved;
        await tester.pumpWidget(
          buildHarness(
            suggestedName: 'Internet',
            onSave: (bill) => saved = bill,
          ),
        );
        await tester.pumpAndSettle();

        // Title and pre-filled name
        expect(find.text('Add Bill'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Internet'), findsOneWidget);

        // Recurrence chips: Weekly, Monthly (selected), Yearly
        expect(find.widgetWithText(ChoiceChip, 'Weekly'), findsOneWidget);
        expect(find.widgetWithText(ChoiceChip, 'Monthly'), findsOneWidget);
        expect(find.widgetWithText(ChoiceChip, 'Yearly'), findsOneWidget);

        // First due date button
        expect(find.textContaining('2026-01-01'), findsOneWidget);

        // Save button
        expect(find.text('Save Changes'), findsOneWidget);
        expect(saved, isNull);
      },
    );

    testWidgets(
      'T08-3: validation fails when bill name is empty and blocks onSave',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        addTearDown(tester.view.resetPhysicalSize);

        OnboardingBillDraft? saved;
        await tester.pumpWidget(
          buildHarness(suggestedName: '', onSave: (bill) => saved = bill),
        );
        await tester.pumpAndSettle();

        // Clear any text if present
        await tester.enterText(find.byType(TextFormField), '');
        await tester.pumpAndSettle();

        // Tap Save
        await tester.ensureVisible(find.text('Save Changes'));
        await tester.tap(find.text('Save Changes'));
        await tester.pumpAndSettle();

        // Inline error shown
        expect(find.text('Please enter a bill name'), findsOneWidget);
        expect(saved, isNull);
      },
    );

    testWidgets('T08-3: validation fails when amount is zero or negative', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      addTearDown(tester.view.resetPhysicalSize);

      OnboardingBillDraft? saved;
      await tester.pumpWidget(
        buildHarness(suggestedName: 'Rent', onSave: (bill) => saved = bill),
      );
      await tester.pumpAndSettle();

      // Amount is currently $0.00
      await tester.ensureVisible(find.text('Save Changes'));
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // Validation error for amount
      expect(find.text('Amount must be greater than zero'), findsOneWidget);
      expect(saved, isNull);
    });

    testWidgets(
      'T08-3: entering valid amount via keypad and selecting recurrence calls onSave with correct draft',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        addTearDown(tester.view.resetPhysicalSize);

        OnboardingBillDraft? saved;
        await tester.pumpWidget(
          buildHarness(suggestedName: 'Gym', onSave: (bill) => saved = bill),
        );
        await tester.pumpAndSettle();

        // Enter $50.00 on keypad: 5 -> 0 -> 0 -> 0
        await tester.tap(find.text('5'));
        await tester.pump();
        await tester.tap(find.text('0'));
        await tester.pump();
        await tester.tap(find.text('0'));
        await tester.pump();
        await tester.tap(find.text('0'));
        await tester.pumpAndSettle();

        expect(find.text(r'$50.00'), findsOneWidget);

        // Select 'Yearly' recurrence
        await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Yearly'));
        await tester.tap(find.widgetWithText(ChoiceChip, 'Yearly'));
        await tester.pumpAndSettle();

        // Tap Save
        await tester.ensureVisible(find.text('Save Changes'));
        await tester.tap(find.text('Save Changes'));
        await tester.pumpAndSettle();

        expect(saved, isNotNull);
        expect(saved!.name, equals('Gym'));
        expect(saved!.amount.cents, equals(5000));
        expect(saved!.amount.currency, equals('USD'));
        expect(saved!.recurrence, equals(BillRecurrence.yearly));
        expect(saved!.firstDueDate, equals(const LocalDate(2026, 1, 1)));
        expect(saved!.id, equals('fixed-uuid-1'));
      },
    );

    testWidgets(
      'T08-3: editing existing bill populates values and preserves existing ID',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        addTearDown(tester.view.resetPhysicalSize);

        const initial = OnboardingBillDraft(
          id: 'existing-bill-999',
          name: 'Car Insurance',
          amount: Money(15000), // $150.00
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 10),
        );

        OnboardingBillDraft? saved;
        await tester.pumpWidget(
          buildHarness(initialBill: initial, onSave: (bill) => saved = bill),
        );
        await tester.pumpAndSettle();

        expect(find.text('Edit Bill'), findsOneWidget);
        expect(
          find.widgetWithText(TextFormField, 'Car Insurance'),
          findsOneWidget,
        );
        expect(find.text(r'$150.00'), findsOneWidget);
        expect(find.textContaining('2026-01-10'), findsOneWidget);

        // Modify name to 'Auto Insurance'
        await tester.enterText(find.byType(TextFormField), 'Auto Insurance');
        await tester.pumpAndSettle();

        // Tap Save
        await tester.ensureVisible(find.text('Save Changes'));
        await tester.tap(find.text('Save Changes'));
        await tester.pumpAndSettle();

        expect(saved, isNotNull);
        expect(saved!.id, equals('existing-bill-999'));
        expect(saved!.name, equals('Auto Insurance'));
        expect(saved!.amount.cents, equals(15000));
      },
    );

    testWidgets(
      'T08-3: Dark mode and Dynamic Type 2.0x render with zero layout exceptions',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(
            theme: AppTheme.darkTheme,
            textScale: 2,
            suggestedName: 'Rent',
            onSave: (_) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Add Bill'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Rent'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
