import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Confirmation dialog for potentially destructive or irreversible actions.
class ConfirmDialog extends StatelessWidget {
  /// Creates a [ConfirmDialog].
  const ConfirmDialog({
    required this.title,
    required this.message,
    super.key,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  /// Dialog headline.
  final String title;

  /// Explanatory message.
  final String message;

  /// Label for the confirmation action.
  final String confirmLabel;

  /// Label for the cancel action.
  final String cancelLabel;

  /// Whether the confirmation represents a destructive action (styled in terracotta).
  final bool isDestructive;

  /// Callback when confirmed.
  final VoidCallback? onConfirm;

  /// Callback when cancelled.
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusCard,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: Text(message, style: const TextStyle(fontSize: 14, height: 1.4)),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.overDark
                      : AppColors.overLight,
                  foregroundColor: Colors.white,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
