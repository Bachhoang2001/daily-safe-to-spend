# Spec 016 · F15 — Savings Goal (1 mục tiêu)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 016
> **Phụ thuộc:** Spec 011 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Cho người dùng để dành tiền mà vẫn thấy con số hằng ngày trung thực.

**Mô tả:**
- Tab Plan → mục "Goal". Nếu chưa có: thẻ "Save for something" → tạo: tên (ví dụ "New TV"), số tiền mục tiêu, ngày mục tiêu (tùy chọn), **"Set aside each paycheck"** (fixed mode; app gợi ý = (target − saved) / số kỳ đến ngày mục tiêu, làm tròn lên đến dollar).
- Hiển thị: tiến độ (%), đã có / mục tiêu, dự kiến đạt ngày (nếu có per-paycheck).
- Nút "Add money": đóng góp thủ công (trừ vào hạn mức hôm nay như mô tả ở Spec 003).
- Free: tối đa **1 goal active**. Khi người dùng cố tạo goal thứ hai → paywall (gắn ở Spec 022; trước Spec 022 chỉ hiển thị thông báo).
- Khi đạt mục tiêu: màn chúc mừng nhẹ (confetti tôn trọng reduced motion), goal chuyển "Completed", có thể tạo goal mới.

**Analytics:** `goal_created` (`has_target_date`, `has_per_paycheck`), `goal_contribution_added`, `goal_completed`.

**Test cases:**
- T15-1: Gợi ý per-paycheck tính đúng.
- T15-2: Đóng góp $50 → Today giảm $50, goal tăng $50.
- T15-3: Đạt target → trạng thái Completed, reserve ngừng trừ kỳ sau.
- T15-4: Tạo goal thứ hai khi free → chặn đúng.
- T15-5: Irregular mode: ẩn "Set aside each paycheck".

**Definition of Done:**
- [ ] Mini goal trên Today hiển thị khi có goal active
- [ ] Hook paywall sẵn sàng cho Spec 022

---

## Bổ sung khi chuyển sang MVC + GetX

- Tạo `IPremiumGate.request(PremiumFeature)` với hiện thực tạm `InfoOnlyPremiumGate`; Spec 022 thay bằng `PaywallPremiumGate`.
- Tạo interface `IEntitlementService`; tới Spec 022 dùng fake luôn trả về free.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
