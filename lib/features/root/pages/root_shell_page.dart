import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/features/root/controllers/root_shell_controller.dart';

/// Root shell widget hosting the 3 main application tabs in an [IndexedStack]
/// with a bottom [NavigationBar].
///
/// Uses [IndexedStack] to preserve the state of all three tabs across navigation.
class RootShellPage extends GetView<RootShellController> {
  /// Creates the [RootShellPage].
  const RootShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todayLabel = l10n?.tabToday ?? 'Today';
    final historyLabel = l10n?.tabHistory ?? 'History';
    final planLabel = l10n?.tabPlan ?? 'Plan';

    return Obx(() {
      final currentTab = controller.tabIndex.value;
      return Scaffold(
        body: IndexedStack(
          index: currentTab,
          children: [
            _TabPlaceholder(
              title: todayLabel,
              key: const Key('today_tab_view'),
            ),
            _TabPlaceholder(
              title: historyLabel,
              key: const Key('history_tab_view'),
            ),
            _TabPlaceholder(title: planLabel, key: const Key('plan_tab_view')),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentTab,
          onDestinationSelected: controller.changeTab,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.today_outlined),
              selectedIcon: const Icon(Icons.today),
              label: todayLabel,
              tooltip: todayLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history),
              label: historyLabel,
              tooltip: historyLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month),
              label: planLabel,
              tooltip: planLabel,
            ),
          ],
        ),
      );
    });
  }
}

class _TabPlaceholder extends StatefulWidget {
  const _TabPlaceholder({required this.title, super.key});

  final String title;

  @override
  State<_TabPlaceholder> createState() => _TabPlaceholderState();
}

class _TabPlaceholderState extends State<_TabPlaceholder> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.s),
          Text(
            '${widget.title} Count: $_counter',
            key: Key('${widget.title.toLowerCase()}_counter_text'),
          ),
          const SizedBox(height: AppSpacing.s),
          TextButton(
            key: Key('${widget.title.toLowerCase()}_increment_button'),
            onPressed: () => setState(() => _counter++),
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
