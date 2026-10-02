# Session State
_Cập nhật: 2026-10-02 · Spec vừa xong: 005 · Spec tiếp theo: 006_

## Tiến độ
| Spec | Feature | Trạng thái | Tests (pass/total) | Analyze (warnings) | Ngày |
|------|---------|------------|--------------------|--------------------|------|
| 001 | Project foundation & bộ nhớ dự án | DONE | 2/2 | 0 | 2026-10-01 |
| 002 | Core primitives | DONE | 12/12 | 0 | 2026-10-01 |
| 003 | Budget engine | DONE | 74/74 (engine) / 80/80 (total) | 0 | 2026-10-02 |
| 004 | Data layer | DONE | 29/29 (flutter) / 75/75 (engine) / 104/104 (total) | 0 | 2026-10-02 |
| 005 | App shell | DONE | 70/70 (flutter) / 75/75 (engine) / 145/145 (total) | 0 | 2026-10-02 |
| 006 | Splash & bootstrap | TODO | – | – | – |
| 007 | Onboarding welcome | TODO | – | – | – |
| 008 | Onboarding income | TODO | – | – | – |
| 009 | Onboarding bills | TODO | – | – | – |
| 010 | Onboarding result | TODO | – | – | – |
| 011 | Today | TODO | – | – | – |
| 012 | Quick add | TODO | – | – | – |
| 013 | History | TODO | – | – | – |
| 014 | Income log | TODO | – | – | – |
| 015 | Bills | TODO | – | – | – |
| 016 | Savings goal | TODO | – | – | – |
| 017 | Settings | TODO | – | – | – |
| 018 | Notifications | TODO | – | – | – |
| 019 | Home widget | TODO | – | – | – |
| 020 | Backup & restore | TODO | – | – | – |
| 021 | Analytics & crash | TODO | – | – | – |
| 022 | Premium paywall | TODO | – | – | – |
| 023 | Rollover modes | TODO | – | – | – |
| 024 | Lockscreen widget & themes | TODO | – | – | – |
| 025 | CSV export | TODO | – | – | – |
| 026 | Ads | TODO | – | – | – |
| 027 | Release readiness | TODO | – | – | – |

Trạng thái: TODO · IN_PROGRESS (<bước>) · BLOCKED (<lý do>) · DONE

## Knowledge (điều spec sau cần biết)
- **Cách dùng `Money` (`packages/budget_engine`):**
  - Giá trị tiền luôn lưu trữ dưới dạng số nguyên cents (`int cents`), mã ISO 4217 (`currency`, mặc định `'USD'`). Tuyệt đối không dùng `double`.
  - Phép tính số học: `+`, `-`, `-()`, so sánh `<`, `<=`, `>`, `>=`. Ném `CurrencyMismatchError` nếu khác loại tiền tệ.
  - `divideEvenly(parts)`: Phân bổ phần dư cents cho các phần tử đầu tiên, bảo toàn 100% tổng cents gốc (`Money(1000).divideEvenly(3) == [334, 333, 333]`).
  - `percent(p)`: Làm tròn **xuống** (floor / integer truncation) tới đơn vị cent để giữ an toàn tài chính (`Money(999).percent(10) == Money(99)`).
- **Cách dùng `LocalDate` (`packages/budget_engine`):**
  - Đại diện cho ngày dương lịch thuần túy `year`, `month`, `day` không múi giờ.
  - Chuỗi định dạng: `parse('YYYY-MM-DD')` và `toIsoString()`.
  - Phép tính: `addDays(days)`, `addMonths(months)` (tự động kẹp ngày cuối tháng nếu tháng đích ít ngày hơn: `2026-01-31` + 1 tháng = `2026-02-28`).
  - Khoảng cách: `daysUntil(other)` $\rightarrow$ `other - this` (dương nếu tương lai, âm nếu quá khứ, 0 nếu cùng ngày).
  - So sánh: `isBefore`, `isAfter`, `isAtSameMomentAs`.
  - Chuyển từ DateTime có múi giờ: Sử dụng `LocalDateFromDateTime.fromDateTime(dateTime, timezoneName)` tại `lib/core/time/local_date_timezone.dart`.
- **Cách dùng `Clock` & `UuidGenerator` (`lib/core/`):**
  - Luôn inject interface `Clock` và `UuidGenerator` qua constructor vào Controller/Repository. Không gọi trực tiếp `DateTime.now()` hay package `uuid`.
  - Đã được đăng ký permanent trong `InitialBinding` (`SystemClock`, `DefaultUuidGenerator`).
- **Test Doubles dùng chung (`test/helpers/`):**
  - `FakeClock([initialTime])`: Gán thời gian cố định và gọi `advance(duration)` để kiểm thử thời gian tất định.
  - `FakeUuidGenerator(prefix: '...')`: Trả về ID tuần tự (`uuid-0001`, `uuid-0002`...).
- **Quy chuẩn CI chặn `double` cho tiền:**
  - Lệnh `make check-money` kiểm tra static regex tự động, được tích hợp vào `make analyze` và GitHub Actions CI.
- **Budget Engine (`packages/budget_engine`):**
  - **Bảng tóm tắt công thức từng chế độ:**
    | Chế độ | Công thức tính hạn mức ngày (`dailyLimit`) | Công thức Safe Today | Dự báo ngày mai (`tomorrowForecast`) |
    |---|---|---|---|
    | **Fixed · Spread** | $\max(0, \lfloor P_{\text{rem}} / D_{\text{rem}} \rfloor)$ với $P_{\text{rem}}$ giảm trừ theo thực chi hàng ngày | $\text{dailyLimit} - \text{spentToday}$ | San đều phần dư/thâm hụt còn lại cho các ngày tiếp theo: $\max(0, \lfloor (P_{\text{rem}} - \text{spentToday}) / (D_{\text{rem}} - 1) \rfloor)$ |
    | **Fixed · Tomorrow boost** | $\max(0, \text{base}_d + (\text{base}_{d-1} - \text{spent}_{d-1}))$ | $\text{dailyLimit} - \text{spentToday}$ | Số dư chưa tiêu hôm nay dồn toàn bộ sang ngày mai: $\max(0, \text{base}_{d+1} + \text{safeToday})$ |
    | **Fixed · Save it** | $\text{base}_d$ (cố định theo lịch ban đầu). Thừa ngày trước gom vào tiết kiệm (`derivedGoalSaved`). Thiếu ngày trước trừ vào các ngày sau. | $\text{dailyLimit} - \text{spentToday}$ | Dự kiến ngày mai: $\max(0, \text{base}_{d+1} - \max(0, \text{spentToday} - \text{dailyLimit}))$ |
    | **Irregular** | $\max(0, \lfloor \text{pool} / H \rfloor)$ với $H = 14$ ngày (safety horizon), $\text{pool} = \max(0, \text{balance} - \text{reserved})$ | $\text{baseDaily} - \text{spentToday}$ | Tự động tính lại hàng ngày theo số dư thực tế và cửa sổ an toàn trượt $H$ ngày |
  - **Các bất biến của Engine (Financial & Computational Invariants):**
    1. *Bảo toàn tổng tiền (Spread & Tomorrow Boost - T02-21):* $\sum_{d=1}^{D} \text{spent}_d + \text{remainingInPeriod} = \text{Pool}$ (sai số 0 cent qua 1.000 kịch bản ngẫu nhiên).
    2. *Bảo toàn tổng tiền (Save it mode - T02-21b):* $\sum_{d=1}^{D} \text{spent}_d + \text{derivedGoalSaved} + \text{remainingInPeriod} = \text{Pool}$ (sai số 0 cent qua 500 kịch bản ngẫu nhiên).
    3. *Không thất thoát cent lẻ (T02-22):* Mọi phép chia đều pool cho các ngày đều dùng `divideEvenly(parts)`, phân bổ phần dư cents tuần tự cho các ngày đầu tiên.
    4. *Kẹp an toàn tài chính (Floor / Truncation):* Tiền đệm buffer (`percent`), hạn mức ngày, dự báo ngày mai và `remainingInPeriod` luôn $\ge 0$. Khi tiêu vượt, `safeToday < 0` phản ánh đúng mức bội chi và trạng thái chuyển sang `BudgetStatus.over`.
    5. *Tính toán phi trạng thái và tất định (Stateless & Deterministic):* Không import Flutter/GetX, không gọi `DateTime.now()`, không I/O, cùng một `EngineInput` và `today` luôn ra cùng một `BudgetSnapshot`.
  - **Cách gọi `computeSnapshot`:**
    ```dart
    import 'package:budget_engine/budget_engine.dart';

    final input = EngineInput(
      config: BudgetConfig(
        currency: 'USD',
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.biweekly,
        payAnchorDate: LocalDate(2026, 1, 2),
        incomePerPaycheck: Money.usd(300000), // $3,000.00
        trackingStartDate: LocalDate(2026, 1, 2),
        rolloverMode: RolloverMode.spread,
        bufferPercent: 5, // 5% đệm
      ),
      expenses: [
        Expense(
          id: 'e-1',
          amount: Money.usd(4500),
          spentOn: LocalDate(2026, 1, 5),
        ),
      ],
      bills: [
        Bill(
          id: 'b-1',
          name: 'Internet',
          amount: Money.usd(8000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 10),
        ),
      ],
      goal: Goal(
        id: 'g-1',
        name: 'Emergency Fund',
        targetAmount: Money.usd(100000),
        targetDate: LocalDate(2026, 6, 30),
      ),
      contributions: [],
      incomes: [],
    );

    final today = LocalDate(2026, 1, 5);
    final snapshot = computeSnapshot(input, today);

    // Kết quả tính toán:
    final safeToday = snapshot.safeToday;               // Money
    final tomorrow = snapshot.tomorrowForecast;         // Money
    final status = snapshot.status;                     // BudgetStatus.great | good | warning | over
    final remaining = snapshot.remainingInPeriod;       // Money
    final daysLeft = snapshot.daysLeftInPeriod;         // int
    final baseline = snapshot.dailyBaseline;            // Money
    final goalProgress = snapshot.goalProgress;         // GoalProgress?
    final upcomingBills = snapshot.upcomingBills;       // List<BillOccurrence>
    ```
- **Sơ đồ bảng cơ sở dữ liệu (Drift SQLite - Spec 004):**
  - **Cột chung đồng bộ (`CommonSyncTable`):** Mọi bảng nghiệp vụ kế thừa 5 cột:
    - `id` (TEXT, PK, UUID v4)
    - `created_at` (INTEGER, epoch ms UTC)
    - `updated_at` (INTEGER, epoch ms UTC)
    - `deleted_at` (INTEGER, epoch ms UTC, nullable: null = active, not null = soft deleted)
    - `device_id` (TEXT, UUID v4 nhận diện thiết bị)

  - **Sơ đồ quan hệ thực thể (ERD text):**
    ```text
    +-------------------------------------------------------------------------------+
    |                               BUDGET_PROFILES                                 |
    | id (PK) | currency | income_mode | pay_frequency | pay_anchor_date            |
    | income_per_paycheck_cents | first_period_balance_cents | starting_balance_cents |
    | tracking_start_date | safety_horizon_days | buffer_percent | rollover_mode       |
    | timezone | week_start | onboarding_completed                                  |
    | [CommonSyncTable: created_at, updated_at, deleted_at, device_id]              |
    +-------------------------------------------------------------------------------+
           |                                |                           |
      1    |                           1    |                      1    |
           v N                              v N                         v 1..N
    +---------------------------+   +-----------------------+   +-------------------+
    |         EXPENSES          |   |         BILLS         |   |       GOALS       |
    | id (PK)                   |   | id (PK)               |   | id (PK)           |
    | profile_id (FK logic)     |   | profile_id (FK logic) |   | profile_id (FK)   |
    | amount_cents (INT > 0)    |   | name (TEXT)           |   | name (TEXT)       |
    | spent_on (YYYY-MM-DD)     |   | amount_cents (INT)    |   | target_amount_    |
    | category_id (FK logic) ---+   | recurrence (TEXT)     |   |   cents (INT)     |
    | note (TEXT?)              |   | first_due_date (TEXT) |   | target_date?      |
    | source ('manual'/'widget')|   | remind_days_before    |   | per_paycheck_     |
    | currency (TEXT)           |   | is_active (BOOL)      |   |   cents?          |
    | [CommonSyncTable]         |   | [CommonSyncTable]     |   | created_on (TEXT) |
    +---------------------------+   +-----------------------+   | is_active (BOOL)  |
           |                                                    | [CommonSyncTable] |
         N |                                                    +-------------------+
           v 1 (optional)                                                 | 1
    +---------------------------+                                         v N
    |        CATEGORIES         |                               +-------------------+
    | id (PK)                   |                               | GOAL_CONTRIBUTIONS|
    | name_key (TEXT l10n)      |                               | id (PK)           |
    | custom_name (TEXT?)       |                               | goal_id (FK logic)|
    | icon (TEXT)               |                               | amount_cents (INT)|
    | color (TEXT hex)          |                               | on_date (TEXT)    |
    | sort_order (INT)          |                               | source ('manual') |
    | is_default (BOOL)         |                               | [CommonSyncTable] |
    | [CommonSyncTable]         |                               +-------------------+
    +---------------------------+

    +---------------------------+   +-----------------------------------------------+
    |      INCOME_ENTRIES       |   |                 APP_SETTINGS                  |
    | id (PK)                   |   | key (TEXT, PK thay cho id)                    |
    | profile_id (FK logic)     |   | value (TEXT / JSON)                           |
    | amount_cents (INT > 0)    |   | updated_at (INTEGER epoch ms UTC)             |
    | received_on (YYYY-MM-DD)  |   | (Lưu device_id, theme, cấu hình cục bộ)       |
    | note (TEXT?)              |   +-----------------------------------------------+
    | [CommonSyncTable]         |
    +---------------------------+
    ```

  - **Quy tắc thiết kế & bảo toàn dữ liệu (Data Layer):**
    1. *Bất biến Soft Delete:* Mọi bảng nghiệp vụ kế thừa `CommonSyncTable` (`deleted_at` nullable). Mọi query đọc mặc định luôn lọc `WHERE deleted_at IS NULL`. Thao tác xóa ghi `deleted_at = nowMs, updated_at = nowMs`. Tuyệt đối không xóa cứng trong bất kỳ repository nghiệp vụ nào (ngoại lệ duy nhất: key-value `app_settings` và chức năng "Erase all data" Spec 017).
    2. *Undo tức thì:* Hỗ trợ khôi phục bản ghi đã xóa nhầm qua `restore(id)` (`deleted_at = NULL, updated_at = nowMs`).
    3. *Bảo toàn tiền tệ:* Cột lưu trữ luôn là số nguyên cents `amount_cents` (`int`), ánh xạ 2 chiều sang `Money(cents, currency)`.
    4. *Idempotent Category Seeder:* Khởi tạo 8 danh mục mặc định (`Food & Drink`, `Groceries`, `Transport`, `Shopping`, `Fun`, `Bills & Utilities`, `Health`, `Other`), an toàn chạy lại nhiều lần mà không bị nhân đôi dữ liệu.
    5. *Background Isolate:* Runtime database sử dụng `NativeDatabase.createInBackground(file)` kết hợp `path_provider` để không bao giờ chặn main UI isolate. Unit test dùng `NativeDatabase.memory()`.
    6. *Reactive Pipeline (`BudgetSnapshotService`):* Gộp stream từ các repository (`CombineLatestStream.combine4`), debounce tự động, gọi pure `computeSnapshot`, expose qua `Rx<BudgetSnapshot?> snapshot`. Presentation Controllers tuyệt đối **KHÔNG** import hay gọi trực tiếp `computeSnapshot` từ `budget_engine`.
    7. *Xử lý lỗi Reactive & Bảo mật:* `IBudgetSnapshotService` cung cấp `Rx<String?> error`. Mọi lỗi stream hoặc tính toán snapshot đều chuyển sang state lỗi và ghi log qua `dart:developer` (tuyệt đối không kèm số tiền, ghi chú hay dữ liệu PII).
    8. *Cách thêm Migration:*
       - Bước 1: Tăng `schemaVersion` trong `AppDatabase` (ví dụ: `int get schemaVersion => 2;`).
       - Bước 2: Chạy lệnh xuất schema dump: `dart run drift_dev schema dump lib/data/db/app_database.dart drift_schemas/drift_schema_v2.json`.
       - Bước 3: Triển khai các bước chuyển đổi schema trong `MigrationStrategy(onUpgrade: (m, from, to) async { ... })`.
       - Bước 4: Viết test migration trong `test/data/db/migration_test.dart` dùng `schema.stepByStep` hoặc `validateDatabaseSchemaFromSchemaDump` để bảo đảm dữ liệu cũ không bị thất thoát.
    9. *Schema Dump Versioning:* Schema drift được dump tại `drift_schemas/drift_schema_v1.json` để kiểm thử hồi quy migration cho các phiên bản tiếp theo.
- **App Shell, Routing & Design System (Spec 005):**
  - **Danh sách Route (`lib/core/routes/app_routes.dart`):**
    - `AppRoutes.splash` (`/splash`): Màn hình splash loader & bootstrap dịch vụ.
    - `AppRoutes.onboardingWelcome` (`/onboarding/welcome`): Màn hình chào mừng onboarding.
    - `AppRoutes.onboardingIncome` (`/onboarding/income`): Thiết lập nguồn thu & chu kỳ lương.
    - `AppRoutes.onboardingBills` (`/onboarding/bills`): Khai báo hóa đơn định kỳ.
    - `AppRoutes.onboardingResult` (`/onboarding/result`): Hiển thị hạn mức an toàn ngày đầu tiên tính được.
    - `AppRoutes.root` (`/root`): Shell chính chứa 3 tab điều hướng (`IndexedStack`):
      - Tab 0: **Today** (`TodayPagePlaceholder` — sẽ thay bằng màn Today ở Spec 011).
      - Tab 1: **History** (`HistoryPagePlaceholder` — sẽ thay bằng màn History ở Spec 013).
      - Tab 2: **Plan** (`PlanPagePlaceholder` — sẽ thay bằng màn Plan ở Spec 014, 015, 016).
    - `AppRoutes.settings` (`/settings`): Cài đặt tài khoản & ứng dụng.
    - `AppRoutes.paywall` (`/paywall`): Modal nâng cấp gói trả phí PRO.
    - `AppRoutes.expenseEdit` (`/expense/edit`): Chỉnh sửa giao dịch (truyền id qua `arguments` hoặc `parameters`).
    - *Quy ước Quick Add:* Quick Add mở bằng modal bottom sheet (`Get.bottomSheet`) qua `QuickAddLauncher.open()`, **tuyệt đối không** cấu hình thành một named route độc lập (tuân thủ `000-conventions.md` mục B3).
  - **Cách đăng ký Page mới vào `AppPages` (`lib/core/routes/app_pages.dart`):**
    1. Khai báo hằng số route trong `lib/core/routes/app_routes.dart`.
    2. Viết Page và Binding tương ứng trong `lib/features/<feature>/pages/` và `bindings/`.
    3. Thêm phần tử `GetPage` vào mảng `AppPages.pages`:
       ```dart
       GetPage<dynamic>(
         name: AppRoutes.yourFeature,
         page: () => const YourFeaturePage(),
         binding: YourFeatureBinding(),
         middlewares: [OnboardingMiddleware()], // Thêm middleware nếu route cần bảo vệ (yêu cầu hoàn tất onboarding)
       ),
       ```
    4. *Cơ chế Fallback Route an toàn:* `AppPages.unknownRoute` được định nghĩa trỏ về `RootShellPage` bọc `OnboardingMiddleware` và gắn vào `GetMaterialApp(unknownRoute: AppPages.unknownRoute)`. Điều này ngăn chặn hoàn toàn lỗi crash `_TypeError: Null check operator used on a null value` trong GetX khi nhận URI hoặc intent bất thường từ hệ điều hành.
  - **Danh sách Component dùng chung & Cách dùng (`lib/core/widgets/`):**
    1. `AmountKeypad`: Bàn phím số 3x4 chuẩn ATM/POS (0–9, 00, xóa 1 số, giữ xóa hết bằng Timer). Tự động kẹp trần 99.999.999 cents ($999,999.99), rung nhẹ `HapticFeedback.lightImpact()`, có `Semantics` cho từng phím bấm. Timer giữ xóa được hủy sạch sẽ khi widget dispose.
    2. `AmountText`: Hiển thị số tiền với font feature tabular figures (`FontFeature.tabularFigures()`), tự động chuyển màu theo `BudgetStatus` (`onTrack`: `#2E9E6A`, `caution`: `#D98E04`, `over`: `#C8553D`). Hỗ trợ cờ `showSign: true` để hiển thị dấu `+` / `-`.
    3. `PrimaryButton`: Nút chính nổi bật, bo góc 14pt (`AppSpacing.buttonRadius`), chiều cao chuẩn 48pt ($\ge 44\text{pt}$), hỗ trợ `isLoading` hiển thị spinner và vô hiệu hóa khi disabled.
    4. `SecondaryButton`: Nút phụ bo góc 14pt, viền border nhẹ hoặc nền surface variant, phản hồi haptic.
    5. `CategoryChip`: Chip danh mục dạng pill (bo góc 999pt) với icon và màu nhận diện.
    6. `SectionCard`: Thẻ card nền surface bo góc 20pt (`AppSpacing.cardRadius`), viền border mờ.
    7. `EmptyState`: Khối trạng thái rỗng minh họa trực quan, kèm tiêu đề, thông điệp hướng dẫn và nút CTA hành động.
    8. `ProgressRing`: Vòng tròn tiến độ ngân sách / mục tiêu tiết kiệm nét bo tròn, tự đổi màu theo trạng thái.
    9. `PremiumBadge`: Huy hiệu "PRO" nhỏ gọn đánh dấu các tính năng cao cấp.
    10. `AppBottomSheet`: Khung modal chuẩn với drag handle, bo góc trên 24pt, tự co giãn theo bàn phím (`isScrollControlled: true`).
    11. `ConfirmDialog`: Hộp thoại xác nhận thao tác quan trọng với nút Hủy và Xác nhận rõ ràng.
    12. `AppScaffold`: Bọc chuẩn SafeArea, màu nền theme và padding an toàn.
  - **Thiết kế Deep Link (`safetospend://quick-add`):**
    - Đã đăng ký scheme `safetospend` với host `quick-add` trong `ios/Runner/Info.plist` và `android/app/src/main/AndroidManifest.xml`.
    - `DeepLinkService` được inject permanent trong `InitialBinding`, tự động kích hoạt lắng nghe trong `onInit()`, kiểm tra `hasCompletedOnboarding()` trước khi phát `QuickAddTriggerEvent`, có debounce 1.500ms chống trùng lặp sự kiện mở modal khi cold start hoặc runtime.
- **Quy ước Git:** Xong mỗi spec (tính năng), USER sẽ tự thực hiện `git commit` và `git push` code. Agent tuyệt đối không tự ý chạy git commit hoặc push.

## Known issues / Tech debt
- Không có issue hoặc tech debt phát sinh từ Spec 005. Đạt 100% test pass (145/145 tests: 70 flutter + 75 engine), 0 analyze issue (zero-warning), 0 vi phạm double, 100% DoD đạt.
- 4 lỗi tiềm ẩn cấp hệ thống đã được phát hiện và xử lý triệt để: thiếu OS scheme trong Info.plist & AndroidManifest.xml, GetX null check crash trên Android intent, thiếu tự động gọi `init()` trong `DeepLinkService`, và Timer leak guard trong `AmountKeypad`.
- Các tính năng mở rộng ngoài MVP (như Universal Links cho web, `dueOnWeekendShift`, multi-goals, irregular rollover, FTS5 cho note chi tiêu, Cloud sync 2 chiều) đã được ghi nhận trong `docs/BACKLOG.md`.

## Next
- Spec 006 · Splash & bootstrap (file `specs/006-splash-bootstrap.md`).

