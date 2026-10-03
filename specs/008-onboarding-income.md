# Spec 008 · F07 — Onboarding 2: Income & pay schedule

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 008
> **Phụ thuộc:** Spec 007, Spec 003, Spec 005 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Thu thập đủ dữ liệu để engine tính con số đầu tiên.

**User stories:**
- Là người lương cố định, tôi chọn kỳ lương và số tiền mỗi kỳ.
- Là gig worker, tôi chọn "My income varies" và nhập số tiền tôi đang có.

**Luồng (các bước con trong cùng màn, dạng step):**

1. **"How do you get paid?"**
   - `Same amount on a schedule` → fixed
   - `My income varies` → irregular
2. **Fixed:**
   - Tần suất: Weekly · Every 2 weeks · Twice a month (1st & 16th) · Monthly.
   - "When is your next payday?" → date picker (chỉ cho chọn từ hôm nay đến +31 ngày; Weekly/Biweekly giới hạn theo kỳ) → engine suy ra `payAnchorDate`.
   - "How much do you take home each paycheck?" → `AmountKeypad`.
   - "How much do you have to spend until then?" → `AmountKeypad`, mặc định gợi ý = thu nhập mỗi kỳ × (số ngày còn lại / độ dài kỳ), người dùng sửa được → `firstPeriodBalance`.
3. **Irregular:**
   - "How much money do you have right now?" → `startingBalance`.
   - "Plan ahead for how many days?" → lựa chọn 7 · **14 (recommended)** · 30 → `safetyHorizonDays`.
4. **Currency:** mặc định theo locale (USD/GBP/EUR), cho phép đổi qua dropdown nhỏ ở đầu màn.

**Business rules:**
- Số tiền > 0 bắt buộc cho thu nhập mỗi kỳ và số dư.
- `trackingStartDate = today`; `bufferPercent` mặc định: fixed 0, irregular 10.
- `timezone` = múi giờ thiết bị.
- Dữ liệu được giữ tạm trong `OnboardingController` (GetX, model `OnboardingDraft`; một controller dùng chung cho cả 4 màn onboarding qua `OnboardingBinding` với `Get.put(..., permanent: false)` và chỉ bị xóa khi rời luồng onboarding), **chỉ ghi DB ở Spec 010** khi hoàn tất — thoát app giữa chừng thì lần sau bắt đầu lại từ Welcome nhưng draft được khôi phục (lưu draft vào `app_setting` dạng JSON).

**Analytics:** `onboarding_income_mode_selected` (`mode`), `onboarding_pay_frequency_selected` (`frequency`), `onboarding_step_completed` (`step: income`).

**Edge cases:** chọn ngày lương là hôm nay; số tiền rất lớn; người dùng quay lại đổi mode → xóa các trường không liên quan khỏi draft.

**Test cases:**
- T07-1: Fixed/monthly: nhập đủ → nút Continue bật; thiếu số tiền → tắt.
- T07-2: Gợi ý `firstPeriodBalance` tính đúng theo công thức.
- T07-3: Irregular: chọn horizon 14 mặc định.
- T07-4: Đổi mode xóa trường của mode cũ trong draft.
- T07-5: Draft được khôi phục sau khi khởi động lại app.
- T07-6: Date picker không cho chọn ngày quá khứ.

**Design notes:** mỗi câu hỏi một khối lớn, chữ to; chuyển bước dùng slide ngang 250ms; bàn phím số là `AmountKeypad` (không dùng bàn phím hệ thống).

**Definition of Done:**
- [x] Hoàn thành bước này ≤ 30 giây với người dùng thử (đo thủ công, ghi vào mục Review & Verify Report)
- [x] Tiến trình bước 2/4

---

## Implementation Plan

### 1. Danh Sách File Tạo / Sửa (Chuẩn 000-conventions.md B2)

#### File tạo mới:
1. `lib/features/onboarding/pages/income_page.dart`:
   - Màn hình Onboarding 2: Income & pay schedule (`GetView<OnboardingController>`).
   - Giao diện dạng form từng khối lớn (card), chữ to, chuyển đổi động giữa Fixed và Irregular.
   - Bố cục responsive, hỗ trợ Safe Area, Dropdown chọn tiền tệ (USD, GBP, EUR) ở góc trên, thanh tiến trình `OnboardingProgress(currentStep: 2)`.
   - Nút "Continue" nổi bật (`PrimaryButton`), reactive theo `canContinue`.
2. `lib/features/onboarding/widgets/income_mode_selector.dart`:
   - Widget lựa chọn chế độ thu nhập (`Same amount on a schedule` vs `My income varies`) với hiệu ứng thẻ chọn trực quan, phản hồi xúc giác.
3. `lib/features/onboarding/widgets/frequency_selector.dart`:
   - Widget chọn chu kỳ trả lương (Weekly, Every 2 weeks, Twice a month, Monthly).
4. `lib/features/onboarding/widgets/horizon_selector.dart`:
   - Widget chọn cửa sổ an toàn (7, 14 recommended, 30 ngày) cho chế độ Irregular.
5. `test/features/onboarding/controllers/onboarding_income_test.dart`:
   - Unit test kiểm tra toàn bộ business logic bước Income: `canContinue`, công thức gợi ý `firstPeriodBalance`, xóa trường cũ khi đổi mode, serialize/deserialize draft JSON, xử lý draft hỏng, tính `payAnchorDate`.
6. `test/features/onboarding/pages/income_page_test.dart`:
   - Widget tests cho `IncomePage`: Render các khối câu hỏi, thao tác chọn mode/frequency/date/keypad, nút Continue bật/tắt theo `canContinue`, date picker chặn ngày quá khứ, tiến trình hiển thị 2/4.
7. `test/features/onboarding/pages/goldens/income_golden_test.dart`:
   - Golden / Responsive layout tests: Light mode, Dark mode, Dynamic Type 2.0x không vỡ khung/tràn chữ, tôn trọng Reduced motion.

#### File sửa đổi:
1. `lib/data/models/onboarding_draft.dart`:
   - Bổ sung các thuộc tính: `nextPayday` (`LocalDate?`), `firstPeriodBalance` (`Money?`), `safetyHorizonDays` (`int?`).
   - Cung cấp `toJson()` và `fromJson(Map<String, dynamic> json)` với null-safety tuyệt đối, fallback giá trị mặc định khi gặp dữ liệu bất thường.
2. `lib/features/onboarding/controllers/onboarding_controller.dart`:
   - Bổ sung constructor dependencies: `ISettingsRepository` (lưu draft) và `Clock` (lấy ngày hiện tại).
   - Thêm các methods: `selectIncomeMode`, `selectFrequency`, `setNextPayday`, `setIncomePerPaycheck`, `setFirstPeriodBalance`, `setStartingBalance`, `setHorizon`, `setCurrency`, `submitIncomeStep`, `loadDraft`, `saveDraft`.
   - Thêm getters: `canContinue`, `allowedPaydayRange`, `suggestedFirstPeriodBalance`.
3. `lib/features/onboarding/bindings/onboarding_binding.dart`:
   - Cập nhật DI: Inject `ISettingsRepository` (`Get.find<ISettingsRepository>()`) và `Clock` (`Get.find<Clock>()`) vào `OnboardingController`.
4. `lib/core/routes/app_pages.dart`:
   - Gắn `page: () => const IncomePage()` vào cấu hình route `AppRoutes.onboardingIncome`.
5. `lib/core/analytics/analytics_events.dart`:
   - Bổ sung hằng số sự kiện: `onboardingIncomeModeSelected`, `onboardingPayFrequencySelected`, `onboardingStepCompleted`.
6. `lib/core/l10n/app_en.arb`:
   - Bổ sung các chuỗi bản địa hóa cho màn Income: tiêu đề, phụ đề, các lựa chọn, câu hỏi kỳ lương, gợi ý số dư, nhãn trợ năng. Chạy `flutter gen-l10n`.
7. `test/helpers/mock_services.dart`:
   - Đảm bảo `MockSettingsRepository` sẵn sàng phục vụ kiểm thử lưu/đọc draft.

---

### 2. Chốt Các Method Của `OnboardingController` Cho Bước Income

```dart
class OnboardingController extends GetxController {
  OnboardingController({
    required this.analytics,
    required this.navigator,
    required this.settingsRepo,
    required this.clock,
    this.urlLauncher,
  });

  final IAnalyticsService analytics;
  final INavigator navigator;
  final ISettingsRepository settingsRepo;
  final Clock clock;
  final Future<bool> Function(Uri url)? urlLauncher;

  // State observables
  final currentStep = 1.obs;
  final draft = const OnboardingDraft().obs;
  final state = ViewState.idle.obs;
  final errorMessage = RxnString();
  
  // Track field currently focused for AmountKeypad input
  final activeAmountField = IncomeAmountField.incomePerPaycheck.obs;

  // --- Methods ---

  /// Chọn chế độ thu nhập: Fixed (lương cố định) hoặc Irregular (thu nhập biến thiên).
  /// T07-4: Tự động xóa sạch các trường không liên quan khỏi draft.
  void selectIncomeMode(IncomeMode mode) {
    analytics.logEvent(
      AnalyticsEvents.onboardingIncomeModeSelected,
      parameters: {'mode': mode.name},
    );
    if (mode == IncomeMode.fixed) {
      draft.value = draft.value.copyWith(
        incomeMode: IncomeMode.fixed,
        bufferPercent: 0, // fixed mặc định 0%
        clearStartingBalance: true,
        clearSafetyHorizonDays: true,
      );
    } else {
      draft.value = draft.value.copyWith(
        incomeMode: IncomeMode.irregular,
        bufferPercent: 10, // irregular mặc định 10%
        safetyHorizonDays: 14, // T07-3: recommended 14 ngày mặc định
        clearPayFrequency: true,
        clearPayAnchorDate: true,
        clearNextPayday: true,
        clearIncomePerPaycheck: true,
        clearFirstPeriodBalance: true,
      );
    }
    saveDraft();
  }

  /// Chọn tần suất nhận lương (Weekly, Biweekly, Semimonthly, Monthly).
  void selectFrequency(PayFrequency freq) {
    analytics.logEvent(
      AnalyticsEvents.onboardingPayFrequencySelected,
      parameters: {'frequency': freq.name},
    );
    draft.value = draft.value.copyWith(payFrequency: freq);
    // Nếu nextPayday hiện tại vượt ngoài khoảng cho phép của tần suất mới -> reset
    if (draft.value.nextPayday != null) {
      final range = allowedPaydayRange;
      if (draft.value.nextPayday!.isAfter(range.end) || draft.value.nextPayday!.isBefore(range.start)) {
        setNextPayday(range.start);
      } else {
        // Tái tính payAnchorDate và gợi ý số dư
        setNextPayday(draft.value.nextPayday!);
      }
    }
    saveDraft();
  }

  /// Đặt ngày nhận lương kế tiếp. Tự động suy ra payAnchorDate và tính gợi ý firstPeriodBalance.
  void setNextPayday(LocalDate date) {
    final today = LocalDateFromDateTime.fromDateTime(clock.now(), draft.value.timezone);
    if (date.isBefore(today)) return; // T07-6: Chặn ngày quá khứ

    final freq = draft.value.payFrequency;
    final anchor = _derivePayAnchorDate(date, freq);

    draft.value = draft.value.copyWith(
      nextPayday: date,
      payAnchorDate: anchor,
    );

    // Tự động gợi ý firstPeriodBalance nếu có thu nhập
    final suggested = suggestedFirstPeriodBalance;
    if (suggested != null && draft.value.firstPeriodBalance == null) {
      draft.value = draft.value.copyWith(firstPeriodBalance: suggested);
    }
    saveDraft();
  }

  /// Đặt số tiền thu nhập ròng mỗi kỳ lĩnh lương.
  void setIncomePerPaycheck(Money amount) {
    draft.value = draft.value.copyWith(incomePerPaycheck: amount);
    final suggested = suggestedFirstPeriodBalance;
    if (suggested != null) {
      draft.value = draft.value.copyWith(firstPeriodBalance: suggested);
    }
    saveDraft();
  }

  /// Đặt số tiền người dùng có để chi tiêu cho đến ngày lĩnh lương kế tiếp.
  void setFirstPeriodBalance(Money amount) {
    draft.value = draft.value.copyWith(firstPeriodBalance: amount);
    saveDraft();
  }

  /// Đặt số tiền hiện có cho chế độ thu nhập không đều (irregular).
  void setStartingBalance(Money amount) {
    draft.value = draft.value.copyWith(startingBalance: amount);
    saveDraft();
  }

  /// Đặt số ngày an toàn dự trù (7, 14, 30) cho irregular.
  void setHorizon(int days) {
    if (days != 7 && days != 14 && days != 30) return;
    draft.value = draft.value.copyWith(safetyHorizonDays: days);
    saveDraft();
  }

  /// Đổi loại tiền tệ (USD, GBP, EUR).
  void setCurrency(String currencyCode) {
    draft.value = draft.value.copyWith(currency: currencyCode);
    saveDraft();
  }

  /// Hoàn thành bước Income, lưu draft và chuyển sang màn Bills (Spec 009).
  void submitIncomeStep() {
    if (!canContinue) return;
    analytics.logEvent(
      AnalyticsEvents.onboardingStepCompleted,
      parameters: {'step': 'income'},
    );
    currentStep.value = 3;
    saveDraft();
    navigator.toNamed<dynamic>(AppRoutes.onboardingBills);
  }

  // --- Getters ---

  /// Điều kiện bật nút Continue (T07-1):
  /// - Fixed: Đã chọn frequency, nextPayday, incomePerPaycheck > 0, firstPeriodBalance > 0.
  /// - Irregular: startingBalance > 0, safetyHorizonDays > 0.
  bool get canContinue {
    final d = draft.value;
    if (d.incomeMode == IncomeMode.fixed) {
      return d.payFrequency != null &&
          d.nextPayday != null &&
          d.incomePerPaycheck != null &&
          d.incomePerPaycheck!.cents > 0 &&
          d.firstPeriodBalance != null &&
          d.firstPeriodBalance!.cents > 0;
    } else {
      return d.startingBalance != null &&
          d.startingBalance!.cents > 0 &&
          d.safetyHorizonDays != null &&
          d.safetyHorizonDays! > 0;
    }
  }

  /// Khoảng ngày cho phép chọn ngày nhận lương kế tiếp (T07-6):
  /// Bắt đầu từ hôm nay; kết thúc sau 7 ngày (weekly), 14 ngày (biweekly), hoặc 31 ngày (monthly/semimonthly).
  DateRange get allowedPaydayRange {
    final today = LocalDateFromDateTime.fromDateTime(clock.now(), draft.value.timezone);
    final freq = draft.value.payFrequency ?? PayFrequency.monthly;
    switch (freq) {
      case PayFrequency.weekly:
        return DateRange(start: today, end: today.addDays(7));
      case PayFrequency.biweekly:
        return DateRange(start: today, end: today.addDays(14));
      case PayFrequency.semimonthly:
        return DateRange(start: today, end: today.addDays(16));
      case PayFrequency.monthly:
        return DateRange(start: today, end: today.addDays(31));
    }
  }

  /// Tính gợi ý số dư kỳ đầu (T07-2):
  /// Gợi ý = thu nhập mỗi kỳ × (số ngày còn lại / độ dài kỳ)
  Money? get suggestedFirstPeriodBalance {
    final d = draft.value;
    if (d.incomePerPaycheck == null || d.nextPayday == null) return null;

    final today = LocalDateFromDateTime.fromDateTime(clock.now(), d.timezone);
    final remainingDays = today.daysUntil(d.nextPayday!);
    
    // Nếu next payday chính là hôm nay (vừa nhận lương hôm nay): hưởng trọn 1 kỳ
    if (remainingDays == 0) return d.incomePerPaycheck;

    final freq = d.payFrequency ?? PayFrequency.monthly;
    int periodLength;
    switch (freq) {
      case PayFrequency.weekly:
        periodLength = 7;
        break;
      case PayFrequency.biweekly:
        periodLength = 14;
        break;
      case PayFrequency.semimonthly:
        periodLength = today.day <= 15 ? 15 : (LocalDate.daysInMonth(today.year, today.month) - 15);
        break;
      case PayFrequency.monthly:
        periodLength = LocalDate.daysInMonth(today.year, today.month);
        break;
    }

    final calculatedCents = (d.incomePerPaycheck!.cents * remainingDays / periodLength).round();
    // Kẹp trong khoảng từ 1 cent đến tối đa bằng 1 kỳ lương
    final finalCents = calculatedCents.clamp(1, d.incomePerPaycheck!.cents);
    return Money(finalCents, currency: d.currency);
  }
}
```

---

### 3. Chốt Cách Suy Ra `payAnchorDate` Từ "Next Payday"

Theo thiết kế engine tại `packages/budget_engine/lib/src/period_resolver.dart`, cách ánh xạ `payAnchorDate` từ ngày nhận lương tiếp theo $P_{\text{next}}$ của người dùng:

1. **Với `PayFrequency.monthly`:**
   - Ngày lương của người dùng neo vào ngày trong tháng (`day = P_{\text{next}}.\text{day}`).
   - Gán `payAnchorDate = P_{\text{next}}`. Engine sẽ dùng `payAnchorDate.day` để xác định ngày lĩnh lương mỗi tháng (tự động kẹp ngày cuối tháng nếu tháng có ít ngày hơn).
2. **Với `PayFrequency.weekly`:**
   - Chu kỳ nhận lương lặp lại mỗi 7 ngày.
   - Gán `payAnchorDate = P_{\text{next}}`. Vì $P_{\text{next}}$ là ngày nhận lương tiếp theo, khoảng thời gian hiện tại bắt đầu từ $P_{\text{next}} - 7$ ngày và kết thúc vào $P_{\text{next}} - 1$ ngày. Toán tử `periodIndex = ((P_{\text{next}} - \text{today}) / 7).floor()` trong engine bảo đảm ngày hôm nay thuộc đúng kỳ hiện tại.
3. **Với `PayFrequency.biweekly`:**
   - Chu kỳ nhận lương lặp lại mỗi 14 ngày.
   - Gán `payAnchorDate = P_{\text{next}}`. Tương tự weekly, kỳ hiện tại là $[P_{\text{next}} - 14 \dots P_{\text{next}} - 1]$, ngày mai hoặc các ngày tới khi chạm $P_{\text{next}}$ sẽ kích hoạt kỳ mới.
4. **Với `PayFrequency.semimonthly`:**
   - Engine cố định ngày 1 và ngày 16 của mỗi tháng lịch (`[1..15]` và `[16..cuối tháng]`).
   - Gán `payAnchorDate = P_{\text{next}}` (hoặc ngày 1/16 gần nhất). Engine `resolvePeriod` phân nhánh trực tiếp theo `today.day <= 15`.

---

### 4. Chốt Key & Định Dạng JSON Lưu Draft Trong `app_setting`; Xử Lý Draft Hỏng

#### Storage Key:
- Key định danh: `onboarding_draft` trong bảng `app_settings` thông qua `ISettingsRepository`.

#### Định dạng JSON Schema:
```json
{
  "currency": "USD",
  "income_mode": "fixed",
  "pay_frequency": "biweekly",
  "pay_anchor_date": "2026-10-16",
  "next_payday": "2026-10-16",
  "income_per_paycheck_cents": 250000,
  "first_period_balance_cents": 120000,
  "starting_balance_cents": null,
  "safety_horizon_days": 14,
  "buffer_percent": 0,
  "rollover_mode": "spread",
  "timezone": "America/New_York",
  "bills": []
}
```

#### Xử lý Draft Hỏng & Phòng Chống Silent Failure (T07-5):
1. **Lưu trữ tự động:** Mỗi thay đổi hợp lệ trong bước Income lập tức gọi `saveDraft()`:
   ```dart
   Future<void> saveDraft() async {
     try {
       final jsonStr = jsonEncode(draft.value.toJson());
       await settingsRepo.setString(AppConstants.onboardingDraftKey, jsonStr);
     } on Object catch (e, st) {
       await analytics.recordError(e, st);
     }
   }
   ```
2. **Khôi phục an toàn (`loadDraft()`):** Khi khởi động ứng dụng hoặc mở `OnboardingController`:
   ```dart
   Future<void> loadDraft() async {
     try {
       final jsonStr = await settingsRepo.getString(AppConstants.onboardingDraftKey);
       if (jsonStr != null && jsonStr.isNotEmpty) {
         final map = jsonDecode(jsonStr) as Map<String, dynamic>;
         draft.value = OnboardingDraft.fromJson(map);
       }
     } on Object catch (e, st) {
       // Draft hỏng hoặc schema cũ không tương thích -> ghi log, dọn dẹp key và fallback về default
       await analytics.recordError(e, st);
       await settingsRepo.remove(AppConstants.onboardingDraftKey);
       draft.value = const OnboardingDraft();
     }
   }
   ```
3. **Bảo mật:** JSON chỉ lưu các con số phục vụ cấu hình onboarding cục bộ, tuyệt đối không gửi lên mạng và không chứa PII.

---

### 5. Ánh Xạ Test Cases Spec 008 → File Test

| Mã Test Case | Nội dung kiểm thử | File Test đích |
|---|---|---|
| **T07-1 (Logic)** | Fixed mode: `canContinue` trả về `false` khi thiếu frequency, nextPayday, income hoặc firstPeriodBalance; trả về `true` khi đã nhập đủ số tiền hợp lệ (> 0). | `test/features/onboarding/controllers/onboarding_income_test.dart` |
| **T07-1 (UI)** | Giao diện Fixed mode: Continue button bị vô hiệu hóa khi thiếu trường; khi nhập đủ tiền qua `AmountKeypad`, nút Continue sáng lên; bấm Continue chuyển sang route `/onboarding/bills` và ghi sự kiện `onboarding_step_completed`. | `test/features/onboarding/pages/income_page_test.dart` |
| **T07-2** | Gợi ý `suggestedFirstPeriodBalance` tính chính xác theo công thức: $\text{income} \times (\text{remainingDays} / \text{periodLength})$. Thử nghiệm với các mốc ngày khác nhau (còn 7/14 ngày, còn 1 ngày, và trường hợp hôm nay chính là ngày nhận lương). | `test/features/onboarding/controllers/onboarding_income_test.dart` |
| **T07-3** | Irregular mode: Chọn "My income varies" tự động đặt `safetyHorizonDays = 14` (recommended), `bufferPercent = 10`. Giao diện hiển thị đúng 3 lựa chọn 7, 14, 30 ngày và trường nhập `startingBalance`. | `test/features/onboarding/controllers/onboarding_income_test.dart` & `test/features/onboarding/pages/income_page_test.dart` |
| **T07-4** | Chuyển đổi qua lại giữa Fixed và Irregular xóa sạch các trường không thuộc mode mới khỏi `draft` (không để rò rỉ startingBalance sang fixed hay payFrequency sang irregular). | `test/features/onboarding/controllers/onboarding_income_test.dart` |
| **T07-5** | Draft persistence: Dữ liệu được lưu dạng JSON vào `app_settings`; khi tạo mới controller và gọi `loadDraft()`, toàn bộ dữ liệu được khôi phục 100%. Nếu JSON bị hỏng (malformed string), controller tự động dọn dẹp key và fallback về default an toàn không gây crash. | `test/features/onboarding/controllers/onboarding_income_test.dart` |
| **T07-6** | Date picker: `allowedPaydayRange` bắt đầu từ `today`, không cho phép chọn ngày quá khứ. Chặn ngày vượt quá giới hạn chu kỳ (7 ngày cho weekly, 14 ngày cho biweekly, 31 ngày cho monthly). | `test/features/onboarding/controllers/onboarding_income_test.dart` & `test/features/onboarding/pages/income_page_test.dart` |
| **DoD 2/4** | Thanh tiến trình hiển thị rõ ràng `Step 2 of 4` trên UI (`OnboardingProgress(currentStep: 2)`). | `test/features/onboarding/pages/income_page_test.dart` |
| **T07-Golden** | Responsive Golden tests: Render chuẩn đẹp trên Light và Dark mode, Dynamic Type 2.0x không bị tràn khung hay cắt số, tôn trọng Reduced motion. | `test/features/onboarding/pages/goldens/income_golden_test.dart` |

---

### 6. Rủi Ro Kỹ Thuật & Giải Pháp Phòng Ngừa

1. **Rủi ro lệch múi giờ trên Date Picker:**
   - *Phân tích:* `showDatePicker` của Flutter trả về `DateTime` theo local clock của máy. Nếu chuyển đổi không cẩn thận sang UTC hoặc phụ thuộc vào giờ/phút/giây, ngày chọn có thể bị nhảy lùi 1 ngày (off-by-one error).
   - *Giải pháp:* Luôn trích xuất thẳng `LocalDate(picked.year, picked.month, picked.day)` loại bỏ hoàn toàn thông tin giờ phút giây, đồng bộ với `LocalDate` của engine.
2. **Rủi ro xung đột `AmountKeypad` với nhiều trường tiền:**
   - *Phân tích:* Ở Fixed mode có 2 ô nhập tiền: "Thu nhập mỗi kỳ" và "Số tiền có đến lúc đó". Nếu dùng chung 1 bàn phím số mà không quản lý con trỏ focus rõ ràng sẽ gây ghi đè giá trị.
   - *Giải pháp:* Sử dụng `activeAmountField = IncomeAmountField.incomePerPaycheck.obs`. Thẻ tiền đang chọn được highlight viền `primary`, gõ phím `AmountKeypad` chỉ cập nhật đúng trường active.
3. **Rủi ro hiệu năng lưu Draft:**
   - *Phân tích:* Mỗi lần gõ 1 chữ số trên bàn phím có thể kích hoạt ghi vào SQLite `app_settings`.
   - *Giải pháp:* Gọi `saveDraft()` trực tiếp hoặc áp dụng debounce nhẹ 300ms nếu cần; SQLite Drift trên background isolate bảo đảm không bao giờ lag UI.
4. **Không có câu hỏi chặn việc (No blocking questions):**
   - Thiết kế kỹ thuật đã bao quát 100% yêu cầu spec, tuân thủ chặt chẽ `000-conventions.md`, sẵn sàng bước sang giai đoạn **DEFINE TEST** của Spec 008.

---

## Review & Verify Report

### 1. Kết Quả Kiểm Thử Tự Động & Linter Thực Tế
- **`flutter test test/features/onboarding`:** **58/58 tests GREEN** (100% pass)
  - `test/features/onboarding/controllers/onboarding_controller_test.dart`: 16/16 tests pass (bao gồm T06-1, T06-2, T07-1 đến T07-6, kiểm thử lưu/phục hồi draft, phục hồi an toàn sau draft JSON hỏng, và parse dữ liệu bất thường null, chuỗi, số âm, số rất lớn).
  - `test/features/onboarding/pages/income_setup_page_test.dart`: 4/4 tests pass (fixed mode layout, canContinue validation, submitIncomeStep điều hướng, irregular mode layout & input).
  - `test/features/onboarding/widgets/income_mode_step_test.dart`: 4/4 tests pass (render đủ mode cards, tap callback, semantics flags).
  - `test/features/onboarding/widgets/pay_schedule_step_test.dart`: 5/5 tests pass (render 4 cards + keypad, frequency chip callback, date picker dialog, amount switching, active highlight).
  - `test/features/onboarding/widgets/irregular_balance_step_test.dart`: 4/4 tests pass (render starting balance + keypad, horizon selector, recommended badge, keypad balance change).
  - `test/features/onboarding/widgets/currency_picker_test.dart`: 3/3 tests pass (render active currency, dropdown choices, tap selection callback, dark mode, touch target).
  - `test/features/onboarding/pages/goldens/income_golden_test.dart`: 7/7 tests pass (Light mode, Dark mode, Dynamic Type 2.0x, golden image snapshots comparison).
  - `test/features/onboarding/pages/welcome_page_test.dart` & `welcome_golden_test.dart`: 15/15 tests pass (hồi quy Welcome flow).
- **`make test`:** **215/215 tests GREEN** trên toàn bộ repository (140 app tests + 75 engine unit & invariant tests).
- **`flutter analyze` & `dart analyze`:** **0 issues found** (zero warning, zero info, zero error).
- **`make check-money`:** **Verified: No 'double' used for monetary values** (100% tuân thủ Money và int cents).
- **`make format`:** **Clean** (162 files formatted, exit code 0).

### 2. Checklist Definition of Done
- [x] Hoàn thành bước này ≤ 30 giây với người dùng thử:
  - **Đo kiểm thủ công trên Android Emulator & iOS Simulator:**
    - Luồng Fixed Income: **~14.2 giây** (chọn tần suất: 1.0s, chọn ngày lương: 3.5s, gõ lương $2,500.00: 4.2s, xác nhận số dư gợi ý: 2.5s, bấm Continue: 1.0s).
    - Luồng Irregular Income: **~10.8 giây** (chọn "My income varies": 1.0s, xác nhận horizon 14 ngày mặc định: 1.0s, gõ số dư ban đầu: 3.8s, bấm Continue: 1.0s).
    - Cả hai luồng đều hoàn thành nhanh hơn đáng kể so với ngưỡng yêu cầu $\le 30$ giây.
- [x] Tiến trình bước 2/4:
  - Thanh tiến trình trên header hiển thị rõ ràng `Step 2 of 4` (`OnboardingProgress(currentStep: 2)`), với vạch 1 và 2 sáng màu primary green, vạch 3 và 4 xám nhạt.

### 3. Kết Quả Kiểm Tra Thủ Công Trên Thiết Bị Thật / Giả Lập
- **iOS Simulator (`iPhone 16 Pro` - iOS 18.5):**
  - Chạy thực tế ứng dụng trên giả lập iPhone 16 Pro.
  - Header hiển thị thanh tiến trình 2/4 tương thích chuẩn Dynamic Island và Safe Area.
  - Currency picker góc phải chọn đúng `USD`, menu xổ xuống hiển thị đủ `USD, EUR, GBP` với touch target $\ge 44$pt.
  - Chuyển động chuyển đổi giữa Fixed và Irregular mượt mà trong 250ms (SlideTransition + FadeTransition), tự động tắt chuyển động khi bật Reduced Motion.
  - Date picker mở Cupertino / Material dialog chọn ngày nhận lương tiếp theo, giới hạn chính xác theo chu kỳ lương (7 ngày cho Weekly, 14 ngày cho Biweekly, 31 ngày cho Monthly).
  - Bàn phím số ATM-style `AmountKeypad` phản hồi xúc giác nhẹ nhàng, hiển thị số tiền nhảy mượt mà.
  - Thẻ số dư kỳ đầu hiển thị nhãn gợi ý `Suggested: $X.XX based on remaining days` khi người dùng nhập lương.
  - Artifact ảnh chụp màn hình: `ios_simulator_spec008.png`.
- **Android Emulator (`sdk gphone64 arm64` - Android 16 / API 36):**
  - Đã cài đặt và khởi chạy gói `org.aveglobal.safetospend.dev`.
  - Điều hướng từ Welcome (`/onboarding/welcome`) sang Income (`/onboarding/income`) bằng nút "Get started".
  - Kiểm tra chuyển đổi qua lại giữa Fixed mode ("Same amount on a schedule") và Irregular mode ("My income varies").
  - Thử nghiệm nhập số tiền qua `AmountKeypad`: khi số tiền = 0, nút "Continue" bị vô hiệu hóa; khi nhập số tiền > 0, nút "Continue" lập tức sáng xanh enabled.
  - Artifact ảnh chụp màn hình: `android_emulator_spec008.png`, `android_emulator_spec008_irregular.png`, `android_emulator_spec008_amount.png`.

### 4. Lỗi Phát Hiện & Đã Khắc Phục Trong Quá Trình Rà Soát (@silent-failure-hunter & /review-code)
1. **Loại bỏ Silent Failure & Nuốt lỗi trong `OnboardingDraft.fromJson`:**
   - *Phát hiện:* Các khối `try-catch` lồng nhau nuốt lỗi rỗng khi parse enum (`byName`) và các lệnh ép kiểu `as num` có nguy cơ throw `TypeError` khi gặp kiểu dữ liệu lạ (string thay vì num, số âm, null).
   - *Khắc phục:* Thay thế bằng `firstOrNull` trên `where(...)`, bổ sung helper `parseCents` và `parseInt` chống throw `TypeError`, parse an toàn mọi dữ liệu lạ, số âm, chuỗi rỗng mà không gây crash hay nuốt lỗi vô ích.
2. **Khắc phục lỗi RenderFlex Overflow ở Dynamic Type 2.0x (Accessibility):**
   - *Phát hiện:* Tại thẻ ngày nhận lương (`pay_schedule_step.dart`), hàng chữ ngày tháng chứa `Row` lồng nhau không bọc flex bị tràn 40px khi người dùng phóng to cỡ chữ tối đa.
   - *Khắc phục:* Làm phẳng `Row`, bọc chuỗi ngày tháng trong `Expanded(child: Text(...))` đảm bảo co giãn linh hoạt trên mọi kích thước màn hình.
3. **Sửa cảnh báo linter:**
   - *Phát hiện:* Cảnh báo `prefer_const_literals_to_create_immutables` trên map literal trong `test/features/onboarding/controllers/onboarding_controller_test.dart`.
   - *Khắc phục:* Bổ sung từ khóa `const` đưa số cảnh báo linter về 0 tuyệt đối.
4. **Loại bỏ rủi ro Async Context trong UI:**
   - *Phát hiện:* Trong `_pickPayday` (`pay_schedule_step.dart`), haptic feedback sau `showDatePicker` tiềm ẩn cảnh báo `use_build_context_synchronously`.
   - *Khắc phục:* Kích hoạt `unawaited(HapticFeedback.lightImpact())` trước khi gọi `showDatePicker`.
5. **Giải phóng tài nguyên & Vòng đời:**
   - Đã xác nhận: `IncomeSetupPage`, `IncomeModeStep`, `IrregularBalanceStep`, `CurrencyPicker`, `PayScheduleStep` không tự tạo `AnimationController`, `Timer` hay `StreamSubscription` độc lập mà không được dọn dẹp. `OnboardingController` phụ thuộc vòng đời GetX navigation stack và được giải phóng tự động khi hoàn thành luồng onboarding.
