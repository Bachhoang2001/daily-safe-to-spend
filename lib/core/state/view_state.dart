/// Status enumeration for asynchronous view operations.
enum ViewStatus {
  /// Initial uninitialized state.
  initial,

  /// Asynchronous operation in progress.
  loading,

  /// Operation finished successfully.
  success,

  /// Operation failed with an error.
  error,
}

/// Generic wrapper representing state, data, and error message for reactive UI views.
class ViewState<T> {
  const ViewState({
    this.status = ViewStatus.initial,
    this.data,
    this.errorMessage,
  });

  /// Factory for the initial state.
  factory ViewState.initial() => const ViewState();

  /// Factory for the loading state, optionally retaining previous data.
  factory ViewState.loading([T? previousData]) =>
      ViewState(status: ViewStatus.loading, data: previousData);

  /// Factory for the successful state with loaded [data].
  factory ViewState.success(T data) =>
      ViewState(status: ViewStatus.success, data: data);

  /// Factory for the error state with a user-friendly [message].
  factory ViewState.error(String message, [T? previousData]) => ViewState(
    status: ViewStatus.error,
    errorMessage: message,
    data: previousData,
  );

  /// Current execution status.
  final ViewStatus status;

  /// Associated data payload, if any.
  final T? data;

  /// User-friendly error message, populated when status is [ViewStatus.error].
  final String? errorMessage;

  /// Whether the current state is [ViewStatus.initial].
  bool get isInitial => status == ViewStatus.initial;

  /// Whether the current state is [ViewStatus.loading].
  bool get isLoading => status == ViewStatus.loading;

  /// Whether the current state is [ViewStatus.success].
  bool get isSuccess => status == ViewStatus.success;

  /// Whether the current state is [ViewStatus.error].
  bool get isError => status == ViewStatus.error;

  /// Whether data is available.
  bool get hasData => data != null;
}
