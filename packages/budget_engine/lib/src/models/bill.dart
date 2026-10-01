import '../local_date.dart';
import '../money.dart';
import 'enums.dart';

/// An immutable recurring bill definition.
class Bill {
  /// Unique identifier of this bill.
  final String id;

  /// Display name of the bill (e.g. 'Rent', 'Netflix').
  final String name;

  /// Monetary amount due for each recurring cycle.
  final Money amount;

  /// Recurrence schedule ([BillRecurrence.weekly], monthly, or yearly).
  final BillRecurrence recurrence;

  /// Date of the first occurrence of this bill.
  final LocalDate firstDueDate;

  /// Number of days before due date to remind the user (default 1).
  final int remindDaysBefore;

  /// Whether this bill is currently active.
  final bool isActive;

  /// Creates an immutable [Bill].
  const Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.recurrence,
    required this.firstDueDate,
    this.remindDaysBefore = 1,
    this.isActive = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bill &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          amount == other.amount &&
          recurrence == other.recurrence &&
          firstDueDate == other.firstDueDate &&
          remindDaysBefore == other.remindDaysBefore &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    amount,
    recurrence,
    firstDueDate,
    remindDaysBefore,
    isActive,
  );

  @override
  String toString() =>
      'Bill(id: $id, name: $name, amount: $amount, recurrence: $recurrence, firstDue: $firstDueDate, remindDaysBefore: $remindDaysBefore)';
}
