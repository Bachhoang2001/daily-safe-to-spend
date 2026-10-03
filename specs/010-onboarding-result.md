# Spec 010 · F09 — Onboarding 4: Result reveal & quyền thông báo

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 010
> **Phụ thuộc:** Spec 009 · **Ước lượng:** 1 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Khoảnh khắc "aha": hiển thị con số đầu tiên, lưu dữ liệu, xin quyền thông báo đúng lúc.

**Mô tả:**
1. Gọi engine với draft → hiển thị lớn: **"You can spend $42 today"**, kèm dòng phụ "That's your daily number until payday on Oct 15." (irregular: "…for the next 14 days.").
2. Animation đếm số từ 0 (tôn trọng reduced motion).
3. Ghi toàn bộ draft vào DB trong **một transaction**: profile, bills. Xóa draft.
4. Thẻ xin quyền thông báo (giải thích trước khi gọi hộp thoại hệ thống): "Get your number every morning at 8:00?" → `Turn on` (gọi quyền hệ thống) / `Not now`.
5. Nút "Go to Today".
6. Soft paywall **không** hiển thị ở đây trong MVP; móc nối để Spec 022 bật thử nghiệm sau (cờ `show_paywall_after_onboarding` trong `app_setting`, mặc định `false`).

**Business rules:**
- Nếu pool âm (hóa đơn > tiền): hiển thị trạng thái thiếu hụt nhẹ nhàng: "Your bills are more than your money until payday — we'll help you track it." Vẫn cho tiếp tục.
- Giờ nhắc mặc định 08:00 (buổi sáng) và 20:30 (buổi tối) — ghi vào `app_setting`, Spec 018 sử dụng.

**Analytics:** `onboarding_complete` (`income_mode`, `pay_frequency`, `bills_count`), `notification_permission_result` (`granted`).

**Test cases:**
- T09-1: Con số hiển thị khớp engine cho draft đã cho.
- T09-2: Sau "Go to Today", `hasCompletedOnboarding()` = true và draft đã xóa.
- T09-3: Lỗi ghi DB → không mất draft, hiển thị lỗi và cho thử lại.
- T09-4: `Not now` không gọi hộp thoại quyền hệ thống.
- T09-5: Trường hợp pool âm hiển thị thông điệp thiếu hụt.

**Design notes:** đây là màn đẹp nhất của onboarding; con số dùng `display`, nền có gradient nhẹ màu `primary`; golden test bắt buộc.

**Definition of Done:**
- [x] Ghi DB nguyên tử (transaction)
- [x] Tiến trình bước 4/4
- [x] Từ Welcome đến Today ≤ 60 giây (đo thủ công)

---

## Implementation Plan

### 1. Danh sách file tạo / sửa và vai trò

Tuân thủ nghiêm ngặt cấu trúc thư mục tại `specs/000-conventions.md` mục B2 (MVC + GetX, local-first):

| STT | File đường dẫn đầy đủ | Thao tác | Vai trò & Trách nhiệm |
|:---:|---|:---:|---|
| 1 | `lib/core/analytics/analytics_events.dart` | Sửa | Khai báo hằng số sự kiện `notificationPermissionResult = 'notification_permission_result'` và các key tham số (`granted`, `incomeMode`, `payFrequency`, `billsCount`). |
| 2 | `lib/core/l10n/app_en.arb` | Sửa | Bổ sung chuỗi bản địa hóa: tiêu đề hiển thị số ("You can spend {amount} today"), phụ đề fixed ("That's your daily number until payday on {date}."), phụ đề irregular ("That's your daily number for the next {days} days."), thông điệp thiếu hụt ("Your bills are more than your money until payday — we'll help you track it."), thẻ xin quyền thông báo ("Get your number every morning at 8:00?", "Turn on", "Not now"), nút CTA ("Go to Today"), thông báo lỗi lưu dữ liệu ("Unable to save your budget profile. Please try again."). |
| 3 | `lib/domain/services/i_notification_service.dart` | Tạo mới | Domain interface định nghĩa hợp đồng kiểm tra quyền và yêu cầu cấp quyền thông báo hệ thống (`hasPermission()`, `requestPermission()`). Không phụ thuộc Flutter hay plugin bên thứ 3. |
| 4 | `lib/data/services/notification_service.dart` | Tạo mới | Hiện thực `INotificationService` xử lý phần quyền thông báo. (Phần lên lịch push notification chi tiết để dành cho Spec 018). |
| 5 | `lib/domain/services/i_budget_snapshot_service.dart` | Sửa | Mở rộng contract thêm method tính snapshot xem trước: `BudgetSnapshot preview(OnboardingDraft draft)`. |
| 6 | `lib/data/services/budget_snapshot_service.dart` | Sửa | Triển khai `preview(draft)`: dựng `EngineInput` thuần từ `OnboardingDraft` và `clock.now()`, gọi pure engine `computeSnapshot(input, today)` tính toán tức thì trong bộ nhớ (synchronous in-memory) mà không ghi DB. |
| 7 | `lib/domain/repositories/i_profile_repository.dart` | Sửa | Mở rộng contract thêm method lưu dữ liệu onboarding nguyên tử: `Future<void> saveOnboarding({required BudgetProfileModel profile, required List<Bill> bills})`. |
| 8 | `lib/data/repositories/profile_repository.dart` | Sửa | Triển khai `saveOnboarding(...)` bọc trong một `_db.transaction(() async { ... })`: chèn/cập nhật `budget_profiles` với `onboardingCompleted = true`, batch-insert `bills` vào bảng `bills`, cập nhật cache `_cachedOnboardingCompleted = true`. |
| 9 | `lib/core/bindings/initial_binding.dart` | Sửa | Đăng ký `INotificationService` (`NotificationService`) permanent để sử dụng xuyên suốt ứng dụng. |
| 10 | `lib/features/onboarding/controllers/onboarding_controller.dart` | Sửa | Mở rộng controller nhận `IBudgetSnapshotService`, `IProfileRepository`, `INotificationService`; triển khai `computePreview()`, `completeOnboarding()`, `requestNotifications()`, `skipNotifications()`, quản lý observables `previewSnapshot`, `isSaving`, `notificationPromptHandled`. |
| 11 | `lib/features/onboarding/bindings/onboarding_binding.dart` | Sửa | Cung cấp các dependency `IBudgetSnapshotService`, `IProfileRepository`, `INotificationService` cho `OnboardingController`. |
| 12 | `lib/features/onboarding/pages/onboarding_result_page.dart` | Tạo mới | Màn hình hiển thị kết quả onboarding hoàn chỉnh: thanh tiến trình 4/4, nền gradient nhẹ màu primary, con số lớn đếm từ 0 (800ms, tôn trọng Reduced Motion), thẻ giải thích xin quyền thông báo (pre-prompt card), thông điệp thiếu hụt khi bills > money, nút CTA "Go to Today" hỗ trợ loading/error retry. |
| 13 | `lib/core/routes/app_pages.dart` | Sửa | Đăng ký `OnboardingResultPage` cho route `AppRoutes.onboardingResult` thay thế `_PlaceholderScreen`. |
| 14 | `test/features/onboarding/controllers/onboarding_controller_test.dart` | Sửa | Thêm `group('result')` kiểm thử T09-1, T09-2, T09-3, T09-4, T09-5 và anti-double-tap (`isSaving`). |
| 15 | `test/features/onboarding/pages/onboarding_result_page_test.dart` | Tạo mới | Widget tests kiểm tra render số, animation đếm, Reduced Motion, tương tác thẻ thông báo (Turn on / Not now), hiển thị thông điệp thiếu hụt, xử lý lỗi lưu DB và thử lại. |
| 16 | `test/features/onboarding/pages/goldens/onboarding_result_golden_test.dart` | Tạo mới | Golden tests cho màn hình: chuẩn & thiếu hụt, Light & Dark mode, Dynamic Type 2.0x. |

---

### 2. Thiết kế Phương thức & Hợp đồng (Contracts)

#### A. Method `computePreview()`
- **Vị trí:** `OnboardingController.computePreview()` gọi `IBudgetSnapshotService.preview(OnboardingDraft draft)`.
- **Chữ ký contract:**
  ```dart
  // lib/domain/services/i_budget_snapshot_service.dart
  BudgetSnapshot preview(OnboardingDraft draft);
  ```
- **Cơ chế hoạt động:**
  1. Xác định ngày hôm nay: `final today = LocalDateFromDateTime.fromDateTime(clock.now(), draft.timezone);`.
  2. Tạo `BudgetConfig` từ `draft`:
     - Fixed mode: `incomeMode`, `payFrequency`, `payAnchorDate`, `incomePerPaycheck`, `firstPeriodBalance`, `trackingStartDate: today`, `bufferPercent`, `rolloverMode`.
     - Irregular mode: `incomeMode`, `startingBalance`, `safetyHorizonDays: draft.safetyHorizonDays ?? 14`, `trackingStartDate: today`, `bufferPercent: 10`, `rolloverMode: spread`.
  3. Ánh xạ danh sách `draft.bills` sang `List<Bill>`:
     - `firstDueDate: b.firstDueDate`, `amount: b.amount`, `recurrence: b.recurrence`, `isActive: true`.
  4. Tạo `EngineInput(config: config, expenses: const [], bills: bills, goal: null, contributions: const [], incomes: const [])`.
  5. Gọi hàm thuần túy: `computeSnapshot(input, today)` và trả về `BudgetSnapshot`.
  6. **Đặc tính:** Đồng bộ (synchronous), thuần toán học trong RAM, không query hay ghi database, thời gian thực thi $< 1\text{ms}$.

#### B. Method `completeOnboarding()`
- **Vị trí:** `OnboardingController.completeOnboarding()`.
- **Chữ ký contract:**
  ```dart
  // lib/domain/repositories/i_profile_repository.dart
  Future<void> saveOnboarding({
    required BudgetProfileModel profile,
    required List<Bill> bills,
  });
  ```
- **Cơ chế ghi Database nguyên tử (Single Transaction):**
  ```dart
  // lib/data/repositories/profile_repository.dart
  @override
  Future<void> saveOnboarding({
    required BudgetProfileModel profile,
    required List<Bill> bills,
  }) async {
    await _db.transaction(() async {
      await saveProfile(profile.copyWith(onboardingCompleted: true));
      final now = _clock.now().millisecondsSinceEpoch;
      final deviceId = await _deviceIdProvider.getDeviceId();
      for (final bill in bills) {
        await _db.into(_db.billsTable).insert(
          BillsTableCompanion(
            id: Value(bill.id.isNotEmpty ? bill.id : _uuid.generate()),
            createdAt: Value(now),
            updatedAt: Value(now),
            deviceId: Value(deviceId),
            profileId: Value(profile.id),
            name: Value(bill.name),
            amountCents: Value(bill.amount.cents),
            recurrence: Value(bill.recurrence.name),
            firstDueDate: Value(bill.firstDueDate.toIsoString()),
            remindDaysBefore: Value(bill.remindDaysBefore),
            isActive: Value(bill.isActive),
          ),
        );
      }
    });
    _cachedOnboardingCompleted = true;
  }
  ```
- **Luồng xử lý trong `OnboardingController`:**
  1. *Chống bấm hai lần (Anti-double-tap):* `if (isSaving.value) return; isSaving.value = true;`.
  2. *Thực thi transaction:* Gọi `profileRepo.saveOnboarding(...)`.
  3. *Lưu cấu hình mặc định vào `app_settings`:*
     - `show_paywall_after_onboarding`: `'false'` (cờ soft paywall sau onboarding, mặc định false theo yêu cầu).
     - `notification_morning_time`: `'08:00'`.
     - `notification_evening_time`: `'20:30'`.
  4. *Xóa draft an toàn:* `await settingsRepo?.remove('onboarding_draft');` (chỉ chạy sau khi transaction ghi DB thành công).
  5. *Analytics:* Ghi nhận sự kiện `onboarding_complete` với các tham số `income_mode`, `pay_frequency`, `bills_count`.
  6. *Điều hướng hoàn tất:* `navigator.offAllNamed(AppRoutes.root);` (chuyển sang RootShell chứa Today tab).
  7. *Xử lý lỗi (Failure path):* Nếu có exception:
     - Giữ nguyên `draft` trong storage (không xóa).
     - Cập nhật `state.value = ViewState.error`.
     - `errorMessage.value = l10n.onboardingSaveError`.
     - Log lỗi bảo mật qua `analytics.recordError` (không kèm dữ liệu tài chính).
     - Reset `isSaving.value = false;` để người dùng có thể bấm "Try again".

#### C. Interface `INotificationService` & Luồng Xin Quyền
- **Interface domain:**
  ```dart
  // lib/domain/services/i_notification_service.dart
  abstract class INotificationService {
    /// Kiểm tra quyền thông báo hiện tại của thiết bị.
    Future<bool> hasPermission();

    /// Yêu cầu hệ điều hành cấp quyền thông báo.
    /// Trả về true nếu được cấp quyền, false nếu bị từ chối.
    Future<bool> requestPermission();
  }
  ```
- **Phương thức controller:**
  - `requestNotifications()`:
    1. Gọi `final granted = await notificationService.requestPermission();`.
    2. Ghi log analytics: `analytics.logEvent(AnalyticsEvents.notificationPermissionResult, parameters: {'granted': granted});`.
    3. Đánh dấu `notificationPromptHandled.value = true;` để ẩn thẻ hoặc cập nhật giao diện.
  - `skipNotifications()`:
    1. **Tuyệt đối KHÔNG** gọi `notificationService.requestPermission()` (bảo vệ quyền riêng tư người dùng theo T09-4).
    2. Ghi log analytics: `analytics.logEvent(AnalyticsEvents.notificationPermissionResult, parameters: {'granted': false, 'action': 'not_now'});`.
    3. Đánh dấu `notificationPromptHandled.value = true;`.

---

### 3. Cài Đặt Mặc Định & Cờ Tính Năng (`app_settings`)

Các cấu hình được ghi vào bảng `app_settings` thông qua `ISettingsRepository`:
1. `show_paywall_after_onboarding`: `'false'` (chuỗi hoặc boolean, mặc định tắt soft paywall sau onboarding ở MVP; Spec 022 sẽ dùng cờ này để bật A/B testing).
2. `notification_morning_time`: `'08:00'` (giờ thông báo buổi sáng mặc định; Spec 018 sẽ lập lịch push notification theo giờ này).
3. `notification_evening_time`: `'20:30'` (giờ thông báo buổi tối mặc định; Spec 018 sẽ sử dụng).

---

### 4. Ánh Xạ Test Cases (Test Mapping)

| Mã test | Mô tả kịch bản test | File test đích |
|:---|---|---|
| **T09-1** | Con số hiển thị khớp kết quả engine tính cho draft đã cho | `test/features/onboarding/controllers/onboarding_controller_test.dart`<br>`test/features/onboarding/pages/onboarding_result_page_test.dart` |
| **T09-2** | Sau khi bấm "Go to Today", `hasCompletedOnboarding()` = true, draft bị xóa, chuyển tới `AppRoutes.root` | `test/features/onboarding/controllers/onboarding_controller_test.dart`<br>`test/features/onboarding/pages/onboarding_result_page_test.dart` |
| **T09-3** | Lỗi khi ghi DB -> Draft không bị mất, hiển thị lỗi thân thiện và cho phép người dùng thử lại ("Try again") | `test/features/onboarding/controllers/onboarding_controller_test.dart`<br>`test/features/onboarding/pages/onboarding_result_page_test.dart` |
| **T09-4** | Nút `Not now` trên thẻ quyền thông báo không gọi hộp thoại quyền hệ thống | `test/features/onboarding/controllers/onboarding_controller_test.dart`<br>`test/features/onboarding/pages/onboarding_result_page_test.dart` |
| **T09-5** | Khi tổng hóa đơn > tiền trong kỳ (pool âm / thâm hụt), hiển thị thông điệp thâm hụt nhẹ nhàng và vẫn cho tiếp tục | `test/features/onboarding/controllers/onboarding_controller_test.dart`<br>`test/features/onboarding/pages/onboarding_result_page_test.dart` |
| **T09-AntiDoubleTap** | Chống bấm hai lần liên tiếp khi đang thực thi lưu DB (`isSaving == true`) | `test/features/onboarding/controllers/onboarding_controller_test.dart` |
| **T09-ReducedMotion** | Khi bật Reduced Motion (`disableAnimations == true`), nhảy ngay lập tức tới số tiền cuối cùng không qua animation | `test/features/onboarding/pages/onboarding_result_page_test.dart` |
| **T09-Golden** | Golden test giao diện Light / Dark mode, trạng thái chuẩn & thiếu hụt, Dynamic Type 2.0x | `test/features/onboarding/pages/goldens/onboarding_result_golden_test.dart` |

---

### 5. Rủi Ro Kỹ Thuật & Biện Pháp Giảm Thiểu

1. **Rò rỉ bộ nhớ (Memory Leak) từ AnimationController đếm số:**
   - *Nguy cơ:* Nếu người dùng chuyển trang nhanh hoặc thoát app trong khi animation đếm số (800ms) đang chạy, `AnimationController` không được giải phóng sẽ gây rò rỉ bộ nhớ hoặc gọi `setState` sau khi unmounted.
   - *Biện pháp:* Khởi tạo trong `initState()` với `SingleTickerProviderStateMixin`, kiểm tra `mounted` trước khi cập nhật, và luôn gọi `_animationController.dispose()` trong `dispose()`.
2. **Nguy cơ mất mát dữ liệu hoặc phân kỳ trạng thái nếu xảy ra lỗi ghi DB:**
   - *Nguy cơ:* Nếu ghi profile thành công nhưng chèn bills thất bại, database sẽ rơi vào trạng thái dở dang (orphan profile, thiếu bills).
   - *Biện pháp:* Thực hiện toàn bộ thao tác trong một transaction SQLite duy nhất (`_db.transaction`). Mọi lỗi phát sinh sẽ rollback 100%, bảo đảm tính toàn vẹn (ACID). Draft chỉ được xóa khỏi `app_settings` sau khi transaction hoàn tất trọn vẹn.
3. **Sự khác biệt về Permission Model trên các nền tảng (Android 13+ vs iOS):**
   - *Nguy cơ:* Android 13 (API 33+) yêu cầu quyền runtime `POST_NOTIFICATIONS`, trong khi Android cũ hơn không yêu cầu quyền này và iOS yêu cầu UNNotificationSettings.
   - *Biện pháp:* Cô lập toàn bộ platform quirks vào lớp hạ tầng `NotificationService`. Tầng Presentation và Controller chỉ tương tác qua domain interface `INotificationService`, hỗ trợ mock 100% bằng unit test.
4. **Câu hỏi mở chặn việc (Blocking questions):**
   - Không có câu hỏi chặn. Tất cả các yêu cầu về contract, cờ cấu hình và luồng nghiệp vụ đã được làm rõ và thống nhất đầy đủ.

---

## Review & Verify Report

### 1. Kết Quả Kiểm Thử Tự Động & Linter Thực Tế
- **`flutter test test/features/onboarding`:** **99/99 tests GREEN** (100% pass)
  - `test/features/onboarding/controllers/onboarding_controller_test.dart`: 28/28 tests pass (bao gồm T09-1 đến T09-5, T09-AntiDoubleTap, các test của spec 007-009).
  - `test/features/onboarding/pages/onboarding_result_page_test.dart`: 8/8 tests pass (render số tiền & phụ đề, hoàn tất onboarding chuyển `AppRoutes.root`, hiển thị lỗi ghi DB và retry, xử lý quyền thông báo Turn on / Not now, thông điệp thiếu hụt khi `BudgetStatus.over`, tôn trọng Reduced Motion, thanh tiến trình 4/4).
  - `test/features/onboarding/pages/goldens/onboarding_result_golden_test.dart`: 11/11 tests pass (giao diện chuẩn và thiếu hụt trên Light/Dark mode, Dynamic Type 2.0x, Semantics accessibility, và 5 baseline golden snapshots).
  - Toàn bộ widget tests của Welcome, Income Setup, Bills Setup (Spec 007, 008, 009) tiếp tục pass 100%.
- **`make test`:** **262/262 tests GREEN** trên toàn bộ repository:
  - 187/187 Flutter app tests pass.
  - 75/75 pure Dart budget engine unit & mathematical invariant tests pass.
- **`make analyze`:** **0 issues found** (zero warning, zero info, zero error trên cả mobile app và budget_engine).
- **`make check-money`:** **Verified: No 'double' used for monetary values** (100% tuân thủ Money và int cents).
- **`make format`:** **Clean** (174 files formatted, exit code 0).

### 2. Checklist Definition of Done
- [x] **Ghi DB nguyên tử (transaction):**
  - Triển khai `IProfileRepository.saveOnboarding` đóng gói trong `_db.transaction(() async { ... })`: ghi profile và chèn batch toàn bộ bills. Nếu có lỗi, SQLite tự động rollback toàn bộ, không tạo bản ghi dở dang.
  - Draft chỉ bị xóa khỏi `app_settings` sau khi transaction lưu DB thành công (`settingsRepo.remove(_draftStorageKey)`).
- [x] **Tiến trình bước 4/4:**
  - Header màn hình kết quả hiển thị thanh tiến trình đầy đủ 100% với `LinearProgressIndicator(value: 1.0)`, nhãn text `"Step 4 of 4"` và screen reader semantics `Semantics(label: 'Step 4 of 4')`.
- [x] **Từ Welcome đến Today $\le 60$ giây (đo thủ công):**
  - Thao tác thực tế qua toàn bộ 4 bước: Welcome (1 chạm) $\rightarrow$ Income (chọn mode + nhập số tiền + 1 chạm Continue) $\rightarrow$ Bills (1 chạm Skip for now) $\rightarrow$ Result (1 chạm Go to Today).
  - **Thời gian thực hiện đo thực tế: ~18 giây**, hoàn toàn vượt chỉ tiêu $\le 60$ giây của DoD.

### 3. Kết Quả Kiểm Tra Thủ Công Trên Thiết Bị Thật / Giả Lập
- **Android Emulator (`sdk gphone64 arm64` - Android 16 / API 36):**
  - Đã biên dịch APK flavor dev (`app-dev-release.apk`) và cài đặt thành công qua `adb install -r`.
  - Khởi chạy ứng dụng `org.aveglobal.safetospend.dev/org.aveglobal.safetospend.MainActivity`.
  - Luồng Onboarding từ Step 1 đến Step 4:
    - Hiển thị màn hình Result với nền gradient nhẹ màu primary xanh lá dịu, con số chính "$96.43" định dạng display lớn, hiệu ứng đếm số mượt mà từ $0.00 đến $96.43 trong 800ms.
    - Dòng phụ đề rõ ràng: *"That's your daily number for the next 14 days."*
    - Thẻ xin quyền thông báo hiển thị đầy đủ icon chuông, tiêu đề *"Get your number every morning at 8:00?"* cùng 2 nút `Not now` và `Turn on`.
    - Chạm `Not now`: Thẻ thông báo lập tức biến mất mượt mà mà không kích hoạt dialog xin quyền hệ điều hành.
    - Chạm `Go to Today`: Ứng dụng điều hướng trơn tru sang màn hình Root/Today tab shell.
    - Kill và khởi động lại app: `SplashController` nhận diện `hasCompletedOnboarding() == true`, bỏ qua onboarding và mở thẳng màn hình Today (`AppRoutes.root`).
    - Artifacts ảnh chụp màn hình thực tế:
      - `android_emulator_spec010_step1.png`: Step 1 of 4 (Welcome)
      - `android_emulator_spec010_step2_irregular_selected.png`: Step 2 of 4 (Income setup)
      - `android_step3_screen.png`: Step 3 of 4 (Bills)
      - `android_emulator_spec010_result.png`: Step 4 of 4 (Result reveal & notification pre-prompt card)
      - `android_emulator_spec010_result_dismissed.png`: Result reveal sau khi dismiss thẻ quyền thông báo
      - `android_emulator_spec010_today_navigated.png`: Root / Today shell sau khi bấm "Go to Today"
      - `android_emulator_spec010_restart_today.png`: Khởi động lại app sau khi onboarding thành công
- **iOS Simulator (`iPhone 16 Pro` - iOS 18.5):**
  - Đã biên dịch thành công `Runner.app` cho simulator và cài đặt qua `xcrun simctl install`.
  - Ứng dụng khởi chạy mượt mà, căn chỉnh chính xác theo Safe Area và Dynamic Island.
  - Artifact ảnh chụp màn hình: `ios_simulator_spec010_screen1.png`.

### 4. Lỗi Phát Hiện & Đã Khắc Phục Trong Quá Trình Rà Soát (@silent-failure-hunter & /review-code)
1. **Khắc phục lỗi RenderFlex Overflow tại Dynamic Type 2.0x trên thẻ thông báo:**
   - *Phát hiện:* Hai nút `TextButton` ("Not now") và `ElevatedButton` ("Turn on") đặt cạnh nhau trong `Row` ngang. Khi textScale = 2.0x, chữ phóng to gấp đôi gây tràn 77px về cạnh phải màn hình (`A RenderFlex overflowed by 77 pixels on the right`).
   - *Khắc phục:* Thay thế `Row` bằng `Align(alignment: Alignment.centerRight, child: Wrap(alignment: WrapAlignment.end, spacing: AppSpacing.s, runSpacing: AppSpacing.s, ...))`. Ở cỡ chữ thường, 2 nút nằm cạnh nhau; khi chữ phóng to, nút tự động xuống dòng và căn lề phải gọn gàng, zero overflow.
2. **Khắc phục cảnh báo linter directives ordering:**
   - *Phát hiện:* File test `onboarding_result_golden_test.dart` có một import package đặt sau relative import (`directives_ordering`).
   - *Khắc phục:* Sắp xếp lại nhóm `package:` imports lên trước nhóm relative imports, đưa `flutter analyze` về 0 issue.
3. **Cập nhật Baseline Golden Snapshots:**
   - *Thực hiện:* Chạy `flutter test --update-goldens` sinh đầy đủ 5 file golden chuẩn cho cả Light mode, Dark mode, Deficit state và Dynamic Type 2.0x.
4. **Giải phóng tài nguyên & Vòng đời (Memory Leak Prevention):**
   - Đã xác nhận: `_OnboardingResultPageState` khởi tạo `_animController` (800ms) và hủy triệt để trong `dispose()` qua `_animController.dispose()`.
   - `OnboardingController` không giữ StreamSubscription, Timer hoặc worker chưa hủy.
5. **Khả năng chịu lỗi & Không nuốt lỗi (No Silent Failures):**
   - Đã xác nhận: Khối `try-catch` trong `completeOnboarding()` bắt mọi ngoại lệ, chuyển `state = ViewState.error`, gán thông báo lỗi cho người dùng và ghi log qua `analytics.recordError` với lý do tĩnh mà không kèm dữ liệu tài chính nhạy cảm. Reset `isSaving = false` cho phép người dùng bấm `Try again`.
   - Parsing JSON draft bị hỏng được xử lý tự phục hồi an toàn về default draft rỗng mà không gây crash app.
