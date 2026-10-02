import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/splash/pages/startup_error_page.dart';

void main() {
  Widget buildHarness({
    required VoidCallback onRetry,
    required VoidCallback onContactSupport,
    ThemeData? theme,
    String? errorMessage,
    double textScale = 1.0,
  }) {
    return MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: TextScaler.linear(textScale),
          size: const Size(430, 932), // Standard device viewport
        ),
        child: StartupErrorPage(
          onRetry: onRetry,
          onContactSupport: onContactSupport,
          errorMessage: errorMessage,
        ),
      ),
    );
  }

  group('StartupErrorPage (T05-3 - UI/UX & Interaction)', () {
    testWidgets(
      'T05-3: displays error icon, friendly title, message, and technical details',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(
            onRetry: () {},
            onContactSupport: () {},
            errorMessage: 'Corrupt SQLite database file',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(
          find.text(
            'We were unable to initialize your local database. '
            'Please try again or contact support if the issue persists.',
          ),
          findsOneWidget,
        );
        expect(find.text('Corrupt SQLite database file'), findsOneWidget);
        expect(
          find.byKey(const Key('bootstrap_try_again_button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('bootstrap_contact_support_button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'T05-3: tapping Try again calls onRetry callback to re-trigger bootstrap',
      (tester) async {
        var retryCount = 0;
        await tester.pumpWidget(
          buildHarness(onRetry: () => retryCount++, onContactSupport: () {}),
        );
        await tester.pumpAndSettle();

        final tryAgainButton = find.byKey(
          const Key('bootstrap_try_again_button'),
        );
        await tester.tap(tryAgainButton);
        await tester.pump();

        expect(retryCount, 1);
      },
    );

    testWidgets(
      'T05-3: tapping Contact support calls onContactSupport callback',
      (tester) async {
        var supportCount = 0;
        await tester.pumpWidget(
          buildHarness(onRetry: () {}, onContactSupport: () => supportCount++),
        );
        await tester.pumpAndSettle();

        final contactButton = find.byKey(
          const Key('bootstrap_contact_support_button'),
        );
        await tester.tap(contactButton);
        await tester.pump();

        expect(supportCount, 1);
      },
    );

    testWidgets('T05-3: renders cleanly in dark mode without layout issues', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(
          theme: AppTheme.darkTheme,
          onRetry: () {},
          onContactSupport: () {},
          errorMessage: 'Error code: 11 - disk I/O failure',
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Error code: 11 - disk I/O failure'), findsOneWidget);
    });

    testWidgets(
      'T05-3: renders under maximum text scale factor (2.0x Dynamic Type) without overflow',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(
            textScale: 2,
            onRetry: () {},
            onContactSupport: () {},
            errorMessage: 'Exception: DB failed to open',
          ),
        );
        await tester.pumpAndSettle();

        // Verify zero overflow exceptions
        expect(tester.takeException(), isNull);
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(
          find.byKey(const Key('bootstrap_try_again_button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'T05-3: provides accessible semantics for screen reader navigation',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(onRetry: () {}, onContactSupport: () {}),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('Try again'), findsOneWidget);
        expect(find.bySemanticsLabel('Contact support'), findsOneWidget);
      },
    );
  });
}
