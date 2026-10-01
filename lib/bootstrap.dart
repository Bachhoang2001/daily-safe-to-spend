import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/app.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/repositories/category_repository.dart';
import 'package:safe_to_spend/data/repositories/settings_repository.dart';

/// Initializes core services and starts the application.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = Get.isRegistered<AppDatabase>()
      ? Get.find<AppDatabase>()
      : AppDatabase.defaults();
  Get.put<AppDatabase>(db, permanent: true);

  const clock = SystemClock();
  const uuid = DefaultUuidGenerator();
  final settingsRepo = SettingsRepository(db: db, clock: clock);
  final deviceIdProvider = DeviceIdProvider(
    settingsRepo: settingsRepo,
    uuid: uuid,
  );

  final categoryRepo = CategoryRepository(
    db: db,
    clock: clock,
    uuid: uuid,
    deviceIdProvider: deviceIdProvider,
  );
  await categoryRepo.seedDefaultCategories();

  runApp(const SafeToSpendApp());
}
