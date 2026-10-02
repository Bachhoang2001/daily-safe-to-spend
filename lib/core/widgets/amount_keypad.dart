import 'dart:async';

import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// 3x4 numeric keypad implementing ATM/POS style decimal entry.
///
/// Digits are shifted in from the rightmost cent position:
/// Entering 1 -> $0.01; 2 -> $0.12; 5 -> $1.25; 0 -> $12.50.
/// Tapping backspace divides by 10; long-pressing backspace clears to zero.
/// Supports pressed/disabled states, light haptic feedback, and safe Timer cleanup.
class AmountKeypad extends StatefulWidget {
  /// Creates an [AmountKeypad].
  const AmountKeypad({
    required this.onChanged,
    super.key,
    this.initialCents = 0,
    this.maxCents = 99999999,
    this.enabled = true,
  });

  /// Callback emitted whenever the current monetary amount changes.
  final ValueChanged<Money> onChanged;

  /// Starting amount in cents.
  final int initialCents;

  /// Upper ceiling in cents (defaults to $999,999.99).
  final int maxCents;

  /// Whether the keypad is interactive or disabled.
  final bool enabled;

  @override
  State<AmountKeypad> createState() => _AmountKeypadState();
}

class _AmountKeypadState extends State<AmountKeypad> {
  late int _cents;
  Timer? _clearTimer;

  @override
  void initState() {
    super.initState();
    _cents = widget.initialCents;
  }

  @override
  void dispose() {
    _clearTimer?.cancel();
    _clearTimer = null;
    super.dispose();
  }

  void _onDigitPressed(int digit) {
    if (!widget.enabled) return;
    HapticFeedback.lightImpact();
    final newCents = (_cents * 10) + digit;
    if (newCents <= widget.maxCents) {
      setState(() => _cents = newCents);
      widget.onChanged(Money(_cents));
    }
  }

  void _onDoubleZeroPressed() {
    if (!widget.enabled) return;
    HapticFeedback.lightImpact();
    final newCents = _cents * 100;
    if (newCents <= widget.maxCents) {
      setState(() => _cents = newCents);
      widget.onChanged(Money(_cents));
    }
  }

  void _onBackspacePressed() {
    if (!widget.enabled) return;
    HapticFeedback.lightImpact();
    if (_cents > 0) {
      setState(() => _cents = _cents ~/ 10);
      widget.onChanged(Money(_cents));
    }
  }

  void _onBackspaceLongPressed() {
    if (!widget.enabled || !mounted) return;
    HapticFeedback.mediumImpact();
    if (_cents > 0) {
      setState(() => _cents = 0);
      widget.onChanged(const Money(0));
    }
  }

  void _onBackspaceTapDown(TapDownDetails _) {
    if (!widget.enabled) return;
    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _onBackspaceLongPressed();
      }
    });
  }

  void _onBackspaceTapUp(TapUpDetails _) {
    _clearTimer?.cancel();
  }

  void _onBackspaceTapCancel() {
    _clearTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.38,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: AppSpacing.s),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: AppSpacing.s),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: AppSpacing.s),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map(_buildDigitButton).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDoubleZeroButton(),
        _buildDigitButton('0'),
        _buildBackspaceButton(),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.enabled;

    final backgroundColor = isDark
        ? AppColors.surfaceVariantDark.withValues(alpha: 0.5)
        : AppColors.surfaceVariantLight.withValues(alpha: 0.7);

    final textColor = isEnabled
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return Semantics(
      label: digit,
      button: true,
      enabled: isEnabled,
      excludeSemantics: true,
      child: Material(
        color: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusButton,
        ),
        child: InkWell(
          borderRadius: AppSpacing.borderRadiusButton,
          onTap: isEnabled ? () => _onDigitPressed(int.parse(digit)) : null,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
          child: Container(
            width: 80,
            height: AppSpacing.minTouchTarget + 12,
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                digit,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleZeroButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.enabled;

    final backgroundColor = isDark
        ? AppColors.surfaceVariantDark.withValues(alpha: 0.5)
        : AppColors.surfaceVariantLight.withValues(alpha: 0.7);

    final textColor = isEnabled
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return Semantics(
      label: 'Double zero',
      button: true,
      enabled: isEnabled,
      excludeSemantics: true,
      child: Material(
        color: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusButton,
        ),
        child: InkWell(
          borderRadius: AppSpacing.borderRadiusButton,
          onTap: isEnabled ? _onDoubleZeroPressed : null,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
          child: Container(
            width: 80,
            height: AppSpacing.minTouchTarget + 12,
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '00',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.enabled;

    final backgroundColor = isDark
        ? AppColors.surfaceVariantDark.withValues(alpha: 0.5)
        : AppColors.surfaceVariantLight.withValues(alpha: 0.7);

    final iconColor = isEnabled
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return Semantics(
      label: 'Backspace',
      button: true,
      enabled: isEnabled && _cents > 0,
      excludeSemantics: true,
      child: Material(
        color: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusButton,
        ),
        child: InkWell(
          key: const Key('amount_keypad_backspace'),
          borderRadius: AppSpacing.borderRadiusButton,
          onTap: isEnabled ? _onBackspacePressed : null,
          onLongPress: isEnabled ? _onBackspaceLongPressed : null,
          onTapDown: isEnabled ? _onBackspaceTapDown : null,
          onTapUp: isEnabled ? _onBackspaceTapUp : null,
          onTapCancel: isEnabled ? _onBackspaceTapCancel : null,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
          child: Container(
            width: 80,
            height: AppSpacing.minTouchTarget + 12,
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(Icons.backspace_outlined, size: 24, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
