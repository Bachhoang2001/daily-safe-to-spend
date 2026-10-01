import '../local_date.dart';
import '../money.dart';

/// An immutable recorded income entry (primarily used in irregular income mode).
class IncomeEntry {
  /// Unique identifier of this income entry.
  final String id;

  /// Monetary amount received.
  final Money amount;

  /// Calendar day on which the income was received.
  final LocalDate receivedOn;

  /// Optional memo or description of the income source.
  final String? note;

  /// Creates an immutable [IncomeEntry].
  const IncomeEntry({
    required this.id,
    required this.amount,
    required this.receivedOn,
    this.note,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          receivedOn == other.receivedOn &&
          note == other.note;

  @override
  int get hashCode => Object.hash(id, amount, receivedOn, note);

  @override
  String toString() =>
      'IncomeEntry(id: $id, amount: $amount, receivedOn: $receivedOn)';
}
