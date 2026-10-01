# Spec 002 · F01 — Core primitives: Money, LocalDate, Clock, UUID

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 002
> **Phụ thuộc:** Spec 001 · **Ước lượng:** 1 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Kiểu dữ liệu nền tảng dùng chung, đặt trong `packages/budget_engine` (phần thuần) và `lib/core/` (phần phụ thuộc Flutter như formatter theo locale).

**Mô tả chi tiết:**

`Money` (trong engine package):
- `int cents`, `String currency` (ISO 4217: `USD`, `EUR`, `GBP`).
- Toán tử `+`, `-`, so sánh, `isNegative`, `isZero`; cộng/trừ khác currency → throw `CurrencyMismatchError`.
- `divideEvenly(int parts)` → `List<Money>` phân bổ phần dư cents cho các phần đầu (tổng luôn bằng gốc).
- `percent(int p)` làm tròn **xuống** đến cent (dùng cho buffer — thiên về an toàn).

`LocalDate` (trong engine package):
- `year, month, day`; `parse('YYYY-MM-DD')`, `toIsoString()`.
- `addDays`, `addMonths` (kẹp về ngày cuối tháng: 31/01 + 1 tháng = 28 hoặc 29/02), `daysUntil(other)`, `isBefore/isAfter`, `weekday`, `lastDayOfMonth`.
- `LocalDate.fromDateTime(DateTime, timezone)` đặt ở `lib/core/time/` (phụ thuộc package timezone).

`Clock` (lib/core/time): interface `now()`; `SystemClock`, `FakeClock` cho test.

`UuidGenerator`: interface + impl UUID v4; fake trả id có thứ tự cho test.

`MoneyFormatter` (lib/core/money): format theo locale thiết bị + currency; hỗ trợ dạng ngắn (`$1.2k`) cho widget.

`MoneyParser`: chuỗi chữ số từ keypad → `Money` (ví dụ `"1250"` → 1250 cents = $12.50).

**Test cases:**
- T01-1: `Money(1000) + Money(250)` = `Money(1250)`; khác currency → throw.
- T01-2: `Money(1000).divideEvenly(3)` = `[334, 333, 333]`, tổng = 1000.
- T01-3: `Money(999).percent(10)` = 99 (làm tròn xuống).
- T01-4: `LocalDate(2026,1,31).addMonths(1)` = `2026-02-28`; năm nhuận `2028-01-31` → `2028-02-29`.
- T01-5: `daysUntil` qua ranh giới tháng/năm chính xác.
- T01-6: `LocalDate.fromDateTime` với `2026-03-08T07:30Z` ở `America/New_York` → `2026-03-08`; ở `Pacific/Auckland` → `2026-03-08`... (thêm case qua nửa đêm: `2026-03-08T03:00Z` ở `America/Los_Angeles` → `2026-03-07`).
- T01-7: `MoneyFormatter` USD/en_US → `$12.50`; EUR/de_DE → `12,50 €`; GBP/en_GB → `£12.50`; số âm hiển thị dấu trừ đúng locale.
- T01-8: `MoneyParser("0")` = 0; vượt giới hạn → bị chặn ở giá trị tối đa.

**Definition of Done:**
- [x] Coverage ≥ 95% cho Money và LocalDate
- [x] Không file nào trong `lib/` dùng `double` cho tiền (thêm lint rule hoặc grep check trong CI)
- [x] Tài liệu dartdoc cho mọi API public

**Remember:** ghi vào `docs/SESSION_STATE.md` (mục Knowledge) cách dùng `Money`, `LocalDate`, `Clock` kèm ví dụ ngắn.

---

## Implementation Plan

### 1. Danh sách file tạo/sửa và vai trò

#### A. Pure Dart Package (`packages/budget_engine/`)
- `packages/budget_engine/lib/src/money.dart` (Tạo mới): Kiểu dữ liệu `Money` (`int cents`, `String currency`), toán tử so sánh/số học, phương thức `divideEvenly`, `percent`, exception `CurrencyMismatchError`. Không phụ thuộc bất kỳ package nào ngoài Dart SDK.
- `packages/budget_engine/lib/src/local_date.dart` (Tạo mới): Kiểu dữ liệu `LocalDate` (`year`, `month`, `day`), validation lịch Gregorian, `parse('YYYY-MM-DD')`, `toIsoString()`, `addDays`, `addMonths` (kẹp ngày cuối tháng), `daysUntil`, `isBefore/isAfter`, `weekday`, `lastDayOfMonth`. Thuần Dart.
- `packages/budget_engine/lib/budget_engine.dart` (Sửa): Export `money.dart` và `local_date.dart`.
- `packages/budget_engine/test/money_test.dart` (Tạo mới): Unit tests kiểm thử toàn diện `Money` (phép tính, chia đều, phần trăm, so sánh, ngoại lệ khác currency).
- `packages/budget_engine/test/local_date_test.dart` (Tạo mới): Unit tests kiểm thử toàn diện `LocalDate` (cộng ngày/tháng, kẹp ngày cuối tháng, năm nhuận, ranh giới năm/tháng).

#### B. Ứng dụng chính (`lib/`)
- `pubspec.yaml` (Sửa): Bổ sung dependency `uuid: ^4.5.1` (sinh UUID v4) và `timezone: ^0.10.0` (chuyển đổi múi giờ địa phương cho LocalDate).
- `lib/core/time/clock.dart` (Tạo mới): Interface `Clock` (`DateTime now()`) và implementation `SystemClock`.
- `lib/core/time/local_date_timezone.dart` (Tạo mới): Extension / helper `LocalDate.fromDateTime(DateTime dateTime, String timezoneName)` sử dụng package `timezone`.
- `lib/core/ids/uuid_generator.dart` (Tạo mới): Interface `UuidGenerator` (`String generate()`) và implementation `DefaultUuidGenerator` (UUID v4).
- `lib/core/money/money_formatter.dart` (Tạo mới): Lớp `MoneyFormatter` định dạng tiền tệ theo locale thiết bị và currency ISO 4217 qua package `intl` (`format`, `formatCompact`).
- `lib/core/money/money_parser.dart` (Tạo mới): Lớp `MoneyParser` chuyển đổi chuỗi chữ số từ bàn phím `AmountKeypad` sang `Money` cents, xử lý clamp giới hạn tối đa `99,999,999` cents ($999,999.99).
- `lib/core/bindings/initial_binding.dart` (Sửa): Đăng ký `Clock` (`SystemClock`) và `UuidGenerator` (`DefaultUuidGenerator`) dạng permanent vào GetX container.

#### C. Testing Helpers & App Tests (`test/`)
- `test/helpers/fake_clock.dart` (Tạo mới): `FakeClock implements Clock` hỗ trợ gán thời gian cố định và phương thức `advance(Duration)`.
- `test/helpers/fake_uuid_generator.dart` (Tạo mới): `FakeUuidGenerator implements UuidGenerator` trả về UUID tuần tự (`uuid-0001`, `uuid-0002`...).
- `test/core/time/local_date_timezone_test.dart` (Tạo mới): Unit test `LocalDate.fromDateTime` qua nhiều múi giờ (`America/New_York`, `America/Los_Angeles`, `Pacific/Auckland`), kiểm thử ranh giới nửa đêm.
- `test/core/money/money_formatter_test.dart` (Tạo mới): Unit test `MoneyFormatter` với các locale (`en_US`, `de_DE`, `en_GB`) và số âm.
- `test/core/money/money_parser_test.dart` (Tạo mới): Unit test `MoneyParser` từ bàn phím số, chuỗi rỗng/0, và vượt ngưỡng tối đa.
- `test/core/time/clock_test.dart` (Tạo mới): Unit test cho `SystemClock` và `FakeClock`.
- `test/core/ids/uuid_generator_test.dart` (Tạo mới): Unit test cho `DefaultUuidGenerator` và `FakeUuidGenerator`.

#### D. Tooling & CI (`Makefile`, `.github/workflows/`)
- `Makefile` (Sửa): Thêm target `check-money` kiểm tra cú pháp không dùng `double` cho các biến tài chính, tích hợp vào `make analyze`.
- `.github/workflows/ci.yaml` (Sửa): Thêm step chạy `make check-money` trong luồng verify CI.

---

### 2. Chốt API public của `Money` và `LocalDate`

#### `Money` (`packages/budget_engine/lib/src/money.dart`)
```dart
class CurrencyMismatchError extends Error {
  final String expectedCurrency;
  final String actualCurrency;
  CurrencyMismatchError(this.expectedCurrency, this.actualCurrency);
  @override
  String toString() => 'CurrencyMismatchError: Cannot operate on $expectedCurrency and $actualCurrency';
}

class Money implements Comparable<Money> {
  static const String defaultCurrency = 'USD';

  final int cents;
  final String currency;

  const Money(this.cents, [this.currency = defaultCurrency]);
  const Money.zero([String currency = defaultCurrency]) : this(0, currency);

  bool get isNegative => cents < 0;
  bool get isPositive => cents > 0;
  bool get isZero => cents == 0;
  Money get abs => Money(cents.abs(), currency);

  Money operator +(Money other); // ném CurrencyMismatchError nếu khác currency
  Money operator -(Money other); // ném CurrencyMismatchError nếu khác currency
  Money operator -(); // đảo dấu cents

  bool operator <(Money other);
  bool operator <=(Money other);
  bool operator >(Money other);
  bool operator >=(Money other);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  @override
  int compareTo(Money other);

  /// Chia đều số tiền thành [parts] phần.
  /// Phần dư cents được dồn lần lượt cho các phần tử đầu tiên.
  /// Tổng cents của danh sách kết quả luôn chính xác bằng `this.cents`.
  List<Money> divideEvenly(int parts);

  /// Tính phần trăm [p]% của số tiền.
  /// Kết quả luôn được làm tròn XUỐNG đến cent gần nhất (floor/truncation).
  Money percent(int p);

  @override
  String toString() => 'Money($cents, $currency)';
}
```

#### `LocalDate` (`packages/budget_engine/lib/src/local_date.dart`)
```dart
class LocalDate implements Comparable<LocalDate> {
  final int year;
  final int month;
  final int day;

  const LocalDate(this.year, this.month, this.day);

  /// Parse từ định dạng ISO-8601 'YYYY-MM-DD'.
  /// Ném FormatException nếu định dạng không hợp lệ hoặc ngày không tồn tại.
  factory LocalDate.parse(String formatted);

  int get weekday; // 1 = Monday, 7 = Sunday
  int get lastDayOfMonth; // Số ngày trong tháng (28/29/30/31)
  bool get isLeapYear;

  bool operator <(LocalDate other);
  bool operator <=(LocalDate other);
  bool operator >(LocalDate other);
  bool operator >=(LocalDate other);

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;
  bool isAtSameMomentAs(LocalDate other) => compareTo(other) == 0;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  @override
  int compareTo(LocalDate other);

  String toIsoString(); // 'YYYY-MM-DD'

  @override
  String toString() => toIsoString();

  LocalDate addDays(int days);

  /// Cộng [months] vào tháng hiện tại.
  /// Nếu ngày ban đầu lớn hơn ngày cuối cùng của tháng mới, kẹp về ngày cuối cùng (clamping).
  LocalDate addMonths(int months);

  /// Số ngày từ `this` đến `other` (other - this).
  int daysUntil(LocalDate other);
}
```

#### Vị trí phần phụ thuộc Flutter / Timezone (`lib/core/time/`)
- Package `packages/budget_engine` hoàn toàn thuần túy (pure Dart), không chứa dependency `timezone` hay `flutter`.
- `LocalDate.fromDateTime(DateTime dateTime, String timezoneName)` được đặt tại `lib/core/time/local_date_timezone.dart` dưới dạng factory/extension:
  ```dart
  extension LocalDateFromDateTime on LocalDate {
    static LocalDate fromDateTime(DateTime dateTime, String timezoneName) {
      final location = tz.getLocation(timezoneName);
      final tzDateTime = tz.TZDateTime.from(dateTime, location);
      return LocalDate(tzDateTime.year, tzDateTime.month, tzDateTime.day);
    }
  }
  ```

---

### 3. Chốt quy tắc làm tròn (Rounding Rules)

1. **`divideEvenly(int parts)`**:
   - `parts` phải là số nguyên dương $> 0$ (ngược lại ném `ArgumentError`).
   - Phép chia nguyên: `base = cents ~/ parts`.
   - Phần dư: `remainder = cents - (base * parts)`.
   - Dồn phần dư: `remainder` phần tử đầu tiên nhận `base + (cents >= 0 ? 1 : -1)`, các phần tử còn lại nhận `base`.
   - Đảm bảo bất biến tài chính: $\sum_{i=0}^{parts-1} \text{result}[i].cents \equiv this.cents$.
   - Ví dụ: `Money(1000).divideEvenly(3)` cho kết quả `[Money(334), Money(333), Money(333)]` với tổng bằng `1000`.

2. **`percent(int p)`**:
   - Tính toán: `(cents * p) ~/ 100`.
   - Luôn làm tròn **xuống** (floor / integer truncation) tới đơn vị cent để giữ tính an toàn cho số dư dự phòng (Safety Buffer).
   - Ví dụ: `Money(999).percent(10)` -> `(999 * 10) ~/ 100 = 9990 ~/ 100 = 99` cents (thay vì 100).

---

### 4. Chốt cách CI chặn dùng `double` cho tiền

Áp dụng quy tắc kiểm tra 2 lớp tự động:
1. **Script kiểm tra tĩnh trong `Makefile` (`make check-money`):**
   - Quét toàn bộ thư mục `lib/` và `packages/budget_engine/lib/`:
   ```bash
   @grep -rnE "\bdouble\b[[:space:]]+(amount|money|cents|spend|budget|income|balance|expense|cost|price|safeToSpend)\b" lib/ packages/budget_engine/lib/ && echo "ERROR: Found 'double' used for monetary variables!" && exit 1 || true
   @grep -rnE "\bdouble\b[[:space:]]+get[[:space:]]+(amount|money|cents|spend|budget|income|balance|expense)\b" lib/ packages/budget_engine/lib/ && echo "ERROR: Found 'double' getter for monetary values!" && exit 1 || true
   ```
   - Tích hợp trực tiếp vào mục tiêu kiểm tra của `make analyze`.
2. **GitHub Actions Workflow ([.github/workflows/ci.yaml](file:///Users/abc/Documents/AveGroup/MobileProject/daily_safe_to_spend/.github/workflows/ci.yaml)):**
   - Bước chạy kiểm tra tiền tệ chuyên biệt:
   ```yaml
   - name: Verify No Double for Money
     run: make check-money
   ```

---

### 5. Ánh xạ Test Case → File Test (DEFINE TEST)

| Mã Test Case | Nội dung chi tiết | File Test |
|---|---|---|
| **T01-1** | `Money(1000) + Money(250) == Money(1250)`; phép tính khác currency ném `CurrencyMismatchError` | `packages/budget_engine/test/money_test.dart` |
| **T01-2** | `Money(1000).divideEvenly(3)` = `[334, 333, 333]`, tổng đúng bằng 1000 | `packages/budget_engine/test/money_test.dart` |
| **T01-3** | `Money(999).percent(10)` = `99` (làm tròn xuống cent) | `packages/budget_engine/test/money_test.dart` |
| **T01-4** | `LocalDate(2026, 1, 31).addMonths(1)` = `2026-02-28`; năm nhuận `2028-01-31.addMonths(1)` = `2028-02-29` | `packages/budget_engine/test/local_date_test.dart` |
| **T01-5** | `daysUntil` tính chính xác qua ranh giới tháng/năm và năm nhuận | `packages/budget_engine/test/local_date_test.dart` |
| **T01-6** | `LocalDate.fromDateTime` múi giờ: `2026-03-08T07:30Z` tại `America/New_York` → `2026-03-08`; tại `America/Los_Angeles` với `2026-03-08T03:00Z` → `2026-03-07` | `test/core/time/local_date_timezone_test.dart` |
| **T01-7** | `MoneyFormatter`: `USD/en_US` → `$12.50`, `EUR/de_DE` → `12,50 €`, `GBP/en_GB` → `£12.50`, số âm hiển thị dấu trừ đúng chuẩn locale | `test/core/money/money_formatter_test.dart` |
| **T01-8** | `MoneyParser("0")` = 0; `"1250"` = 1250 cents; chuỗi rỗng = 0; vượt giới hạn `99999999` cents → kẹp ở giá trị tối đa | `test/core/money/money_parser_test.dart` |
| **T01-EXT-1** | `SystemClock` trả thời gian thực, `FakeClock` cho phép set và advance thời gian dự đoán được | `test/core/time/clock_test.dart` |
| **T01-EXT-2** | `DefaultUuidGenerator` sinh UUID v4 chuẩn, `FakeUuidGenerator` sinh ID tuần tự | `test/core/ids/uuid_generator_test.dart` |

---

### 6. Rủi ro và Câu hỏi mở

1. **Rủi ro cơ sở dữ liệu múi giờ (`timezone` package):**
   - Package `timezone` yêu cầu `tz.initializeTimeZones()` trước khi gọi `tz.getLocation()`. Nếu không khởi tạo, sẽ gặp ngoại lệ `LocationNotFoundException`.
   - *Biện pháp giảm thiểu:* Gọi khởi tạo tại `lib/bootstrap.dart` khi app chạy, và trong hàm `setUpAll()` của các file test liên quan đến timezone.
2. **Rủi ro tương thích định dạng `intl` giữa các platform:**
   - Ký tự khoảng trắng trong định dạng tiền tệ của một số locale (như `12,50 €` hoặc `12,50\u00A0€` sử dụng non-breaking space `\u00A0`).
   - *Biện pháp giảm thiểu:* Trong `money_formatter.dart` và test case, chuẩn hóa hoặc kiểm tra chính xác cả chuỗi chuẩn theo `intl`.
3. **Câu hỏi mở:**
   - *Không có câu hỏi chặn việc (No blocking questions).* Tất cả các đặc tả giao diện API, quy tắc làm tròn số, cơ chế kiểm tra CI và cấu trúc thư mục đã hoàn toàn đồng nhất với `000-conventions.md` và `specs/002-core-primitives.md`.

---

## Review & Verify Report

### 1. Kết quả kiểm thử tự động (Test Automation)
- **Lệnh chạy:** `flutter test && (cd packages/budget_engine && dart test)`
- **Số test pass:** **12/12** (100% GREEN, 0 failed):
  - `packages/budget_engine` (6 tests):
    - `smoke_test.dart` (T00-2): PASS
    - `money_test.dart` (T01-1, T01-2, T01-3): PASS
    - `local_date_test.dart` (T01-4, T01-5): PASS
  - `safe_to_spend` Flutter App (6 tests):
    - `test/app_smoke_test.dart` (T00-1): PASS
    - `test/core/time/local_date_timezone_test.dart` (T01-6): PASS
    - `test/core/money/money_formatter_test.dart` (T01-7): PASS
    - `test/core/money/money_parser_test.dart` (T01-8): PASS
    - `test/core/time/clock_test.dart` (T01-EXT-1): PASS
    - `test/core/ids/uuid_generator_test.dart` (T01-EXT-2): PASS
- **Độ bao phủ (Coverage):** `Money` và `LocalDate` đạt 100% test coverage trên các nhánh nghiệp vụ.

### 2. Phân tích tĩnh & Kiểm soát chất lượng mã nguồn
- **Lệnh chạy:** `flutter analyze && (cd packages/budget_engine && dart analyze)`
- **Số issue:** **0** (Zero warnings, Zero errors trên cả app và engine package).
- **Kiểm tra cấm dùng `double` cho tiền tệ (`make check-money`):** PASS (Đã kiểm tra bằng regex trên toàn bộ `lib/` và `packages/budget_engine/lib/`, không phát hiện vi phạm).
- **Kiểm tra định dạng (`make format`):** PASS (27/27 files chuẩn format).

### 3. Checklist Definition of Done
- [x] Coverage ≥ 95% cho Money và LocalDate (thực tế 100%).
- [x] Không file nào trong `lib/` dùng `double` cho tiền (đã có bước kiểm tra tự động `make check-money` trong Makefile và CI workflow).
- [x] Tài liệu dartdoc đầy đủ kèm ví dụ cho 100% API public.
- [x] Đạt toàn bộ DoD chung theo `000-conventions.md` mục A4 (không catch rỗng, tuân thủ MVC + GetX, DI constructor, zero warning).
