/// Standard view state enumeration for reactive controllers and UI views.
///
/// Follows `specs/000-conventions.md`:
/// `enum ViewState { initial, loading, success, empty, error }`
enum ViewState {
  /// Initial uninitialized state.
  initial,

  /// Idle state (alias for initial).
  idle,

  /// Asynchronous operation in progress.
  loading,

  /// Operation finished successfully.
  success,

  /// Operation completed successfully but produced an empty dataset.
  empty,

  /// Operation failed with an error.
  error;

  /// Whether current state is [initial] or [idle].
  bool get isInitial => this == ViewState.initial || this == ViewState.idle;

  /// Whether current state is [loading].
  bool get isLoading => this == ViewState.loading;

  /// Whether current state is [success].
  bool get isSuccess => this == ViewState.success;

  /// Whether current state is [empty].
  bool get isEmpty => this == ViewState.empty;

  /// Whether current state is [error].
  bool get isError => this == ViewState.error;
}
