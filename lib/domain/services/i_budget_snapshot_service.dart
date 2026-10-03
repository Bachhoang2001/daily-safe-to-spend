import 'package:budget_engine/budget_engine.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';

/// Central reactive service coordinating calculation of the Safe-to-Spend snapshot.
///
/// Implemented as a singleton `GetxService` registered permanently in `InitialBinding`.
/// Listens to underlying database streams (`IProfileRepository`, `IExpenseRepository`,
/// `IBillRepository`, `IIncomeRepository`, `IGoalRepository`), combines their data,
/// debounces mutations, and invokes the pure `computeSnapshot` budget engine.
///
/// ### Architecture Rule:
/// - Presentation controllers must **never** call `computeSnapshot` directly.
/// - Controllers only observe [snapshot] or read [currentSnapshot] from this service.
abstract class IBudgetSnapshotService {
  /// Reactive observable stream emitting the most up-to-date [BudgetSnapshot].
  ///
  /// Emits `null` if the user has not yet completed onboarding or configured an active profile.
  Rx<BudgetSnapshot?> get snapshot;

  /// Returns the most recently computed [BudgetSnapshot], or `null` if uninitialized.
  BudgetSnapshot? get currentSnapshot;

  /// Forces an immediate recalculation of the snapshot.
  ///
  /// Useful when an external boundary condition changes without a database mutation
  /// (for example, when midnight passes and `today` advances).
  Future<void> refresh();

  /// Reactive error message if computation or data loading encounters an error.
  ///
  /// Emits `null` when healthy. Contains a user-safe message when calculation fails.
  Rx<String?> get error;

  /// Computes a preview snapshot synchronously in memory from an in-flight [draft].
  ///
  /// Does not write to the database or mutate the reactive [snapshot] stream.
  BudgetSnapshot preview(OnboardingDraft draft);
}
