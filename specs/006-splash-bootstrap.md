# Spec 006 · F05 — Splash & bootstrap

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 006
> **Phụ thuộc:** Spec 004, Spec 005 · **Ước lượng:** 0,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Khởi động nhanh, khởi tạo dịch vụ, điều hướng đúng.

**User story:** Là người dùng, khi mở app tôi thấy màn hình chính trong chưa đầy 1 giây.

**Mô tả:**
- Native splash (`flutter_native_splash`): logo trên nền thương hiệu, light/dark.
- `bootstrap()`: mở DB → seed danh mục (nếu cần) → đọc profile → khởi tạo Analytics/Crashlytics (Spec 021, lúc này dùng no-op) → quyết định route.
- RevenueCat, AdMob khởi tạo **không chặn** khởi động (lazy, sau khi vào màn đầu tiên) — hook sẵn để Spec 022/Spec 026 gắn vào.
- Nếu khởi tạo DB lỗi → màn lỗi thân thiện có nút "Try again" và "Contact support" (mailto), ghi Crashlytics.
- Xử lý deep link `quick-add` khi app mở từ widget: sau bootstrap, mở Today rồi trình bày Quick Add.

**Analytics:** `app_open` (`is_first_open`, `has_profile`).

**Test cases:**
- T05-1: Không có profile → điều hướng `/onboarding/welcome`.
- T05-2: Có profile hoàn chỉnh → `/today`.
- T05-3: Lỗi DB giả lập → màn lỗi, nút Try again gọi lại bootstrap.
- T05-4: Mở bằng deep link quick-add khi đã onboarding → Today + Quick Add mở.
- T05-5: Mở bằng deep link khi chưa onboarding → vào onboarding (bỏ qua deep link).

**Design notes:** không có màn Flutter splash riêng nếu không cần; chuyển cảnh fade 250ms.

**Definition of Done:**
- [ ] Cold start đến Today ≤ **1,0 s** trên iPhone 12 / Pixel 6 (bản profile/release)
- [ ] Không gọi mạng trên đường khởi động chính

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
