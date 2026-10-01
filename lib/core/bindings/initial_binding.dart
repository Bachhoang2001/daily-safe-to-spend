import 'package:get/get.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';

/// Global initial binding for long-lived application services & repositories.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<Clock>(const SystemClock(), permanent: true)
      ..put<UuidGenerator>(const DefaultUuidGenerator(), permanent: true);
  }
}
