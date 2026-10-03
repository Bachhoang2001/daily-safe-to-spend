import 'package:budget_engine/budget_engine.dart';
import 'package:drift/drift.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/mappers/profile_mapper.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';

/// SQLite implementation of [IProfileRepository] using Drift.
class ProfileRepository implements IProfileRepository {
  /// Creates a [ProfileRepository].
  ProfileRepository({
    required this._db,
    required this._clock,
    required this._uuid,
    required this._deviceIdProvider,
  });

  final AppDatabase _db;
  final Clock _clock;
  final UuidGenerator _uuid;
  final DeviceIdProvider _deviceIdProvider;

  @override
  Stream<BudgetProfileModel?> watchActiveProfile() {
    return (_db.select(_db.budgetProfilesTable)
          ..where((t) => t.deletedAt.isNull())
          ..limit(1))
        .watchSingleOrNull()
        .map((row) => row?.toDomain());
  }

  @override
  Future<BudgetProfileModel?> getActiveProfile() async {
    final row =
        await (_db.select(_db.budgetProfilesTable)
              ..where((t) => t.deletedAt.isNull())
              ..limit(1))
            .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> saveProfile(BudgetProfileModel profile) async {
    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();
    final profileId = profile.id.isNotEmpty ? profile.id : _uuid.generate();

    final companion = BudgetProfilesTableCompanion(
      id: Value(profileId),
      createdAt: Value(now),
      updatedAt: Value(now),
      deviceId: Value(deviceId),
      currency: Value(profile.config.currency),
      incomeMode: Value(profile.config.incomeMode.name),
      payFrequency: Value(profile.config.payFrequency?.name),
      payAnchorDate: Value(profile.config.payAnchorDate?.toIsoString()),
      incomePerPaycheckCents: Value(profile.config.incomePerPaycheck?.cents),
      firstPeriodBalanceCents: Value(profile.config.firstPeriodBalance?.cents),
      startingBalanceCents: Value(profile.config.startingBalance?.cents),
      trackingStartDate: Value(profile.config.trackingStartDate.toIsoString()),
      safetyHorizonDays: Value(profile.config.safetyHorizonDays),
      bufferPercent: Value(profile.config.bufferPercent),
      rolloverMode: Value(profile.config.rolloverMode.name),
      timezone: Value(profile.timezone),
      weekStart: Value(profile.weekStart),
      onboardingCompleted: Value(profile.onboardingCompleted),
    );

    // If active profile already exists, update it, preserving createdAt
    final existing = await getActiveProfile();
    if (existing != null) {
      await (_db.update(
        _db.budgetProfilesTable,
      )..where((t) => t.id.equals(existing.id))).write(
        companion.copyWith(
          id: Value(existing.id),
          createdAt: const Value.absent(),
          updatedAt: Value(now),
        ),
      );
    } else {
      await _db.into(_db.budgetProfilesTable).insert(companion);
    }
    _cachedOnboardingCompleted = profile.onboardingCompleted;
  }

  @override
  Future<void> saveOnboarding({
    required BudgetProfileModel profile,
    required List<Bill> bills,
  }) async {
    await _db.transaction(() async {
      await saveProfile(profile.copyWith(onboardingCompleted: true));
      final now = _clock.now().millisecondsSinceEpoch;
      final deviceId = await _deviceIdProvider.getDeviceId();
      for (final bill in bills) {
        await _db
            .into(_db.billsTable)
            .insert(
              BillsTableCompanion(
                id: Value(bill.id.isNotEmpty ? bill.id : _uuid.generate()),
                createdAt: Value(now),
                updatedAt: Value(now),
                deviceId: Value(deviceId),
                profileId: Value(profile.id),
                name: Value(bill.name),
                amountCents: Value(bill.amount.cents),
                recurrence: Value(bill.recurrence.name),
                firstDueDate: Value(bill.firstDueDate.toIsoString()),
                remindDaysBefore: Value(bill.remindDaysBefore),
                isActive: Value(bill.isActive),
              ),
            );
      }
    });
    _cachedOnboardingCompleted = true;
  }

  bool _cachedOnboardingCompleted = false;

  @override
  bool hasCompletedOnboardingSync() => _cachedOnboardingCompleted;

  @override
  Future<bool> hasCompletedOnboarding() async {
    final profile = await getActiveProfile();
    return _cachedOnboardingCompleted = profile?.onboardingCompleted ?? false;
  }

  @override
  // Positional boolean complies with IProfileRepository interface definition.
  // ignore: avoid_positional_boolean_parameters
  Future<void> setOnboardingCompleted(bool completed) async {
    _cachedOnboardingCompleted = completed;
    final existing = await getActiveProfile();
    if (existing != null) {
      final now = _clock.now().millisecondsSinceEpoch;
      await (_db.update(
        _db.budgetProfilesTable,
      )..where((t) => t.id.equals(existing.id))).write(
        BudgetProfilesTableCompanion(
          onboardingCompleted: Value(completed),
          updatedAt: Value(now),
        ),
      );
    }
  }
}
