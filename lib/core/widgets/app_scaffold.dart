import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Standard app scaffold enforcing SafeArea, theme background, and default padding.
class AppScaffold extends StatelessWidget {
  /// Creates an [AppScaffold].
  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding = const EdgeInsets.all(AppSpacing.l),
  });

  /// Optional top app bar.
  final PreferredSizeWidget? appBar;

  /// Main content of the scaffold.
  final Widget body;

  /// Bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Padding applied around the body.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(padding: padding, child: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
