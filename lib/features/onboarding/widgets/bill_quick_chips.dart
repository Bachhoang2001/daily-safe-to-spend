import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Data class representing a bill suggestion with an icon.
class BillSuggestionItem {
  /// Creates a [BillSuggestionItem].
  const BillSuggestionItem({required this.name, required this.icon});

  /// The label of the suggestion.
  final String name;

  /// The icon representing the category.
  final IconData icon;
}

/// Quick suggestion chips with icons for common bills during onboarding.
class BillQuickChips extends StatelessWidget {
  /// Creates an instance of [BillQuickChips].
  const BillQuickChips({required this.onSelected, super.key});

  /// Callback emitted when a suggestion chip is tapped.
  final ValueChanged<String> onSelected;

  /// Default suggestion items paired with clear outline icons.
  static const List<BillSuggestionItem> suggestions = [
    BillSuggestionItem(name: 'Rent', icon: Icons.home_outlined),
    BillSuggestionItem(name: 'Phone', icon: Icons.phone_iphone_outlined),
    BillSuggestionItem(name: 'Internet', icon: Icons.wifi_outlined),
    BillSuggestionItem(name: 'Utilities', icon: Icons.water_drop_outlined),
    BillSuggestionItem(
      name: 'Car payment',
      icon: Icons.directions_car_outlined,
    ),
    BillSuggestionItem(name: 'Insurance', icon: Icons.shield_outlined),
    BillSuggestionItem(
      name: 'Subscriptions',
      icon: Icons.subscriptions_outlined,
    ),
    BillSuggestionItem(name: 'Custom', icon: Icons.add_circle_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: suggestions.map((item) {
        return Semantics(
          button: true,
          label: 'Add ${item.name} bill',
          child: ActionChip(
            avatar: Icon(item.icon, size: 18, color: iconColor),
            label: Text(item.name),
            backgroundColor: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.surfaceVariantLight,
            side: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            onPressed: () => onSelected(item.name == 'Custom' ? '' : item.name),
          ),
        );
      }).toList(),
    );
  }
}
