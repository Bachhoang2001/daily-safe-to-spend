import 'package:drift/drift.dart';
import 'package:safe_to_spend/data/db/tables/common_sync_table.dart';

/// Table storing budget configurations, period setups, and onboarding states.
@DataClassName('BudgetProfileData')
class BudgetProfilesTable extends CommonSyncTable {
  @override
  String get tableName => 'budget_profiles';

  /// Primary currency code (e.g. 'USD').
  TextColumn get currency => text().withDefault(const Constant('USD'))();

  /// Income calculation mode ('fixed' | 'irregular').
  TextColumn get incomeMode => text()();

  /// Paycheck frequency for fixed income ('weekly', 'biweekly', 'semimonthly', 'monthly').
  TextColumn get payFrequency => text().nullable()();

  /// Known past paycheck date formatted as ISO string 'YYYY-MM-DD'.
  TextColumn get payAnchorDate => text().nullable()();

  /// Income amount per paycheck in integer cents.
  IntColumn get incomePerPaycheckCents => integer().nullable()();

  /// Initial balance for the first period when onboarding mid-cycle.
  IntColumn get firstPeriodBalanceCents => integer().nullable()();

  /// Starting liquid balance for irregular income mode.
  IntColumn get startingBalanceCents => integer().nullable()();

  /// Date tracking started formatted as ISO string 'YYYY-MM-DD'.
  TextColumn get trackingStartDate => text()();

  /// Safety horizon in days for irregular mode (default 14).
  IntColumn get safetyHorizonDays =>
      integer().withDefault(const Constant(14))();

  /// Emergency buffer safety percentage (0-20%).
  IntColumn get bufferPercent => integer().withDefault(const Constant(0))();

  /// Rollover strategy ('spread', 'tomorrow', 'save').
  TextColumn get rolloverMode => text().withDefault(const Constant('spread'))();

  /// User timezone name (e.g. 'America/New_York').
  TextColumn get timezone => text().withDefault(const Constant('UTC'))();

  /// Starting day of week (1 = Monday, ..., 7 = Sunday).
  IntColumn get weekStart => integer().withDefault(const Constant(1))();

  /// Flag indicating whether onboarding has been completed.
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
}
