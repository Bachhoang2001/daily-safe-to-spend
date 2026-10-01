# Spec 018 · F17 — Local notifications

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 018
> **Phụ thuộc:** Spec 015, Spec 017 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Kéo người dùng quay lại mỗi ngày (động cơ retention), không cần server.

**Loại thông báo:**

| Loại | Thời điểm | Nội dung mẫu | Ghi chú |
|---|---|---|---|
| Morning number | 08:00 (tùy chỉnh) | "You can spend $42 today." | Nội dung tính tại thời điểm lên lịch (xem dưới) |
| Evening log | 20:30 (tùy chỉnh) | "Spent anything today? Log it in 2 taps." | **Bỏ qua** nếu hôm nay đã có ≥ 1 giao dịch |
| Bill reminder | 09:00, N ngày trước hạn | "Rent ($1,200) is due tomorrow." | Theo `remind_days_before` của từng bill |
| New period | Ngày lương, 08:00 | "Payday! Your new daily number is $58." | Fixed mode; thay cho Morning number ngày đó |

**Cơ chế lên lịch (không server, không background fetch phức tạp):**
- Mỗi khi snapshot thay đổi hoặc app vào foreground → **lên lịch lại 7 ngày tới**: hủy thông báo cũ, tạo mới với nội dung tính bằng engine cho từng ngày tương lai **giả định không chi tiêu thêm** (chấp nhận sai số nhỏ; ghi ADR).
- Evening log: lên lịch cho các ngày tới; khi người dùng thêm giao dịch hôm nay → hủy evening log của hôm nay.
- Tuân giới hạn iOS 64 thông báo chờ: tổng số thông báo lên lịch ≤ 40.
- Tôn trọng quyền: nếu chưa cấp quyền → không lên lịch; trong Settings hiển thị trạng thái và nút mở cài đặt hệ thống.
- Chạm thông báo: Morning/Evening → Today (Evening mở thẳng Quick Add); Bill → tab Plan.
- **Riêng tư:** tùy chọn "Hide amounts on lock screen" (mặc định tắt) → nội dung chung "Your daily number is ready."

**Analytics:** `notification_opened` (`type`).

**Test cases:**
- T17-1: Lên lịch đúng số lượng và thời điểm cho 7 ngày (dùng fake notification plugin).
- T17-2: Thêm giao dịch hôm nay → evening log hôm nay bị hủy.
- T17-3: Bill reminder 1 ngày trước hạn lên lịch đúng.
- T17-4: Ngày lương thay morning bằng new period.
- T17-5: Không có quyền → không lên lịch gì.
- T17-6: Đổi múi giờ thiết bị → lên lịch lại theo giờ địa phương mới.
- T17-7: Hide amounts → nội dung không chứa số tiền.

**Definition of Done:**
- [ ] Kiểm tra thủ công trên thiết bị thật iOS + Android: nhận đúng giờ (ghi vào mục Review & Verify Report)
- [ ] Android 13+: xin quyền `POST_NOTIFICATIONS`; dùng exact alarm chỉ khi được phép, nếu không thì inexact

---

## Bổ sung khi chuyển sang MVC + GetX

- **Mở rộng engine:** thêm `projectNextDays(input, today, days) → List<DayProjection>` (hạn mức các ngày tới, giả định không chi thêm). Spec 019 dùng lại cho widget.
- Plugin thông báo được bọc qua `ILocalNotificationsPlugin` để test.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
