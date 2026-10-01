# Spec 015 · F14 — Bills management

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 015
> **Phụ thuộc:** Spec 011, Spec 009 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Quản lý hóa đơn định kỳ sau onboarding.

**Mô tả:**
- Tab Plan → mục "Bills": danh sách theo ngày đến hạn kế tiếp; mỗi dòng: tên, số tiền, "Due in 3 days", lặp.
- Tổng: "Bills this pay period: $1,240" (irregular: "next 14 days").
- Thêm/sửa: tên, số tiền, ngày đến hạn đầu tiên, lặp (Weekly/Monthly/Yearly), nhắc trước (Off / On the day / 1 day / 3 days), Active toggle.
- Xóa: soft delete, xác nhận.
- Không giới hạn số hóa đơn (free).

**Business rules:** thay đổi hóa đơn ảnh hưởng ngay đến kỳ hiện tại (engine tính lại); thông báo nhắc được lên lịch lại (Spec 018 lắng nghe thay đổi).

**Analytics:** `bill_added` (`recurrence`, `has_reminder`), `bill_edited`, `bill_deleted`.

**Test cases:**
- T14-1: Thêm bill monthly ngày 31 → occurrence tháng 30 ngày rơi vào ngày 30.
- T14-2: Tắt Active → không bị trừ khỏi pool.
- T14-3: Sắp xếp theo ngày đến hạn kế tiếp.
- T14-4: Validation tên/số tiền.

**Definition of Done:**
- [ ] Today phản ánh thay đổi hóa đơn ngay lập tức
- [ ] Sự kiện thay đổi hóa đơn được phát để Spec 018 lên lịch lại

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
