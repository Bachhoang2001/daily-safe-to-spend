import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/app.dart';
import 'package:safe_to_spend/core/bindings/initial_binding.dart';
import 'package:safe_to_spend/core/startup/startup_task.dart';
import 'package:safe_to_spend/data/db/app_database.dart';

/// Initializes core platform services and starts the application.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize local SQLite database
  final db = Get.isRegistered<AppDatabase>()
      ? Get.find<AppDatabase>()
      : AppDatabase.defaults();
  Get.put<AppDatabase>(db, permanent: true);

  // 2. Initialize application-wide dependencies
  InitialBinding().dependencies();

  // 3. Register post-frame hook for lazy background startup tasks
  if (Get.isRegistered<IStartupTaskRunner>()) {
    final runner = Get.find<IStartupTaskRunner>();
    if (runner is StartupTaskRunner) {
      runner.schedulePostFrame();
    }
  }

  // 4. Run Flutter application
  runApp(const SafeToSpendApp());
}
