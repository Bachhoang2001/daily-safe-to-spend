# Spec 002 · F01 — Core primitives: Money, LocalDate, Clock, UUID

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 002
> **Phụ thuộc:** Spec 001 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

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
- [ ] Coverage ≥ 95% cho Money và LocalDate
- [ ] Không file nào trong `lib/` dùng `double` cho tiền (thêm lint rule hoặc grep check trong CI)
- [ ] Tài liệu dartdoc cho mọi API public

**Remember:** ghi vào `docs/SESSION_STATE.md` (mục Knowledge) cách dùng `Money`, `LocalDate`, `Clock` kèm ví dụ ngắn.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
