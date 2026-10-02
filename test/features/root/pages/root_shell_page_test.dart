import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/root/controllers/root_shell_controller.dart';
import 'package:safe_to_spend/features/root/pages/root_shell_page.dart';

void main() {
  late RootShellController controller;

  setUp(() {
    Get.testMode = true;
    controller = RootShellController();
    Get.put<RootShellController>(controller);
  });

  tearDown(Get.reset);

  Widget buildHarness() {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const RootShellPage(),
    );
  }

  group('RootShellPage (T04-2)', () {
    testWidgets('T04-2: displays all 3 navigation tabs: Today, History, Plan', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsWidgets);
      expect(find.text('History'), findsWidgets);
      expect(find.text('Plan'), findsWidgets);

      expect(
        find.byIcon(Icons.today_outlined),
        findsNothing,
      ); // Active tab uses selectedIcon Icons.today
      expect(find.byIcon(Icons.today), findsOneWidget);
      expect(find.byIcon(Icons.history_outlined), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
    });

    testWidgets(
      'T04-2: switching tabs preserves state in each tab via IndexedStack',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // 1. Initial tab: Today
        expect(find.byKey(const Key('today_tab_view')), findsOneWidget);
        expect(find.text('Today Count: 0'), findsOneWidget);

        // Increment Today counter
        await tester.tap(find.byKey(const Key('today_increment_button')));
        await tester.pumpAndSettle();
        expect(find.text('Today Count: 1'), findsOneWidget);

        // 2. Switch to History tab (tab 1)
        await tester.tap(find.byIcon(Icons.history_outlined));
        await tester.pumpAndSettle();

        expect(controller.tabIndex.value, 1);
        expect(find.byKey(const Key('history_tab_view')), findsOneWidget);
        expect(find.text('History Count: 0'), findsOneWidget);

        // Increment History counter
        await tester.tap(find.byKey(const Key('history_increment_button')));
        await tester.pumpAndSettle();
        expect(find.text('History Count: 1'), findsOneWidget);

        // 3. Switch to Plan tab (tab 2)
        await tester.tap(find.byIcon(Icons.calendar_month_outlined));
        await tester.pumpAndSettle();

        expect(controller.tabIndex.value, 2);
        expect(find.byKey(const Key('plan_tab_view')), findsOneWidget);

        // 4. Switch back to Today tab (tab 0) -> state is preserved!
        await tester.tap(find.byIcon(Icons.today_outlined));
        await tester.pumpAndSettle();

        expect(controller.tabIndex.value, 0);
        expect(find.text('Today Count: 1'), findsOneWidget); // Counter STILL 1!

        // 5. Switch back to History tab (tab 1) -> state is preserved!
        await tester.tap(find.byIcon(Icons.history_outlined));
        await tester.pumpAndSettle();

        expect(controller.tabIndex.value, 1);
        expect(
          find.text('History Count: 1'),
          findsOneWidget,
        ); // Counter STILL 1!
      },
    );

    testWidgets(
      'T04-2: tapping destinations provides accessible semantics and tooltips',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        expect(find.byTooltip('Today'), findsOneWidget);
        expect(find.byTooltip('History'), findsOneWidget);
        expect(find.byTooltip('Plan'), findsOneWidget);
      },
    );
  });
}
