import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/onboarding/widgets/currency_picker.dart';

void main() {
  Widget buildHarness({
    required String selectedCurrency,
    required ValueChanged<String> onChanged,
    ThemeData? theme,
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
        body: Center(
          child: CurrencyPicker(
            selectedCurrency: selectedCurrency,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  group('CurrencyPicker Widget Tests', () {
    testWidgets('renders active currency and opens dropdown options', (
      tester,
    ) async {
      String? changedCurrency;

      await tester.pumpWidget(
        buildHarness(
          selectedCurrency: 'USD',
          onChanged: (c) => changedCurrency = c,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('USD'), findsOneWidget);

      // Tap dropdown to open menu
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('EUR').hitTestable(), findsOneWidget);
      expect(find.text('GBP').hitTestable(), findsOneWidget);

      // Select EUR
      await tester.tap(find.text('EUR').last);
      await tester.pumpAndSettle();

      expect(changedCurrency, equals('EUR'));
    });

    testWidgets('has accessible Semantics label and min touch target height', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(selectedCurrency: 'GBP', onChanged: (_) {}),
      );
      await tester.pumpAndSettle();

      final semantics = find.byWidgetPredicate(
        (w) => w is Semantics && (w.properties.label?.contains('GBP') ?? false),
      );
      expect(semantics, findsOneWidget);

      final size = tester.getSize(find.byType(CurrencyPicker));
      expect(size.height, greaterThanOrEqualTo(44.0));
    });

    testWidgets('renders correctly in dark mode', (tester) async {
      await tester.pumpWidget(
        buildHarness(
          selectedCurrency: 'EUR',
          onChanged: (_) {},
          theme: AppTheme.darkTheme,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('EUR'), findsOneWidget);
    });
  });
}
