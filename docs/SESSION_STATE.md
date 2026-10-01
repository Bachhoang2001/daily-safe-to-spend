# Session State
_Cập nhật: 2026-10-01 · Spec vừa xong: 002 · Spec tiếp theo: 003_

## Tiến độ
| Spec | Feature | Trạng thái | Tests (pass/total) | Analyze (warnings) | Ngày |
|------|---------|------------|--------------------|--------------------|------|
| 001 | Project foundation & bộ nhớ dự án | DONE | 2/2 | 0 | 2026-10-01 |
| 002 | Core primitives | DONE | 12/12 | 0 | 2026-10-01 |
| 003 | Budget engine | TODO | – | – | – |
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
- **Quy ước Git:** Xong mỗi spec (tính năng), USER sẽ tự thực hiện `git commit` và `git push` code. Agent tuyệt đối không tự ý chạy git commit hoặc push.

## Known issues / Tech debt
- Không có issue hoặc tech debt phát sinh từ Spec 002. Đạt 100% test pass (12/12) và 0 analyze issue.
- Các tính năng mở rộng ngoài MVP đã ghi nhận trong `docs/BACKLOG.md`.

## Next
- Spec 003 · Budget Engine (package Dart thuần) (file `specs/003-budget-engine.md`).
