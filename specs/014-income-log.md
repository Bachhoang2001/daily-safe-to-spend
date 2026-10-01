# Spec 014 · F13 — Income log (chế độ thu nhập không đều)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 014
> **Phụ thuộc:** Spec 011 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Người dùng irregular ghi tiền về để con số cập nhật.

**Mô tả:**
- Chỉ hiển thị khi `income_mode = irregular`.
- Tab Plan có mục "Income" với nút "Add income": số tiền, ngày (mặc định hôm nay, cho chọn lùi), ghi chú (ví dụ "DoorDash week 40").
- Today có nút phụ nhỏ "Got paid?" cạnh thẻ kỳ → mở form Add income.
- Danh sách thu nhập gần đây, sửa/xóa giống History.
- Ở fixed mode: mục Income ẩn; (ghi `docs/BACKLOG.md`: thu nhập phát sinh thêm cho fixed mode).

**Analytics:** `income_added` (`is_backdated`), `income_deleted`.

**Test cases:**
- T13-1: Thêm income hôm nay → `safeToday` tăng đúng theo công thức irregular.
- T13-2: Mục Income không hiển thị ở fixed mode.
- T13-3: Sửa/xóa income cập nhật snapshot.

**Definition of Done:**
- [ ] "Got paid?" chỉ hiện ở irregular
- [ ] Thêm income ≤ 3 chạm

---

## Bổ sung khi chuyển sang MVC + GetX

- Spec này tạo khung `PlanPage` (tab Plan) theo section; Spec 015 và 016 thêm section Bills và Goal.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
