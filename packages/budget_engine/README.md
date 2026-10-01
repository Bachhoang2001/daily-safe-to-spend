# Budget Engine (`packages/budget_engine`)

Package Dart thuần (Pure Dart) chứa toàn bộ lõi thuật toán tính toán tài chính của ứng dụng **Daily Safe-to-Spend**.

---

## 1. Nguyên tắc thiết kế (Core Design Principles)

* **Zero Dependencies on Flutter:** Không import bất kỳ thư viện nào từ Flutter SDK hay GetX.
* **Deterministic & Pure:** Hàm tính toán `computeSnapshot(input, today)` là một hàm thuần (pure function) — không I/O, không gọi cơ sở dữ liệu, không đọc đồng hồ hệ thống `DateTime.now()`.
* **Zero Float:** Toàn bộ số tiền nghiệp vụ được tính toán dưới dạng số nguyên `cents` (`Money`), không bao giờ sử dụng số thực `double`.
* **Day-by-Day Simulation:** Engine mô phỏng chi tiêu tuần tự từng ngày từ đầu chu kỳ đến ngày hiện tại để các chế độ rollover (tích lũy/chia đều) đạt tính tất định 100%.

---

## 2. Các kiểu dữ liệu nền tảng (Core Primitives)

### `Money` (`src/money.dart`)
* Bất biến (immutable), lưu trữ số tiền dưới dạng số nguyên `cents` (ví dụ: `$12.50 = 1250` cents).
* Đi kèm mã tiền tệ chuẩn ISO 4217 (`USD`, `EUR`, `GBP`...).
* Hỗ trợ đầy đủ các phép toán số học `+`, `-`, đổi dấu `-()`, và các toán tử so sánh `<`, `<=`, `>`, `>=`.
* **An toàn loại tiền tệ (Currency Safety):** Phép tính giữa hai số tiền khác loại tiền tệ sẽ ném ngoại lệ `CurrencyMismatchError`.
* **`divideEvenly(int parts)`:** Phân bổ phần dư cents cho các phần tử đầu tiên sao cho tổng các phần tử luôn bảo toàn chính xác bằng `cents` gốc.
  ```dart
  const total = Money(1000); // $10.00
  final split = total.divideEvenly(3);
  // [Money(334), Money(333), Money(333)] -> tổng = 1000
  ```
* **`percent(int p)`:** Tính phần trăm và luôn làm tròn **xuống** (floor) đến cent gần nhất để giữ tính an toàn cho quỹ dự phòng.
  ```dart
  const amount = Money(999);
  final buffer = amount.percent(10); // Money(99)
  ```

### `LocalDate` (`src/local_date.dart`)
* Bất biến (immutable), đại diện cho ngày dương lịch thuần túy (`year`, `month`, `day`).
* Không chứa múi giờ hay giờ/phút/giây, không bị ảnh hưởng bởi Daylight Saving Time (DST).
* Hỗ trợ `parse('YYYY-MM-DD')` và `toIsoString()`.
* **`addMonths(int months)`:** Tự động kẹp về ngày cuối cùng của tháng mới (clamping) khi tháng đích có ít ngày hơn:
  ```dart
  const jan31 = LocalDate(2026, 1, 31);
  jan31.addMonths(1); // 2026-02-28 (năm thường)
  const jan31Leap = LocalDate(2028, 1, 31);
  jan31Leap.addMonths(1); // 2028-02-29 (năm nhuận)
  ```
* **`daysUntil(LocalDate other)`:** Tính số ngày giữa hai mốc thời gian một cách chuẩn xác qua ranh giới tháng, năm và năm nhuận.
* Các toán tử so sánh thời gian: `isBefore`, `isAfter`, `isAtSameMomentAs`, `<`, `<=`, `>`, `>=`.

---

## 3. Các chế độ thu nhập & Ví dụ Đầu vào → Đầu ra

### A. Chế độ Thu nhập cố định (`IncomeMode.fixed`)

#### Công thức tính Pool khả dụng của kỳ:
```text
income      = (kỳ chứa trackingStartDate) ? firstPeriodBalance : incomePerPaycheck
bills       = Σ hóa đơn có ngày đến hạn ∈ [periodStart, periodEnd]
goalReserve = goal?.perPaycheckAmount ?? 0
buffer      = income * (bufferPercent / 100) (làm tròn xuống cent)
pool        = income − bills − goalReserve − buffer
```

#### Ví dụ minh họa:
* **Đầu vào:**
  * Lương hàng tháng: `$3,000.00` (nhận ngày 01 hàng tháng).
  * Hóa đơn cố định trong tháng: `$1,200.00` (tiền nhà, internet, điện nước).
  * Trích quỹ tiết kiệm (`goalReserve`): `$200.00` / kỳ.
  * Dự phòng an toàn (`bufferPercent`): `5%` (`$3,000 * 5% = $150.00`).
  * Chu kỳ: 30 ngày (từ 01/10 đến 30/10).
  * Hôm nay là ngày 01/10 (`today = Day 1`).
* **Tính toán Pool:**
  $$\text{Pool} = \$3,000 - \$1,200 - \$200 - \$150 = \$1,450.00 \text{ (145,000 cents)}$$
* **Hạn mức ngày 1 (`dailyAllowanceToday`):**
  $$\text{allowance}(1) = \frac{\$1,450.00}{30} = \$48.33 / \text{ngày}$$
* **Đầu ra ngày 1:**
  * Nếu chưa tiêu gì: `safeToday = $48.33`, `status = onTrack`.
  * Nếu tiêu `$18.33`: `safeToday = $30.00`, `spentToday = $18.33`.

---

### B. Các chế độ Rollover (Chuyển tiếp số dư cuối ngày)

#### 1. Chế độ `RolloverMode.spread` (Mặc định)
Số dư thừa (hoặc bội chi) của ngày hôm trước được chia đều lại cho toàn bộ các ngày còn lại trong kỳ:
$$\text{allowance}(d) = \frac{\text{pool} - \text{spentBefore}(d)}{\text{daysLeftInclDay}(d)}$$

* **Kịch bản Tiêu ít hơn hạn mức:**
  * Ngày 1 hạn mức `$48.33`, người dùng chỉ tiêu `$8.33` (dư `$40.00`).
  * Còn lại 29 ngày trong kỳ: Phần dư `$40.00` được rải đều:
    $$\text{allowance}(2) = \frac{\$1,450.00 - \$8.33}{29} = \frac{\$1,441.67}{29} \approx \$49.71$$
    *(Hạn mức mỗi ngày từ ngày 2 đến ngày 30 tăng từ $48.33 lên ~$49.71)*.
* **Kịch bản Bội chi (Overspent):**
  * Ngày 1 hạn mức `$48.33`, người dùng đi ăn tiệc tiêu `$148.33` (bội chi `$100.00`).
  * `safeToday(1) = -$100.00`, `status = BudgetStatus.over`.
  * Ngày 2 hạn mức tự động co lại để bù đắp:
    $$\text{allowance}(2) = \frac{\$1,450.00 - \$148.33}{29} = \frac{\$1,301.67}{29} \approx \$44.88$$

---

#### 2. Chế độ `RolloverMode.tomorrow` (Tomorrow Boost — Premium)
Số dư thừa của ngày hôm trước được cộng dồn toàn bộ vào ngày hôm sau nhằm thưởng cho người dùng. Nếu bội chi, khoản âm được chia đều cho các ngày còn lại:
```text
base     = pool / totalDaysInPeriod
carry(d) = allowance(d - 1) - spent(d - 1)

Nếu carry(d) > 0: allowance(d) = baseAdjusted + carry(d)
Nếu carry(d) < 0: phần bội chi được trừ đều vào các ngày còn lại
```

* **Ví dụ:**
  * Base chuẩn: `$50.00 / ngày`.
  * Ngày 1 hạn mức `$50.00`, tiêu `$10.00` $\rightarrow$ Thặng dư `+$40.00`.
  * **Hạn mức Ngày 2:** `$50.00 + $40.00 = $90.00` *(Có thể tiêu xả láng vào ngày mai)*.
  * Nếu Ngày 2 tiêu hết `$30.00` $\rightarrow$ Thặng dư ngày 2 là `+$60.00` dồn tiếp sang Ngày 3.

---

#### 3. Chế độ `RolloverMode.save` (Save It — Premium)
Mỗi ngày sống dưới hạn mức, phần tiền dư tự động chuyển vào mục tiêu tiết kiệm (`Goal`), giữ nguyên nhịp sống ổn định:

* **Ví dụ:**
  * Base chuẩn: `$50.00 / ngày`.
  * Ngày 1 hạn mức `$50.00`, chỉ tiêu `$35.00` $\rightarrow$ Thặng dư `$15.00`.
  * Cuối ngày 1: `$15.00` được chuyển trực tiếp vào `goalSaved` của Goal hiện tại.
  * **Hạn mức Ngày 2:** Vẫn giữ nguyên mức cơ bản `$50.00` (không tăng lên), rèn luyện thói quen chi tiêu kỷ luật.

---

### C. Chế độ Thu nhập không đều (`IncomeMode.irregular`)

Dành cho Freelancers hoặc người làm nghề tự do với dòng tiền không cố định. Thuật toán dựa trên **Số dư khả dụng** và **Cửa sổ bảo vệ an toàn (Safety Horizon $H = 14$ ngày)**.

#### Công thức:
```text
balance(today) = startingBalance
               + Σ income[trackingStartDate..today]
               − Σ expense[trackingStartDate..today)
               − Σ contribution[trackingStartDate..today)
               − Σ bill_due[trackingStartDate..today)

window         = [today, today + H − 1]
billsInWindow  = Σ bill có due ∈ window
buffer         = balance * (bufferPercent / 100) (nếu balance > 0)

allowanceToday = max(0, balance − billsInWindow − buffer) / H
safeToday      = allowanceToday − spentToday
```

#### Ví dụ minh họa:
* **Đầu vào:**
  * Số dư khả dụng hiện tại: `balance = $800.00`.
  * Cửa sổ an toàn: $H = 14$ ngày.
  * Dự phòng an toàn: `bufferPercent = 10%` $\rightarrow$ `$800 * 10% = $80.00`.
  * Hóa đơn cần trả trong 14 ngày tới (`billsInWindow`): `$160.00`.
* **Tính toán Hạn mức hôm nay:**
  $$\text{Tiền khả dụng} = \$800.00 - \$160.00 - \$80.00 = \$560.00$$
  $$\text{allowanceToday} = \frac{\$560.00}{14} = \$40.00 / \text{ngày}$$
* **Dòng tiền đột xuất (Thu nhập phát sinh):**
  * Buổi chiều nhận thêm thanh toán dự án `+$350.00`.
  * Số dư mới = `$1,150.00`. Hạn mức các ngày còn lại lập tức được nâng lên tự động mà không cần setup lại kỳ.
* **Kịch bản Thâm hụt (Shortfall):**
  * Số dư `$100.00`, hóa đơn cần trả `$250.00`.
  * Số dư không đủ trả hóa đơn $\rightarrow$ `allowanceToday = $0.00`, `safeToday = -$spentToday`.
  * Snapshot trả về cờ `shortfall = true` và `shortfallAmount = $150.00` để ứng dụng cảnh báo người dùng.

---

## 4. Quy ước Kiểm thử (Verification & Test Coverage)

Toàn bộ các trường hợp biên và tính bất biến toán học được kiểm chứng trong `packages/budget_engine/test/`:
1. **Bất biến tổng tiền (Conservation of Money):**
   $$\sum_{d=1}^{N} \text{allowance}(d) + \text{goalAutoSaved} = \text{Pool}$$
2. **Không thất thoát Cent:** Hàm phân bổ chia đều làm tròn không để rơi rụng hoặc sinh thêm bất kỳ 1 cent nào.
