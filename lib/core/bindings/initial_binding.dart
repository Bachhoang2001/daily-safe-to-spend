import 'package:get/get.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/startup/startup_task.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/repositories/bill_repository.dart';
import 'package:safe_to_spend/data/repositories/category_repository.dart';
import 'package:safe_to_spend/data/repositories/expense_repository.dart';
import 'package:safe_to_spend/data/repositories/goal_repository.dart';
import 'package:safe_to_spend/data/repositories/income_repository.dart';
import 'package:safe_to_spend/data/repositories/profile_repository.dart';
import 'package:safe_to_spend/data/repositories/settings_repository.dart';
import 'package:safe_to_spend/data/services/budget_snapshot_service.dart';
import 'package:safe_to_spend/data/services/deep_link_service.dart';
import 'package:safe_to_spend/data/services/noop_analytics_service.dart';

import 'package:safe_to_spend/domain/repositories/i_bill_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_category_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_expense_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_goal_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_income_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_settings_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';
import 'package:safe_to_spend/domain/services/i_budget_snapshot_service.dart';
import 'package:safe_to_spend/domain/services/i_deep_link_service.dart';

/// Global initial binding for long-lived application services & repositories.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    const clock = SystemClock();
    const uuid = DefaultUuidGenerator();

    final db = Get.isRegistered<AppDatabase>()
        ? Get.find<AppDatabase>()
        : AppDatabase.defaults();

    final settingsRepo = SettingsRepository(db: db, clock: clock);
    final deviceIdProvider = DeviceIdProvider(
      settingsRepo: settingsRepo,
      uuid: uuid,
    );

    Get
      ..put<Clock>(clock, permanent: true)
      ..put<UuidGenerator>(uuid, permanent: true)
      ..put<AppDatabase>(db, permanent: true)
      ..put<ISettingsRepository>(settingsRepo, permanent: true)
      ..put<DeviceIdProvider>(deviceIdProvider, permanent: true)
      ..put<IProfileRepository>(
        ProfileRepository(
          db: db,
          clock: Get.find(),
          uuid: Get.find(),
          deviceIdProvider: deviceIdProvider,
        ),
        permanent: true,
      )
      ..put<IExpenseRepository>(
        ExpenseRepository(
          db: db,
          clock: Get.find(),
          uuid: Get.find(),
          deviceIdProvider: deviceIdProvider,
        ),
        permanent: true,
      )
      ..put<IIncomeRepository>(
        IncomeRepository(
          db: db,
          clock: Get.find(),
          uuid: Get.find(),
          deviceIdProvider: deviceIdProvider,
        ),
        permanent: true,
      )
      ..put<IBillRepository>(
        BillRepository(
          db: db,
          clock: Get.find(),
          uuid: Get.find(),
          deviceIdProvider: deviceIdProvider,
        ),
        permanent: true,
      )
      ..put<IGoalRepository>(
        GoalRepository(
          db: db,
          clock: Get.find(),
          uuid: Get.find(),
          deviceIdProvider: deviceIdProvider,
        ),
        permanent: true,
      )
      ..put<ICategoryRepository>(
        CategoryRepository(
          db: db,
          clock: Get.find(),
          uuid: Get.find(),
          deviceIdProvider: deviceIdProvider,
        ),
        permanent: true,
      )
      ..put<IAnalyticsService>(const NoOpAnalyticsService(), permanent: true)
      ..put<IDeepLinkService>(
        DeepLinkService(profileRepo: Get.find(), analytics: Get.find()),
        permanent: true,
      )
      ..put<IBudgetSnapshotService>(
        BudgetSnapshotService(
          profileRepo: Get.find(),
          expenseRepo: Get.find(),
          incomeRepo: Get.find(),
          billRepo: Get.find(),
          goalRepo: Get.find(),
          clock: Get.find(),
        ),
        permanent: true,
      )
      ..put<IStartupTaskRunner>(
        StartupTaskRunner(analytics: Get.find()),
        permanent: true,
      )
      ..put<INavigator>(const AppNavigator(), permanent: true);
  }
}
