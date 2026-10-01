/// Pure Dart business logic & calculation engine for Daily Safe-to-Spend.
///
/// This package encapsulates the pure financial algorithm of the Safe-to-Spend
/// philosophy, completely free of any Flutter SDK, platform channels, or I/O.
///
/// ### Core Entry Point
/// - [computeSnapshot]: Pure function evaluating `(EngineInput, LocalDate) -> BudgetSnapshot`.
///
/// ### Core Primitives
/// - [Money]: Immutable integer-cents representation of currency values, immune to float rounding errors.
/// - [LocalDate]: Immutable calendar date representation (`YYYY-MM-DD`) free from timezone and DST anomalies.
///
/// ### Income & Rollover Modes
/// - **Fixed Income ([IncomeMode.fixed]):** Supports weekly, biweekly, semimonthly, and monthly paychecks.
///   - [RolloverMode.spread]: Default mode; amortizes surplus or deficit across all remaining days in the period.
///   - [RolloverMode.tomorrow]: Tomorrow Boost (Premium); boosts the immediate next day's allowance with unspent surplus.
///   - [RolloverMode.save]: Save It (Premium); automatically routes unspent surplus into the active savings goal.
/// - **Irregular Income ([IncomeMode.irregular]):** Dynamic rolling balance evaluated across a rolling safety horizon window (default 14 days).
library;

export 'src/bill_occurrences.dart';
export 'src/compute_snapshot.dart';
export 'src/local_date.dart';
export 'src/models/bill.dart';
export 'src/models/bill_occurrence.dart';
export 'src/models/budget_config.dart';
export 'src/models/budget_snapshot.dart';
export 'src/models/engine_input.dart';
export 'src/models/enums.dart';
export 'src/models/expense.dart';
export 'src/models/goal.dart';
export 'src/models/goal_contribution.dart';
export 'src/models/goal_progress.dart';
export 'src/models/income_entry.dart';
export 'src/money.dart';
export 'src/period_resolver.dart';

/// Current version of the budget engine package.
const String budgetEngineVersion = '0.0.1';
