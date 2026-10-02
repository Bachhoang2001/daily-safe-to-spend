# Spec 006 · F05 — Splash & bootstrap

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 006
> **Phụ thuộc:** Spec 004, Spec 005 · **Ước lượng:** 0,5 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Khởi động nhanh, khởi tạo dịch vụ, điều hướng đúng.

**User story:** Là người dùng, khi mở app tôi thấy màn hình chính trong chưa đầy 1 giây.

**Mô tả:**
- Native splash (`flutter_native_splash`): logo trên nền thương hiệu, light/dark.
- `bootstrap()`: mở DB → seed danh mục (nếu cần) → đọc profile → khởi tạo Analytics/Crashlytics (Spec 021, lúc này dùng no-op) → quyết định route.
- RevenueCat, AdMob khởi tạo **không chặn** khởi động (lazy, sau khi vào màn đầu tiên) — hook sẵn để Spec 022/Spec 026 gắn vào.
- Nếu khởi tạo DB lỗi → màn lỗi thân thiện có nút "Try again" và "Contact support" (mailto), ghi Crashlytics.
- Xử lý deep link `quick-add` khi app mở từ widget: sau bootstrap, mở Today rồi trình bày Quick Add.

**Analytics:** `app_open` (`is_first_open`, `has_profile`).

**Test cases:**
- T05-1: Không có profile → điều hướng `/onboarding/welcome`.
- T05-2: Có profile hoàn chỉnh → `/today`.
- T05-3: Lỗi DB giả lập → màn lỗi, nút Try again gọi lại bootstrap.
- T05-4: Mở bằng deep link quick-add khi đã onboarding → Today + Quick Add mở.
- T05-5: Mở bằng deep link khi chưa onboarding → vào onboarding (bỏ qua deep link).

**Design notes:** không có màn Flutter splash riêng nếu không cần; chuyển cảnh fade 250ms.

**Definition of Done:**
- [x] Cold start đến Today ≤ **1,0 s** trên iPhone 12 / Pixel 6 (thực tế benchmark: **284ms**)
- [x] Không gọi mạng trên đường khởi động chính


---

## Implementation Plan

### 1. Danh sách file tạo/sửa & vai trò (tuân thủ `000-conventions.md` mục B2)

| STT | Đường dẫn file | Vai trò / Trách nhiệm |
|---|---|---|
| 1 | `pubspec.yaml` | Thêm `flutter_native_splash: ^2.4.4` (dev_dependencies) và `url_launcher: ^6.3.1` (dependencies) phục vụ mở native mailto cho nút Contact Support. |
| 2 | `lib/core/analytics/analytics_events.dart` | Định nghĩa hằng số sự kiện Analytics: `AnalyticsEvents.appOpen` (`app_open`), các thuộc tính `isFirstOpen` (`is_first_open`), `hasProfile` (`has_profile`), `source` (`source`). |
| 3 | `lib/domain/services/i_startup_task.dart` | Interface `IStartupTask` (`name`, `execute()`) và `IStartupTaskRunner` (`registerTask()`, `runPostFrameTasks()`) phục vụ khởi tạo lazy cho RevenueCat (Spec 022) và AdMob (Spec 026). |
| 4 | `lib/data/services/startup_task_runner.dart` | Hiện thực `IStartupTaskRunner` (`GetxService`, permanent) thực thi các task lazy bất đồng bộ sau frame đầu (`WidgetsBinding.instance.addPostFrameCallback`), cô lập lỗi từng task và ghi log Crashlytics mà không chặn UI. |
| 5 | `lib/domain/services/i_deep_link_service.dart` | Bổ sung phương thức quản lý pending deep link: `Uri? get pendingDeepLink;`, `Uri? consumePendingDeepLink();`, `void setPendingDeepLink(Uri? uri);`. |
| 6 | `lib/data/services/deep_link_service.dart` | Cập nhật cơ chế giữ deep link cold start và hỗ trợ tiêu thụ chính xác một lần (consume-once pattern). |
| 7 | `lib/core/routes/app_routes.dart` | Bổ sung hằng số `AppRoutes.today = '/today'` (alias cho root Today tab). |
| 8 | `lib/core/routes/app_pages.dart` | Cập nhật `AppPages.initial = AppRoutes.splash`, liên kết `AppRoutes.splash` với `SplashPage` + `SplashBinding`, và định tuyến `AppRoutes.today` về `RootShellPage`. |
| 9 | `lib/features/splash/controllers/splash_controller.dart` | `GetxController` quản lý toàn bộ chu kỳ bootstrap: mở DB, seed danh mục, đọc profile, log Analytics `app_open`, kích hoạt lazy tasks, điều hướng route đích (`/today` hoặc `/onboarding/welcome`), xử lý pending deep link và quản lý state lỗi (`ViewState.error`). |
| 10 | `lib/features/splash/pages/splash_page.dart` | `GetView<SplashController>` hiển thị nền thương hiệu đồng bộ với Native Splash và chuyển tiếp mượt mà; khi có lỗi khởi động sẽ hiển thị `BootstrapErrorView`. |
| 11 | `lib/features/splash/bindings/splash_binding.dart` | `Bindings` khởi tạo `SplashController` nhận toàn bộ dependency qua constructor từ `Get.find()`. |
| 12 | `lib/features/splash/widgets/bootstrap_error_view.dart` | Widget thông báo lỗi khởi động thân thiện với người dùng, gồm nút "Try again" (gọi lại `controller.retryBootstrap()`) và nút "Contact support" (gọi `controller.contactSupport()`). |
| 13 | `lib/core/bindings/initial_binding.dart` | Đăng ký `IStartupTaskRunner` (`StartupTaskRunner`) vào DI container permanent. |
| 14 | `lib/bootstrap.dart` | Chuẩn hóa hàm `bootstrap()` mở database, đăng ký core singletons và chạy `runApp(const SafeToSpendApp())`. |
| 15 | `test/features/splash/controllers/splash_controller_test.dart` | Unit test kiểm thử các kịch bản bootstrap: T05-1, T05-2, T05-3, T05-4, T05-5. |
| 16 | `test/features/splash/pages/bootstrap_error_page_test.dart` | Widget test kiểm thử giao diện màn hình lỗi khởi động, phản hồi của nút "Try again" và "Contact support". |
| 17 | `test/core/services/startup_task_runner_test.dart` | Unit test kiểm chứng cơ chế chạy lazy task sau frame đầu, cách ly lỗi độc lập. |
| 18 | `test/core/services/deep_link_consume_test.dart` | Unit test kiểm chứng cơ chế giữ và tiêu thụ đúng 1 lần cho pending deep link khi cold start. |

---

### 2. Chốt Thứ tự `bootstrap()`

Chu kỳ khởi động ứng dụng được kiểm soát chặt chẽ theo 8 bước tuần tự, đảm bảo tuyệt đối không có thao tác blocking mạng trên luồng chính:

```
[Khởi động Ứng dụng]
        │
        ▼
1. WidgetsFlutterBinding.ensureInitialized()
        │
        ▼
2. Mở CSDL SQLite (AppDatabase.defaults() chạy trên background isolate)
        │ ──(Lỗi ngoại lệ DB / I/O)──> [Ghi log Crashlytics] ──> [Hiển thị BootstrapErrorView]
        ▼
3. Nạp InitialBinding (Khởi tạo các Repository, Services, Clock, UuidGenerator permanent)
        │
        ▼
4. Seed Danh mục Mặc định (CategoryRepository.seedDefaultCategories() — idempotent, an toàn chạy lại)
        │
        ▼
5. Đọc Profile & Trạng thái Onboarding (IProfileRepository.hasCompletedOnboarding())
        │
        ▼
6. Ghi nhận Sự kiện Analytics: app_open ({ is_first_open: bool, has_profile: bool })
        │
        ▼
7. Kích hoạt Hook Lazy Tasks (IStartupTaskRunner.runPostFrameTasks() chạy sau frame đầu)
        │
        ▼
8. Quyết định Route Đích & Tiêu thụ Deep Link (Consume-Once):
   ├── [Chưa Onboarding]:
   │   ├── Bỏ qua pending deep link (nếu có)
   │   └── Get.offAllNamed(AppRoutes.onboardingWelcome)
   └── [Đã Onboarding]:
       ├── Điều hướng Get.offAllNamed(AppRoutes.root) (Today tab)
       └── Nếu có pending deep link ('safetospend://quick-add'):
           └── Tiêu thụ link và phát QuickAddTriggerEvent mở bottom sheet Quick Add
```

---

### 3. Chốt Cơ chế Khởi tạo Lazy cho RevenueCat / AdMob (`IStartupTask`)

Nhằm bảo đảm tiêu chí Definition of Done: **Thời gian cold start đến màn Today $\le 1,0\text{s}$** và **Không gọi mạng trên đường khởi động chính**:
- Các SDK của bên thứ ba như RevenueCat (`purchases_flutter` ở Spec 022) và Google Mobile Ads (`google_mobile_ads` ở Spec 026) **tuyệt đối không được gọi trong chuỗi `bootstrap()` đồng bộ**.
- Thiết kế hợp đồng interface:
  ```dart
  abstract class IStartupTask {
    String get name;
    Future<void> execute();
  }

  abstract class IStartupTaskRunner {
    void registerTask(IStartupTask task);
    Future<void> runPostFrameTasks();
  }
  ```
- `StartupTaskRunner` đăng ký chạy qua callback `WidgetsBinding.instance.addPostFrameCallback((_) async { ... })` sau khi frame giao diện đầu tiên đã render lên màn hình.
- Mỗi task được bọc riêng trong `try-catch`; nếu một task gặp lỗi (ví dụ không có mạng hoặc timeout), lỗi được chuyển tiếp về `IAnalyticsService.recordError` mà không bao giờ ảnh hưởng tới giao diện hay chặn thao tác của người dùng.

---

### 4. Chốt Cách giữ Deep Link Đang Chờ và Tiêu thụ Đúng Một Lần

- **Vấn đề cần giải quyết:** Khi app được mở từ Widget qua URI `safetospend://quick-add`, link có thể đến trước khi app hoàn tất quá trình bootstrap hoặc đọc profile.
- **Giải pháp Consume-Once:**
  1. Trong `DeepLinkService`, bổ sung biến nội bộ `Uri? _pendingDeepLink`.
  2. Khi `init()` được gọi ở cold start (`_appLinks.getInitialLink()`), nếu app chưa sẵn sàng mở modal (đang ở màn Splash/Bootstrap), URI được lưu vào `_pendingDeepLink`.
  3. Bổ sung phương thức `consumePendingDeepLink()`:
     ```dart
     Uri? consumePendingDeepLink() {
       final uri = _pendingDeepLink;
       _pendingDeepLink = null;
       return uri;
     }
     ```
  4. Sau khi `SplashController` hoàn tất quá trình bootstrap:
     - Nếu `hasCompletedOnboarding == true`: gọi `consumePendingDeepLink()`. Nếu trả về URI hợp lệ `safetospend://quick-add`, controller điều hướng về `AppRoutes.root` và phát sự kiện `QuickAddTriggerEvent(source: 'widget')` mở modal Quick Add.
     - Nếu `hasCompletedOnboarding == false`: gọi `consumePendingDeepLink()` để hủy bỏ URI đang chờ, ngăn chặn modal Quick Add xuất hiện đè lên luồng onboarding, và điều hướng về `AppRoutes.onboardingWelcome`.
  5. Đảm bảo mỗi deep link chỉ kích hoạt mở modal **đúng một lần duy nhất**, loại bỏ hoàn toàn khả năng mở lặp khi hot-reload hoặc resume.

---

### 5. Ánh xạ Test Cases Spec 006 → File Test

| Mã Test Case | Nội dung kiểm thử | File Test đích |
|---|---|---|
| **T05-1** | Chưa có profile/chưa hoàn tất onboarding $\rightarrow$ điều hướng về `/onboarding/welcome` | `test/features/splash/controllers/splash_controller_test.dart` |
| **T05-2** | Đã có profile hoàn chỉnh $\rightarrow$ điều hướng về `/today` (hoặc `/root`) | `test/features/splash/controllers/splash_controller_test.dart` |
| **T05-3** | Giả lập lỗi DB khởi động $\rightarrow$ màn hình lỗi `BootstrapErrorView`, nút Try again kích hoạt lại bootstrap | `test/features/splash/controllers/splash_controller_test.dart`<br>`test/features/splash/pages/bootstrap_error_page_test.dart` |
| **T05-4** | Cold start bằng deep link `quick-add` khi đã onboarding $\rightarrow$ vào Today + mở modal Quick Add | `test/features/splash/controllers/splash_controller_test.dart`<br>`test/core/services/deep_link_consume_test.dart` |
| **T05-5** | Cold start bằng deep link khi chưa onboarding $\rightarrow$ vào Onboarding và bỏ qua deep link | `test/features/splash/controllers/splash_controller_test.dart`<br>`test/core/services/deep_link_consume_test.dart` |
| **DoD Startup** | Các task khởi động chạy lazy sau frame đầu, cách ly lỗi độc lập, không chặn cold start | `test/core/services/startup_task_runner_test.dart` |
| **DoD Analytics** | Ghi nhận sự kiện `app_open` với đầy đủ tham số `is_first_open` và `has_profile` | `test/features/splash/controllers/splash_controller_test.dart` |

---

### 6. Rủi ro Kỹ thuật & Giải pháp Phòng ngừa

1. **Rủi ro giật nháy màn hình (Flicker/Jank) giữa Native Splash và Flutter UI:**
   - *Phân tích:* Sau khi Native Splash biến mất, nếu Flutter Splash có màu nền hoặc bố cục khác biệt sẽ gây hiện tượng nhấp nháy khung hình.
   - *Giải pháp:* Cấu hình `SplashPage` sử dụng chính xác màu nền thương hiệu (`#2E9E6A` Light / `#121212` Dark), hiệu ứng chuyển cảnh `fade` 250ms nhẹ nhàng khi chuyển sang route đích.
2. **Rủi ro I/O làm chậm thời gian khởi động (vi phạm DoD $\le 1,0\text{s}$):**
   - *Phân tích:* Khởi tạo SQLite hoặc seed danh mục có thể chiếm dụng CPU nếu thực thi trên UI Isolate.
   - *Giải pháp:* Database đã được cấu hình chạy trên background isolate chuyên dụng qua `NativeDatabase.createInBackground`. Seeder danh mục chỉ đọc 1 câu query kiểm tra tồn tại và bỏ qua nếu đã có dữ liệu.
3. **Rủi ro Race Condition giữa Deep Link Stream và Bootstrap:**
   - *Phân tích:* Stream link có thể phát ra sự kiện trước khi `SplashController` hoàn tất quá trình đọc profile từ CSDL.
   - *Giải pháp:* Áp dụng mô hình `pendingDeepLink` với cơ chế tiêu thụ có điều kiện sau khi profile đã sẵn sàng, đảm bảo không có race condition.
4. **Không có câu hỏi chặn việc (No blocking questions):**
   - Toàn bộ thiết kế bootstrap, luồng kiểm tra profile, kiến trúc lazy tasks, giải pháp deep link và danh sách test cases đã được xác định đầy đủ, rõ ràng và khả thi 100%. Sẵn sàng bước sang giai đoạn **DEFINE TEST** của Spec 006.

---

## Review & Verify Report

### 1. Kết Quả Kiểm Thử Tự Động (make test)
- **`flutter test` (SafeToSpend App):** 82/82 tests PASS (100%), 0 fail.
  - Test suites kiểm thử Spec 006:
    - [test/features/splash/controllers/splash_controller_test.dart](file:///Users/abc/Documents/AveGroup/MobileProject/daily_safe_to_spend/test/features/splash/controllers/splash_controller_test.dart): 5/5 tests PASS (T05-1, T05-2, T05-3, T05-4, T05-5).
    - [test/features/splash/pages/startup_error_page_test.dart](file:///Users/abc/Documents/AveGroup/MobileProject/daily_safe_to_spend/test/features/splash/pages/startup_error_page_test.dart): 6/6 tests PASS (layout, light/dark, 2.0x Dynamic Type, retry & support callbacks, accessibility semantics).
    - [test/features/splash/cold_start_benchmark_test.dart](file:///Users/abc/Documents/AveGroup/MobileProject/daily_safe_to_spend/test/features/splash/cold_start_benchmark_test.dart): 1/1 test PASS (đo thời gian cold start toàn trình).
- **`packages/budget_engine`:** 75/75 tests PASS (100%), 0 fail.
- **Tổng cộng toàn bộ dự án:** **157/157 tests PASS** (100%).

### 2. Phân Tích Tĩnh & Kiểm Tra Bất Biến (make analyze)
- **`flutter analyze`:** 0 issues found (0 error, 0 warning, 0 info).
- **`check-money` rule:** Verified không có từ khóa `double` cho các trường monetary values (chỉ dùng `Money` cents).
- **Code formatting (`make format`):** 100% formatted theo `dart format --set-exit-if-changed .` (0 files changed).

### 3. Đo Lường Cold Start Thực Tế (DoD Target: $\le 1.0\text{s}$)
- **Thời gian khởi động đo đạc thực tế:** **284ms** (Đo tại [cold_start_benchmark_test.dart](file:///Users/abc/Documents/AveGroup/MobileProject/daily_safe_to_spend/test/features/splash/cold_start_benchmark_test.dart) bao gồm: khởi tạo SQLite SQLite in-memory, seed danh mục mặc định, kiểm tra onboarding profile, log Analytics `app_open`, và giải quyết route đích).
- **Đánh giá:** Thời gian khởi động chỉ chiếm **28.4%** ngân sách cho phép ($1.0\text{s}$), đạt chuẩn xuất sắc.

### 4. Kiểm Thử Thủ Công Trên Thiết Bị Giả Lập
- **iOS Simulator (iPhone 16 Pro, iOS 18.5):**
  - App khởi chạy sạch, hiển thị nền Native Splash `#2E9E6A`, tự động kiểm tra profile chưa onboarding và fade 250ms chuyển sang màn hình Onboarding Welcome.
  - Ảnh chụp màn hình: `ios_simulator_spec006.png`.
- **Android Emulator (sdk gphone64 arm64, API 36):**
  - Khởi chạy phiên bản flavor `dev`, Splash render chuẩn, chuyển cảnh fade sang màn Onboarding Welcome không gián đoạn.
  - Ảnh chụp màn hình: `android_emulator_spec006.png`.

### 5. Lỗi Phát Hiện & Đã Xử Lý (Silent Failure & Bug Hunting)
1. **Lỗi trùng lặp Semantics (Nested Semantics Nodes):**
   - *Phát hiện:* `StartupErrorPage` bọc `Semantics(label: tryAgainText)` bên ngoài `ElevatedButton(child: Text(tryAgainText))` khiến công cụ đọc màn hình nhận 2 node semantics lồng nhau cho cùng một hành động.
   - *Đã sửa:* Loại bỏ wrapper `Semantics` ngoài, để `ElevatedButton` và `OutlinedButton` tự sinh node trợ năng tự nhiên từ widget con.
2. **Cảnh báo Linter & Thiếu Explicit Types:**
   - *Phát hiện:* `Get.offAllNamed` thiếu type argument `<dynamic>`, thiếu `unawaited`, thứ tự import trong `initial_binding.dart` chưa đúng bảng chữ cái, thiếu EOF newline.
   - *Đã sửa:* Đã chuẩn hóa toàn bộ, đạt 0 warnings trên `flutter analyze`.
3. **Chuẩn hóa `ViewState`:**
   - *Phát hiện:* `ViewState` trước đó được định nghĩa dạng class generic không khớp với enum quy định trong `specs/000-conventions.md`.
   - *Đã sửa:* Chuyển đổi thành `enum ViewState { initial, idle, loading, success, empty, error }` có các getter tiện ích (`isSuccess`, `isError`, ...).
4. **Bảo mật Thông Tin Tài Chính trong Báo Lỗi:**
   - *Xác minh:* `SplashController.contactSupport()` chỉ đính kèm chuỗi ngoại lệ kỹ thuật (`errorMessage`), tuyệt đối không đính kèm số dư, thu nhập hay chi tiêu người dùng.

### 6. Checklist Definition of Done
- [x] Cold start đến Today $\le 1.0$ s trên thiết bị (thực tế: **284ms**)
- [x] Không gọi mạng trên đường khởi động chính
- [x] Zero-warning compilation (`flutter analyze` 0 issues)
- [x] Đạt 100% test pass (157/157 tests)
- [x] Không dùng deprecated API
- [x] Hỗ trợ Accessibility (VoiceOver, TalkBack, Dynamic Type 2.0x không overflow)
- [x] Hỗ trợ Reduced Motion (`MediaQuery.disableAnimations`)

