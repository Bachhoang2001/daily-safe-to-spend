/// Contract for application key-value configuration and preferences storage.
///
/// Stores lightweight preferences, theme configurations, flags, and persistent
/// identifiers (such as the device identifier).
abstract class ISettingsRepository {
  /// Retrieves the string value associated with [key], or `null` if absent.
  Future<String?> getString(String key);

  /// Stores or updates the string [value] associated with [key].
  Future<void> setString(String key, String value);

  /// Emits the string value associated with [key] whenever it changes.
  ///
  /// Emits `null` initially if the key does not currently exist.
  Stream<String?> watchString(String key);

  /// Removes the setting entry associated with [key].
  Future<void> remove(String key);
}
