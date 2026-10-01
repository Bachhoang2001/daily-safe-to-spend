# Spec 003 · F02 — Budget Engine (package Dart thuần)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 003
> **Phụ thuộc:** Spec 002 · **Ước lượng:** 3–4 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Tính chính xác con số "safe to spend" và các số liệu liên quan cho mọi chế độ. **Đây là feature quan trọng nhất.**

## F02.1. API

```dart
BudgetSnapshot computeSnapshot(EngineInput input, LocalDate today);

class EngineInput {
  BudgetConfig config;
  List<IncomeEntry> incomes;        // dùng cho chế độ irregular
  List<Expense> expenses;           // chưa bị xóa
  List<Bill> bills;                 // đang active
  Goal? goal;                       // tối đa 1 ở MVP
  List<GoalContribution> contributions; // đóng góp thủ công
}

class BudgetConfig {
  String currency;
  IncomeMode incomeMode;            // fixed | irregular
  PayFrequency? payFrequency;       // weekly | biweekly | semimonthly | monthly (fixed)
  LocalDate? payAnchorDate;         // một ngày lương đã biết (fixed)
  Money? incomePerPaycheck;         // fixed
  Money? firstPeriodBalance;        // fixed: tiền hiện có cho kỳ đầu (onboarding giữa kỳ)
  Money? startingBalance;           // irregular: số dư lúc bắt đầu theo dõi
  LocalDate trackingStartDate;
  int safetyHorizonDays;            // irregular, mặc định 14
  int bufferPercent;                // 0–20; mặc định fixed 0, irregular 10
  RolloverMode rolloverMode;        // spread | tomorrow | save
}

class BudgetSnapshot {
  Money safeToday;                  // có thể âm
  Money dailyAllowanceToday;        // hạn mức gốc của hôm nay (trước khi trừ chi tiêu hôm nay)
  Money spentToday;
  Money tomorrowForecast;           // hạn mức ngày mai nếu hôm nay không tiêu thêm
  Money remainingInPeriod;          // fixed: pool còn lại; irregular: số dư khả dụng
  int daysLeftInclToday;
  LocalDate periodStart, periodEnd; // irregular: today .. today+H-1
  BudgetStatus status;              // onTrack | caution | over
  List<BillOccurrence> upcomingBills; // trong kỳ / trong cửa sổ, sắp xếp theo ngày
  GoalProgress? goalProgress;
}
```

## F02.2. Xác định kỳ (fixed mode)

- `weekly`: kỳ dài 7 ngày, neo theo `payAnchorDate`.
- `biweekly`: kỳ dài 14 ngày, neo theo `payAnchorDate` (tính cả tiến và lùi theo bội số 14).
- `semimonthly`: ngày lương **1** và **16** mỗi tháng → kỳ `[1..15]` và `[16..cuối tháng]`.
- `monthly`: ngày lương = `payAnchorDate.day` (kẹp về cuối tháng nếu tháng ngắn hơn) → kỳ từ ngày lương đến ngày trước ngày lương kế tiếp.
- `periodStart` = ngày lương gần nhất ≤ today; `periodEnd` = ngày trước ngày lương kế tiếp.

## F02.3. Pool của kỳ (fixed mode)

```
income      = (kỳ chứa trackingStartDate) ? firstPeriodBalance : incomePerPaycheck
bills       = Σ hóa đơn có ngày đến hạn ∈ [periodStart, periodEnd]
              (kỳ đầu: chỉ tính hóa đơn đến hạn ∈ [trackingStartDate, periodEnd])
goalReserve = goal?.perPaycheckAmount ?? 0   (chỉ khi goal đang active và chưa đạt target)
buffer      = income.percent(bufferPercent)
pool        = income − bills − goalReserve − buffer
```

- Kỳ đầu: ngày bắt đầu tính = `trackingStartDate` (không phải `periodStart`).
- Đóng góp thủ công vào goal (`GoalContribution`) **được trừ như một khoản chi** vào ngày đóng góp (nhưng không tính vào `spentToday` hiển thị; hiển thị riêng là "Saved").

## F02.4. Hạn mức theo ngày — mô phỏng từ đầu kỳ

Engine **mô phỏng từng ngày** từ `start` (đầu kỳ hoặc `trackingStartDate`) đến `today`, để mọi chế độ rollover đều tất định:

**Spread (mặc định):**
```
allowance(d) = (pool − spentBefore(d)) / daysLeftInclDay(d)     // chia nguyên, phần dư cents dồn cho ngày đầu
safeToday    = allowance(today) − spent(today)
```

**Tomorrow boost (Premium — Spec 023):**
```
base         = pool / totalDaysInPeriod (tính từ start)
carry(d)     = allowance(d−1) − spent(d−1)
nếu carry(d) > 0: allowance(d) = baseAdjusted(d) + carry(d)
nếu carry(d) < 0: phần âm chia đều cho các ngày còn lại (giảm baseAdjusted từ ngày d)
```

**Save it (Premium — Spec 023):**
- Như Spread, nhưng cuối mỗi ngày đã qua, nếu `allowance(d) − spent(d) > 0` thì phần dư **chuyển vào goal** (đóng góp dẫn xuất, **không lưu DB** — ADR) và không cộng vào các ngày sau.
- Nếu không có goal active → hành xử như Spread.

> Bất biến kiểm tra bằng test: **Σ allowance gốc của mọi ngày trong kỳ + phần chuyển vào goal = pool** (Spread và Save); Tomorrow tương tự khi không tiêu vượt.

## F02.5. Chế độ thu nhập không đều (irregular)

```
balance(today) = startingBalance
               + Σ income có receivedOn ∈ [trackingStartDate, today]
               − Σ expense có spentOn ∈ [trackingStartDate, today)        // trước hôm nay
               − Σ contribution có onDate ∈ [trackingStartDate, today)
               − Σ bill occurrence có due ∈ [trackingStartDate, today)    // coi như đã trả

window         = [today, today + H − 1]          // H = safetyHorizonDays
billsInWindow  = Σ bill occurrence có due ∈ window
buffer         = balance.percent(bufferPercent)  // nếu balance > 0, ngược lại 0

allowanceToday = max(0, balance − billsInWindow − buffer) / H
safeToday      = allowanceToday − spentToday − contributionToday
```

- Nếu `balance − billsInWindow − buffer < 0` → `allowanceToday = 0`, `safeToday` âm theo chi tiêu hôm nay, status = `over`, kèm cờ `shortfall = true` và số tiền thiếu để UI cảnh báo.
- Rollover mode **không áp dụng** cho irregular ở MVP (luôn hành xử như Spread vì hạn mức tính lại mỗi ngày từ số dư).
- `periodStart = today`, `periodEnd = today + H − 1`, `daysLeftInclToday = H`.

## F02.6. Hóa đơn định kỳ (bill occurrences)

- `recurrence`: `weekly` (theo thứ trong tuần của `firstDueDate`), `monthly` (theo ngày của `firstDueDate`, kẹp cuối tháng), `yearly`.
- Sinh occurrence trong một khoảng `[from, to]` bất kỳ; không sinh trước `firstDueDate`.
- Tùy chọn `dueOnWeekendShift` **không có trong MVP** (ghi `docs/BACKLOG.md`).

## F02.7. Trạng thái

- `over` nếu `safeToday < 0`.
- `caution` nếu `0 ≤ safeToday < 20% × dailyAllowanceToday` (hoặc `dailyAllowanceToday == 0`).
- `onTrack` còn lại.

## F02.8. Tiến độ mục tiêu

```
goalSaved = Σ contribution thủ công
          + Σ goalReserve của các kỳ đã bắt đầu (fixed, kể từ goal.createdOn)
          + Σ phần chuyển rollover "save" của các ngày đã qua
goalProgress = { saved, target, percent (0–100, kẹp), reachedOn? }
```

Khi `saved ≥ target` → goal coi là đạt, `goalReserve` ngừng trừ ở các kỳ sau.

## F02.9. Edge cases bắt buộc xử lý

- Chưa có giao dịch nào; kỳ chỉ còn 1 ngày.
- Pool âm ngay từ đầu kỳ (hóa đơn > thu nhập) → allowance = 0, status `over`, `shortfall`.
- Giao dịch ghi lùi vào ngày trước `trackingStartDate` → bỏ qua (UI sẽ chặn ở Spec 013).
- Giao dịch ở ngày tương lai → không tính vào hôm nay (UI chặn ở Spec 012/Spec 013).
- Hóa đơn ngày 31 ở tháng 30 ngày; ngày lương 31 với `monthly`.
- `today` trước `trackingStartDate` (đổi giờ thiết bị) → trả snapshot của `trackingStartDate`.
- Đổi `payFrequency` giữa chừng → engine luôn tính theo config hiện tại (lịch sử kỳ cũ không cần tái hiện ở MVP; ghi ADR).

## F02.10. Test cases (tối thiểu)

| ID | Kịch bản | Kỳ vọng |
|---|---|---|
| T02-1 | Monthly, lương $3,000 ngày 1, bill $1,200 ngày 5, kỳ 30 ngày, hôm nay ngày 1, chưa tiêu | allowance = $60.00 |
| T02-2 | Như T02-1, ngày 1 tiêu $20 | safeToday = $40; tomorrowForecast = (1800−20)/29 |
| T02-3 | Spread: ngày 1 tiêu $0, ngày 2 | allowance ngày 2 = 1800/29 (dư được rải) |
| T02-4 | Tiêu vượt: ngày 1 tiêu $200 | safeToday = −$140, status `over`; ngày 2 allowance = 1600/29 |
| T02-5 | Biweekly anchor 2026-09-25, hôm nay 2026-10-10 | periodStart 2026-10-09, periodEnd 2026-10-22 |
| T02-6 | Semimonthly, hôm nay 2026-02-20 | kỳ [16..28], 13 ngày |
| T02-7 | Monthly anchor ngày 31, tháng 2 | ngày lương 28/02 (29 năm nhuận) |
| T02-8 | Kỳ đầu: onboarding ngày 20, firstPeriodBalance $500, lương kế ngày 1 | start = ngày 20, chỉ tính bill từ ngày 20 |
| T02-9 | Buffer 5% với income $3,000 | pool giảm $150 |
| T02-10 | Goal perPaycheck $200 | pool giảm $200; goalSaved tăng $200 mỗi kỳ bắt đầu |
| T02-11 | Goal đạt target | goalReserve ngừng trừ kỳ sau |
| T02-12 | Contribution thủ công $50 hôm nay | safeToday giảm $50, spentToday không đổi |
| T02-13 | Tomorrow: ngày 1 allowance $60, tiêu $10 | ngày 2 allowance = base + $50 |
| T02-14 | Tomorrow: ngày 1 tiêu vượt $30 | ngày 2.. giảm đều; tổng bất biến |
| T02-15 | Save: ngày 1 dư $15, có goal | goalSaved +$15; ngày 2 allowance không cộng $15 |
| T02-16 | Save khi không có goal | giống Spread |
| T02-17 | Irregular: startingBalance $800, H=14, buffer 10%, bill $140 trong cửa sổ | allowance = (800−140−80)/14 |
| T02-18 | Irregular: nhận income $500 hôm nay | balance tăng ngay hôm nay |
| T02-19 | Irregular: bill đã quá hạn được trừ khỏi balance | đúng công thức |
| T02-20 | Irregular shortfall | allowance 0, `shortfall = true`, số tiền thiếu đúng |
| T02-21 | Bất biến: Σ allowance (Spread, không tiêu vượt) = pool | đúng với 1.000 cấu hình ngẫu nhiên (property-based test, seed cố định) |
| T02-22 | `divideEvenly` không làm mất/thừa cent qua cả kỳ | tổng cents chính xác |
| T02-23 | Hiệu năng: 5.000 giao dịch, kỳ 31 ngày | `computeSnapshot` < 10 ms trên máy dev |
| T02-24 | Status caution/onTrack/over theo ngưỡng 20% | đúng |

**Design notes:** không có UI.

**Definition of Done:**
- [x] Tất cả T02-x xanh; coverage engine ≥ 95% (Thực tế: 74/74 tests engine + 6/6 tests app pass; coverage = 95.40%)
- [x] Engine không import Flutter, không I/O, không đọc đồng hồ
- [x] Dartdoc mô tả công thức ở mỗi chế độ
- [x] ADR ghi: (1) rollover "save" là dữ liệu dẫn xuất, (2) đổi payFrequency không tái hiện kỳ cũ, (3) irregular không dùng rollover mode (đã ghi vào docs/DECISIONS.md: ADR-002, ADR-003, ADR-004)

**Remember:** `docs/SESSION_STATE.md` (mục Knowledge) — cách gọi engine, bảng tóm tắt công thức, các bất biến.

---

## Implementation Plan

### 1. Danh sách file tạo/sửa & vai trò (tuân thủ `000-conventions.md` mục B2)

Toàn bộ mã nguồn của engine nằm trong package Dart thuần `packages/budget_engine`, độc lập hoàn toàn với Flutter SDK, I/O và database.

| STT | Đường dẫn file | Vai trò / Trách nhiệm |
|---|---|---|
| 1 | `packages/budget_engine/lib/src/models/enums.dart` | Định nghĩa các enum tài chính: `IncomeMode`, `PayFrequency`, `RolloverMode`, `BudgetStatus`, `BillRecurrence`. |
| 2 | `packages/budget_engine/lib/src/models/budget_config.dart` | Immutable model `BudgetConfig` chứa thông số cấu hình ngân sách của người dùng. |
| 3 | `packages/budget_engine/lib/src/models/expense.dart` | Immutable model `Expense` biểu diễn một giao dịch chi tiêu theo ngày. |
| 4 | `packages/budget_engine/lib/src/models/bill.dart` | Immutable model `Bill` (định nghĩa hóa đơn định kỳ) và `BillOccurrence` (lần đến hạn cụ thể). |
| 5 | `packages/budget_engine/lib/src/models/income_entry.dart` | Immutable model `IncomeEntry` ghi nhận khoản thu nhập thực tế theo ngày (cho irregular mode). |
| 6 | `packages/budget_engine/lib/src/models/goal.dart` | Immutable models: `Goal` (mục tiêu), `GoalContribution` (nạp tiền thủ công), `GoalProgress` (tiến độ tích lũy). |
| 7 | `packages/budget_engine/lib/src/models/engine_input.dart` | Immutable model `EngineInput` gom toàn bộ dữ liệu đầu vào cho engine tính toán. |
| 8 | `packages/budget_engine/lib/src/models/budget_snapshot.dart` | Immutable model `BudgetSnapshot` chứa kết quả tính toán chi tiết hiển thị cho UI. |
| 9 | `packages/budget_engine/lib/src/engine/period_resolver.dart` | Logic thuần xác định `periodStart`, `periodEnd` cho 4 chu kỳ lương (`weekly`, `biweekly`, `semimonthly`, `monthly`). |
| 10 | `packages/budget_engine/lib/src/engine/bill_generator.dart` | Logic sinh danh sách `BillOccurrence` trong khoảng `[from, to]` cho `weekly`, `monthly`, `yearly` có kẹp ngày cuối tháng. |
| 11 | `packages/budget_engine/lib/src/engine/day_simulation.dart` | Thuật toán mô phỏng từng ngày trong kỳ cho 3 chính sách rollover (`spread`, `tomorrow`, `save`) bảo toàn 100% cents. |
| 12 | `packages/budget_engine/lib/src/engine/fixed_engine.dart` | Engine tính toán cho `IncomeMode.fixed` (tính pool, khấu trừ bill, trích goal reserve, buffer, chạy mô phỏng). |
| 13 | `packages/budget_engine/lib/src/engine/irregular_engine.dart` | Engine tính toán cho `IncomeMode.irregular` (tính rolling balance, window H, buffer, phát hiện shortfall). |
| 14 | `packages/budget_engine/lib/src/engine/budget_engine_impl.dart` | Hiện thực hàm điều phối cấp cao `computeSnapshot(EngineInput input, LocalDate today)`. |
| 15 | `packages/budget_engine/lib/budget_engine.dart` | Barrel export công khai các models, enums, primitives và hàm `computeSnapshot`. |
| 16 | `packages/budget_engine/test/period_resolver_test.dart` | Test xác định kỳ lương cố định (weekly, biweekly, semimonthly, monthly) — T02-5, T02-6, T02-7. |
| 17 | `packages/budget_engine/test/bill_occurrence_test.dart` | Test bộ sinh occurrence hóa đơn theo recurrence, khoảng ngày, và kẹp cuối tháng. |
| 18 | `packages/budget_engine/test/fixed_engine_test.dart` | Test tính pool, safeToday, buffer, kỳ đầu, goal progress, contribution — T02-1, T02-2, T02-3, T02-4, T02-8, T02-9, T02-10, T02-11, T02-12, T02-24. |
| 19 | `packages/budget_engine/test/rollover_test.dart` | Test các chế độ rollover: Tomorrow boost, Save it (có goal / không goal) — T02-13, T02-14, T02-15, T02-16. |
| 20 | `packages/budget_engine/test/irregular_engine_test.dart` | Test chế độ thu nhập không đều: rolling balance, cửa sổ H, buffer, bills, shortfall — T02-17, T02-18, T02-19, T02-20. |
| 21 | `packages/budget_engine/test/invariants_test.dart` | Test các bất biến tài chính: bảo toàn cents qua 1.000 cấu hình ngẫu nhiên, divideEvenly, hiệu năng < 10ms — T02-21, T02-22, T02-23. |

---

### 2. Chốt chính xác các Model & Enum (F02.1)

Tất cả các model đều bất biến (immutable), triển khai `operator ==` và `hashCode` dựa trên giá trị các trường.

#### A. Enums
```dart
enum IncomeMode { fixed, irregular }
enum PayFrequency { weekly, biweekly, semimonthly, monthly }
enum RolloverMode { spread, tomorrow, save }
enum BudgetStatus { onTrack, caution, over }
enum BillRecurrence { weekly, monthly, yearly }
```

#### B. Data Contracts
```dart
class BudgetConfig {
  final String currency;                   // ISO 4217, e.g. 'USD'
  final IncomeMode incomeMode;
  final PayFrequency? payFrequency;        // Bắt buộc nếu incomeMode == fixed
  final LocalDate? payAnchorDate;          // Bắt buộc nếu incomeMode == fixed
  final Money? incomePerPaycheck;          // Bắt buộc nếu incomeMode == fixed
  final Money? firstPeriodBalance;         // Tùy chọn: số dư kỳ đầu khi onboarding giữa kỳ
  final Money? startingBalance;            // Bắt buộc nếu incomeMode == irregular
  final LocalDate trackingStartDate;
  final int safetyHorizonDays;             // Mặc định 14 (cho irregular)
  final int bufferPercent;                 // 0–20 (mặc định fixed 0, irregular 10)
  final RolloverMode rolloverMode;         // Mặc định spread
}

class Expense {
  final String id;
  final Money amount;
  final LocalDate spentOn;
  final String? categoryId;
  final String? note;
}

class Bill {
  final String id;
  final String name;
  final Money amount;
  final BillRecurrence recurrence;
  final LocalDate firstDueDate;
  final bool isActive;
}

class BillOccurrence {
  final String billId;
  final String billName;
  final Money amount;
  final LocalDate dueDate;
}

class IncomeEntry {
  final String id;
  final Money amount;
  final LocalDate receivedOn;
  final String? note;
}

class Goal {
  final String id;
  final String name;
  final Money targetAmount;
  final Money perPaycheckAmount;           // Trích từ pool mỗi kỳ (fixed)
  final LocalDate createdOn;
  final LocalDate? targetDate;
  final bool isActive;
}

class GoalContribution {
  final String id;
  final String goalId;
  final Money amount;
  final LocalDate onDate;
  final String? note;
}

class GoalProgress {
  final Money savedAmount;                 // Tổng đã tích lũy
  final Money targetAmount;                // Mục tiêu cần đạt
  final double percent;                    // 0.0 - 100.0 (được kẹp)
  final bool isReached;                    // savedAmount >= targetAmount
  final LocalDate? reachedOn;              // Ngày đạt mục tiêu nếu có
}

class BudgetSnapshot {
  final Money safeToday;                   // Hạn mức an toàn còn lại hôm nay (có thể âm nếu vượt)
  final Money dailyAllowanceToday;         // Hạn mức gốc phân bổ cho hôm nay
  final Money spentToday;                  // Chi tiêu thực tế hôm nay
  final Money tomorrowForecast;            // Dự báo hạn mức ngày mai nếu hôm nay không tiêu thêm
  final Money remainingInPeriod;           // Fixed: pool còn lại; Irregular: số dư khả dụng
  final int daysLeftInclToday;             // Số ngày còn lại tính cả hôm nay
  final LocalDate periodStart;             // Bắt đầu kỳ tính toán
  final LocalDate periodEnd;               // Kết thúc kỳ tính toán
  final BudgetStatus status;               // onTrack | caution | over
  final List<BillOccurrence> upcomingBills;// Hóa đơn sắp đến hạn
  final GoalProgress? goalProgress;        // Tiến độ mục tiêu tích lũy
  final bool shortfall;                    // true nếu thu nhập/số dư không đủ trả bill + buffer
  final Money shortfallAmount;             // Số tiền thiếu hụt nếu shortfall == true, ngược lại 0
}

class EngineInput {
  final BudgetConfig config;
  final List<IncomeEntry> incomes;
  final List<Expense> expenses;
  final List<Bill> bills;
  final Goal? goal;
  final List<GoalContribution> contributions;
}
```

---

### 3. Thuật toán mô phỏng từng ngày & Công thức tính toán (Pseudo-code)

#### A. Fixed Income Mode: Xác định Kỳ lương (F02.2) & Pool (F02.3)
```text
FUNCTION resolvePeriod(payFrequency, payAnchorDate, today):
  SWITCH payFrequency:
    CASE weekly:
      diff = payAnchorDate.daysUntil(today)
      periodIndex = FLOOR(diff / 7)
      periodStart = payAnchorDate.addDays(periodIndex * 7)
      periodEnd   = periodStart.addDays(6)
      RETURN (periodStart, periodEnd)

    CASE biweekly:
      diff = payAnchorDate.daysUntil(today)
      periodIndex = FLOOR(diff / 14)
      periodStart = payAnchorDate.addDays(periodIndex * 14)
      periodEnd   = periodStart.addDays(13)
      RETURN (periodStart, periodEnd)

    CASE semimonthly:
      IF today.day <= 15:
        periodStart = LocalDate(today.year, today.month, 1)
        periodEnd   = LocalDate(today.year, today.month, 15)
      ELSE:
        periodStart = LocalDate(today.year, today.month, 16)
        periodEnd   = LocalDate(today.year, today.month, today.lastDayOfMonth)
      RETURN (periodStart, periodEnd)

    CASE monthly:
      anchorDay = payAnchorDate.day
      payDayThisMonth = MIN(anchorDay, LocalDate.daysInMonth(today.year, today.month))
      payDateThisMonth = LocalDate(today.year, today.month, payDayThisMonth)

      IF today >= payDateThisMonth:
        periodStart = payDateThisMonth
        (nextYear, nextMonth) = getNextMonth(today.year, today.month)
        payDayNextMonth = MIN(anchorDay, LocalDate.daysInMonth(nextYear, nextMonth))
        periodEnd = LocalDate(nextYear, nextMonth, payDayNextMonth).addDays(-1)
      ELSE:
        (prevYear, prevMonth) = getPrevMonth(today.year, today.month)
        payDayPrevMonth = MIN(anchorDay, LocalDate.daysInMonth(prevYear, prevMonth))
        periodStart = LocalDate(prevYear, prevMonth, payDayPrevMonth)
        periodEnd = payDateThisMonth.addDays(-1)
      RETURN (periodStart, periodEnd)

FUNCTION calculateFixedPool(config, periodStart, periodEnd, bills, goal, goalIsReached):
  isFirstPeriod = (trackingStartDate >= periodStart AND trackingStartDate <= periodEnd)
  calcStart = isFirstPeriod ? trackingStartDate : periodStart

  income = (isFirstPeriod AND config.firstPeriodBalance != null)
             ? config.firstPeriodBalance
             : config.incomePerPaycheck

  billsOccurrences = generateBillOccurrences(bills, calcStart, periodEnd)
  totalBills = SUM(occurrence.amount FOR occurrence IN billsOccurrences)

  goalReserve = (goal != null AND goal.isActive AND NOT goalIsReached)
                  ? goal.perPaycheckAmount
                  : Money.zero(currency)

  buffer = income.percent(config.bufferPercent) // Làm tròn xuống cent
  pool = income - totalBills - goalReserve - buffer
  RETURN (calcStart, pool, billsOccurrences, goalReserve)
```

#### B. Mô phỏng từng ngày trong kỳ (F02.4)
Mô phỏng chạy tuyến tính từ ngày `calcStart` đến `today`:
```text
FUNCTION simulatePeriod(calcStart, periodEnd, today, pool, expenses, contributions, rolloverMode, hasActiveGoal):
  currency = pool.currency
  totalDays = calcStart.daysUntil(periodEnd) + 1
  todayIndex = calcStart.daysUntil(today)

  // Gom nhóm chi tiêu và đóng góp thủ công theo ngày
  spentByDate = GROUP_SUM(expenses.amount BY spentOn)
  contribByDate = GROUP_SUM(contributions.amount BY onDate)

  // Kiểm tra tình trạng thiếu hụt (Shortfall) ngay từ đầu kỳ
  IF pool < Money.zero(currency):
    shortfall = true
    shortfallAmount = pool.abs()
    allowanceToday = Money.zero(currency)
    safeToday = Money.zero(currency) - spentByDate[today] - contribByDate[today]
    tomorrowForecast = Money.zero(currency)
    remainingInPeriod = pool - SUM_OUTFLOW_UP_TO(today)
    RETURN snapshotWithShortfall(...)

  SWITCH rolloverMode:
    CASE spread:
      poolRemaining = pool
      FOR dayIndex FROM 0 TO todayIndex:
        d = calcStart.addDays(dayIndex)
        daysLeft = calcStart.addDays(dayIndex).daysUntil(periodEnd) + 1
        IF poolRemaining <= Money.zero(currency):
          allowance(d) = Money.zero(currency)
        ELSE:
          allowance(d) = poolRemaining.divideEvenly(daysLeft)[0]

        outflow(d) = spentByDate[d] + contribByDate[d]
        poolRemaining = poolRemaining - outflow(d)

      allowanceToday = allowance(today)
      safeToday = allowanceToday - spentByDate[today] - contribByDate[today]
      
      // Dự báo ngày mai (nếu hôm nay không tiêu thêm)
      daysLeftTomorrow = daysLeftInclToday - 1
      IF daysLeftTomorrow > 0:
        poolRemainingTomorrow = poolRemaining // không trừ thêm gì nữa
        tomorrowForecast = (poolRemainingTomorrow <= Money.zero)
                             ? Money.zero
                             : poolRemainingTomorrow.divideEvenly(daysLeftTomorrow)[0]
      ELSE:
        // Ngày cuối kỳ: dự báo trở về hạn mức cơ sở của kỳ kế tiếp
        tomorrowForecast = calculateNextPeriodBaseAllowance(...)

    CASE tomorrow:
      baseSchedule = pool.divideEvenly(totalDays) // Mảng totalDays phần tử, bảo toàn cents
      FOR dayIndex FROM 0 TO todayIndex:
        d = calcStart.addDays(dayIndex)
        IF dayIndex == 0:
          allowance(d) = baseSchedule[0]
        ELSE:
          prevDay = calcStart.addDays(dayIndex - 1)
          prevOutflow = spentByDate[prevDay] + contribByDate[prevDay]
          carry = allowance(prevDay) - prevOutflow
          IF carry >= Money.zero(currency):
            allowance(d) = baseSchedule[dayIndex] + carry
          ELSE:
            // Phần âm chia đều khấu trừ vào các ngày còn lại từ d đến cuối kỳ
            remainingDaysCount = totalDays - dayIndex
            deficitParts = (-carry).divideEvenly(remainingDaysCount)
            FOR k FROM dayIndex TO totalDays - 1:
              baseSchedule[k] = baseSchedule[k] - deficitParts[k - dayIndex]
            allowance(d) = MAX(Money.zero(currency), baseSchedule[dayIndex])

      allowanceToday = allowance(today)
      safeToday = allowanceToday - spentByDate[today] - contribByDate[today]

      // Dự báo ngày mai: nếu safeToday >= 0 thì boost vào ngày mai, nếu < 0 thì khấu trừ đều
      IF todayIndex < totalDays - 1:
        tomorrowBase = baseSchedule[todayIndex + 1]
        IF safeToday >= Money.zero(currency):
          tomorrowForecast = tomorrowBase + safeToday
        ELSE:
          remainingAfterTomorrow = totalDays - (todayIndex + 1)
          deduction = (-safeToday).divideEvenly(remainingAfterTomorrow)[0]
          tomorrowForecast = MAX(Money.zero(currency), tomorrowBase - deduction)
      ELSE:
        tomorrowForecast = calculateNextPeriodBaseAllowance(...)

    CASE save:
      IF NOT hasActiveGoal:
        // Không có goal active -> hành xử hệt như Spread
        FALLTHROUGH_TO(spread)
      
      poolRemaining = pool
      derivedGoalSaved = Money.zero(currency)
      FOR dayIndex FROM 0 TO todayIndex:
        d = calcStart.addDays(dayIndex)
        daysLeft = calcStart.addDays(dayIndex).daysUntil(periodEnd) + 1
        IF poolRemaining <= Money.zero(currency):
          allowance(d) = Money.zero(currency)
        ELSE:
          allowance(d) = poolRemaining.divideEvenly(daysLeft)[0]

        spentD = spentByDate[d]
        contribD = contribByDate[d]
        IF dayIndex < todayIndex:
          // Ngày trong quá khứ: phần dư cuối ngày tự động chuyển vào goal
          surplus = allowance(d) - spentD - contribD
          IF surplus > Money.zero(currency):
            derivedGoalSaved = derivedGoalSaved + surplus
            poolRemaining = poolRemaining - (spentD + contribD + surplus) // = poolRemaining - allowance(d)
          ELSE:
            poolRemaining = poolRemaining - (spentD + contribD)
        ELSE:
          // Hôm nay: chưa kết thúc ngày, surplus chưa chuyển vào goal
          poolRemaining = poolRemaining - (spentD + contribD)

      allowanceToday = allowance(today)
      safeToday = allowanceToday - spentByDate[today] - contribByDate[today]
      
      // Dự báo ngày mai: surplus hôm nay sẽ vào goal, ngày mai nhận hạn mức chuẩn ổn định
      daysLeftTomorrow = daysLeftInclToday - 1
      IF daysLeftTomorrow > 0:
        poolForTomorrow = poolRemaining - MAX(Money.zero(currency), safeToday)
        tomorrowForecast = (poolForTomorrow <= Money.zero)
                             ? Money.zero
                             : poolForTomorrow.divideEvenly(daysLeftTomorrow)[0]
      ELSE:
        tomorrowForecast = calculateNextPeriodBaseAllowance(...)
```

#### C. Chế độ thu nhập không đều (Irregular Mode — F02.5)
```text
FUNCTION computeIrregularSnapshot(config, incomes, expenses, bills, contributions, today):
  currency = config.currency
  H = config.safetyHorizonDays // Mặc định 14

  // 1. Tính rolling balance tại ngày hôm nay
  incomesUpToToday = SUM(income.amount FOR income IN incomes 
                         WHERE income.receivedOn >= trackingStartDate AND income.receivedOn <= today)
  expensesBeforeToday = SUM(expense.amount FOR expense IN expenses 
                            WHERE expense.spentOn >= trackingStartDate AND expense.spentOn < today)
  contribBeforeToday = SUM(contrib.amount FOR contrib IN contributions 
                           WHERE contrib.onDate >= trackingStartDate AND contrib.onDate < today)

  pastOccurrences = generateBillOccurrences(bills, trackingStartDate, today.addDays(-1))
  billsPastDue = SUM(occ.amount FOR occ IN pastOccurrences)

  balanceToday = config.startingBalance + incomesUpToToday - expensesBeforeToday - contribBeforeToday - billsPastDue

  // 2. Tính các khoản trong cửa sổ an toàn H: [today, today + H - 1]
  windowEnd = today.addDays(H - 1)
  windowOccurrences = generateBillOccurrences(bills, today, windowEnd)
  billsInWindow = SUM(occ.amount FOR occ IN windowOccurrences)

  buffer = (balanceToday > Money.zero(currency))
             ? balanceToday.percent(config.bufferPercent)
             : Money.zero(currency)

  spendableBalance = balanceToday - billsInWindow - buffer
  spentToday = SUM(expense.amount FOR expense IN expenses WHERE expense.spentOn == today)
  contribToday = SUM(contrib.amount FOR contrib IN contributions WHERE contrib.onDate == today)

  // 3. Phân bổ hạn mức và kiểm tra Shortfall
  IF spendableBalance < Money.zero(currency):
    shortfall = true
    shortfallAmount = spendableBalance.abs()
    allowanceToday = Money.zero(currency)
    safeToday = Money.zero(currency) - spentToday - contribToday
    status = BudgetStatus.over
  ELSE:
    shortfall = false
    shortfallAmount = Money.zero(currency)
    allowanceToday = spendableBalance.divideEvenly(H)[0]
    safeToday = allowanceToday - spentToday - contribToday
    status = computeStatus(safeToday, allowanceToday)

  // 4. Dự báo ngày mai: cửa sổ [today + 1, today + 1 + H - 1]
  balanceTomorrow = balanceToday - spentToday - contribToday
  windowTomorrowEnd = today.addDays(H)
  billsTomorrowWindow = SUM(occ.amount FOR occ IN generateBillOccurrences(bills, today.addDays(1), windowTomorrowEnd))
  bufferTomorrow = (balanceTomorrow > Money.zero) ? balanceTomorrow.percent(config.bufferPercent) : Money.zero
  spendableTomorrow = balanceTomorrow - billsTomorrowWindow - bufferTomorrow
  tomorrowForecast = (spendableTomorrow > Money.zero) ? spendableTomorrow.divideEvenly(H)[0] : Money.zero

  remainingInPeriod = MAX(Money.zero(currency), spendableBalance - spentToday - contribToday)
```

#### D. Trạng thái ngân sách (F02.7)
```text
FUNCTION computeStatus(safeToday, dailyAllowanceToday):
  IF safeToday < Money.zero(currency):
    RETURN BudgetStatus.over
  cautionThreshold = dailyAllowanceToday.percent(20)
  IF safeToday < cautionThreshold OR dailyAllowanceToday == Money.zero(currency):
    RETURN BudgetStatus.caution
  RETURN BudgetStatus.onTrack
```

#### E. Tiến độ mục tiêu tiết kiệm (F02.8)
```text
FUNCTION computeGoalProgress(goal, contributions, periodStart, today, payFrequency, payAnchorDate, derivedSaveRollover):
  IF goal == null:
    RETURN null

  // 1. Tổng đóng góp thủ công từ trước đến nay
  manualSaved = SUM(c.amount FOR c IN contributions WHERE c.goalId == goal.id AND c.onDate <= today)

  // 2. Tổng auto-reserve của các kỳ đã bắt đầu kể từ goal.createdOn (chỉ fixed mode)
  reserveSaved = Money.zero(goal.targetAmount.currency)
  IF payFrequency != null AND payAnchorDate != null:
    periodsStartedCount = countPeriodsStartedBetween(goal.createdOn, today, payFrequency, payAnchorDate)
    reserveSaved = goal.perPaycheckAmount * periodsStartedCount

  // 3. Tổng phần tiết kiệm tự động dẫn xuất từ rollover mode 'save'
  totalSaved = manualSaved + reserveSaved + derivedSaveRollover

  percent = (goal.targetAmount.cents > 0)
              ? CLAMP((totalSaved.cents / goal.targetAmount.cents) * 100.0, 0.0, 100.0)
              : 100.0
  isReached = totalSaved >= goal.targetAmount

  RETURN GoalProgress(
    savedAmount: totalSaved,
    targetAmount: goal.targetAmount,
    percent: percent,
    isReached: isReached,
    reachedOn: isReached ? today : null,
  )
```

---

### 4. Bộ sinh Occurrence hóa đơn (F02.6)

```text
FUNCTION generateBillOccurrences(bills, fromDate, toDate):
  occurrences = []
  FOR bill IN bills WHERE bill.isActive:
    IF toDate < bill.firstDueDate:
      CONTINUE

    searchStart = MAX(fromDate, bill.firstDueDate)

    SWITCH bill.recurrence:
      CASE weekly:
        daysDiff = bill.firstDueDate.daysUntil(searchStart)
        k = (daysDiff <= 0) ? 0 : CEIL(daysDiff / 7)
        currDate = bill.firstDueDate.addDays(k * 7)
        WHILE currDate <= toDate:
          IF currDate >= searchStart:
            occurrences.ADD(BillOccurrence(bill.id, bill.name, bill.amount, currDate))
          currDate = currDate.addDays(7)

      CASE monthly:
        dueDay = bill.firstDueDate.day
        // Lặp qua từng tháng từ searchStart đến toDate
        FOR (year, month) FROM searchStart TO toDate:
          maxDay = LocalDate.daysInMonth(year, month)
          actualDay = MIN(dueDay, maxDay) // Kẹp ngày cuối tháng (ví dụ 31 kẹp về 28/29 tháng 2)
          candidateDate = LocalDate(year, month, actualDay)
          IF candidateDate >= searchStart AND candidateDate <= toDate:
            occurrences.ADD(BillOccurrence(bill.id, bill.name, bill.amount, candidateDate))

      CASE yearly:
        dueMonth = bill.firstDueDate.month
        dueDay = bill.firstDueDate.day
        FOR year FROM searchStart.year TO toDate.year:
          maxDay = LocalDate.daysInMonth(year, dueMonth)
          actualDay = MIN(dueDay, maxDay)
          candidateDate = LocalDate(year, dueMonth, actualDay)
          IF candidateDate >= searchStart AND candidateDate <= toDate:
            occurrences.ADD(BillOccurrence(bill.id, bill.name, bill.amount, candidateDate))

  SORT occurrences BY dueDate ASCENDING
  RETURN occurrences
```

---

### 5. Danh sách 3 Architecture Decision Records (ADR) sẽ ghi vào `docs/DECISIONS.md`

1. **ADR-002: Rollover "Save it" là dữ liệu dẫn xuất (derived), không lưu DB**
   - *Bối cảnh:* Khi bật `RolloverMode.save`, số dư cuối mỗi ngày chưa tiêu hết được dồn vào tiết kiệm.
   - *Quyết định:* Giá trị `goalAutoSaved` hoàn toàn được tính toán động (pure derived computation) trong `computeSnapshot` tại thời điểm chạy engine; SQLite DB chỉ lưu các khoản nạp thủ công `GoalContribution`.
   - *Hệ quả:* Không làm bẩn cơ sở dữ liệu với hàng chục record tự động mỗi tháng. Khi người dùng thay đổi chi tiêu ngày cũ hoặc đổi chế độ rollover, engine tự động tái tính toán kết quả mà không cần rollback hay dọn dẹp DB.

2. **ADR-003: Đổi payFrequency hoặc payAnchorDate không tái hiện lại kỳ cũ**
   - *Bối cảnh:* Người dùng có thể đổi chu kỳ lương từ biweekly sang monthly hoặc đổi ngày trả lương trong Settings.
   - *Quyết định:* Engine luôn tính snapshot kỳ hiện tại dựa trên `BudgetConfig` đang áp dụng. Các kỳ lịch sử trước đó không cần lưu snapshot tĩnh hay tái hiện phức tạp trong MVP. Lịch sử chi tiêu theo ngày (`Expense`) vẫn được bảo toàn nguyên vẹn.
   - *Hệ quả:* Giữ engine hoàn toàn phi trạng thái (stateless), tránh phân kỳ dữ liệu và loại bỏ hoàn toàn việc phải versioning cấu hình theo thời gian ở MVP.

3. **ADR-004: Chế độ thu nhập không đều (irregular) không dùng rollover mode ở MVP**
   - *Bối cảnh:* Người dùng freelance/gig-worker có dòng tiền và số dư biến thiên liên tục.
   - *Quyết định:* Chế độ `irregular` luôn tính lại hạn mức ngày linh hoạt từ số dư thực tế chia đều cho cửa sổ an toàn $H$ (mặc định 14 ngày), tương đương cơ chế `spread` tự nhiên. Các chế độ `tomorrow` và `save` bị vô hiệu hóa cho `irregular` trong MVP.
   - *Hệ quả:* Đơn giản hóa mô hình tư duy tài chính cho người dùng thu nhập không đều, loại bỏ nguy cơ tích lũy thặng dư ảo khi dòng tiền không có chu kỳ cố định.

---

### 6. Ánh xạ từng Test Case (F02.10) → File Test

| Mã test | Kịch bản mô tả | File test tương ứng |
|---|---|---|
| **T02-1** | Monthly, lương $3,000 ngày 1, bill $1,200 ngày 5, kỳ 30 ngày, hôm nay ngày 1, chưa tiêu → allowance = $60.00 | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-2** | Như T02-1, ngày 1 tiêu $20 → safeToday = $40; tomorrowForecast = (1800−20)/29 | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-3** | Spread: ngày 1 tiêu $0, ngày 2 → allowance ngày 2 = 1800/29 (dư được rải) | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-4** | Tiêu vượt: ngày 1 tiêu $200 → safeToday = −$140, status `over`; ngày 2 allowance = 1600/29 | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-5** | Biweekly anchor 2026-09-25, hôm nay 2026-10-10 → periodStart 2026-10-09, periodEnd 2026-10-22 | `packages/budget_engine/test/period_resolver_test.dart` |
| **T02-6** | Semimonthly, hôm nay 2026-02-20 → kỳ [16..28], 13 ngày | `packages/budget_engine/test/period_resolver_test.dart` |
| **T02-7** | Monthly anchor ngày 31, tháng 2 → ngày lương 28/02 (29 năm nhuận) | `packages/budget_engine/test/period_resolver_test.dart` |
| **T02-8** | Kỳ đầu: onboarding ngày 20, firstPeriodBalance $500, lương kế ngày 1 → start = ngày 20, chỉ tính bill từ ngày 20 | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-9** | Buffer 5% với income $3,000 → pool giảm $150 | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-10** | Goal perPaycheck $200 → pool giảm $200; goalSaved tăng $200 mỗi kỳ bắt đầu | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-11** | Goal đạt target → goalReserve ngừng trừ kỳ sau | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-12** | Contribution thủ công $50 hôm nay → safeToday giảm $50, spentToday không đổi | `packages/budget_engine/test/fixed_engine_test.dart` |
| **T02-13** | Tomorrow: ngày 1 allowance $60, tiêu $10 → ngày 2 allowance = base + $50 | `packages/budget_engine/test/rollover_test.dart` |
| **T02-14** | Tomorrow: ngày 1 tiêu vượt $30 → ngày 2.. giảm đều; tổng bất biến | `packages/budget_engine/test/rollover_test.dart` |
| **T02-15** | Save: ngày 1 dư $15, có goal → goalSaved +$15; ngày 2 allowance không cộng $15 | `packages/budget_engine/test/rollover_test.dart` |
| **T02-16** | Save khi không có goal → giống Spread | `packages/budget_engine/test/rollover_test.dart` |
| **T02-17** | Irregular: startingBalance $800, H=14, buffer 10%, bill $140 trong cửa sổ → allowance = (800−140−80)/14 | `packages/budget_engine/test/irregular_engine_test.dart` |
| **T02-18** | Irregular: nhận income $500 hôm nay → balance tăng ngay hôm nay | `packages/budget_engine/test/irregular_engine_test.dart` |
| **T02-19** | Irregular: bill đã quá hạn được trừ khỏi balance → đúng công thức | `packages/budget_engine/test/irregular_engine_test.dart` |
| **T02-20** | Irregular shortfall → allowance 0, `shortfall = true`, số tiền thiếu đúng | `packages/budget_engine/test/irregular_engine_test.dart` |
| **T02-21** | Bất biến: Σ allowance (Spread, không tiêu vượt) = pool qua 1.000 cấu hình ngẫu nhiên (seed cố định) | `packages/budget_engine/test/invariants_test.dart` |
| **T02-22** | `divideEvenly` không làm mất/thừa cent qua cả kỳ | `packages/budget_engine/test/invariants_test.dart` |
| **T02-23** | Hiệu năng: 5.000 giao dịch, kỳ 31 ngày → `computeSnapshot` < 10 ms trên máy dev | `packages/budget_engine/test/invariants_test.dart` |
| **T02-24** | Status caution/onTrack/over theo ngưỡng 20% → đúng theo đặc tả | `packages/budget_engine/test/fixed_engine_test.dart` |

---

### 7. Rủi ro kỹ thuật & Câu hỏi mở

1. **Rủi ro ngày thiết bị thay đổi lùi trước `trackingStartDate`:**
   - *Giải pháp:* Edge case F02.9 đã quy định rõ: nếu `today < trackingStartDate`, engine kẹp và tính snapshot tại `trackingStartDate` để đảm bảo không crash và không cho phép hiển thị số liệu âm kỳ ảo.
2. **Rủi ro tiêu vượt quá mức Pool còn lại:**
   - *Giải pháp:* Khi `poolRemaining <= 0`, hạn mức phân bổ cho các ngày tiếp theo tự động kẹp về `Money.zero`. `safeToday` sẽ âm tương ứng đúng với số tiền chi tiêu hôm đó, và trạng thái chuyển ngay sang `BudgetStatus.over`.
3. **Rủi ro ngày cuối kỳ (Last Day of Period):**
   - *Giải pháp:* Vào ngày cuối kỳ (`daysLeftInclToday == 1`), `tomorrowForecast` không thể chia cho `daysLeft - 1 = 0`. Engine sẽ tính toán hạn mức cơ sở dự kiến cho kỳ tiếp theo (dựa trên thu nhập định kỳ và hóa đơn kỳ sau) để người dùng luôn thấy con số dự báo trực quan.
4. **Không có câu hỏi chặn việc (No blocking questions):** Toàn bộ công thức toán học và bất biến tài chính đã được đối soát chặt chẽ, hoàn toàn nhất quán với Spec 000, 002 và 003. Sẵn sàng chuyển sang bước DEFINE TEST.

---

## Review & Verify Report

- **Ngày thực hiện:** 2026-10-02
- **Người thực hiện:** `@silent-failure-hunter` kết hợp skill `/review-code`
- **Kết quả Unit Tests:**
  - `packages/budget_engine`: **74 / 74 tests pass** (100%), bao gồm:
    - `period_resolver_test.dart`: T02-5, T02-6, T02-7, T02-8
    - `bill_occurrences_test.dart`: F02.6-1 đến F02.6-8
    - `engine_fixed_spread_test.dart`: T02-1, T02-2, T02-3, T02-4, T02-9, T02-10, T02-11, T02-12, T02-24
    - `engine_rollover_test.dart`: T02-13, T02-14, T02-15, T02-16
    - `engine_irregular_test.dart`: T02-17, T02-18, T02-19, T02-20
    - `engine_invariants_test.dart`: T02-21 (Spread qua 1.000 cấu hình ngẫu nhiên), T02-21b (Save qua 500 cấu hình ngẫu nhiên), T02-22 (divideEvenly)
    - `engine_performance_test.dart`: T02-23 (benchmark 5.000 giao dịch chi tiêu trong kỳ 31 ngày < 2 ms)
    - `engine_edge_cases_test.dart`: F02.9-1 đến F02.9-7
    - `primitives_coverage_test.dart`: Money methods, divideEvenly negative cents, LocalDate parse edge cases (rỗng, sai định dạng, ngày/tháng không hợp lệ, leap year)
    - `models_test.dart`: Kiểm thử equality, hashCode, toString cho toàn bộ data models
    - `engine_branches_test.dart`: Kiểm thử goal reserve đa chu kỳ (weekly, biweekly, semimonthly), irregular contributions & negative balance
  - Flutter App (`test/`): **6 / 6 tests pass** (100%)
  - **Tổng cộng:** **80 / 80 tests PASS**
- **Test Coverage (`packages/budget_engine`):**
  - **95.40%** (664 / 696 dòng được cover theo lcov info)
  - `bill_occurrences.dart`: 100.00%
  - `compute_snapshot.dart`: 99.08%
  - `local_date.dart`: 100.00%
  - `expense.dart`, `goal.dart`, `goal_contribution.dart`, `income_entry.dart`: 100.00%
  - `money.dart`: 100.00%
  - `irregular_calculator.dart`: 100.00%
  - `day_simulator.dart`: 99.24%
  - `period_resolver.dart`: 98.25%
- **Static Analysis (`make analyze`):**
  - Flutter app: `No issues found!`
  - Budget engine: `No issues found!`
  - CI Guard check: `Verified: No 'double' used for monetary values.`
  - Formatting: `dart format .` $\rightarrow$ 55 files formatted cleanly.
- **Kiểm tra Thủ công trên Thiết bị Thật / Simulator / Emulator:**
  - **iOS Simulator (iPhone 17 · iOS 26.5):** Khởi chạy Runner.app thành công (PID 53305), render giao diện chuẩn không crash.
  - **Android Emulator (Medium Phone · Android API 35):** Cài đặt và khởi chạy `app-dev-debug.apk` thành công (`org.aveglobal.safetospend.dev`), render giao diện chính xác.
- **Lỗi Ngầm Đã Phát Hiện & Đã Sửa:**
  1. *Lỗi ngầm dự báo ngày mai trong Tomorrow Boost (`packages/budget_engine/lib/src/fixed/day_simulator.dart`):* Khi người dùng tiêu vượt quá lớn ở ngày đầu khiến `baseSchedule` của các ngày sau bị âm, sang ngày thứ hai người dùng chưa tiêu gì (`safeToday == 0`), biểu thức `tomorrowBase + safeToday` dẫn đến `tomorrowForecast` bị gán giá trị âm thay vì kẹp về `Money.zero`. Đã sửa bằng cách kẹp `boosted < Money.zero ? Money.zero : boosted` đúng theo công thức spec.
  2. *Thiếu test bảo toàn tiền cho Save Mode:* Đã bổ sung `T02-21b` trong `test/engine_invariants_test.dart` kiểm chứng $\sum \text{spent} + \text{derivedGoalSaved} + \text{remainingInPeriod} = \text{Pool}$ qua 500 cấu hình ngẫu nhiên.
  3. *Thiếu ADR trong `docs/DECISIONS.md`:* Đã bổ sung đầy đủ ADR-002, ADR-003, ADR-004 theo đúng đặc tả DoD.
  4. *Coverage ban đầu đạt 68.01% do thiếu test các model methods, primitives edge cases và branches:* Đã viết bổ sung `models_test.dart`, `primitives_coverage_test.dart`, `engine_branches_test.dart`, nâng coverage lên **95.40%**.
- **Checklist Definition of Done:**
  - [x] Tất cả T02-x xanh; coverage engine ≥ 95% (Đạt 95.40%)
  - [x] Engine không import Flutter, không I/O, không đọc đồng hồ
  - [x] Dartdoc mô tả công thức ở mỗi chế độ
  - [x] ADR ghi: (1) rollover "save" là dữ liệu dẫn xuất, (2) đổi payFrequency không tái hiện kỳ cũ, (3) irregular không dùng rollover mode (Đã ghi vào `docs/DECISIONS.md`)

