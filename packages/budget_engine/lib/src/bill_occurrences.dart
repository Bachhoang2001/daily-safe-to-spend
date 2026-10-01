import 'dart:math';

import 'local_date.dart';
import 'models/bill.dart';
import 'models/bill_occurrence.dart';
import 'models/enums.dart';

/// Generates concrete [BillOccurrence] instances for all active [bills]
/// falling due within the inclusive calendar window `[fromDate .. toDate]`.
///
/// ### Recurrence Rules (F02.6)
/// - **Weekly (`BillRecurrence.weekly`):** Repeats every 7 days based on the
///   day of the week of [Bill.firstDueDate].
/// - **Monthly (`BillRecurrence.monthly`):** Repeats on the day of the month
///   specified by [Bill.firstDueDate.day]. If the target month has fewer days
///   (e.g., Day 31 in a 30-day month or February), it automatically clamps to
///   the last day of that month.
/// - **Yearly (`BillRecurrence.yearly`):** Repeats annually on the same month
///   and day as [Bill.firstDueDate]. Clamps to February 28 in non-leap years
///   if the anchor date is February 29.
///
/// ### Filtering & Ordering
/// - Ignores bills where [Bill.isActive] is false.
/// - Never generates occurrences before [Bill.firstDueDate].
/// - Output is sorted in ascending chronological order by [BillOccurrence.dueDate].
List<BillOccurrence> generateBillOccurrences(
  List<Bill> bills,
  LocalDate fromDate,
  LocalDate toDate,
) {
  final occurrences = <BillOccurrence>[];

  for (final bill in bills) {
    if (!bill.isActive) continue;
    if (toDate.isBefore(bill.firstDueDate)) continue;

    final searchStart = fromDate.isAfter(bill.firstDueDate)
        ? fromDate
        : bill.firstDueDate;

    switch (bill.recurrence) {
      case BillRecurrence.weekly:
        final daysDiff = bill.firstDueDate.daysUntil(searchStart);
        final k = daysDiff <= 0 ? 0 : (daysDiff / 7).ceil();
        var curr = bill.firstDueDate.addDays(k * 7);

        while (curr.isBefore(toDate) || curr.isAtSameMomentAs(toDate)) {
          if (curr.isAfter(searchStart) || curr.isAtSameMomentAs(searchStart)) {
            occurrences.add(
              BillOccurrence(
                billId: bill.id,
                billName: bill.name,
                amount: bill.amount,
                dueDate: curr,
              ),
            );
          }
          curr = curr.addDays(7);
        }

      case BillRecurrence.monthly:
        var currYear = searchStart.year;
        var currMonth = searchStart.month;

        while (true) {
          final firstOfMonth = LocalDate(currYear, currMonth, 1);
          if (firstOfMonth.isAfter(toDate)) break;

          final maxDay = LocalDate.daysInMonth(currYear, currMonth);
          final actualDay = min(bill.firstDueDate.day, maxDay);
          final candidate = LocalDate(currYear, currMonth, actualDay);

          if ((candidate.isAfter(searchStart) ||
                  candidate.isAtSameMomentAs(searchStart)) &&
              (candidate.isBefore(toDate) ||
                  candidate.isAtSameMomentAs(toDate))) {
            occurrences.add(
              BillOccurrence(
                billId: bill.id,
                billName: bill.name,
                amount: bill.amount,
                dueDate: candidate,
              ),
            );
          }

          if (currMonth == 12) {
            currMonth = 1;
            currYear++;
          } else {
            currMonth++;
          }
        }

      case BillRecurrence.yearly:
        for (var y = searchStart.year; y <= toDate.year; y++) {
          final maxDay = LocalDate.daysInMonth(y, bill.firstDueDate.month);
          final actualDay = min(bill.firstDueDate.day, maxDay);
          final candidate = LocalDate(y, bill.firstDueDate.month, actualDay);

          if ((candidate.isAfter(searchStart) ||
                  candidate.isAtSameMomentAs(searchStart)) &&
              (candidate.isBefore(toDate) ||
                  candidate.isAtSameMomentAs(toDate))) {
            occurrences.add(
              BillOccurrence(
                billId: bill.id,
                billName: bill.name,
                amount: bill.amount,
                dueDate: candidate,
              ),
            );
          }
        }
    }
  }

  occurrences.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return occurrences;
}
