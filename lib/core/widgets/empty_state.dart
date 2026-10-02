import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Standard empty state display with icon, title, description, and action button.
class EmptyState extends StatelessWidget {
  /// Creates an [EmptyState] widget.
  const EmptyState({
    required this.title,
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  /// Primary message.
  final String title;

  /// Secondary guidance message.
  final String? message;

  /// Illustrative icon.
  final IconData icon;

  /// Optional call-to-action widget (e.g. PrimaryButton).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryTextColor = theme.colorScheme.onSurfaceVariant;

    return Semantics(
      container: true,
      label: '$title. ${message ?? ''}',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: secondaryTextColor),
              const SizedBox(height: AppSpacing.l),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.s),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: secondaryTextColor),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppSpacing.xl),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
