# Spec 023 · F22 — Premium: Rollover modes (Tomorrow boost / Save to goal)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 023
> **Phụ thuộc:** Spec 003, Spec 022 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Mở khóa chế độ xử lý tiền dư đã có trong engine.

**Mô tả:**
- Settings → Leftover money: chọn Spread / Tomorrow boost / Save to goal (2 mục cuối yêu cầu premium).
- Mỗi lựa chọn có giải thích ngắn + ví dụ trực quan nhỏ ("Save $15 today → tomorrow stays $60, goal +$15").
- Chọn "Save to goal" khi chưa có goal → gợi ý tạo goal (mở Spec 016).
- Today hiển thị dòng phụ theo mode: Tomorrow boost: "Unspent money goes to tomorrow." · Save: "Unspent money goes to {goal}."
- Nếu premium hết hạn → tự quay về Spread, giữ lựa chọn cũ để khôi phục nếu đăng ký lại; thông báo nhẹ một lần.

**Analytics:** `rollover_mode_changed` (`mode`).

**Test cases:**
- T22-1: Free chọn Tomorrow → paywall.
- T22-2: Premium chọn Tomorrow → snapshot theo công thức Tomorrow.
- T22-3: Premium hết hạn → mode hiệu lực = Spread.
- T22-4: Save khi chưa có goal → gợi ý tạo goal.

**Definition of Done:**
- [ ] Ví dụ minh họa trong Settings dùng số từ engine với dữ liệu thực của người dùng

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
