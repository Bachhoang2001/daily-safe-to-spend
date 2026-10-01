# Spec 010 · F09 — Onboarding 4: Result reveal & quyền thông báo

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 010
> **Phụ thuộc:** Spec 009 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Khoảnh khắc "aha": hiển thị con số đầu tiên, lưu dữ liệu, xin quyền thông báo đúng lúc.

**Mô tả:**
1. Gọi engine với draft → hiển thị lớn: **"You can spend $42 today"**, kèm dòng phụ "That's your daily number until payday on Oct 15." (irregular: "…for the next 14 days.").
2. Animation đếm số từ 0 (tôn trọng reduced motion).
3. Ghi toàn bộ draft vào DB trong **một transaction**: profile, bills. Xóa draft.
4. Thẻ xin quyền thông báo (giải thích trước khi gọi hộp thoại hệ thống): "Get your number every morning at 8:00?" → `Turn on` (gọi quyền hệ thống) / `Not now`.
5. Nút "Go to Today".
6. Soft paywall **không** hiển thị ở đây trong MVP; móc nối để Spec 022 bật thử nghiệm sau (cờ `show_paywall_after_onboarding` trong `app_setting`, mặc định `false`).

**Business rules:**
- Nếu pool âm (hóa đơn > tiền): hiển thị trạng thái thiếu hụt nhẹ nhàng: "Your bills are more than your money until payday — we'll help you track it." Vẫn cho tiếp tục.
- Giờ nhắc mặc định 08:00 (buổi sáng) và 20:30 (buổi tối) — ghi vào `app_setting`, Spec 018 sử dụng.

**Analytics:** `onboarding_complete` (`income_mode`, `pay_frequency`, `bills_count`), `notification_permission_result` (`granted`).

**Test cases:**
- T09-1: Con số hiển thị khớp engine cho draft đã cho.
- T09-2: Sau "Go to Today", `hasCompletedOnboarding()` = true và draft đã xóa.
- T09-3: Lỗi ghi DB → không mất draft, hiển thị lỗi và cho thử lại.
- T09-4: `Not now` không gọi hộp thoại quyền hệ thống.
- T09-5: Trường hợp pool âm hiển thị thông điệp thiếu hụt.

**Design notes:** đây là màn đẹp nhất của onboarding; con số dùng `display`, nền có gradient nhẹ màu `primary`; golden test bắt buộc.

**Definition of Done:**
- [ ] Ghi DB nguyên tử (transaction)
- [ ] Tiến trình bước 4/4
- [ ] Từ Welcome đến Today ≤ 60 giây (đo thủ công)

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
