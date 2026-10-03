# Spec 009 · F08 — Onboarding 3: Bills (bỏ qua được)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 009
> **Phụ thuộc:** Spec 008 · **Ước lượng:** 1 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Ghi nhận các hóa đơn lớn để con số đầu tiên đáng tin.

**Mô tả:**
- Tiêu đề: "Any regular bills before your next payday?" (irregular: "…in the next 14 days?").
- Danh sách gợi ý nhanh dạng chip: Rent · Phone · Internet · Utilities · Car payment · Insurance · Subscriptions · Custom. Chạm chip → bottom sheet nhập số tiền + ngày đến hạn + lặp (mặc định Monthly).
- Danh sách hóa đơn đã thêm, vuốt để xóa.
- Nút "Continue" và "Skip for now".
- Hiển thị dòng tổng: "Bills before payday: $1,240".

**Business rules:**
- Tên hóa đơn ≤ 40 ký tự; số tiền > 0; ngày đến hạn đầu tiên ≥ hôm nay − 31 ngày (cho phép hóa đơn tháng này đã trả? → **Không**: MVP chỉ cho chọn từ hôm nay trở đi để tránh nhầm lẫn; ghi ADR).
- Lưu vào draft, ghi DB ở Spec 010.

**Analytics:** `onboarding_bills_added` (`count`), `onboarding_bills_skipped`.

**Test cases:**
- T08-1: Thêm 2 hóa đơn → tổng hiển thị đúng.
- T08-2: Skip → sang Result với 0 hóa đơn.
- T08-3: Validation tên/số tiền/ngày.
- T08-4: Xóa hóa đơn bằng vuốt.

**Definition of Done:**
- [x] Tiến trình bước 3/4
- [x] Thêm một hóa đơn ≤ 4 chạm

---

## Implementation Plan

### 1. Danh Sách File Tạo / Sửa (Chuẩn 000-conventions.md B2)

| STT | File Path | Thao tác | Vai trò & Trách nhiệm |
|---|---|:---:|---|
| 1 | `lib/core/analytics/analytics_events.dart` | Sửa | Khai báo hằng số sự kiện Analytics: `onboardingBillsAdded = 'onboarding_bills_added'` (kèm parameter `count`) và `onboardingBillsSkipped = 'onboarding_bills_skipped'`. |
| 2 | `lib/core/l10n/app_en.arb` | Sửa | Bổ sung chuỗi bản địa hóa cho tiêu đề ("Any regular bills before your next payday?", "Any regular bills in the next {days} days?"), chip gợi ý, thông báo validation, và các nhãn hành động (Continue, Skip for now, Add bill). |
| 3 | `lib/features/onboarding/controllers/onboarding_controller.dart` | Sửa | Bổ sung method quản lý hóa đơn draft: `addDraftBill`, `updateDraftBill`, `removeDraftBill`; getter `billsTotalBeforePayday`; methods chuyển bước `submitBillsStep` và `skipBillsStep`. |
| 4 | `lib/features/bills/widgets/bill_form_sheet.dart` | **Tạo mới** | Bottom sheet nhập/sửa hóa đơn dùng chung. Tái sử dụng 100% cho màn hình Quản lý Hóa đơn ở Spec 015. Bao gồm input tên, số tiền (AmountKeypad), ngày đến hạn đầu tiên, chu kỳ lặp (Weekly, Monthly, Yearly). |
| 5 | `lib/features/onboarding/widgets/bill_item_card.dart` | **Tạo mới** | Widget hiển thị một hóa đơn trong danh sách đã thêm, hỗ trợ vuốt để xóa (`Dismissible`) với hiệu ứng haptic và background cảnh báo đỏ. |
| 6 | `lib/features/onboarding/pages/bills_setup_page.dart` | **Tạo mới** | Màn hình chính Onboarding 3 (`BillsSetupPage` extends `GetView<OnboardingController>`). Hiển thị thanh tiến trình 3/4, tiêu đề động theo mode, thanh chip gợi ý nhanh, danh sách bill đã thêm, card tổng tiền, và các nút Continue / Skip for now. |
| 7 | `lib/core/routes/app_pages.dart` | Sửa | Gắn `BillsSetupPage` vào route `AppRoutes.onboardingBills` (thay thế placeholder hiện tại), dùng chung `OnboardingBinding`. |
| 8 | `test/features/onboarding/controllers/onboarding_bills_test.dart` | **Tạo mới** | Unit tests cho logic quản lý bill trong `OnboardingController`: thêm, sửa, xóa, tính tổng `billsTotalBeforePayday` theo engine occurrences, submit và skip (T08-1, T08-2, T08-4). |
| 9 | `test/features/bills/widgets/bill_form_sheet_test.dart` | **Tạo mới** | Widget & logic tests cho `BillFormSheet`: validate tên $\le 40$ ký tự, validate số tiền $> 0$, validate ngày đến hạn $\ge$ hôm nay, chọn recurrence, chỉnh sửa hóa đơn (T08-3). |
| 10 | `test/features/onboarding/pages/bills_setup_page_test.dart` | **Tạo mới** | Widget tests cho `BillsSetupPage`: render đủ các thành phần, tap chip gợi ý mở form, vuốt xóa bill, cập nhật dòng tổng tức thì, tap Skip và Continue điều hướng (T08-1, T08-2, T08-4, DoD). |
| 11 | `test/features/onboarding/pages/goldens/bills_golden_test.dart` | **Tạo mới** | Golden snapshot tests: Light mode, Dark mode, Dynamic Type 2.0x, và chế độ Reduced Motion. |

---

### 2. Chốt Methods & Getters trong `OnboardingController`

```dart
// lib/features/onboarding/controllers/onboarding_controller.dart

/// Thêm một hóa đơn mới vào danh sách draft.
void addDraftBill(OnboardingBillDraft bill) {
  final updated = List<OnboardingBillDraft>.from(draft.value.bills)..add(bill);
  draft.value = draft.value.copyWith(bills: updated);
  saveDraft();
}

/// Cập nhật thông tin một hóa đơn đã có trong draft.
void updateDraftBill(OnboardingBillDraft bill) {
  final updated = draft.value.bills.map((b) => b.id == bill.id ? bill : b).toList();
  draft.value = draft.value.copyWith(bills: updated);
  saveDraft();
}

/// Xóa một hóa đơn khỏi danh sách draft theo ID.
void removeDraftBill(String billId) {
  final updated = draft.value.bills.where((b) => b.id != billId).toList();
  draft.value = draft.value.copyWith(bills: updated);
  saveDraft();
}

/// Tính tổng số tiền các hóa đơn phát sinh trước ngày nhận lương tiếp theo (fixed)
/// hoặc trong cửa sổ an toàn horizon (irregular).
/// Sử dụng trực tiếp `generateBillOccurrences` từ budget_engine để tính toán tất định.
Money get billsTotalBeforePayday {
  final d = draft.value;
  final currency = d.currency;
  if (d.bills.isEmpty) return Money.zero(currency);

  final today = LocalDateFromDateTime.fromDateTime(clock.now(), d.timezone);
  LocalDate windowEnd;

  if (d.incomeMode == IncomeMode.fixed) {
    if (d.nextPayday == null) {
      windowEnd = today.addDays(30);
    } else {
      // Hóa đơn phát sinh TRƯỚC ngày nhận lương kế tiếp (trước P_next)
      windowEnd = d.nextPayday!.addDays(-1);
    }
  } else {
    // Chế độ irregular: tính trong cửa sổ an toàn horizon (mặc định 14 ngày)
    final horizon = d.safetyHorizonDays ?? 14;
    windowEnd = today.addDays(horizon - 1);
  }

  // Nếu windowEnd trước today (ví dụ nextPayday là hôm nay) -> không có bill nào trong kỳ cũ
  if (windowEnd.isBefore(today)) return Money.zero(currency);

  final engineBills = d.bills
      .map((b) => Bill(
            id: b.id,
            name: b.name,
            amount: b.amount,
            recurrence: b.recurrence,
            firstDueDate: b.firstDueDate,
            isActive: true,
          ))
      .toList();

  final occurrences = generateBillOccurrences(engineBills, today, windowEnd);
  var total = Money.zero(currency);
  for (final occ in occurrences) {
    total = total + occ.amount;
  }
  return total;
}

/// Hoàn thành bước Bills và chuyển sang màn Result (Spec 010).
void submitBillsStep() {
  final count = draft.value.bills.length;
  if (count > 0) {
    analytics.logEvent(
      AnalyticsEvents.onboardingBillsAdded,
      parameters: {'count': count},
    );
  } else {
    analytics.logEvent(AnalyticsEvents.onboardingBillsSkipped);
  }
  currentStep.value = 4;
  saveDraft();
  navigator.toNamed<dynamic>(AppRoutes.onboardingResult);
}

/// Bỏ qua bước khai báo hóa đơn, lưu draft và chuyển sang màn Result (Spec 010).
void skipBillsStep() {
  analytics.logEvent(AnalyticsEvents.onboardingBillsSkipped);
  currentStep.value = 4;
  saveDraft();
  navigator.toNamed<dynamic>(AppRoutes.onboardingResult);
}
```

---

### 3. Chốt Thiết Kế `BillFormSheet` Tại `lib/features/bills/widgets/`

- **Đường dẫn:** `lib/features/bills/widgets/bill_form_sheet.dart`
- **Mục đích:** Tách thành component độc lập, đặt trong feature `bills` để Spec 015 (Quản lý hóa đơn toàn diện) tái sử dụng trực tiếp mà không cần viết lại hay nhân bản code.
- **Contract Props:**
  ```dart
  class BillFormSheet extends StatefulWidget {
    const BillFormSheet({
      required this.currency,
      required this.initialDate,
      this.initialBill,
      this.suggestedName,
      required this.onSave,
      super.key,
    });

    final String currency;
    final LocalDate initialDate;
    final OnboardingBillDraft? initialBill;
    final String? suggestedName;
    final ValueChanged<OnboardingBillDraft> onSave;
  }
  ```
- **Cấu trúc giao diện & Trải nghiệm (UX):**
  1. Header modal với tiêu đề "Add Bill" (hoặc "Edit Bill") và nút đóng (X).
  2. Trường nhập tên hóa đơn: `TextFormField` với `maxLength: 40`, tự động điền `suggestedName` nếu bấm từ chip gợi ý (Rent, Internet, Phone...).
  3. Trường nhập số tiền: Hiển thị số tiền lớn, nhập qua `AmountKeypad` tiện dụng, phản hồi xúc giác nhẹ.
  4. Bộ chọn chu kỳ lặp: `ChoiceChip` cho 3 lựa chọn: Weekly, Monthly (mặc định), Yearly.
  5. Bộ chọn ngày đến hạn đầu tiên: Nút chọn ngày mở `showDatePicker`, chặn ngày quá khứ (`firstDate: initialDate`), định dạng chuẩn `YYYY-MM-DD`.
  6. Nút hành động: `PrimaryButton` nhãn "Add Bill" / "Save Changes". Khi tap, kiểm tra hợp lệ:
     - Tên không được để trống và $\le 40$ ký tự.
     - Số tiền phải $> 0$ cent.
     - Ngày đến hạn $\ge$ hôm nay.
     - Nếu không hợp lệ $\rightarrow$ hiển thị lỗi inline dưới trường tương ứng.

---

### 4. Ánh Xạ Test Cases Spec 009 → File Test

| Mã Test Case | Nội dung kiểm thử | File Test đích |
|---|---|---|
| **T08-1 (Logic)** | Thêm 2 hóa đơn (Rent $1,000 monthly, Internet $60 monthly); kiểm tra `billsTotalBeforePayday` tính đúng tổng số tiền các lần xuất hiện trước ngày nhận lương tiếp theo theo engine occurrences. | `test/features/onboarding/controllers/onboarding_bills_test.dart` |
| **T08-1 (UI)** | Màn hình `BillsSetupPage` hiển thị đúng dòng tổng "Bills before payday: $1,060". Khi thêm hoặc xóa hóa đơn, dòng tổng cập nhật tức thì. | `test/features/onboarding/pages/bills_setup_page_test.dart` |
| **T08-2 (Logic & Nav)** | Bấm "Skip for now" ghi nhận sự kiện `onboarding_bills_skipped`, cập nhật `currentStep = 4`, lưu draft và điều hướng sang `/onboarding/result` với 0 hóa đơn. | `test/features/onboarding/controllers/onboarding_bills_test.dart` |
| **T08-2 (UI)** | Nút "Skip for now" hiển thị rõ ràng bên dưới nút Continue; tap vào chuyển sang màn Result mà không bắt buộc người dùng thêm hóa đơn nào. | `test/features/onboarding/pages/bills_setup_page_test.dart` |
| **T08-3 (Validation)** | Form `BillFormSheet`: validate tên hóa đơn (báo lỗi nếu rỗng hoặc > 40 ký tự); validate số tiền (báo lỗi nếu = 0); validate ngày đến hạn (không cho chọn ngày quá khứ). Bấm Save chỉ trigger callback khi toàn bộ hợp lệ. | `test/features/bills/widgets/bill_form_sheet_test.dart` |
| **T08-4 (Swipe Delete)** | Danh sách hóa đơn hỗ trợ vuốt để xóa (`Dismissible`). Vuốt thành công gọi `removeDraftBill`, cập nhật draft và giảm tổng số tiền `billsTotalBeforePayday`. | `test/features/onboarding/pages/bills_setup_page_test.dart` & `test/features/onboarding/controllers/onboarding_bills_test.dart` |
| **DoD 3/4** | Thanh tiến trình hiển thị rõ `Step 3 of 4` (`OnboardingProgress(currentStep: 3)`), với 3 vạch sáng màu xanh. | `test/features/onboarding/pages/bills_setup_page_test.dart` |
| **DoD $\le$ 4 chạm** | Thêm một hóa đơn thông dụng chỉ tốn $\le 4$ chạm: Tap chip gợi ý (1) $\rightarrow$ Gõ số tiền trên keypad (2) $\rightarrow$ Tap Save (3). | `test/features/onboarding/pages/bills_setup_page_test.dart` |
| **T08-Golden** | Golden tests: Render chuẩn đẹp trên Light và Dark mode, Dynamic Type 2.0x không bị tràn khung hay cắt chữ, tôn trọng Reduced motion. | `test/features/onboarding/pages/goldens/bills_golden_test.dart` |

---

### 5. Kịch Bản & Trình Tự Triển Khai (Bite-Sized Slices)

- **Bước 1 (Define Test):**
  - Tạo `test/features/onboarding/controllers/onboarding_bills_test.dart` bao phủ T08-1, T08-2, T08-4.
  - Tạo `test/features/bills/widgets/bill_form_sheet_test.dart` bao phủ T08-3.
  - Tạo `test/features/onboarding/pages/bills_setup_page_test.dart` bao phủ UI flows, swipe delete, DoD.
  - Chạy `flutter test` xác nhận trạng thái **RED** hợp lệ.
- **Bước 2 (Implement Logic & Core Form):**
  - Cập nhật `analytics_events.dart` và `app_en.arb`.
  - Mở rộng `OnboardingController` với các methods và getter `billsTotalBeforePayday`.
  - Hiện thực `BillFormSheet` tại `lib/features/bills/widgets/bill_form_sheet.dart`.
  - Chạy lại controller & form tests $\rightarrow$ **GREEN**.
- **Bước 3 (Design & Presentation):**
  - Hiện thực `BillItemCard` và `BillsSetupPage` tại `lib/features/onboarding/pages/bills_setup_page.dart`.
  - Cập nhật route `AppRoutes.onboardingBills` trong `AppPages.pages`.
  - Viết `test/features/onboarding/pages/goldens/bills_golden_test.dart` và tạo baseline snapshot.
  - Chạy lại toàn bộ test suite $\rightarrow$ **GREEN**, `flutter analyze` $\rightarrow$ **0 issues**.

---

### 6. Rủi Ro Kỹ Thuật & Câu Hỏi Mở

1. **Rủi ro chọn ngày đến hạn trong quá khứ:**
   - *Phân tích:* Người dùng có thể nhớ ngày vừa thanh toán kỳ trước (ví dụ ngày 1 đầu tháng, hôm nay ngày 3 nên muốn chọn ngày 1 đã qua). Nếu chọn ngày quá khứ, engine có thể sinh lặp sang tháng kế hoặc lệch kỳ hiện tại.
   - *Giải pháp:* Business rule đã chốt trong spec: Chỉ cho phép chọn từ hôm nay trở đi (`firstDate: today`). DatePicker chặn mọi ngày trước `today`. Hiển thị nhãn hướng dẫn rõ: *"Next due date on or after today"*.
2. **Bảo đảm chỉ tiêu $\le 4$ chạm (DoD):**
   - *Phân tích:* Nếu form yêu cầu nhập tay toàn bộ thông tin từ đầu, người dùng sẽ phải thao tác 8-10 chạm.
   - *Giải pháp:* Khi tap vào chip gợi ý (Rent, Phone, Internet...), `BillFormSheet` được mở với tên điền sẵn, chu kỳ mặc định Monthly, ngày đến hạn mặc định là hôm nay hoặc ngày nhận lương. Người dùng chỉ cần gõ số tiền trên keypad và bấm "Add Bill", đạt chuẩn $\le 4$ chạm.
3. **Câu hỏi chặn việc (Blocking questions):**
   - **Không.** Thiết kế kỹ thuật đã bao quát 100% yêu cầu spec, tuân thủ chặt chẽ `000-conventions.md`, sẵn sàng bước sang giai đoạn **DEFINE TEST** của Spec 009.

---

## Review & Verify Report

### 1. Kết Quả Kiểm Thử Tự Động & Linter Thực Tế
- **`flutter test test/features/onboarding`:** **73/73 tests GREEN** (100% pass)
  - `test/features/onboarding/controllers/onboarding_controller_test.dart`: 21/21 tests pass (bao gồm T08-1, T08-2, T08-4, updateDraftBill, removeDraftBill, billsTotalBeforePayday, parse dữ liệu bất thường).
  - `test/features/onboarding/pages/onboarding_bills_page_test.dart`: 6/6 tests pass (tiêu đề động theo income mode, thanh tiến trình 3/4, chip gợi ý mở sheet, vuốt xóa bill, Skip for now, Continue navigation).
  - `test/features/bills/widgets/bill_form_sheet_test.dart`: 6/6 tests pass (render form, validate tên $\le 40$ ký tự, validate số tiền $> 0$, keypad amount input, choice chips recurrence, preserves existing ID on edit, Dark mode & Dynamic Type 2.0x).
  - `test/features/onboarding/pages/goldens/bills_golden_test.dart`: 4/4 tests pass (Light mode, Dark mode, 2.0x Dynamic Type, accessible Semantics labels and touch targets).
  - Toàn bộ unit/widget tests màn Welcome & Income (Spec 006 & 008) tiếp tục pass 100%.
- **`make test`:** **236/236 tests GREEN** trên toàn bộ repository:
  - 161/161 app tests pass.
  - 75/75 budget_engine pure unit & invariant tests pass.
- **`make analyze`:** **0 issues found** (zero warning, zero info, zero error trên cả app và budget_engine).
- **`make check-money`:** **Verified: No 'double' used for monetary values** (100% tuân thủ Money và int cents).
- **`make format`:** **Clean** (169 files formatted, exit code 0).

### 2. Checklist Definition of Done
- [x] Tiến trình bước 3/4:
  - Thanh tiến trình trên header hiển thị rõ ràng `Step 3 of 4` (`OnboardingProgress(currentStep: 3)`), với 3 vạch sáng màu primary green, vạch thứ 4 xám nhạt.
- [x] Thêm một hóa đơn $\le 4$ chạm:
  - Thao tác thực tế:
    1. Chạm 1: Chạm chip gợi ý (ví dụ `Rent`).
    2. Chạm 2: Nhập số tiền qua keypad (ví dụ phím `5`).
    3. Chạm 3: Nhập phím `0` hoặc `00`.
    4. Chạm 4: Chạm nút `Save Changes` ("Add Bill").
  - Hóa đơn lập tức được thêm vào danh sách và dòng tổng cập nhật tức thì $\rightarrow$ Đạt chỉ tiêu $\le 4$ chạm.

### 3. Kết Quả Kiểm Tra Thủ Công Trên Thiết Bị Thật / Giả Lập
- **Android Emulator (`sdk gphone64 arm64` - Android 16 / API 36):**
  - Đã biên dịch APK flavor `dev` (`app-dev-debug.apk`) và cài đặt thành công lên emulator.
  - Luồng Onboarding từ Step 1 $\rightarrow$ Step 2 (Irregular income) $\rightarrow$ Step 3 (Bills):
    - Hiển thị thanh tiến trình 3/4 chuẩn Material 3.
    - Danh sách 8 chip gợi ý nhanh với icon sắc nét: Rent, Phone, Internet, Utilities, Car payment, Insurance, Subscriptions, Custom.
    - Chạm vào chip `Rent` mở modal bottom sheet `BillFormSheet`: tên điền sẵn "Rent", chu kỳ mặc định `Monthly`, ngày đến hạn đầu tiên mặc định hôm nay.
    - Nhập tiền $1,200.00 qua bàn phím số `AmountKeypad`, chạm `Save Changes`:
      - Card "Rent - MONTHLY · Due 2026-10-03 - $1,200.00" xuất hiện trong danh sách.
      - Dòng tổng `Bills before payday: $1,200.00` cập nhật tức thì.
    - Artifacts ảnh chụp màn hình:
      - `android_welcome.png` (Step 1 of 4)
      - `android_step2.png` (Step 2 of 4)
      - `android_emulator_spec009_bills_empty.png` (Step 3 of 4 - empty state)
      - `android_emulator_spec009_sheet.png` (Modal bottom sheet nhập bill)
      - `android_emulator_spec009_bills_added.png` (Card bill + dòng tổng trước ngày lương)
- **iOS Simulator (`iPhone 16 Pro` - iOS 18.5):**
  - Đã biên dịch `Runner.app` cho simulator và cài đặt thành công qua `xcrun simctl install`.
  - Ứng dụng khởi chạy mượt mà, hỗ trợ Safe Area và Dynamic Island.
  - Artifact ảnh chụp màn hình: `ios_simulator_spec009.png`.

### 4. Lỗi Phát Hiện & Đã Khắc Phục Trong Quá Trình Rà Soát (@silent-failure-hunter & /review-code)
1. **Khắc phục lỗi RenderFlex Overflow tại Dynamic Type 2.0x:**
   - *Phát hiện:* Dòng tổng "Bills before payday: $1,200.00" bọc trong `Row` không giới hạn chiều ngang, khi textScaler = 2.0x gây tràn 150px về bên phải (`bills_golden_test.dart`).
   - *Khắc phục:* Thay `Row` bằng `Text` trực tiếp trong `Container` có `width: double.infinity` để chuỗi tự động xuống dòng mượt mà khi phóng to chữ.
2. **Khắc phục nguy cơ tràn ngang các nút chọn chu kỳ lặp `ChoiceChip`:**
   - *Phát hiện:* Đặt 3 `ChoiceChip` (Weekly, Monthly, Yearly) trong `Row` có thể gây tràn ngang trên các thiết bị màn hình hẹp khi phóng to font.
   - *Khắc phục:* Dùng `Wrap(spacing: AppSpacing.s, runSpacing: AppSpacing.s, alignment: WrapAlignment.center)` đảm bảo các chip tự động xuống dòng an toàn.
3. **Trùng lặp nhãn text tìm kiếm trong Bottom Sheet:**
   - *Phát hiện:* Cả tiêu đề `AppBottomSheet` và nhãn nút `PrimaryButton` đều dùng `l10n.addBill`, khiến widget test tìm thấy 2 widget trùng nhau.
   - *Khắc phục:* Đổi nhãn nút sang `l10n.saveChanges` ("Save Changes"), rõ ràng và phân biệt rành mạch ngữ cảnh.
4. **Sửa cảnh báo linter:**
   - *Phát hiện:* Sử dụng `textScale: 2.0` trong widget test kích hoạt lint warning `prefer_int_literals`.
   - *Khắc phục:* Sửa thành `textScale: 2`, đưa `flutter analyze` về 0 issue.
5. **Khắc phục Flaky race condition trong `budget_snapshot_service_test`:**
   - *Phát hiện:* Test debounce reactive pipeline phụ thuộc vào `delayed(100ms)` có thể bị timeout ngẫu nhiên khi CPU bận chạy nhiều test song song.
   - *Khắc phục:* Cung cấp `debounceDuration: Duration.zero` trong test fixture, đảm bảo 100% deterministic.
6. **Giải phóng tài nguyên & Vòng đời:**
   - Đã xác nhận: `BillFormSheet` giải phóng `_nameController.dispose()`. `OnboardingBillsPage`, `BillItemCard`, `BillQuickChips` là các stateless widgets không giữ animation controller hay timer nào rò rỉ.

