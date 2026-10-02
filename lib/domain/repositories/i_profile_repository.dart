import 'package:safe_to_spend/domain/models/budget_profile_model.dart';

/// Contract for managing user budget profiles and onboarding state.
///
/// Implementations handle persistence of the user's core financial configuration
/// (income mode, pay frequency, anchor dates, safety horizon, buffer percentage,
/// rollover mode, timezone, and week start), as well as onboarding completion status.
///
/// All read operations only return the active, non-deleted profile record
/// (`deleted_at IS NULL`).
abstract class IProfileRepository {
  /// Emits the currently active [BudgetProfileModel] whenever it changes.
  ///
  /// Emits `null` if no active budget profile exists (e.g. before onboarding).
  Stream<BudgetProfileModel?> watchActiveProfile();

  /// Retrieves the currently active [BudgetProfileModel] asynchronously.
  ///
  /// Returns `null` if no active budget profile has been configured yet.
  Future<BudgetProfileModel?> getActiveProfile();

  /// Persists the given [profile] configuration.
  ///
  /// If an active profile already exists, it is updated in-place while preserving
  /// the original creation timestamp. If no active profile exists, a new record
  /// is inserted with fresh audit timestamps and device identifier.
  Future<void> saveProfile(BudgetProfileModel profile);

  /// Checks whether the user has completed the initial onboarding setup.
  ///
  /// Returns `true` if an active profile exists with `onboardingCompleted == true`,
  /// or `false` otherwise.
  Future<bool> hasCompletedOnboarding();

  /// Synchronously returns whether the user has completed onboarding,
  /// based on cached state from bootstrap or recent mutation.
  bool hasCompletedOnboardingSync();

  /// Updates the onboarding completion flag for the active profile.
  ///
  /// Setting [completed] to `true` marks the application as ready for main shell navigation.
  // Positional boolean matches spec contract definition.
  // ignore: avoid_positional_boolean_parameters
  Future<void> setOnboardingCompleted(bool completed);
}
