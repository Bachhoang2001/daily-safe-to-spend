import '../local_date.dart';
import '../money.dart';

/// A concrete occurrence of a bill falling due on a specific calendar date.
class BillOccurrence {
  /// Identifier of the parent bill.
  final String billId;

  /// Display name of the bill.
  final String billName;

  /// Monetary amount due for this occurrence.
  final Money amount;

  /// Due date of this occurrence.
  final LocalDate dueDate;

  /// Creates an immutable [BillOccurrence].
  const BillOccurrence({
    required this.billId,
    required this.billName,
    required this.amount,
    required this.dueDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillOccurrence &&
          runtimeType == other.runtimeType &&
          billId == other.billId &&
          billName == other.billName &&
          amount == other.amount &&
          dueDate == other.dueDate;

  @override
  int get hashCode => Object.hash(billId, billName, amount, dueDate);

  @override
  String toString() =>
      'BillOccurrence(id: $billId, name: $billName, amount: $amount, due: $dueDate)';
}
