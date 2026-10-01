import 'package:safe_to_spend/core/ids/uuid_generator.dart';

/// Test fake for [UuidGenerator] producing predictable sequential IDs.
class FakeUuidGenerator implements UuidGenerator {
  /// Creates a [FakeUuidGenerator] with an optional [prefix].
  FakeUuidGenerator({this.prefix = 'uuid'});

  int _counter = 0;

  /// Prefix attached to each generated ID.
  final String prefix;

  @override
  String generate() {
    _counter++;
    return '$prefix-${_counter.toString().padLeft(4, '0')}';
  }

  /// Resets the generation counter to zero.
  void reset() {
    _counter = 0;
  }
}
