import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/foundation.dart';

/// Immutable date range spanning from [start] to [end] inclusive.
@immutable
class DateRange {
  /// Creates a [DateRange] spanning from [start] to [end].
  const DateRange({required this.start, required this.end});

  /// Inclusive starting date of the range.
  final LocalDate start;

  /// Inclusive ending date of the range.
  final LocalDate end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DateRange($start .. $end)';
}
