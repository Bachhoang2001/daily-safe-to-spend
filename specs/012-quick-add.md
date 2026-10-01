# Spec 012 · F11 — Quick Add expense

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 012
> **Phụ thuộc:** Spec 011 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Ghi một khoản chi trong ≤ 3 chạm.

**Mô tả:**
- Bottom sheet toàn chiều cao gần full, mở bằng FAB, deep link `quick-add`, hoặc widget.
- Bàn phím `AmountKeypad` luôn hiển thị; con số lớn ở trên.
- Hàng chip danh mục (cuộn ngang), danh mục dùng gần nhất đứng đầu; không chọn = "Other".
- Trường ghi chú tùy chọn (một dòng, ≤ 60 ký tự).
- Chip ngày: mặc định "Today"; chạm → chọn "Yesterday" hoặc date picker (giới hạn: từ `trackingStartDate` đến hôm nay).
- Nút "Add" (bật khi số tiền > 0). Lưu → đóng sheet → snackbar "Added $12.50 · Undo" (5 giây).
- Live preview nhỏ phía trên nút: "Left today after this: $29.50" (màu theo trạng thái).

**Business rules:**
- `source = manual` (hoặc `widget` khi mở từ widget — truyền qua deep link query `?source=widget`).
- Undo = `softDelete` bản ghi vừa tạo (không phải xóa cứng).
- Haptic success khi lưu.

**Analytics:** `expense_added` (`source`, `has_note`, `has_category`, `is_backdated`).

**Test cases:**
- T11-1: Nhập 1250 → Add → expense $12.50 được lưu, ngày hôm nay.
- T11-2: Chọn Yesterday → `spent_on` = hôm qua; Today không đổi số hôm nay nhưng hạn mức điều chỉnh đúng.
- T11-3: Undo → bản ghi bị soft delete, số khôi phục.
- T11-4: Nút Add tắt khi số tiền 0.
- T11-5: Không chọn được ngày trước `trackingStartDate` và ngày tương lai.
- T11-6: Live preview đúng theo engine.
- T11-7: Mở từ deep link có `source=widget` → lưu `source = widget`.

**Design notes:** sheet mở với animation spring nhẹ; chip danh mục có icon + màu; nút Add rộng toàn chiều ngang; golden test bắt buộc.

**Definition of Done:**
- [ ] Từ chạm FAB đến lưu xong: ≤ 3 chạm cho trường hợp "số tiền + Add"
- [ ] Sheet mở ≤ 150 ms

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
