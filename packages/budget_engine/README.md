# Budget Engine (`packages/budget_engine`)

[![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Pure%20Dart%20%7C%20Zero%20IO-success.svg)](specs/003-budget-engine.md)
[![Test Coverage](https://img.shields.io/badge/Coverage-100%25%20(50%2F50)-brightgreen.svg)](packages/budget_engine/test)

Package Dart thuần (Pure Dart) chứa toàn bộ lõi thuật toán tính toán tài chính của ứng dụng **Daily Safe-to-Spend**.

Package này được thiết kế theo triết lý **Pure Functional Engine**:
- **Zero Flutter SDK:** Không phụ thuộc vào Flutter, Widgets, platform channels hay UI state.
- **Zero I/O & Clock Independence:** Không thực hiện đọc/ghi file, SQLite, SharedPreferences hay đọc đồng hồ hệ thống `DateTime.now()`. Toàn bộ dữ liệu đầu vào và mốc thời gian `today` được tiêm từ bên ngoài (injected explicitly).
- **Zero Float:** 100% số tiền nghiệp vụ được biểu diễn bằng số nguyên `cents` (`Money`), loại bỏ hoàn toàn sai số dấu phẩy động của `double`.
- **Deterministic Simulation:** Mô phỏng tuần tự từng ngày từ đầu kỳ đến ngày hiện tại để bảo toàn tính tất định và bảo toàn cents cho mọi chế độ rollover.

---

## 1. Kiến trúc & API Public

### Điểm vào duy nhất: `computeSnapshot`

```dart
BudgetSnapshot computeSnapshot(EngineInput input, LocalDate today);
```

Hàm nhận vào toàn bộ dữ liệu cấu hình, hóa đơn, chi tiêu, mục tiêu tiết kiệm ([EngineInput]) cùng ngày mục tiêu [LocalDate today], và trả về một [BudgetSnapshot] bất biến chứa toàn bộ chỉ số tài chính của ngày hôm đó.

### Sơ đồ dữ liệu đầu vào ([EngineInput])

```
EngineInput
├── BudgetConfig config             // Cấu hình chế độ, chu kỳ, tỷ lệ buffer, rollover
├── List<IncomeEntry> incomes        // Các khoản thu nhập thực tế (dành cho Irregular)
├── List<Expense> expenses          // Các giao dịch chi tiêu theo ngày
├── List<Bill> bills                // Danh sách hóa đơn định kỳ đang active
├── Goal? goal                      // Mục tiêu tiết kiệm đang kích hoạt (tối đa 1 ở MVP)
└── List<GoalContribution> contributions // Các khoản nạp tiết kiệm thủ công
```

### Dữ liệu kết quả ([BudgetSnapshot])

| Thuộc tính | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `safeToday` | `Money` | Số tiền an toàn còn lại có thể chi tiêu trong ngày hôm nay (có thể âm nếu đã bội chi). |
| `dailyAllowanceToday` | `Money` | Hạn mức cơ sở của ngày hôm nay (trước khi trừ chi tiêu và đóng góp hôm nay). |
| `spentToday` | `Money` | Tổng chi tiêu đã ghi nhận trong ngày hôm nay. |
| `tomorrowForecast` | `Money` | Dự báo hạn mức ngày mai nếu từ giờ đến hết hôm nay không tiêu thêm. |
| `remainingInPeriod` | `Money` | Số tiền khả dụng còn lại trong kỳ (Fixed) hoặc số dư khả dụng (Irregular). |
| `daysLeftInclToday` | `int` | Số ngày còn lại tính cả hôm nay trong kỳ hoặc trong cửa sổ an toàn $H$. |
| `periodStart`, `periodEnd` | `LocalDate` | Khoảng thời gian chu kỳ tính toán (`[start .. end]` bao gồm cả 2 đầu). |
| `status` | `BudgetStatus` | Trạng thái ngân sách: `onTrack`, `caution` (dưới 20%), hoặc `over` (âm hoặc thiếu hụt). |
| `upcomingBills` | `List<BillOccurrence>` | Các đợt hóa đơn đến hạn trong kỳ/cửa sổ, sắp xếp tăng dần theo ngày. |
| `goalProgress` | `GoalProgress?` | Tiến độ mục tiêu tiết kiệm (đã lưu, phần trăm đạt, cờ hoàn thành). |
| `shortfall` | `bool` | `true` nếu thu nhập/số dư không đủ để chi trả hóa đơn và quỹ dự phòng. |
| `shortfallAmount` | `Money` | Số tiền thâm hụt cần bù đắp nếu `shortfall == true`. |

---

## 2. Kiểu dữ liệu nền tảng (Primitives)

### `Money` (`src/money.dart`)
* Lưu trữ số tiền dưới dạng số nguyên `cents` (ví dụ: `$25.50 = 2550` cents).
* Đi kèm mã tiền tệ chuẩn ISO 4217 (`USD`, `VND`, `EUR`...).
* Ném ngoại lệ `CurrencyMismatchError` nếu tính toán giữa 2 loại tiền tệ khác nhau.
* **`divideEvenly(int parts)`:** Phân chia số tiền thành `parts` phần bằng nhau. Phần dư cents luôn được chia đều vào các phần tử đầu tiên, đảm bảo **tổng cents của các phần luôn bằng đúng số tiền ban đầu**:
  ```dart
  const pool = Money(1000); // 1,000 cents ($10.00)
  final parts = pool.divideEvenly(3);
  // Kết quả: [Money(334), Money(333), Money(333)] -> Tổng = 1000 cents
  ```
* **`percent(int p)`:** Tính phần trăm và luôn làm tròn **xuống** (floor) về cent gần nhất để giữ tính an toàn cho quỹ dự phòng:
  ```dart
  const income = Money(999);
  final buffer = income.percent(10); // Money(99)
  ```

### `LocalDate` (`src/local_date.dart`)
* Biểu diễn ngày dương lịch thuần túy (`year`, `month`, `day`).
* Không chứa múi giờ hay giờ/phút/giây, miễn nhiễm với lỗi chuyển đổi giờ mùa hè (Daylight Saving Time - DST).
* **`addMonths(int months)`:** Tự động kẹp về ngày cuối cùng của tháng nếu tháng đích ngắn hơn:
  ```dart
  const jan31 = LocalDate(2026, 1, 31);
  jan31.addMonths(1); // 2026-02-28 (năm thường)
  ```
* **`daysUntil(LocalDate other)`:** Tính chính xác khoảng cách số ngày giữa 2 mốc thời gian.

---

## 3. Chế độ Thu nhập Cố định (`IncomeMode.fixed`)

### A. Xác định Chu kỳ Lương (Pay Period Resolution)

Engine hỗ trợ 4 chu kỳ lương cố định dựa trên [PayAnchorDate]:
1. **`weekly`:** Chu kỳ 7 ngày, tính từ ngày trong tuần của `payAnchorDate`.
2. **`biweekly`:** Chu kỳ 14 ngày, tính tiến và lùi theo bội số 14 ngày từ `payAnchorDate`.
3. **`semimonthly`:** Ngày lương mùng 1 và 16 hàng tháng $\rightarrow$ Kỳ `[1..15]` và `[16..cuối tháng]`.
4. **`monthly`:** Ngày lương cố định theo `payAnchorDate.day` (kẹp về cuối tháng nếu tháng ngắn hơn).

*Quy tắc kỳ đầu tiên (Onboarding):* Nếu kỳ hiện tại chứa ngày bắt đầu theo dõi `trackingStartDate`, ngày bắt đầu tính toán `calcStart` là `trackingStartDate`, thu nhập dùng `firstPeriodBalance` (nếu có), và chỉ tính các hóa đơn đến hạn từ `trackingStartDate` trở đi.

### B. Công thức Tính Pool Khả dụng

$$\text{income} = (\text{isFirstPeriod} \land \text{firstPeriodBalance} \ne \text{null}) \ ?\ \text{firstPeriodBalance} : \text{incomePerPaycheck}$$
$$\text{bills} = \sum \text{bill.amount} \quad (\text{ngày đến hạn} \in [\text{calcStart}, \text{periodEnd}])$$
$$\text{goalReserve} = (\text{goal} \ne \text{null} \land \text{goal.isActive} \land \neg \text{isReached}) \ ?\ \text{goal.perPaycheckAmount} : \$0$$
$$\text{buffer} = \lfloor \text{income} \times \frac{\text{bufferPercent}}{100} \rfloor$$
$$\mathbf{Pool} = \text{income} - \text{bills} - \text{goalReserve} - \text{buffer}$$

---

## 4. Các Chế độ Rollover & Ví dụ Đầu vào → Đầu ra

### 📌 Ví dụ 1: Fixed Mode với `RolloverMode.spread` (Mặc định)

#### Kịch bản Đầu vào:
- **Chu kỳ:** Hàng tháng (`monthly`), nhận lương ngày 1.
- **Ngày hiện tại:** `today = 2026-10-01` (Kỳ 30 ngày: `2026-10-01` đến `2026-10-30`).
- **Thu nhập kỳ:** `$3,000.00` (`300,000` cents).
- **Hóa đơn định kỳ:** Tiền thuê nhà `$1,200.00` đến hạn ngày `2026-10-05`.
- **Tiết kiệm định kỳ:** Trích quỹ `$200.00` cho mục tiêu "Mua xe máy".
- **Quỹ dự phòng an toàn:** `5%` thu nhập = `$150.00`.
- **Rollover Mode:** `RolloverMode.spread`.

#### Mã khởi tạo:
```dart
import 'package:budget_engine/budget_engine.dart';

final input = EngineInput(
  config: const BudgetConfig(
    currency: 'USD',
    incomeMode: IncomeMode.fixed,
    payFrequency: PayFrequency.monthly,
    payAnchorDate: LocalDate(2026, 10, 1),
    incomePerPaycheck: Money(300000), // $3,000.00
    trackingStartDate: LocalDate(2026, 10, 1),
    bufferPercent: 5,
    rolloverMode: RolloverMode.spread,
  ),
  bills: const [
    Bill(
      id: 'b1',
      name: 'Rent',
      amount: Money(120000), // $1,200.00
      recurrence: BillRecurrence.monthly,
      firstDueDate: LocalDate(2026, 10, 5),
    ),
  ],
  goal: const Goal(
    id: 'g1',
    name: 'Motorbike',
    targetAmount: Money(200000), // $2,000.00
    perPaycheckAmount: Money(20000), // $200.00
    createdOn: LocalDate(2026, 10, 1),
  ),
);
```

#### Tính toán Pool:
$$\text{Pool} = \$3,000.00 - \$1,200.00 - \$200.00 - \$150.00 = \$1,450.00 \ (145,000 \text{ cents})$$

#### Kết quả Ngày 1 (`2026-10-01`, Chưa tiêu gì):
$$\text{allowance}(1) = \frac{\$1,450.00}{30} = \$48.33 \quad (\text{cents: } 145000 / 30 = 4833)$$
- `dailyAllowanceToday = $48.33`
- `safeToday = $48.33`
- `spentToday = $0.00`
- `tomorrowForecast = $48.33`
- `status = BudgetStatus.onTrack`

#### Kịch bản Tiết kiệm Ngày 1 (Người dùng chỉ tiêu `$18.33`):
```dart
final day1Input = input.copyWith(
  expenses: const [
    Expense(id: 'e1', amount: Money(1833), spentOn: LocalDate(2026, 10, 1)),
  ],
);
final day1Snapshot = computeSnapshot(day1Input, const LocalDate(2026, 10, 1));
```
- `safeToday = $48.33 - $18.33 = $30.00`
- `tomorrowForecast = (Pool $1,450 - $18.33) / 29 = $49.36`

#### Kết quả Ngày 2 (`2026-10-02`):
Do ngày 1 dư `$30.00`, ở chế độ `spread`, phần dư này được rải đều cho 29 ngày còn lại:
$$\text{allowance}(2) = \frac{\$1,450.00 - \$18.33}{29} = \frac{\$1,431.67}{29} = \mathbf{\$49.36}$$
- Hạn mức mỗi ngày từ ngày 2 đến ngày 30 tăng từ `$48.33` lên **`$49.36`**.

#### Kịch bản Bội chi Ngày 1 (Người dùng tiêu `$148.33`, bội chi `$100.00`):
- Ngày 1: `safeToday = -$100.00`, `status = BudgetStatus.over`.
- Ngày 2: Hạn mức tự động thắt chặt đều cho 29 ngày còn lại:
  $$\text{allowance}(2) = \frac{\$1,450.00 - \$148.33}{29} = \frac{\$1,301.67}{29} = \mathbf{\$44.88}$$

---

### 📌 Ví dụ 2: Fixed Mode với `RolloverMode.tomorrow` (Tomorrow Boost — Premium)

Chế độ thưởng ngay lập tức: Mọi khoản thặng dư của ngày hôm trước được dồn **toàn bộ** vào ngày tiếp theo. Nếu bội chi, khoản âm được chia đều khấu trừ cho các ngày còn lại để bảo vệ người dùng không bị sốc ngân sách.

#### Công thức:
```text
baseSchedule = pool.divideEvenly(totalDays)
carry(d)     = allowance(d - 1) − outflow(d - 1)

Nếu carry(d) >= 0:
  allowance(d) = baseSchedule[d] + carry(d)
Nếu carry(d) < 0:
  deductionParts = (-carry).divideEvenly(remainingDays)
  baseSchedule[k] = baseSchedule[k] - deductionParts[k - d] (cho k từ d đến cuối kỳ)
  allowance(d) = max(0, baseSchedule[d])
```

#### Minh họa Đầu vào $\rightarrow$ Đầu ra:
Giả sử Pool là `$1,500.00` cho kỳ 30 ngày $\rightarrow$ Hạn mức cơ sở `base = $50.00/ngày`.

1. **Trường hợp 1: Tích lũy thặng dư (Surplus Boost)**
   - **Ngày 1:** Hạn mức `$50.00`. Người dùng chỉ tiêu `$10.00` $\rightarrow$ Thặng dư cuối ngày là `carry = +$40.00`.
   - **Ngày 2:**
     $$\text{allowance}(2) = \text{base} + \text{carry} = \$50.00 + \$40.00 = \mathbf{\$90.00}$$
     *(Người dùng được cấp hạn mức $90.00 cho ngày 2 để tự thưởng).*

2. **Trường hợp 2: Bội chi (Overspent Deficit Amortization)**
   - **Ngày 1:** Hạn mức `$50.00`. Người dùng đi tiệc tiêu `$80.00` $\rightarrow$ Bội chi `carry = -$30.00`.
   - Khoản âm `$30.00` được chia đều cho 29 ngày còn lại: `-$30.00 / 29 ≈ -$1.03/ngày`.
   - **Ngày 2:**
     $$\text{allowance}(2) = \$50.00 - \$1.03 = \mathbf{\$48.97}$$
     *(Hạn mức giảm nhẹ xuống $48.97/ngày thay vì bị trừ đứt $30 vào ngày 2).*

---

### 📌 Ví dụ 3: Fixed Mode với `RolloverMode.save` (Save It — Premium)

Chế độ rèn luyện kỷ luật chi tiêu: Cuối mỗi ngày, bất kỳ khoản tiền nào chưa tiêu hết được tự động chuyển thẳng vào mục tiêu tiết kiệm (`Goal`), giữ hạn mức mỗi ngày luôn ổn định và không tăng lên.

#### Nguyên tắc cốt lõi (ADR-002):
- Khoản tích lũy `derivedGoalSaved` là **dữ liệu dẫn xuất**, tính toán động khi chạy engine, **không lưu record rác vào database**.
- Nếu không có mục tiêu nào đang active (`goal == null`), engine tự động rơi về cơ chế `spread`.

#### Minh họa Đầu vào $\rightarrow$ Đầu ra:
- Pool: `$1,500.00` / 30 ngày $\rightarrow$ `base = $50.00/ngày`. Mục tiêu tiết kiệm `Goal(targetAmount: $2,000)`.
- **Ngày 1:** Hạn mức `$50.00`. Người dùng chi tiêu `$35.00` $\rightarrow$ Thặng dư cuối ngày là `$15.00`.
- **Kết quả Ngày 2:**
  - Tiết kiệm tự động ghi nhận: `goalProgress.savedAmount` tăng thêm **`+$15.00`**.
  - **Hạn mức Ngày 2:** Vẫn giữ nguyên ở mức cơ sở chuẩn **`$50.00`** (không bị tăng lên `$65` như Tomorrow hay `$50.51` như Spread).

---

## 5. Chế độ Thu nhập Không Đều (`IncomeMode.irregular`)

Dành riêng cho Freelancers, Gig workers hoặc người làm kinh doanh tự do với dòng thu nhập biến động và không theo chu kỳ lương cố định.

### A. Thuật toán Cửa sổ An toàn ($H = \text{safetyHorizonDays}$)

Engine không chia theo kỳ lương mà liên tục tính toán số dư thực tế theo ngày và phân bổ số dư khả dụng qua cửa sổ trượt $H$ ngày (mặc định $H = 14$ ngày).

#### 1. Tính Số dư Khả dụng Hôm nay (Rolling Balance):
$$\text{balance}(\text{today}) = \text{startingBalance} + \sum_{\text{start}}^{\text{today}} \text{incomes} - \sum_{\text{start}}^{\text{today}-1} \text{expenses} - \sum_{\text{start}}^{\text{today}-1} \text{contributions} - \sum_{\text{start}}^{\text{today}-1} \text{billsPastDue}$$

#### 2. Tính Khoản Chi Cửa sổ $H$:
$$\text{billsInWindow} = \sum \text{bill.amount} \quad (\text{đến hạn} \in [\text{today}, \text{today} + H - 1])$$
$$\text{buffer} = \text{balance}(\text{today}) > 0 \ ?\ \lfloor \text{balance} \times \frac{\text{bufferPercent}}{100} \rfloor : \$0$$
$$\text{spendable} = \text{balance}(\text{today}) - \text{billsInWindow} - \text{buffer}$$

#### 3. Phân bổ Hạn mức Ngày & Phát hiện Thâm hụt:
- Nếu $\text{spendable} \ge 0$:
  $$\text{allowanceToday} = \frac{\text{spendable}}{H} \quad (\text{chia nguyên bảo toàn cent})$$
  $$\text{safeToday} = \text{allowanceToday} - \text{spentToday} - \text{contributionsToday}$$
- Nếu $\text{spendable} < 0$ (Thiếu hụt dòng tiền):
  $$\text{shortfall} = \text{true}, \quad \text{shortfallAmount} = |\text{spendable}|$$
  $$\text{dailyAllowanceToday} = \$0, \quad \text{safeToday} = -\text{spentToday}, \quad \text{status} = \text{BudgetStatus.over}$$

---

### 📌 Ví dụ 4: Irregular Mode — Dòng tiền Biến động & Thâm hụt

#### Kịch bản Đầu vào:
- **Số dư ban đầu (`startingBalance`):** `$800.00` (`80,000` cents).
- **Cửa sổ an toàn ($H$):** 14 ngày.
- **Quỹ dự phòng an toàn:** `10%`.
- **Hóa đơn trong 14 ngày tới:** Internet `$60.00` (ngày 5) và Điện nước `$100.00` (ngày 10) $\rightarrow$ Tổng bill trong window = `$160.00`.

#### Mã nguồn:
```dart
final irregularInput = EngineInput(
  config: const BudgetConfig(
    currency: 'USD',
    incomeMode: IncomeMode.irregular,
    startingBalance: Money(80000), // $800.00
    trackingStartDate: LocalDate(2026, 10, 1),
    safetyHorizonDays: 14,
    bufferPercent: 10,
  ),
  bills: const [
    Bill(
      id: 'b1',
      name: 'Internet',
      amount: Money(6000), // $60.00
      recurrence: BillRecurrence.monthly,
      firstDueDate: LocalDate(2026, 10, 5),
    ),
    Bill(
      id: 'b2',
      name: 'Electricity',
      amount: Money(10000), // $100.00
      recurrence: BillRecurrence.monthly,
      firstDueDate: LocalDate(2026, 10, 10),
    ),
  ],
);
```

#### 1. Tính toán Ngày Thường (`2026-10-01`):
- $\text{Buffer} = \$800.00 \times 10\% = \$80.00$.
- $\text{spendable} = \$800.00 - \$160.00 - \$80.00 = \$560.00$.
- Hạn mức ngày:
  $$\text{dailyAllowanceToday} = \frac{\$560.00}{14} = \mathbf{\$40.00 / \text{ngày}}$$
- Snapshot: `dailyAllowanceToday = $40.00`, `safeToday = $40.00`, `status = BudgetStatus.onTrack`, `shortfall = false`.

#### 2. Nhận Thêm Thu Nhập Bất Ngờ Trong Ngày:
- Đến chiều ngày 1, người dùng nhận thanh toán freelance `+$350.00`:
  ```dart
  final updatedInput = irregularInput.copyWith(
    incomes: const [
      IncomeEntry(id: 'inc1', amount: Money(35000), receivedOn: LocalDate(2026, 10, 1)),
    ],
  );
  ```
- Số dư tăng ngay lên: `$800.00 + $350.00 = $1,150.00`.
- $\text{Buffer mới} = \$1,150.00 \times 10\% = \$115.00$.
- $\text{spendable mới} = \$1,150.00 - \$160.00 - \$115.00 = \$875.00$.
- Hạn mức mới lập tức nhảy lên:
  $$\text{dailyAllowanceToday} = \frac{\$875.00}{14} = \mathbf{\$62.50 / \text{ngày}}$$
  *(Không cần cấu hình lại kỳ, engine tự động thích ứng với dòng tiền).*

#### 3. Tình Huống Cảnh Báo Thâm Hụt (Shortfall):
- Nếu số dư hiện có chỉ là `$100.00`, trong khi hóa đơn 14 ngày tới cần trả `$250.00`:
- $\text{spendable} = \$100.00 - \$250.00 - \$10.00 = -\$160.00 < 0$.
- Kết quả trả về:
  - `dailyAllowanceToday = $0.00`
  - `safeToday = $0.00` (hoặc âm nếu đã tiêu)
  - `shortfall = true`
  - `shortfallAmount = $160.00`
  - `status = BudgetStatus.over`
  *(UI sẽ hiển thị cảnh báo đỏ và thông báo người dùng cần nạp thêm ít nhất $160.00 để an toàn trả hóa đơn).*

---

## 6. Các Bất Biến Tài Chính (Invariants) & Kiểm Thử

Bộ test suite của engine (`packages/budget_engine/test/`) bao gồm **50 test cases** kiểm chứng nghiêm ngặt các nguyên lý:

1. **Bất biến Bảo toàn Tiền tệ (Conservation of Money - T02-21):**
   Trong suốt một chu kỳ, nếu người dùng chi tiêu đúng bằng hạn mức mỗi ngày:
   $$\sum_{d=\text{start}}^{\text{end}} \text{allowance}(d) + \text{derivedGoalSaved} = \mathbf{Pool}$$
   Bất biến này được kiểm chứng qua **1.000 cấu hình ngẫu nhiên** (Property-based test với seed cố định).

2. **Bảo toàn Cents Tuyệt Đối (No-Cent-Leakage - T02-22):**
   Mọi phép chia đều số dư qua nhiều ngày sử dụng `Money.divideEvenly(n)`, đảm bảo phần dư cents luôn được phân bổ đầy đủ mà không mất đi hay phát sinh thêm 1 cent nào.

3. **Hiệu năng Cực Cao (Performance Benchmark - T02-23):**
   Với cấu hình chịu tải gồm **5.000 giao dịch chi tiêu** trong kỳ 31 ngày, hàm `computeSnapshot` hoàn thành trong **< 2 ms** (yêu cầu spec < 10 ms).
