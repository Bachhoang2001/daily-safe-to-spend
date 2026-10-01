# Spec 017 · F16 — Settings

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 017
> **Phụ thuộc:** Spec 011, Spec 016 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Điều chỉnh ngân sách và ứng dụng.

**Nhóm mục:**
1. **Premium:** thẻ trạng thái (Free → "Upgrade" mở paywall; Premium → "Premium active"), "Restore purchases" (Spec 022 gắn vào).
2. **Budget:**
   - Income mode (đổi mode → wizard mini giống Spec 008, xác nhận vì ảnh hưởng con số).
   - Pay frequency & next payday; income per paycheck (fixed).
   - Planning horizon (irregular).
   - Safety buffer: 0 · 5 · 10 · 15 · 20%.
   - Leftover money (rollover): Spread (mặc định) · Tomorrow boost 🔒 · Save to goal 🔒 (Spec 023 mở khóa).
   - Currency (đổi chỉ đổi ký hiệu hiển thị, **không quy đổi** số tiền — cảnh báo rõ).
3. **Reminders:** Morning number (bật/tắt, giờ), Evening log reminder (bật/tắt, giờ), Bill reminders (bật/tắt chung). (Spec 018 dùng.)
4. **Appearance:** Theme System/Light/Dark; App theme màu 🔒 (Spec 024).
5. **Data:** Backup / Restore (Spec 020), Export CSV 🔒 (Spec 025), **Erase all data** (xác nhận 2 lần bằng gõ chữ "DELETE"; đây là ngoại lệ duy nhất được xóa cứng; sau khi xóa về Welcome).
6. **About:** phiên bản, Privacy Policy, Terms, Contact support (mailto kèm phiên bản app + OS, **không** kèm dữ liệu tài chính), Rate the app.

**Analytics:** `settings_changed` (`setting_key`, giá trị enum — không gửi số tiền), `data_erased`.

**Test cases:**
- T16-1: Đổi buffer → snapshot cập nhật.
- T16-2: Đổi pay frequency → kỳ hiện tại tính lại đúng.
- T16-3: Mục 🔒 khi free → mở paywall (sau Spec 022) / thông báo (trước Spec 022).
- T16-4: Erase all data yêu cầu gõ "DELETE"; sau đó DB trống, điều hướng về Welcome.
- T16-5: Đổi currency hiển thị cảnh báo không quy đổi.

**Definition of Done:**
- [ ] Mọi thay đổi lưu ngay (không cần nút Save chung)
- [ ] Erase all data xóa cả DB, `app_setting`, widget snapshot, lịch thông báo

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
