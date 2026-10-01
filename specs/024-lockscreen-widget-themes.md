# Spec 024 · F23 — Premium: Lock Screen widget & themes

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 024
> **Phụ thuộc:** Spec 019, Spec 022 · **Ước lượng:** 2 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Tính năng premium "nhìn thấy được", đồng thời tăng retention.

**Mô tả:**
- **iOS Lock Screen widgets** (accessoryCircular, accessoryRectangular, accessoryInline): số safe today + vòng tiến độ. Free: widget hiển thị "Upgrade to see" (khóa); premium: hiển thị số.
- **Android:** widget nhỏ 1×1 / 2×1 kiểu tối giản cho màn hình khóa/màn hình chính (tùy launcher) — premium.
- **App themes:** 5 bảng màu (Default Green, Ocean, Sunset, Mono, Lavender) áp dụng cho app + widget; free chỉ có Default. Có tùy chọn **thử theme 24 giờ bằng rewarded ad** (Spec 026 gắn vào; trước Spec 026 ẩn tùy chọn này).
- Snapshot widget có trường `theme` và `isPremium`.

**Analytics:** `theme_changed` (`theme`), `theme_trial_started`.

**Test cases:**
- T23-1: Free chọn theme khác Default → paywall.
- T23-2: Premium chọn theme → app và snapshot widget cập nhật.
- T23-3: Theme trial hết 24 giờ → quay về Default.
- T23-4: Snapshot `isPremium=false` → lock screen widget ở trạng thái khóa.

**Definition of Done:**
- [ ] Checklist thủ công Lock Screen widget trên iOS 17+ đạt
- [ ] Mọi theme đạt tương phản WCAG AA cho text chính ở cả light/dark

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
