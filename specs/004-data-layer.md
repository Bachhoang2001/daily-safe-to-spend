# Spec 004 · F03 — Data layer (drift schema, DAO, repository)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 004
> **Phụ thuộc:** Spec 002, Spec 003 · **Ước lượng:** 2 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Lưu trữ cục bộ bền vững, sẵn sàng đồng bộ ở Giai đoạn 3.

**Bảng** (mọi bảng có cột chung: `id`, `created_at`, `updated_at`, `deleted_at`, `device_id`):

| Bảng | Cột nghiệp vụ |
|---|---|
| `budget_profile` | `currency`, `income_mode`, `pay_frequency?`, `pay_anchor_date?`, `income_per_paycheck_cents?`, `first_period_balance_cents?`, `starting_balance_cents?`, `tracking_start_date`, `safety_horizon_days`, `buffer_percent`, `rollover_mode`, `timezone`, `week_start` |
| `income_entry` | `profile_id`, `amount_cents`, `received_on`, `note?` |
| `bill` | `profile_id`, `name`, `amount_cents`, `recurrence`, `first_due_date`, `remind_days_before` (mặc định 1), `is_active` |
| `expense` | `profile_id`, `amount_cents`, `spent_on`, `category_id?`, `note?`, `source` (`manual`/`widget`), `currency` |
| `category` | `name_key` (key l10n) hoặc `custom_name?`, `icon`, `color`, `sort_order`, `is_default` |
| `goal` | `profile_id`, `name`, `target_amount_cents`, `target_date?`, `per_paycheck_cents?`, `created_on`, `is_active` |
| `goal_contribution` | `goal_id`, `amount_cents`, `on_date`, `source` (`manual`) |
| `app_setting` | `key` (PK thay cho id), `value` (TEXT/JSON), `updated_at` |

> Lưu ý: bảng giao dịch tên `expense` (tránh từ khóa `transaction`).

**Danh mục mặc định (seed):** Food & Drink, Groceries, Transport, Shopping, Fun, Bills & Utilities, Health, Other.

**Repository** (interface `I...Repository` ở `lib/domain/repositories/`, hiện thực ở `lib/data/repositories/`, đăng ký qua `Get.put(..., permanent: true)` trong `InitialBinding`):
- `ProfileRepository`: `watchActive()`, `save(profile)`, `hasCompletedOnboarding()`.
- `ExpenseRepository`: `watchRange(from, to)`, `add`, `update`, `softDelete`, `restore` (cho Undo).
- `IncomeRepository`, `BillRepository`, `GoalRepository`, `CategoryRepository`, `SettingsRepository`.
- `BudgetSnapshotService` (`GetxService`, permanent, ở `lib/data/services/`): gộp các stream từ repository → `EngineInput` → gọi engine → phát `Rx<BudgetSnapshot?> snapshot`. Mọi controller cần con số đều đọc từ service này, **không** tự gọi engine.

**Migration:** `schemaVersion = 1`; có test migration bằng `drift_dev` schema dump để chuẩn bị cho các phiên bản sau.

**Test cases:**
- T03-1: Thêm expense → `watchRange` phát giá trị mới.
- T03-2: `softDelete` → không xuất hiện trong query mặc định; `restore` → xuất hiện lại.
- T03-3: `update` thay đổi `updated_at`, giữ `created_at`.
- T03-4: Mọi bản ghi mới có UUID v4 hợp lệ và `device_id`.
- T03-5: Seed danh mục chạy đúng 1 lần (chạy bootstrap 2 lần không nhân đôi).
- T03-6: `BudgetSnapshotService.snapshot` phát giá trị mới khi thêm expense/bill/income.
- T03-7: Tiền lưu/đọc đúng cents (không sai số).
- T03-8: Schema dump v1 được commit và test migration chạy được.

**Definition of Done:**
- [x] Không có xóa cứng trong toàn bộ data layer (trừ chức năng "Erase all data" ở Spec 017 — ghi rõ ngoại lệ)
- [x] Mọi query đọc mặc định lọc `deleted_at IS NULL`
- [x] DB chạy trên background isolate (drift `NativeDatabase.createInBackground`)

**Remember:** `docs/SESSION_STATE.md` (mục Knowledge) — sơ đồ bảng, quy ước soft delete, cách thêm migration.

---

## Bổ sung khi chuyển sang MVC + GetX

- Phụ thuộc thêm Spec 003 vì `BudgetSnapshotService` gọi engine.
- Controller không gọi engine trực tiếp; luôn đọc `IBudgetSnapshotService.snapshot`.

---

## Implementation Plan

### 1. Danh sách file tạo/sửa & vai trò (tuân thủ `000-conventions.md` mục B2)

Toàn bộ data layer được tổ chức theo mô hình phân lớp rõ ràng:
- `lib/domain/`: Chứa các interface Repository, Service và Models độc lập hoàn toàn với Flutter SDK, GetX và Drift.
- `lib/data/db/`: Chứa bảng Drift, migration và kết nối cơ sở dữ liệu SQLite nền.
- `lib/data/mappers/`: Chuyển đổi hai chiều giữa Drift data rows và Engine/Domain models.
- `lib/data/repositories/`: Hiện thực các interface repository bằng Drift DAOs/queries, đảm bảo lọc `deleted_at IS NULL` và tự động cập nhật audit timestamp.
- `lib/data/services/`: Hiện thực `BudgetSnapshotService` (`GetxService`), gộp các reactive stream từ repository và gọi `computeSnapshot`.

| STT | Đường dẫn file | Vai trò / Trách nhiệm |
|---|---|---|
| 1 | `pubspec.yaml` | Bổ sung dependencies: `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`, `rxdart`; dev: `drift_dev`, `build_runner`. |
| 2 | `lib/domain/models/budget_profile_model.dart` | Domain model cho `BudgetProfile` (kết hợp `BudgetConfig`, `timezone`, `weekStart`, `onboardingCompleted`). |
| 3 | `lib/domain/models/category_model.dart` | Domain model cho danh mục chi tiêu (`id`, `nameKey`, `customName`, `icon`, `color`, `sortOrder`, `isDefault`). |
| 4 | `lib/domain/repositories/i_profile_repository.dart` | Interface quản trị ngân sách: `watchActiveProfile()`, `getActiveProfile()`, `saveProfile()`, `hasCompletedOnboarding()`. |
| 5 | `lib/domain/repositories/i_expense_repository.dart` | Interface quản trị chi tiêu: `watchRange()`, `getRange()`, `addExpense()`, `updateExpense()`, `softDelete()`, `restore()`. |
| 6 | `lib/domain/repositories/i_income_repository.dart` | Interface quản trị thu nhập: `watchAll()`, `getAll()`, `addIncome()`, `updateIncome()`, `softDelete()`, `restore()`. |
| 7 | `lib/domain/repositories/i_bill_repository.dart` | Interface quản trị hóa đơn: `watchActive()`, `getActive()`, `addBill()`, `updateBill()`, `softDelete()`, `restore()`. |
| 8 | `lib/domain/repositories/i_goal_repository.dart` | Interface quản trị mục tiêu & đóng góp: `watchActiveGoal()`, `saveGoal()`, `softDeleteGoal()`, `watchContributions()`, `addContribution()`. |
| 9 | `lib/domain/repositories/i_category_repository.dart` | Interface quản trị danh mục: `watchCategories()`, `getCategories()`, `addCategory()`, `updateCategory()`, `seedDefaultCategories()`. |
| 10 | `lib/domain/repositories/i_settings_repository.dart` | Interface lưu trữ cấu hình key-value: `getString()`, `setString()`, `watchString()`, `remove()`. |
| 11 | `lib/domain/services/i_budget_snapshot_service.dart` | Interface dịch vụ tính toán ngân sách thời gian thực: `snapshot` (`Rx<BudgetSnapshot?>`), `currentSnapshot`, `refresh()`. |
| 12 | `lib/core/ids/device_id_provider.dart` | Provider lấy/sinh `deviceId` (UUID v4 bền vững) phục vụ audit trail và chuẩn bị đồng bộ Giai đoạn 3. |
| 13 | `lib/data/db/tables/common_sync_table.dart` | Abstract class định nghĩa các cột đồng bộ chuẩn: `id`, `created_at`, `updated_at`, `deleted_at`, `device_id`. |
| 14 | `lib/data/db/tables/budget_profiles_table.dart` | Bảng Drift `budget_profiles` lưu cấu hình ngân sách và trạng thái onboarding. |
| 15 | `lib/data/db/tables/income_entries_table.dart` | Bảng Drift `income_entries` lưu các khoản thu nhập thực tế. |
| 16 | `lib/data/db/tables/bills_table.dart` | Bảng Drift `bills` lưu các hóa đơn định kỳ và chu kỳ thanh toán. |
| 17 | `lib/data/db/tables/expenses_table.dart` | Bảng Drift `expenses` lưu các giao dịch chi tiêu theo ngày. |
| 18 | `lib/data/db/tables/categories_table.dart` | Bảng Drift `categories` lưu danh mục chi tiêu mặc định và tùy biến. |
| 19 | `lib/data/db/tables/goals_table.dart` | Bảng Drift `goals` lưu mục tiêu tiết kiệm. |
| 20 | `lib/data/db/tables/goal_contributions_table.dart` | Bảng Drift `goal_contributions` lưu các khoản nạp thủ công vào mục tiêu. |
| 21 | `lib/data/db/tables/app_settings_table.dart` | Bảng Drift `app_settings` lưu cặp key-value cho cài đặt ứng dụng. |
| 22 | `lib/data/db/app_database.dart` | Drift Database triển khai `NativeDatabase.createInBackground` cho runtime và memory cho unit test; quản lý seed & migration v1. |
| 23 | `lib/data/mappers/profile_mapper.dart` | Mapper giữa `BudgetProfileData` và `BudgetProfileModel` / `BudgetConfig`. |
| 24 | `lib/data/mappers/expense_mapper.dart` | Mapper giữa `ExpenseData` và `Expense` (chuyển đổi `amount_cents` ↔ `Money`, `spent_on` ↔ `LocalDate`). |
| 25 | `lib/data/mappers/income_mapper.dart` | Mapper giữa `IncomeEntryData` và `IncomeEntry`. |
| 26 | `lib/data/mappers/bill_mapper.dart` | Mapper giữa `BillData` và `Bill`. |
| 27 | `lib/data/mappers/goal_mapper.dart` | Mapper giữa `GoalData` / `GoalContributionData` và `Goal` / `GoalContribution`. |
| 28 | `lib/data/mappers/category_mapper.dart` | Mapper giữa `CategoryData` và `CategoryModel`. |
| 29 | `lib/data/repositories/profile_repository.dart` | Hiện thực `IProfileRepository` trên Drift SQLite. |
| 30 | `lib/data/repositories/expense_repository.dart` | Hiện thực `IExpenseRepository` hỗ trợ soft-delete và khôi phục undo. |
| 31 | `lib/data/repositories/income_repository.dart` | Hiện thực `IIncomeRepository`. |
| 32 | `lib/data/repositories/bill_repository.dart` | Hiện thực `IBillRepository`. |
| 33 | `lib/data/repositories/goal_repository.dart` | Hiện thực `IGoalRepository`. |
| 34 | `lib/data/repositories/category_repository.dart` | Hiện thực `ICategoryRepository` và idempotent seeder cho 8 danh mục mặc định. |
| 35 | `lib/data/repositories/settings_repository.dart` | Hiện thực `ISettingsRepository`. |
| 36 | `lib/data/services/budget_snapshot_service.dart` | `GetxService` gộp reactive streams, debounce 50ms, gọi `computeSnapshot`, expose `Rx<BudgetSnapshot?>`. |
| 37 | `lib/core/bindings/initial_binding.dart` | Đăng ký toàn bộ Database, DeviceIdProvider, Repositories, và BudgetSnapshotService (`permanent: true`). |
| 38 | `lib/bootstrap.dart` | Khởi tạo background isolate database và chạy seed danh mục ban đầu. |
| 39 | `drift_schemas/drift_schema_v1.json` | Schema dump v1 do `drift_dev` xuất ra để phục vụ kiểm thử hồi quy migration. |
| 40 | `test/data/db/app_database_test.dart` | Unit test database: audit columns (UUID v4, device_id), idempotent seed categories, Money cents precision (T03-4, T03-5, T03-7). |
| 41 | `test/data/repositories/expense_repository_test.dart` | Unit test expense repo: watchRange phản ứng thêm mới, softDelete, restore, timestamps (T03-1, T03-2, T03-3). |
| 42 | `test/data/repositories/profile_bill_goal_repositories_test.dart` | Unit test CRUD & soft delete cho Profile, Income, Bill, Goal, Category, Settings. |
| 43 | `test/data/services/budget_snapshot_service_test.dart` | Unit test reactive snapshot: phản ứng khi thêm expense, bill, income và tự động hủy subscriptions (T03-6). |
| 44 | `test/data/db/migration_test.dart` | Unit test schema verification và migration v1 (T03-8). |

---

### 2. Chốt Schema Drift từng bảng & Cột đồng bộ chuẩn

#### A. Cột chung cho mọi bảng nghiệp vụ (`CommonSyncTable`)
Mọi bảng nghiệp vụ kế thừa từ `CommonSyncTable`:
```dart
abstract class CommonSyncTable extends Table {
  TextColumn get id => text()(); // UUID v4 PK
  IntColumn get createdAt => integer()(); // Epoch ms UTC
  IntColumn get updatedAt => integer()(); // Epoch ms UTC
  IntColumn get deletedAt => integer().nullable()(); // Epoch ms UTC (null = active, not null = soft deleted)
  TextColumn get deviceId => text()(); // Device identifier

  @override
  Set<Column> get primaryKey => {id};
}
```

#### B. Chi tiết 8 bảng dữ liệu

1. **`budget_profiles`** (Lưu cấu hình ngân sách & tiến độ onboarding):
   - Kế thừa: `CommonSyncTable`
   - `currency`: `TextColumn` (mặc định `'USD'`)
   - `incomeMode`: `TextColumn` (`'fixed'` | `'irregular'`)
   - `payFrequency`: `TextColumn.nullable()` (`'weekly'`, `'biweekly'`, `'semimonthly'`, `'monthly'`)
   - `payAnchorDate`: `TextColumn.nullable()` (chuỗi `'YYYY-MM-DD'`)
   - `incomePerPaycheckCents`: `IntColumn.nullable()`
   - `firstPeriodBalanceCents`: `IntColumn.nullable()`
   - `startingBalanceCents`: `IntColumn.nullable()`
   - `trackingStartDate`: `TextColumn` (chuỗi `'YYYY-MM-DD'`)
   - `safetyHorizonDays`: `IntColumn.withDefault(const Constant(14))()`
   - `bufferPercent`: `IntColumn.withDefault(const Constant(0))()`
   - `rolloverMode`: `TextColumn.withDefault(const Constant('spread'))()` (`'spread'`, `'tomorrow'`, `'save'`)
   - `timezone`: `TextColumn` (tên IANA, ví dụ `'America/New_York'`)
   - `weekStart`: `IntColumn.withDefault(const Constant(1))()` (1 = Monday ... 7 = Sunday)
   - `onboardingCompleted`: `BoolColumn.withDefault(const Constant(false))()`

2. **`income_entries`** (Thu nhập thực tế theo ngày cho irregular mode):
   - Kế thừa: `CommonSyncTable`
   - `profileId`: `TextColumn` (khóa ngoại logic tham chiếu `budget_profiles.id`)
   - `amountCents`: `IntColumn` (số nguyên cents > 0)
   - `receivedOn`: `TextColumn` (chuỗi `'YYYY-MM-DD'`)
   - `note`: `TextColumn.nullable()`

3. **`bills`** (Hóa đơn định kỳ):
   - Kế thừa: `CommonSyncTable`
   - `profileId`: `TextColumn`
   - `name`: `TextColumn`
   - `amountCents`: `IntColumn`
   - `recurrence`: `TextColumn` (`'weekly'`, `'biweekly'`, `'monthly'`, `'yearly'`)
   - `firstDueDate`: `TextColumn` (chuỗi `'YYYY-MM-DD'`)
   - `remindDaysBefore`: `IntColumn.withDefault(const Constant(1))()`
   - `isActive`: `BoolColumn.withDefault(const Constant(true))()`

4. **`expenses`** (Giao dịch chi tiêu hàng ngày - tránh từ khóa SQL `transaction`):
   - Kế thừa: `CommonSyncTable`
   - `profileId`: `TextColumn`
   - `amountCents`: `IntColumn` (số nguyên cents > 0)
   - `spentOn`: `TextColumn` (chuỗi `'YYYY-MM-DD'`)
   - `categoryId`: `TextColumn.nullable()` (tham chiếu `categories.id`)
   - `note`: `TextColumn.nullable()`
   - `source`: `TextColumn.withDefault(const Constant('manual'))()` (`'manual'`, `'widget'`)
   - `currency`: `TextColumn.withDefault(const Constant('USD'))()`

5. **`categories`** (Danh mục chi tiêu):
   - Kế thừa: `CommonSyncTable`
   - `nameKey`: `TextColumn` (key dịch l10n ARB, ví dụ `'category_food_drink'`)
   - `customName`: `TextColumn.nullable()` (tên người dùng tự đặt nếu tự tạo)
   - `icon`: `TextColumn` (tên icon identifier)
   - `color`: `TextColumn` (mã màu hex string)
   - `sortOrder`: `IntColumn.withDefault(const Constant(0))()`
   - `isDefault`: `BoolColumn.withDefault(const Constant(false))()`

6. **`goals`** (Mục tiêu tiết kiệm - tối đa 1 active ở MVP):
   - Kế thừa: `CommonSyncTable`
   - `profileId`: `TextColumn`
   - `name`: `TextColumn`
   - `targetAmountCents`: `IntColumn`
   - `targetDate`: `TextColumn.nullable()` (chuỗi `'YYYY-MM-DD'`)
   - `perPaycheckCents`: `IntColumn.nullable()`
   - `createdOn`: `TextColumn` (chuỗi `'YYYY-MM-DD'`)
   - `isActive`: `BoolColumn.withDefault(const Constant(true))()`

7. **`goal_contributions`** (Khoản nạp tiền thủ công vào mục tiêu):
   - Kế thừa: `CommonSyncTable`
   - `goalId`: `TextColumn` (tham chiếu `goals.id`)
   - `amountCents`: `IntColumn`
   - `onDate`: `TextColumn` (chuỗi `'YYYY-MM-DD'`)
   - `source`: `TextColumn.withDefault(const Constant('manual'))()`

8. **`app_settings`** (Cặp key-value lưu cài đặt ứng dụng):
   - `key`: `TextColumn` (`primaryKey`)
   - `value`: `TextColumn` (chuỗi TEXT / JSON)
   - `updatedAt`: `IntColumn` (Epoch ms UTC)
   - *Ghi chú:* Bảng cài đặt sử dụng `key` làm PK trực tiếp, không kế thừa `CommonSyncTable`.

#### C. Quy tắc Seed danh mục mặc định (Idempotent Seed)
8 danh mục mặc định:
1. Food & Drink (`category_food_drink`, icon: `restaurant`, color: `#FF8A65`, sort: 1)
2. Groceries (`category_groceries`, icon: `shopping_cart`, color: `#4DB6AC`, sort: 2)
3. Transport (`category_transport`, icon: `directions_car`, color: `#4FC3F7`, sort: 3)
4. Shopping (`category_shopping`, icon: `shopping_bag`, color: `#BA68C8`, sort: 4)
5. Fun (`category_fun`, icon: `celebration`, color: `#FFD54F`, sort: 5)
6. Bills & Utilities (`category_bills_utilities`, icon: `receipt_long`, color: `#90A4AE`, sort: 6)
7. Health (`category_health`, icon: `favorite`, color: `#E57373`, sort: 7)
8. Other (`category_other`, icon: `more_horiz`, color: `#A1887F`, sort: 8)

*Cơ chế Idempotent:* `seedDefaultCategories()` kiểm tra nếu đã tồn tại record có `is_default = true` thì bỏ qua (hoặc sử dụng `insertOnConflictUpdate`), bảo đảm chạy 2 lần không nhân đôi (T03-5).

---

### 3. Chốt Interface Repository trong `lib/domain/repositories/`

Mọi interface độc lập hoàn toàn với Flutter SDK, GetX và Drift. Các phương thức đọc mặc định chỉ trả về bản ghi active (`deleted_at IS NULL`).

#### A. `IProfileRepository`
```dart
abstract class IProfileRepository {
  Stream<BudgetProfileModel?> watchActiveProfile();
  Future<BudgetProfileModel?> getActiveProfile();
  Future<void> saveProfile(BudgetProfileModel profile);
  Future<bool> hasCompletedOnboarding();
  Future<void> setOnboardingCompleted(bool completed);
}
```

#### B. `IExpenseRepository`
```dart
abstract class IExpenseRepository {
  Stream<List<Expense>> watchRange({required LocalDate from, required LocalDate to});
  Future<List<Expense>> getRange({required LocalDate from, required LocalDate to});
  Future<Expense?> getById(String id);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> softDelete(String id);
  Future<void> restore(String id);
}
```

#### C. `IIncomeRepository`
```dart
abstract class IIncomeRepository {
  Stream<List<IncomeEntry>> watchAll();
  Future<List<IncomeEntry>> getAll();
  Future<IncomeEntry?> getById(String id);
  Future<void> addIncome(IncomeEntry entry);
  Future<void> updateIncome(IncomeEntry entry);
  Future<void> softDelete(String id);
  Future<void> restore(String id);
}
```

#### D. `IBillRepository`
```dart
abstract class IBillRepository {
  Stream<List<Bill>> watchActive();
  Future<List<Bill>> getActive();
  Future<Bill?> getById(String id);
  Future<void> addBill(Bill bill);
  Future<void> updateBill(Bill bill);
  Future<void> softDelete(String id);
  Future<void> restore(String id);
}
```

#### E. `IGoalRepository`
```dart
abstract class IGoalRepository {
  Stream<Goal?> watchActiveGoal();
  Future<Goal?> getActiveGoal();
  Future<void> saveGoal(Goal goal);
  Future<void> softDeleteGoal(String id);
  
  Stream<List<GoalContribution>> watchContributions(String goalId);
  Future<List<GoalContribution>> getContributions(String goalId);
  Future<void> addContribution(GoalContribution contribution);
  Future<void> softDeleteContribution(String id);
  Future<void> restoreContribution(String id);
}
```

#### F. `ICategoryRepository`
```dart
abstract class ICategoryRepository {
  Stream<List<CategoryModel>> watchCategories();
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel?> getById(String id);
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> softDelete(String id);
  Future<void> seedDefaultCategories();
}
```

#### G. `ISettingsRepository`
```dart
abstract class ISettingsRepository {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Stream<String?> watchString(String key);
  Future<void> remove(String key);
}
```

---

### 4. Chốt Mapper Drift Row ↔ Model Engine (`lib/data/mappers/`)

Quy tắc mapping:
- `amount_cents` (`int`) ↔ `Money(cents: amountCents, currency: currency)` (Bảo đảm không bao giờ dùng `double`).
- Chuỗi `'YYYY-MM-DD'` (`String`) ↔ `LocalDate.parse(isoString)` / `localDate.toIsoString()`.
- String enum trong DB ↔ Dart enum (`IncomeMode`, `PayFrequency`, `RolloverMode`, `BillRecurrence`).
- `deleted_at`: Nếu `deleted_at != null` thì bản ghi ở trạng thái soft-deleted.

1. **`ProfileMapper`:**
   - DB `BudgetProfileData` ↔ `BudgetProfileModel`:
     - Trích xuất `BudgetConfig`:
       - `currency: row.currency`
       - `incomeMode: IncomeMode.values.byName(row.incomeMode)`
       - `payFrequency: row.payFrequency != null ? PayFrequency.values.byName(row.payFrequency!) : null`
       - `payAnchorDate: row.payAnchorDate != null ? LocalDate.parse(row.payAnchorDate!) : null`
       - `incomePerPaycheck: row.incomePerPaycheckCents != null ? Money(cents: row.incomePerPaycheckCents!, currency: row.currency) : null`
       - `firstPeriodBalance: row.firstPeriodBalanceCents != null ? Money(cents: row.firstPeriodBalanceCents!, currency: row.currency) : null`
       - `startingBalance: row.startingBalanceCents != null ? Money(cents: row.startingBalanceCents!, currency: row.currency) : null`
       - `trackingStartDate: LocalDate.parse(row.trackingStartDate)`
       - `safetyHorizonDays: row.safetyHorizonDays`
       - `bufferPercent: row.bufferPercent`
       - `rolloverMode: RolloverMode.values.byName(row.rolloverMode)`
     - Giữ các thông tin mở rộng: `timezone: row.timezone`, `weekStart: row.weekStart`, `onboardingCompleted: row.onboardingCompleted`.
2. **`ExpenseMapper`:**
   - `ExpenseData` ↔ `Expense`:
     - `amount: Money(cents: row.amountCents, currency: row.currency)`
     - `spentOn: LocalDate.parse(row.spentOn)`
     - `categoryId: row.categoryId`, `note: row.note`, `source: row.source`
3. **`IncomeMapper`:**
   - `IncomeEntryData` ↔ `IncomeEntry`:
     - `amount: Money(cents: row.amountCents, currency: profileCurrency)`
     - `receivedOn: LocalDate.parse(row.receivedOn)`
4. **`BillMapper`:**
   - `BillData` ↔ `Bill`:
     - `amount: Money(cents: row.amountCents, currency: profileCurrency)`
     - `recurrence: BillRecurrence.values.byName(row.recurrence)`
     - `firstDueDate: LocalDate.parse(row.firstDueDate)`
     - `remindDaysBefore: row.remindDaysBefore`, `isActive: row.isActive`
5. **`GoalMapper`:**
   - `GoalData` ↔ `Goal`:
     - `targetAmount: Money(cents: row.targetAmountCents, currency: profileCurrency)`
     - `targetDate: row.targetDate != null ? LocalDate.parse(row.targetDate!) : null`
     - `perPaycheckAmount: row.perPaycheckCents != null ? Money(cents: row.perPaycheckCents!, currency: profileCurrency) : null`
     - `createdOn: LocalDate.parse(row.createdOn)`
   - `GoalContributionData` ↔ `GoalContribution`:
     - `amount: Money(cents: row.amountCents, currency: profileCurrency)`
     - `onDate: LocalDate.parse(row.onDate)`
6. **`CategoryMapper`:**
   - `CategoryData` ↔ `CategoryModel`:
     - `nameKey: row.nameKey`, `customName: row.customName`, `icon: row.icon`, `color: row.color`, `sortOrder: row.sortOrder`, `isDefault: row.isDefault`

---

### 5. Chốt Contract & Implementation `IBudgetSnapshotService`

#### A. Contract (`lib/domain/services/i_budget_snapshot_service.dart`)
```dart
abstract class IBudgetSnapshotService {
  /// Stream phản ứng chứa snapshot hiện tại.
  Rx<BudgetSnapshot?> get snapshot;

  /// Giá trị snapshot tính toán gần nhất.
  BudgetSnapshot? get currentSnapshot;

  /// Kích hoạt tính toán lại snapshot thủ công khi có thay đổi ngoại lai (ví dụ đổi ngày qua nửa đêm).
  Future<void> refresh();
}
```

#### B. Implementation (`lib/data/services/budget_snapshot_service.dart`)
- Kế thừa: `GetxService` triển khai `IBudgetSnapshotService`.
- Nhận dependencies qua constructor:
  - `IProfileRepository profileRepo`
  - `IExpenseRepository expenseRepo`
  - `IIncomeRepository incomeRepo`
  - `IBillRepository billRepo`
  - `IGoalRepository goalRepo`
  - `Clock clock`
- Cơ chế gộp stream:
  1. Lắng nghe `profileRepo.watchActiveProfile()`.
  2. Nếu profile null (chưa onboarding): phát `snapshot.value = null`.
  3. Khi có profile, tạo subscription gộp các stream:
     - Với `fixed`: xác định khoảng ngày của kỳ lương hiện tại qua `PeriodResolver.resolve(...)`. Lắng nghe `expenseRepo.watchRange(from: periodStart, to: periodEnd)`.
     - Với `irregular`: lắng nghe toàn bộ expenses từ `trackingStartDate` đến nay qua `expenseRepo.watchRange(from: profile.trackingStartDate, to: today)`.
     - Lắng nghe `incomeRepo.watchAll()`, `billRepo.watchActive()`, `goalRepo.watchActiveGoal()`, và `goalRepo.watchContributions(goal.id)`.
  4. Sử dụng RxDart `CombineLatestStream` (hoặc stream transformer) kết hợp toán tử `debounceTime(const Duration(milliseconds: 50))` để tránh re-compute liên tục khi thêm dữ liệu hàng loạt.
  5. Đóng gói thành `EngineInput`:
     ```dart
     final input = EngineInput(
       config: profile.config,
       expenses: expenses,
       bills: bills,
       goal: activeGoal,
       contributions: contributions,
       incomes: incomes,
     );
     final today = LocalDateFromDateTime.fromDateTime(clock.now(), profile.timezone);
     snapshot.value = computeSnapshot(input, today);
     ```
  6. Xử lý lỗi không im lặng: Nếu có lỗi tính toán, bắt ngoại lệ, ghi log an toàn (không lộ số tiền) và đặt trạng thái lỗi an toàn.
  7. Dọn dẹp tài nguyên: Triển khai trong `onClose()` — hủy toàn bộ `StreamSubscription` đã đăng ký.

---

### 6. Chốt Đăng ký DI trong `InitialBinding` (Permanent)

Mọi service và repository của data layer được đăng ký `permanent: true` trong `InitialBinding` theo đúng quy ước của `000-conventions.md`:

```dart
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Core Primitives & Utilities
    Get
      ..put<Clock>(const SystemClock(), permanent: true)
      ..put<UuidGenerator>(const DefaultUuidGenerator(), permanent: true);

    // 2. Database & Device ID
    final db = Get.isRegistered<AppDatabase>()
        ? Get.find<AppDatabase>()
        : AppDatabase.defaults(); // createInBackground for runtime
    Get.put<AppDatabase>(db, permanent: true);

    final deviceIdProvider = DeviceIdProvider(
      settingsRepo: SettingsRepository(db: db, clock: Get.find()),
      uuid: Get.find(),
    );
    Get.put<DeviceIdProvider>(deviceIdProvider, permanent: true);

    // 3. Repositories
    Get
      ..put<ISettingsRepository>(
        SettingsRepository(db: db, clock: Get.find()),
        permanent: true,
      )
      ..put<IProfileRepository>(
        ProfileRepository(db: db, clock: Get.find(), uuid: Get.find(), deviceIdProvider: deviceIdProvider),
        permanent: true,
      )
      ..put<IExpenseRepository>(
        ExpenseRepository(db: db, clock: Get.find(), uuid: Get.find(), deviceIdProvider: deviceIdProvider),
        permanent: true,
      )
      ..put<IIncomeRepository>(
        IncomeRepository(db: db, clock: Get.find(), uuid: Get.find(), deviceIdProvider: deviceIdProvider),
        permanent: true,
      )
      ..put<IBillRepository>(
        BillRepository(db: db, clock: Get.find(), uuid: Get.find(), deviceIdProvider: deviceIdProvider),
        permanent: true,
      )
      ..put<IGoalRepository>(
        GoalRepository(db: db, clock: Get.find(), uuid: Get.find(), deviceIdProvider: deviceIdProvider),
        permanent: true,
      )
      ..put<ICategoryRepository>(
        CategoryRepository(db: db, clock: Get.find(), uuid: Get.find(), deviceIdProvider: deviceIdProvider),
        permanent: true,
      );

    // 4. Budget Snapshot Service (GetxService)
    Get.put<IBudgetSnapshotService>(
      BudgetSnapshotService(
        profileRepo: Get.find(),
        expenseRepo: Get.find(),
        incomeRepo: Get.find(),
        billRepo: Get.find(),
        goalRepo: Get.find(),
        clock: Get.find(),
      ),
      permanent: true,
    );
  }
}
```

---

### 7. Ánh xạ Test Cases Spec 004 → File Test

Các file test được định danh chính xác theo AGENT-RUNBOOK.md cho bước DEFINE TEST:

| Mã Test Case | Nội dung kiểm thử | File Test đích |
|---|---|---|
| **T03-1** | Thêm expense → `watchRange` phát giá trị mới phản ứng tức thì | `test/data/repositories/expense_repository_test.dart` |
| **T03-2** | `softDelete` → không xuất hiện trong query mặc định; `restore` → xuất hiện lại | `test/data/repositories/expense_repository_test.dart` |
| **T03-3** | `update` thay đổi `updated_at`, giữ nguyên `created_at` ban đầu | `test/data/repositories/expense_repository_test.dart` |
| **T03-4** | Mọi bản ghi mới tự sinh UUID v4 hợp lệ và gắn đúng `device_id` | `test/data/db/app_database_test.dart` |
| **T03-5** | Seed danh mục mặc định chạy idempotent (chạy 2 lần không nhân đôi) | `test/data/db/app_database_test.dart` |
| **T03-6** | `BudgetSnapshotService.snapshot` tự phát giá trị mới khi thêm expense/bill/income | `test/data/services/budget_snapshot_service_test.dart` |
| **T03-7** | Tiền tệ lưu và đọc đúng số nguyên cents qua Drift SQLite (không sai số thập phân) | `test/data/db/app_database_test.dart` & `test/data/mappers/money_drift_test.dart` |
| **T03-8** | Schema dump v1 do `drift_dev` xuất ra được commit và test migration kiểm chứng thành công | `test/data/db/migration_test.dart` |
| **Extra CRUD** | Kiểm thử toàn diện CRUD & soft-delete cho Profile, Income, Bill, Goal, Settings | `test/data/repositories/profile_bill_goal_repositories_test.dart` |

---

### 8. Rủi ro & Câu hỏi mở

1. **Rủi ro code generation của Drift (`build_runner`):**
   - *Phân tích:* Sinh code qua `drift_dev` có thể tạo ra nhiều file `.g.dart`. Cần cấu hình `build.yaml` tối ưu để chỉ quét thư mục `lib/data/db/` nhằm tăng tốc độ build và tránh xung đột với các package khác.
   - *Giải pháp:* Chạy `dart run build_runner build --delete-conflicting-outputs` sạch sẽ và kiểm tra tĩnh bằng `flutter analyze`.
2. **Rủi ro NativeDatabase background isolate:**
   - *Phân tích:* Khi chạy unit test, môi trường không hỗ trợ isolate path như mobile native.
   - *Giải pháp:* Constructor của `AppDatabase` hỗ trợ injection `QueryExecutor`. Mặc định runtime dùng `NativeDatabase.createInBackground(file)` kết hợp `path_provider`, còn trong test suite luôn inject `NativeDatabase.memory()`.
3. **Quản lý vòng đời Stream trong `BudgetSnapshotService`:**
   - *Phân tích:* Khi gộp nhiều stream (`profile`, `expense`, `bill`, `income`, `goal`), nếu không dọn dẹp cẩn thận sẽ gây memory leak hoặc phát sinh tính toán thừa khi app background.
   - *Giải pháp:* Hủy tất cả subscription trong `onClose()`. Dùng `debounce` 50ms để gộp các đợt phát sinh dữ liệu đồng thời.
4. **Không có câu hỏi chặn việc (No blocking questions):**
   - Mọi quy ước schema, interface, audit columns và DoD đã rõ ràng 100%, sẵn sàng bước sang giai đoạn DEFINE TEST.

---

## Review & Verify Report

### 1. Số liệu kiểm thử tự động & Phân tích tĩnh (Thực tế)
- **`flutter test`:** **29 / 29 tests passed** (100% GREEN, 0 failed)
  - `test/data/db/app_database_test.dart` (3 tests: T03-4, T03-5, T03-7)
  - `test/data/repositories/expense_repository_test.dart` (3 tests: T03-1, T03-2, T03-3)
  - `test/data/repositories/profile_bill_goal_repositories_test.dart` (7 tests: CRUD & soft delete toàn diện)
  - `test/data/services/budget_snapshot_service_test.dart` (4 tests: T03-6 reactive pipeline, memory leak prevention, error tracking)
  - `test/data/db/migration_test.dart` (1 test: T03-8 Drift schema v1 verification)
  - `test/data/mappers/mappers_resilience_test.dart` (7 tests: resilience với dữ liệu bất thường)
  - Core & Smoke tests (4 tests: `clock_test`, `local_date_timezone_test`, `app_smoke_test`)
- **`dart test packages/budget_engine`:** **75 / 75 tests passed** (100% GREEN, 0 failed)
- **Tổng cộng toàn bộ test suite:** **104 / 104 tests passed**.
- **`flutter analyze` & `dart analyze`:** **0 issues found** (Zero-warning, zero-info trên toàn bộ monorepo).
- **`check-money` rule:** **Verified: No 'double' used for monetary values** trong `lib/` và `packages/budget_engine/lib/`.
- **`make format`:** Đạt 100% chuẩn format (98 files checked, 0 changed).

---

### 2. Định nghĩa hoàn thành (Definition of Done)
- [x] **Không có xóa cứng trong toàn bộ data layer:**
  - 100% bảng nghiệp vụ (`budget_profiles`, `expenses`, `bills`, `incomes`, `goals`, `goal_contributions`, `categories`) chỉ sử dụng soft delete (`deleted_at = now()`).
  - Phục hồi Undo qua `restore()` thiết lập `deleted_at = NULL`.
  - Ngoại lệ duy nhất là bảng `app_settings` (key-value store độc lập không phải thực thể nghiệp vụ) dùng `remove(key)` và chức năng "Erase all data" ở Spec 017.
- [x] **Mọi query đọc mặc định lọc `deleted_at IS NULL`:**
  - Kiểm tra toàn bộ 7 repositories: mọi query `watch` và `get` đều bắt buộc điều kiện `tbl.deletedAt.isNull()`.
- [x] **Cập nhật `updated_at`, bảo toàn `created_at`:**
  - 17/17 câu lệnh `.update()` trong các repository đều cập nhật `updatedAt: Value(now)` và bảo toàn `createdAt` (bằng `const Value.absent()` hoặc không đưa vào companion).
- [x] **DB chạy trên background isolate:**
  - `AppDatabase.defaults()` khởi tạo SQLite qua `NativeDatabase.createInBackground(file)` kết hợp `path_provider`. Unit test inject `NativeDatabase.memory()`.
- [x] **Hủy tài nguyên trong `onClose()`:**
  - `BudgetSnapshotService` hủy triệt để `_pipelineSubscription` và toàn bộ subscription trong `_subscriptions.clear()`.
- [x] **Không nuốt lỗi & Không lộ thông tin tài chính:**
  - `IBudgetSnapshotService` cung cấp observable `Rx<String?> error`.
  - Mọi lỗi đọc stream hoặc tính toán snapshot đều được chuyển thành state `error` kèm thông báo thân thiện và ghi log qua `dart:developer.log(..., name: 'BudgetSnapshotService')` mà không chứa số tiền, ghi chú hay dữ liệu PII.
- [x] **Parse dữ liệu bất thường không crash:**
  - `LocalDate.tryParse` xử lý chuỗi ngày hỏng/rỗng; enum parsers có fallback an toàn; timezone hỏng fallback về UTC; số âm/rất lớn/cents được bao bọc an toàn.

---

### 3. Kết quả kiểm tra trên thiết bị thật & Giả lập (Simulator / Emulator)
- **iOS Simulator (iPhone 17 · iOS 26.5):**
  - Chạy `flutter build ios --simulator --debug`: Biên dịch sạch sẽ.
  - Cài đặt & khởi chạy thành công qua `xcrun simctl` (PID: 89307).
  - Khởi tạo `AppDatabase.defaults()` trên isolate nền, chạy seed danh mục và hiển thị ứng dụng không có lỗi. Ảnh chụp màn hình: `ios_simulator_spec004.png`.
- **Android Emulator (sdk gphone64 arm64 · Android 16 API 36):**
  - Biên dịch APK debug `app-dev-debug.apk` sạch sẽ.
  - Cài đặt và khởi chạy qua `adb` thành công (Events injected: 1).
  - App khởi chạy mượt mà, kết nối SQLite nền ổn định. Ảnh chụp màn hình: `android_emulator_spec004.png`.

---

### 4. Lỗi đã phát hiện qua rà soát @silent-failure-hunter & Đã sửa dứt điểm
1. **Lỗi nuốt ngoại lệ (Silent failure) trong `BudgetSnapshotService`:**
   - *Phát hiện:* Khối `catch (_)` nuốt lỗi tính toán snapshot, thiếu kênh báo lỗi cho UI và không ghi log.
   - *Đã sửa:* Bổ sung getter `Rx<String?> get error` vào `IBudgetSnapshotService` và triển khai trong `BudgetSnapshotService`. Thêm lắng nghe lỗi `onError` cho các stream repository, wrap `refresh()` và `_computeFromData` bằng `try/on Object catch`, phát state lỗi và ghi log an toàn qua `dart:developer` (tuyệt đối không lộ số tiền hoặc ghi chú chi tiêu).
2. **Khả năng crash khi dữ liệu lưu trữ bị bất thường / corrupt:**
   - *Phát hiện:* `LocalDate.parse` ném `FormatException` nếu chuỗi ngày không hợp lệ; `byName` ném `ArgumentError` nếu chuỗi enum trong DB bị biến dạng; timezone rỗng ném lỗi vị trí.
   - *Đã sửa:* Bổ sung `LocalDate.tryParse` vào `budget_engine`, cài đặt parser an toàn cho `IncomeMode`, `PayFrequency`, `RolloverMode`, `BillRecurrence` với giá trị fallback hợp lý. Fallback timezone về `UTC` nếu tên múi giờ không xác định. Tạo bộ test `mappers_resilience_test.dart` (7 test cases) kiểm chứng không crash.
3. **Cảnh báo linter tĩnh:**
   - *Phát hiện:* 3 khối catch vi phạm quy tắc `avoid_catches_without_on_clauses`, 1 constructor thiếu `const`, 1 tham số mặc định dư thừa trong test.
   - *Đã sửa:* Khắc phục toàn bộ 5 cảnh báo, đưa `flutter analyze` về 0 issue tuyệt đối.
4. **Đồng bộ hóa khởi động trong `lib/bootstrap.dart`:**
   - *Phát hiện:* `bootstrap()` chưa kích hoạt seed danh mục mặc định ban đầu.
   - *Đã sửa:* Thêm `categoryRepo.seedDefaultCategories()` và đăng ký `AppDatabase.defaults()` trong `bootstrap()` trước khi gọi `runApp()`.
