import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/domain/repositories/i_settings_repository.dart';

/// Provider responsible for managing the persistent unique identifier of this device.
class DeviceIdProvider {
  /// Creates a [DeviceIdProvider] with required [_settingsRepo] and [_uuid] generator.
  DeviceIdProvider({required this._settingsRepo, required this._uuid});

  final ISettingsRepository _settingsRepo;
  final UuidGenerator _uuid;

  String? _cachedDeviceId;

  static const String _settingKey = 'app_device_id';

  /// Synchronous getter for device ID if already loaded.
  String get currentDeviceId => _cachedDeviceId ?? 'device-uninitialized';

  /// Asynchronously retrieves the device ID, generating and persisting a new UUID v4 if absent.
  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    final stored = await _settingsRepo.getString(_settingKey);
    if (stored != null && stored.isNotEmpty) {
      _cachedDeviceId = stored;
      return stored;
    }

    final newId = _uuid.generate();
    await _settingsRepo.setString(_settingKey, newId);
    _cachedDeviceId = newId;
    return newId;
  }
}
