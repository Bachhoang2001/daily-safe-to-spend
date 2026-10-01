import '../local_date.dart';
import '../money.dart';

/// An immutable financial expense entry logged on a specific calendar day.
class Expense {
  /// Unique identifier of this expense.
  final String id;

  /// Monetary amount of the expense.
  final Money amount;

  /// Calendar day on which the expense was spent.
  final LocalDate spentOn;

  /// Optional category identifier.
  final String? categoryId;

  /// Optional user memo or note.
  final String? note;

  /// Creates an immutable [Expense].
  const Expense({
    required this.id,
    required this.amount,
    required this.spentOn,
    this.categoryId,
    this.note,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          spentOn == other.spentOn &&
          categoryId == other.categoryId &&
          note == other.note;

  @override
  int get hashCode => Object.hash(id, amount, spentOn, categoryId, note);

  @override
  String toString() => 'Expense(id: $id, amount: $amount, spentOn: $spentOn)';
}
