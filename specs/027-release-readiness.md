# Spec 027 · F26 — Release readiness

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 027
> **Phụ thuộc:** Tất cả Spec 001–026 · **Ước lượng:** 2 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Sẵn sàng submit App Store và Google Play.

**Hạng mục:**
1. **QA tổng:** chạy toàn bộ integration test; kịch bản thủ công end-to-end trên thiết bị thật (iOS + Android), gồm: onboarding fixed & irregular, qua nửa đêm, qua kỳ lương, tiêu vượt, ghi lùi, restore backup, mua/khôi phục premium, widget, thông báo.
2. **Hiệu năng:** cold start ≤ 1 s; không jank khi cuộn History 2.000 mục; kích thước app hợp lý (ghi số liệu).
3. **Accessibility:** VoiceOver/TalkBack toàn luồng chính; Dynamic Type lớn nhất; tương phản.
4. **Privacy & tuân thủ:**
   - App Store Privacy Label: dữ liệu tài chính **không thu thập** (lưu trên máy); khai báo đúng analytics, crash, quảng cáo.
   - Google Play Data safety tương ứng.
   - Privacy Policy & Terms có trên web công ty; disclaimer "not financial advice" trong About.
   - Nút xóa toàn bộ dữ liệu (đã có ở Spec 017).
5. **Store assets:** tên `Daily Budget: Safe to Spend`, phụ đề `Paycheck budget, no bank login`, từ khóa (product plan mục 3.3), screenshot 6.7"/6.1"/Android, mô tả ngắn/dài, icon.
6. **Phát hành:** TestFlight + Internal testing; checklist review guideline (3.1.2 subscription, 5.1 privacy).

**Definition of Done:**
- [ ] Toàn bộ test (unit, widget, golden, integration) xanh trên CI
- [ ] Checklist QA thủ công đạt 100%, lưu trong mục Review & Verify Report của spec này
- [ ] Bản build được duyệt TestFlight/Internal và chạy ổn định ≥ 3 ngày nội bộ không crash
- [ ] `SESSION_STATE.md`: Spec 001–027 DONE; mục Knowledge có quy trình phát hành

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
