import '../local_date.dart';
import '../money.dart';

/// An immutable savings goal definition.
class Goal {
  /// Unique identifier of this goal.
  final String id;

  /// Display name of the goal (e.g. 'Emergency Fund', 'New Laptop').
  final String name;

  /// Target monetary amount to accumulate.
  final Money targetAmount;

  /// Optional automatic contribution reserved from pool per paycheck (in fixed mode).
  final Money perPaycheckAmount;

  /// Date when the goal was created.
  final LocalDate createdOn;

  /// Optional target completion date.
  final LocalDate? targetDate;

  /// Whether this goal is actively being tracked.
  final bool isActive;

  /// Creates an immutable [Goal].
  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.perPaycheckAmount = const Money(0),
    required this.createdOn,
    this.targetDate,
    this.isActive = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          targetAmount == other.targetAmount &&
          perPaycheckAmount == other.perPaycheckAmount &&
          createdOn == other.createdOn &&
          targetDate == other.targetDate &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    targetAmount,
    perPaycheckAmount,
    createdOn,
    targetDate,
    isActive,
  );

  @override
  String toString() =>
      'Goal(id: $id, name: $name, target: $targetAmount, perPaycheck: $perPaycheckAmount)';
}
