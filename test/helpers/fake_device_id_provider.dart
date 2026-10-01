import 'package:safe_to_spend/core/ids/device_id_provider.dart';

/// Test fake for [DeviceIdProvider] that returns a fixed test device ID.
class FakeDeviceIdProvider implements DeviceIdProvider {
  /// Creates a [FakeDeviceIdProvider] with a default or custom [deviceId].
  FakeDeviceIdProvider({this.deviceId = 'device-test-uuid-0001'});

  /// Device ID returned in tests.
  final String deviceId;

  @override
  Future<String> getDeviceId() async => deviceId;

  @override
  String get currentDeviceId => deviceId;
}
