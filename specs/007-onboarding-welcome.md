# Spec 007 · F06 — Onboarding 1: Welcome

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 007
> **Phụ thuộc:** Spec 006 · **Ước lượng:** 0,5 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Truyền đạt giá trị cốt lõi trong một màn.

**Mô tả:**
- Tiêu đề: "Know what's safe to spend today."
- Phụ đề: "One number every morning. No bank login. Your data stays on your phone."
- Minh họa: thẻ số tiền mẫu (`$42 safe to spend today`) có animation đếm nhẹ.
- 3 điểm nhấn ngắn (icon + 1 dòng): Built around your paycheck · Works with irregular income · Private by design.
- Nút chính "Get started"; liên kết nhỏ "Privacy Policy" và "Terms".
- Thanh tiến trình onboarding: bước 1/4.

**Analytics:** `onboarding_start`.

**Test cases:**
- T06-1: Render đủ nội dung, nút Get started điều hướng sang `/onboarding/income`.
- T06-2: Link Privacy mở URL ngoài.
- T06-3: Golden light/dark, cỡ chữ lớn nhất không bị cắt chữ.

**Definition of Done:**
- [x] Không có nút "Skip" (onboarding bắt buộc tối thiểu)
- [x] Nút "Back" hệ thống ở màn này đóng app (Android), không quay về splash

---

## Implementation Plan

### 1. Danh Sách File Tạo / Sửa (Chuẩn 000-conventions.md B2)

#### File tạo mới:
1. `lib/core/navigation/navigator.dart`:
   - Định nghĩa interface `INavigator` (`toNamed`, `offNamed`, `offAllNamed`, `back`) và hiện thực GetX `AppNavigator`.
   - Giúp tách rời việc điều hướng khỏi global state của GetX, hỗ trợ dependency injection qua constructor và cho phép test điều hướng 100% bằng pure `mocktail` trong unit test.
2. `lib/data/models/onboarding_draft.dart`:
   - Model dữ liệu nháp `OnboardingDraft` và `OnboardingBillDraft` (bất biến, có `copyWith`, giá trị mặc định) dùng để gom dữ liệu người dùng nhập xuyên suốt 4 màn onboarding trước khi ghi vào SQLite ở màn 4 (Spec 010).
3. `lib/features/onboarding/controllers/onboarding_controller.dart`:
   - Controller trung tâm quản lý toàn bộ luồng onboarding (bước 1/4 đến 4/4).
   - Nhận dependency qua constructor: `IAnalyticsService`, `INavigator`, `IUrlLauncher`.
   - State reactive: `currentStep = 1.obs`, `draft = const OnboardingDraft().obs`, `state = ViewState.idle.obs`, `errorMessage`.
   - Methods Spec 007: `start()` (log `onboarding_start`, điều hướng `/onboarding/income`), `openPrivacyPolicy()`, `openTermsOfService()`.
4. `lib/features/onboarding/bindings/onboarding_binding.dart`:
   - `OnboardingBinding` implements `Bindings`.
   - Đăng ký `INavigator` và `Get.lazyPut<OnboardingController>`.
   - Sống xuyên suốt 4 màn onboarding và tự động hủy (`onClose()`) khi rời luồng (chuyển sang `/today`).
5. `lib/features/onboarding/widgets/onboarding_progress.dart`:
   - Widget hiển thị thanh tiến trình onboarding (`Step X of 4`) với visual progress bar và semantics label hỗ trợ VoiceOver/TalkBack.
6. `lib/features/onboarding/pages/welcome_page.dart`:
   - Màn hình Welcome (`GetView<OnboardingController>`).
   - Bố cục responsive, hỗ trợ Safe Area, `PopScope` chặn back về Splash (đóng app trên Android theo DoD).
   - Thẻ số tiền mẫu `$42 safe to spend today` với animation đếm nhẹ nhàng (tôn trọng reduced motion qua `MediaQuery.disableAnimations`, hủy `AnimationController` trong `dispose()`).
   - 3 điểm nhấn cốt lõi: Built around your paycheck, Works with irregular income, Private by design.
   - Nút CTA chính "Get started", liên kết nhỏ "Privacy Policy" và "Terms of Service". Không có nút "Skip" (DoD).
7. `test/features/onboarding/controllers/onboarding_controller_test.dart`:
   - Unit tests cho `OnboardingController` (group `welcome`): kiểm tra gọi `start()` ghi sự kiện `onboarding_start` và gọi `navigator.toNamed(AppRoutes.onboardingIncome)`.
8. `test/features/onboarding/pages/welcome_page_test.dart`:
   - Widget tests cho `WelcomePage`: kiểm tra render đủ nội dung, 3 điểm nhấn, không có nút Skip, tap nút Get started kích hoạt điều hướng, tap Privacy/Terms mở URL, PopScope đóng app (T06-1, T06-2).
9. `test/features/onboarding/pages/goldens/welcome_golden_test.dart`:
   - Golden / layout tests kiểm tra hiển thị light/dark mode và Dynamic Type 2.0x không bị cắt/overflow chữ (T06-3).

#### File sửa đổi:
1. `lib/core/bindings/initial_binding.dart`:
   - Đăng ký `INavigator` (`Get.lazyPut<INavigator>(() => const AppNavigator(), fenix: true)`) để các controller toàn app đều có thể inject.
2. `lib/core/routes/app_pages.dart`:
   - Cập nhật cấu hình route `AppRoutes.onboardingWelcome` thay thế `_PlaceholderScreen` bằng `const WelcomePage()`, gắn `binding: OnboardingBinding()`.
   - Gắn `binding: OnboardingBinding()` cho cả 3 route onboarding tiếp theo (`onboardingIncome`, `onboardingBills`, `onboardingResult`) để dùng chung controller instance.
3. `lib/core/l10n/app_en.arb` (và file sinh mã `app_localizations.dart` / `app_localizations_en.dart`):
   - Bổ sung chuỗi bản địa hóa cho màn Welcome: tiêu đề, phụ đề, thẻ số tiền mẫu, 3 điểm nhấn, nút Get started, Privacy, Terms, thanh tiến trình.
4. `test/helpers/mock_services.dart`:
   - Bổ sung `MockNavigator` implements `INavigator` và `MockUrlLauncher` để phục vụ mocktail test.

---

### 2. Chốt Kiến Trúc `OnboardingDraft` & `OnboardingController` (Spec 007–010)

#### Model `OnboardingDraft` (`lib/data/models/onboarding_draft.dart`):
- Model Dart thuần túy, bất biến (`@immutable`), không phụ thuộc Flutter UI hay Drift DB.
- Thiết kế:
  ```dart
  @immutable
  class OnboardingDraft {
    const OnboardingDraft({
      this.currency = 'USD',
      this.incomeMode = IncomeMode.fixed,
      this.payFrequency = PayFrequency.biweekly,
      this.payAnchorDate,
      this.incomePerPaycheck,
      this.startingBalance,
      this.bufferPercent = 5,
      this.rolloverMode = RolloverMode.spread,
      this.bills = const <OnboardingBillDraft>[],
    });

    final String currency;
    final IncomeMode incomeMode;
    final PayFrequency payFrequency;
    final LocalDate? payAnchorDate;
    final Money? incomePerPaycheck;
    final Money? startingBalance;
    final int bufferPercent;
    final RolloverMode rolloverMode;
    final List<OnboardingBillDraft> bills;

    OnboardingDraft copyWith({ ... });
  }

  @immutable
  class OnboardingBillDraft {
    const OnboardingBillDraft({
      required this.id,
      required this.name,
      required this.amount,
      required this.recurrence,
      required this.firstDueDate,
    });

    final String id;
    final String name;
    final Money amount;
    final BillRecurrence recurrence;
    final LocalDate firstDueDate;

    OnboardingBillDraft copyWith({ ... });
  }
  ```
- **Vai trò:** Lưu trữ trạng thái tạm thời trên RAM suốt quá trình người dùng đi qua 4 màn. Chỉ khi người dùng bấm xác nhận ở màn 4 (`OnboardingResult` - Spec 010), toàn bộ thông tin từ `OnboardingDraft` mới được ghi vào SQLite (`BudgetProfile`, `Bills`) và kích hoạt `onboardingCompleted = true`.

#### Controller `OnboardingController` (`lib/features/onboarding/controllers/onboarding_controller.dart`):
- Kế thừa `GetxController`.
- **Constructor Injection:**
  ```dart
  class OnboardingController extends GetxController {
    OnboardingController({
      required IAnalyticsService analytics,
      required INavigator navigator,
      IUrlLauncher? urlLauncher,
    })  : _analytics = analytics,
          _navigator = navigator,
          _urlLauncher = urlLauncher ?? const SystemUrlLauncher();

    final IAnalyticsService _analytics;
    final INavigator _navigator;
    final IUrlLauncher _urlLauncher;

    final currentStep = 1.obs; // 1..4
    final draft = const OnboardingDraft().obs;
    final state = ViewState.idle.obs;
    final errorMessage = RxnString();

    void start() {
      _analytics.logEvent(AnalyticsEvents.onboardingStart);
      currentStep.value = 2;
      _navigator.toNamed(AppRoutes.onboardingIncome);
    }

    Future<void> openPrivacyPolicy() async {
      await _urlLauncher.launch(AppConstants.privacyPolicyUrl);
    }

    Future<void> openTermsOfService() async {
      await _urlLauncher.launch(AppConstants.termsOfServiceUrl);
    }
  }
  ```

---

### 3. Chốt Vòng Đời `OnboardingBinding`

- **Nguyên lý vòng đời:** Luồng onboarding là một chuỗi wizard tuyến tính (Welcome $\rightarrow$ Income $\rightarrow$ Bills $\rightarrow$ Result). `OnboardingController` phải được giữ nguyên trạng thái khi người dùng chuyển giữa các màn hoặc bấm Back để sửa thông tin ở bước trước.
- **Cấu hình Binding:**
  - `OnboardingBinding` được gán vào cả 4 route trong `AppPages.pages`:
    - `AppRoutes.onboardingWelcome`
    - `AppRoutes.onboardingIncome`
    - `AppRoutes.onboardingBills`
    - `AppRoutes.onboardingResult`
  - Trong `OnboardingBinding.dependencies()`:
    ```dart
    class OnboardingBinding extends Bindings {
      @override
      void dependencies() {
        if (!Get.isRegistered<OnboardingController>()) {
          Get.lazyPut<OnboardingController>(
            () => OnboardingController(
              analytics: Get.find<IAnalyticsService>(),
              navigator: Get.find<INavigator>(),
            ),
          );
        }
      }
    }
    ```
- **Giải phóng bộ nhớ (Disposal):**
  - Khi người dùng ở bước 4 hoàn tất onboarding, controller gọi `_navigator.offAllNamed(AppRoutes.today)` (hoặc `AppRoutes.root`).
  - GetX sẽ gỡ bỏ toàn bộ các màn onboarding khỏi navigation stack. Do `OnboardingController` không đặt `permanent: true`, GetX tự động gọi `onClose()` và dọn dẹp controller khỏi bộ nhớ, hoàn toàn giải phóng RAM.

---

### 4. Ánh Xạ Test Cases Spec 007 → File Test

| Mã Test Case | Nội dung kiểm thử | File Test đích |
|---|---|---|
| **T06-1 (Logic)** | Gọi `start()` $\rightarrow$ ghi sự kiện analytics `onboarding_start`, điều hướng sang `/onboarding/income` | `test/features/onboarding/controllers/onboarding_controller_test.dart` |
| **T06-1 (UI)** | Render đủ nội dung: Tiêu đề, phụ đề, thẻ số tiền mẫu `$42`, 3 điểm nhấn, thanh tiến trình 1/4, nút Get started. Tap nút Get started gọi `start()`. Không có nút "Skip" | `test/features/onboarding/pages/welcome_page_test.dart` |
| **T06-2** | Tap liên kết "Privacy Policy" và "Terms" mở URL ngoại vi an toàn qua `IUrlLauncher` | `test/features/onboarding/pages/welcome_page_test.dart` |
| **T06-3** | Golden / Layout Responsive: Hiển thị chuẩn trên Light & Dark mode; không bị cắt chữ hay vỡ khung khi bật Dynamic Type 2.0x (cỡ chữ lớn nhất); tôn trọng Reduced Motion | `test/features/onboarding/pages/goldens/welcome_golden_test.dart` |
| **DoD Back** | Nút Back hệ thống (Android PopScope) tại WelcomePage thực hiện đóng ứng dụng, không pop ngược về splash | `test/features/onboarding/pages/welcome_page_test.dart` |

---

### 5. Rủi Ro Kỹ Thuật & Giải Pháp Phòng Ngừa

1. **Rủi ro rò rỉ `AnimationController` trên thẻ số tiền mẫu:**
   - *Phân tích:* Thẻ số tiền mẫu có animation đếm số (`$0` $\rightarrow$ `$42`). Nếu widget chuyển trang trước khi animation kết thúc hoặc bị dispose mà không hủy ticker sẽ gây rò rỉ tài nguyên.
   - *Giải pháp:* Dùng `StatefulWidget` với `SingleTickerProviderStateMixin`, hủy `_animationController.dispose()` trong `dispose()`, đồng thời kiểm tra `MediaQuery.disableAnimations` để tắt animation ngay lập tức khi người dùng bật chế độ giảm chuyển động.
2. **Rủi ro Back Navigation trên Android:**
   - *Phân tích:* Splash đã dùng `Get.offAllNamed(AppRoutes.onboardingWelcome)`, nghĩa là dưới Welcome trên stack không còn route nào. Tuy nhiên cần đảm bảo `PopScope` trên Android cư xử đúng là thoát app chứ không gây màn hình đen hoặc loop.
   - *Giải pháp:* Cấu hình `PopScope(canPop: true)` trên `WelcomePage` để hệ điều hành xử lý thoát app tự nhiên.
3. **Không có câu hỏi chặn việc (No blocking questions):**
   - Thiết kế `OnboardingDraft`, `OnboardingController`, `INavigator` và `OnboardingBinding` hoàn toàn trong sáng, tách biệt và tuân thủ 100% `000-conventions.md`. Sẵn sàng bước sang giai đoạn **DEFINE TEST** của Spec 007.

---

## Review & Verify Report
 
### 1. Kết Quả Kiểm Thử Tự Động & Linter Thực Tế
- **`flutter test test/features/onboarding`:** **16/16 tests GREEN** (100% pass)
  - `test/features/onboarding/controllers/onboarding_controller_test.dart`: 4/4 tests pass (khởi tạo state, start ghi log analytics & điều hướng income, mở legal links thành công, xử lý lỗi mở URL chuyển `ViewState.error` & `recordError`).
  - `test/features/onboarding/pages/welcome_page_test.dart`: 5/5 tests pass (render đủ 3 điểm nhấn + card + progress 1/4, tap CTA gọi start, DoD không nút Skip, DoD PopScope đóng app, tap Privacy/Terms).
  - `test/features/onboarding/pages/goldens/welcome_golden_test.dart`: 7/7 tests pass (Light mode, Dark mode, Dynamic Type 2.0x không overflow/cắt chữ, Reduced Motion bỏ qua animation đếm, 3 golden image snapshots comparison).
- **`make test`:** **173/173 tests GREEN** trên toàn bộ repository (98 app tests + 75 engine unit & invariant tests).
- **`flutter analyze` & `dart analyze`:** **0 issues found** (zero warning, zero info, zero error).
- **`make check-money`:** **Verified: No 'double' used for monetary values** (100% tuân thủ Money và int cents).
- **`make format`:** **Clean** (150 files formatted, exit code 0).

### 2. Checklist Definition of Done
- [x] Không có nút "Skip" (onboarding bắt buộc tối thiểu theo triết lý sản phẩm).
- [x] Nút "Back" hệ thống ở màn này đóng app (Android PopScope `canPop: true`), không pop ngược về splash.

### 3. Kết Quả Kiểm Tra Thủ Công Trên Thiết Bị Thật / Giả Lập
- **iOS Simulator (`iPhone 16 Pro` - iOS 18.5):**
  - Chuyển tiếp fade mượt mà từ Splash sang Welcome (`/onboarding/welcome`).
  - Thanh tiến trình hiển thị rõ ràng `Step 1 of 4` với 1 vạch xanh chính.
  - Card số tiền mẫu hiển thị `$42` với animation đếm mượt mà (650ms `easeOutCubic`), tôn trọng Reduced Motion.
  - 3 điểm nhấn với icon thương hiệu và nội dung chuẩn: *Built around your paycheck*, *Works with irregular income*, *Private by design*.
  - Nút *Get started* full-width nổi bật; liên kết *Privacy Policy* và *Terms of Service* nhỏ gọn, có gạch chân, touch target đạt chuẩn 44×44px.
  - Artifact ảnh chụp màn hình: `ios_simulator_spec007.png`.
- **Android Emulator (`sdk gphone64 arm64` - Android 16 / API 36):**
  - Cài đặt và khởi chạy chuẩn xác package `org.aveglobal.safetospend.dev`.
  - Layout hiển thị sắc nét, typography và padding chuẩn theo Design System.
  - Artifact ảnh chụp màn hình: `android_emulator_spec007.png`.
- **Kiểm tra phím Back hệ thống trên Android:**
  - Gửi lệnh `adb shell input keyevent 4` tại màn hình Welcome.
  - Kết quả kiểm tra Window Focus: `mCurrentFocus=Window{... NexusLauncherActivity}`. Ứng dụng thoát sạch sẽ về màn hình chính của hệ điều hành, không bị lặp hay quay lại màn Splash.

### 4. Lỗi Phát Hiện & Đã Khắc Phục Trong Quá Trình Rà Soát (Silent Failure Audit)
1. **Lỗi RenderFlex Overflow ở Dynamic Type 2.0x (Accessibility):**
   - *Phát hiện:* Tại test layout với text scale = 2.0, hàng liên kết pháp lý (`Row`) bị tràn 63px bên phải.
   - *Khắc phục:* Chuyển đổi từ `Row` sang `Wrap` kết hợp `spacing: AppSpacing.xs` và bọc `sampleLabel` trong card bằng `Expanded`, cho phép các phần tử tự động xuống hàng linh hoạt mà không gây vỡ giao diện.
2. **Loại bỏ nguy cơ Catch rỗng (Silent Failure):**
   - *Phát hiện:* Đoạn mở URL ngoài có block try-catch lồng nhau dễ dẫn đến nuốt lỗi nếu dịch vụ analytics gặp sự cố.
   - *Khắc phục:* Chuẩn hóa `_launchUrlString` trong `OnboardingController`: khi xảy ra exception, chuyển trạng thái `state.value = ViewState.error`, lưu `errorMessage.value = e.toString()`, đồng thời gọi `analytics.recordError(e, st)` có stubbing và test suite bao phủ trường hợp lỗi.
3. **Sửa cảnh báo linter:**
   - *Phát hiện:* `prefer_int_literals` trên `textScale: 2.0` trong file test.
   - *Khắc phục:* Đổi thành `textScale: 2`.
4. **Tối ưu Semantics nhãn đọc màn hình:**
   - *Phát hiện:* Screen reader đọc từng số đếm nhảy trong lúc animation `$0` $\rightarrow$ `$42` gây ồn ào và đọc cả icon trang trí.
   - *Khắc phục:* Bọc component bằng `Semantics(label: '$42 safe to spend today', container: true)` và bọc các icon/dấu chấm phân cách bằng `ExcludeSemantics`.
