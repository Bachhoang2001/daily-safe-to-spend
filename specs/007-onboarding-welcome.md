# Spec 007 · F06 — Onboarding 1: Welcome

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 007
> **Phụ thuộc:** Spec 006 · **Ước lượng:** 0,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Truyền đạt giá trị cốt lõi trong một màn.

**Mô tả:**
- Tiêu đề: "Know what's safe to spend today."
- Phụ đề: "One number every morning. No bank login. Your data stays on your phone."
- Minh họa: thẻ số tiền mẫu (`$42 safe to spend today`) có animation đếm nhẹ.
- 3 điểm nhấn ngắn (icon + 1 dòng): Built around your paycheck · Works with irregular income · Private by design.
- Nút chính "Get started"; liên kết nhỏ "Privacy Policy" và "Terms".
- Thanh tiến trình onboarding: bước 1/4.

**Analytics:** `onboarding_start`.

**Test cases:**
- T06-1: Render đủ nội dung, nút Get started điều hướng sang `/onboarding/income`.
- T06-2: Link Privacy mở URL ngoài.
- T06-3: Golden light/dark, cỡ chữ lớn nhất không bị cắt chữ.

**Definition of Done:**
- [ ] Không có nút "Skip" (onboarding bắt buộc tối thiểu)
- [ ] Nút "Back" hệ thống ở màn này đóng app (Android), không quay về splash

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
