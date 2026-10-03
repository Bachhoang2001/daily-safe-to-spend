import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/money/money_formatter.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';

/// Card displaying an added bill with swipe-to-delete support.
class BillItemCard extends StatelessWidget {
  /// Creates an instance of [BillItemCard].
  const BillItemCard({
    required this.bill,
    required this.onDismissed,
    this.onTap,
    super.key,
  });

  /// The bill draft represented by this card.
  final OnboardingBillDraft bill;

  /// Callback invoked when the card is swiped to dismiss.
  final VoidCallback onDismissed;

  /// Optional callback when tapping to edit the bill.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(bill.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDismissed();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.l),
        decoration: const BoxDecoration(
          color: AppColors.over,
          borderRadius: AppSpacing.borderRadiusCard,
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        color: isDark
            ? AppColors.surfaceVariantDark
            : AppColors.surfaceVariantLight,
        child: ListTile(
          onTap: onTap,
          title: Text(
            bill.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${bill.recurrence.name.toUpperCase()} · Due ${bill.firstDueDate.toIsoString()}',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          trailing: Text(
            MoneyFormatter.format(bill.amount),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
