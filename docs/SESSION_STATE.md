# Session State
_Cập nhật: 2026-10-02 · Spec vừa xong: 003 · Spec tiếp theo: 004_

## Tiến độ
| Spec | Feature | Trạng thái | Tests (pass/total) | Analyze (warnings) | Ngày |
|------|---------|------------|--------------------|--------------------|------|
| 001 | Project foundation & bộ nhớ dự án | DONE | 2/2 | 0 | 2026-10-01 |
| 002 | Core primitives | DONE | 12/12 | 0 | 2026-10-01 |
| 003 | Budget engine | DONE | 74/74 (engine) / 80/80 (total) | 0 | 2026-10-02 |
| 004 | Data layer | TODO | – | – | – |
| 005 | App shell | TODO | – | – | – |
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
- **Quy ước Git:** Xong mỗi spec (tính năng), USER sẽ tự thực hiện `git commit` và `git push` code. Agent tuyệt đối không tự ý chạy git commit hoặc push.

## Known issues / Tech debt
- Không có issue hoặc tech debt phát sinh từ Spec 003. Đạt 100% test pass (80/80 tests), coverage `packages/budget_engine` đạt 95.40%, 0 analyze issue.
- Các tính năng mở rộng ngoài MVP (như `dueOnWeekendShift`, multi-goals, irregular rollover) đã được ghi nhận trong `docs/BACKLOG.md`.

## Next
- Spec 004 · Data layer (drift schema, DAO, repository) (file `specs/004-data-layer.md`).
