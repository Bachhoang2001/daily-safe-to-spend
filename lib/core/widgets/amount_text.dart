import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/money/money_formatter.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';

/// Formatted monetary text display with tabular figures and status-aware coloring.
class AmountText extends StatelessWidget {
  /// Creates an [AmountText] widget.
  const AmountText({
    required this.amount,
    super.key,
    this.status,
    this.showSign = false,
    this.style,
    this.semanticsLabel,
  });

  /// The monetary amount to render.
  final Money amount;

  /// Optional budget status dictating color scheme.
  final BudgetStatus? status;

  /// Whether to explicitly prefix positive amounts with '+'.
  final bool showSign;

  /// Optional base text style.
  final TextStyle? style;

  /// Optional accessibility semantics label.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = _resolveColor(context);
    final baseStyle =
        style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    final effectiveStyle = baseStyle.copyWith(
      color: effectiveColor,
      fontFeatures: [
        ...?baseStyle.fontFeatures,
        const FontFeature.tabularFigures(),
      ],
    );

    var formatted = MoneyFormatter.format(amount);
    if (showSign && amount.cents > 0) {
      formatted = '+$formatted';
    }

    return Semantics(
      label: semanticsLabel ?? formatted,
      excludeSemantics: true,
      child: Text(formatted, style: effectiveStyle),
    );
  }

  Color _resolveColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (status != null) {
      switch (status!) {
        case BudgetStatus.onTrack:
          return isDark ? AppColors.onTrackDark : AppColors.onTrackLight;
        case BudgetStatus.caution:
          return isDark ? AppColors.cautionDark : AppColors.cautionLight;
        case BudgetStatus.over:
          return isDark ? AppColors.overDark : AppColors.overLight;
      }
    }

    if (amount.isNegative) {
      return isDark ? AppColors.overDark : AppColors.overLight;
    }

    return style?.color ?? Theme.of(context).colorScheme.onSurface;
  }
}
