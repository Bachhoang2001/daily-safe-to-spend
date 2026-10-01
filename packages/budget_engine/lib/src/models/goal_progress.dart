import '../local_date.dart';
import '../money.dart';

/// Computed progress towards a savings goal.
class GoalProgress {
  /// Total monetary amount accumulated towards the goal.
  final Money savedAmount;

  /// Target monetary amount of the goal.
  final Money targetAmount;

  /// Percentage completed (0.0 to 100.0, clamped).
  final double percent;

  /// Whether the target amount has been achieved ([savedAmount] >= [targetAmount]).
  final bool isReached;

  /// Calendar date when the goal was reached, if applicable.
  final LocalDate? reachedOn;

  /// Creates an immutable [GoalProgress].
  const GoalProgress({
    required this.savedAmount,
    required this.targetAmount,
    required this.percent,
    required this.isReached,
    this.reachedOn,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalProgress &&
          runtimeType == other.runtimeType &&
          savedAmount == other.savedAmount &&
          targetAmount == other.targetAmount &&
          percent == other.percent &&
          isReached == other.isReached &&
          reachedOn == other.reachedOn;

  @override
  int get hashCode =>
      Object.hash(savedAmount, targetAmount, percent, isReached, reachedOn);

  @override
  String toString() =>
      'GoalProgress(saved: $savedAmount, target: $targetAmount, percent: $percent%, reached: $isReached)';
}
