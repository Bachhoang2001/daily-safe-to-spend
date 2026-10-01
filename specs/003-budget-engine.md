# Spec 003 · F02 — Budget Engine (package Dart thuần)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 003
> **Phụ thuộc:** Spec 002 · **Ước lượng:** 3–4 ngày
> **Trạng thái:** TODO

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
- [ ] Tất cả T02-x xanh; coverage engine ≥ 95%
- [ ] Engine không import Flutter, không I/O, không đọc đồng hồ
- [ ] Dartdoc mô tả công thức ở mỗi chế độ
- [ ] ADR ghi: (1) rollover "save" là dữ liệu dẫn xuất, (2) đổi payFrequency không tái hiện kỳ cũ, (3) irregular không dùng rollover mode

**Remember:** `docs/SESSION_STATE.md` (mục Knowledge) — cách gọi engine, bảng tóm tắt công thức, các bất biến.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
