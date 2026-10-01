import 'package:budget_engine/budget_engine.dart';
import 'package:safe_to_spend/data/db/app_database.dart';

/// Extension methods for converting [GoalData] and [GoalContributionData] to domain models.
extension GoalMapper on GoalData {
  /// Converts Drift database row [GoalData] to domain [Goal].
  Goal toDomain([String currency = 'USD']) {
    final safeCurrency = currency.isEmpty ? 'USD' : currency;
    final safeCreatedDate =
        LocalDate.tryParse(createdOn) ?? const LocalDate(2026, 1, 1);
    return Goal(
      id: id,
      name: name,
      targetAmount: Money(targetAmountCents, safeCurrency),
      targetDate: LocalDate.tryParse(targetDate),
      perPaycheckAmount: perPaycheckCents != null
          ? Money(perPaycheckCents!, safeCurrency)
          : const Money(0),
      createdOn: safeCreatedDate,
      isActive: isActive,
    );
  }
}

/// Extension methods for converting [GoalContributionData] to [GoalContribution].
extension GoalContributionMapper on GoalContributionData {
  /// Converts Drift database row [GoalContributionData] to domain [GoalContribution].
  GoalContribution toDomain([String currency = 'USD']) {
    final safeCurrency = currency.isEmpty ? 'USD' : currency;
    final safeDate = LocalDate.tryParse(onDate) ?? const LocalDate(2026, 1, 1);
    return GoalContribution(
      id: id,
      goalId: goalId,
      amount: Money(amountCents, safeCurrency),
      onDate: safeDate,
      source: source,
    );
  }
}
