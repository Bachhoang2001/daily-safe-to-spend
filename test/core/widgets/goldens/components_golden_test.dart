import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/core/widgets/amount_keypad.dart';
import 'package:safe_to_spend/core/widgets/amount_text.dart';
import 'package:safe_to_spend/core/widgets/app_bottom_sheet.dart';
import 'package:safe_to_spend/core/widgets/category_chip.dart';
import 'package:safe_to_spend/core/widgets/confirm_dialog.dart';
import 'package:safe_to_spend/core/widgets/empty_state.dart';
import 'package:safe_to_spend/core/widgets/premium_badge.dart';
import 'package:safe_to_spend/core/widgets/primary_button.dart';
import 'package:safe_to_spend/core/widgets/progress_ring.dart';
import 'package:safe_to_spend/core/widgets/secondary_button.dart';
import 'package:safe_to_spend/core/widgets/section_card.dart';

void main() {
  Widget buildHarness({
    required ThemeData theme,
    double textScale = 1.0,
    Widget? content,
  }) {
    return MaterialApp(
      theme: theme,
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
          size: const Size(430, 932), // iPhone 16 Pro Max viewport
        ),
        child: content ?? const _ComponentsGallery(),
      ),
    );
  }

  group('Components Golden & Visual Quality (T04-5)', () {
    testWidgets(
      'T04-5: components render in light mode without layout overflow',
      (tester) async {
        await tester.pumpWidget(buildHarness(theme: AppTheme.lightTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(r'+$1,250.00'), findsOneWidget);
        expect(find.text('Save Expense'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Food & Dining'), findsOneWidget);
        expect(find.text('PRO'), findsOneWidget);
      },
    );

    testWidgets(
      'T04-5: components render in dark mode without layout overflow',
      (tester) async {
        await tester.pumpWidget(buildHarness(theme: AppTheme.darkTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(r'+$1,250.00'), findsOneWidget);
        expect(find.text('Save Expense'), findsOneWidget);
        expect(find.text('PRO'), findsOneWidget);
      },
    );

    testWidgets(
      'T04-5: components render under maximum text scale factor (2.0x Dynamic Type)',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(theme: AppTheme.lightTheme, textScale: 2),
        );
        await tester.pumpAndSettle();

        // Zero exceptions and no RenderFlex overflow
        expect(tester.takeException(), isNull);
        expect(find.text('Save Expense'), findsOneWidget);
        expect(find.text('PRO'), findsOneWidget);
      },
    );

    testWidgets(
      'T04-5: AppBottomSheet and ConfirmDialog render with proper themes',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(
            theme: AppTheme.lightTheme,
            content: const Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    AppBottomSheet(
                      title: 'Quick Add',
                      child: Text('Sheet content'),
                    ),
                    ConfirmDialog(
                      title: 'Delete Expense',
                      message: 'Are you sure you want to delete this expense?',
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Quick Add'), findsOneWidget);
        expect(find.text('Delete Expense'), findsOneWidget);
      },
    );

    testWidgets('T04-5: Light mode golden snapshot comparison', (tester) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildHarness(theme: AppTheme.lightTheme));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components_light.png'),
      );
    }, tags: ['golden']);

    testWidgets('T04-5: Dark mode golden snapshot comparison', (tester) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildHarness(theme: AppTheme.darkTheme));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components_dark.png'),
      );
    }, tags: ['golden']);

    testWidgets(
      'T04-5: Max text scale (2.0x Dynamic Type) golden snapshot comparison',
      (tester) async {
        tester.view.physicalSize = const Size(430 * 3, 932 * 3);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          buildHarness(theme: AppTheme.lightTheme, textScale: 2),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/components_max_text_scale.png'),
        );
      },
      tags: ['golden'],
    );

    testWidgets(
      'T04-5: PrimaryButton and SecondaryButton display disabled states correctly',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(
            theme: AppTheme.lightTheme,
            content: Scaffold(
              body: Column(
                children: [
                  const PrimaryButton(label: 'Disabled Primary'),
                  const PrimaryButton(
                    label: 'Loading Primary',
                    isLoading: true,
                  ),
                  const SecondaryButton(label: 'Disabled Secondary'),
                  CategoryChip(
                    label: 'Disabled Chip',
                    enabled: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.text('Disabled Primary'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Disabled Secondary'), findsOneWidget);
        expect(find.text('Disabled Chip'), findsOneWidget);
      },
    );
  });
}

class _ComponentsGallery extends StatelessWidget {
  const _ComponentsGallery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AmountText(
                amount: Money(125000),
                status: BudgetStatus.onTrack,
                showSign: true,
              ),
              const SizedBox(height: AppSpacing.m),
              const AmountText(amount: Money(-3500), status: BudgetStatus.over),
              const SizedBox(height: AppSpacing.m),
              PrimaryButton(label: 'Save Expense', onPressed: () {}),
              const SizedBox(height: AppSpacing.s),
              SecondaryButton(label: 'Cancel', onPressed: () {}),
              const SizedBox(height: AppSpacing.m),
              const Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  CategoryChip(label: 'Food & Dining', isSelected: true),
                  CategoryChip(label: 'Bills'),
                  PremiumBadge(),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              const SectionCard(
                title: 'Daily Allowance',
                trailing: Icon(Icons.info_outline, size: 18),
                child: Column(
                  children: [ProgressRing(progress: 0.65, child: Text('65%'))],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              AmountKeypad(onChanged: (_) {}),
              const SizedBox(height: AppSpacing.m),
              const EmptyState(
                title: 'No expenses yet',
                message: 'Your transactions for today will appear here.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
