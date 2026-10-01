# Spec 009 · F08 — Onboarding 3: Bills (bỏ qua được)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 009
> **Phụ thuộc:** Spec 008 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Ghi nhận các hóa đơn lớn để con số đầu tiên đáng tin.

**Mô tả:**
- Tiêu đề: "Any regular bills before your next payday?" (irregular: "…in the next 14 days?").
- Danh sách gợi ý nhanh dạng chip: Rent · Phone · Internet · Utilities · Car payment · Insurance · Subscriptions · Custom. Chạm chip → bottom sheet nhập số tiền + ngày đến hạn + lặp (mặc định Monthly).
- Danh sách hóa đơn đã thêm, vuốt để xóa.
- Nút "Continue" và "Skip for now".
- Hiển thị dòng tổng: "Bills before payday: $1,240".

**Business rules:**
- Tên hóa đơn ≤ 40 ký tự; số tiền > 0; ngày đến hạn đầu tiên ≥ hôm nay − 31 ngày (cho phép hóa đơn tháng này đã trả? → **Không**: MVP chỉ cho chọn từ hôm nay trở đi để tránh nhầm lẫn; ghi ADR).
- Lưu vào draft, ghi DB ở Spec 010.

**Analytics:** `onboarding_bills_added` (`count`), `onboarding_bills_skipped`.

**Test cases:**
- T08-1: Thêm 2 hóa đơn → tổng hiển thị đúng.
- T08-2: Skip → sang Result với 0 hóa đơn.
- T08-3: Validation tên/số tiền/ngày.
- T08-4: Xóa hóa đơn bằng vuốt.

**Definition of Done:**
- [ ] Tiến trình bước 3/4
- [ ] Thêm một hóa đơn ≤ 4 chạm

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
