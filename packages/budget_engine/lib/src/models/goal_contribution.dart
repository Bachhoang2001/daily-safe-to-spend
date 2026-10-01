import '../local_date.dart';
import '../money.dart';

/// An immutable manual contribution made towards a specific savings goal.
class GoalContribution {
  /// Unique identifier of this contribution.
  final String id;

  /// Identifier of the target [Goal].
  final String goalId;

  /// Monetary amount contributed.
  final Money amount;

  /// Calendar date when the contribution was recorded.
  final LocalDate onDate;

  /// Optional memo or description.
  final String? note;

  /// Source of the contribution (e.g. 'manual', default: 'manual').
  final String source;

  /// Creates an immutable [GoalContribution].
  const GoalContribution({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.onDate,
    this.note,
    this.source = 'manual',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalContribution &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          goalId == other.goalId &&
          amount == other.amount &&
          onDate == other.onDate &&
          note == other.note &&
          source == other.source;

  @override
  int get hashCode => Object.hash(id, goalId, amount, onDate, note, source);

  @override
  String toString() =>
      'GoalContribution(id: $id, goalId: $goalId, amount: $amount, onDate: $onDate, source: $source)';
}
