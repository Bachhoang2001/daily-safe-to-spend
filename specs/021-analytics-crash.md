# Spec 021 · F20 — Analytics & Crash reporting

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 021
> **Phụ thuộc:** Spec 006 · **Ước lượng:** 0,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Đo funnel và retention mà không chạm dữ liệu tài chính.

**Mô tả:**
- Firebase project `dev` và `prod` riêng (theo flavor).
- `AnalyticsService` interface (đã dùng no-op từ Spec 006) → impl Firebase.
- **Danh sách sự kiện chuẩn:** tổng hợp mọi sự kiện đã nêu trong các card (xem `000-conventions.md` Phụ lục 1). Agent tạo hằng số tên sự kiện ở một file duy nhất.
- User properties: `income_mode`, `pay_frequency`, `is_premium`, `has_widget`, `notifications_enabled`.
- Crashlytics: bật ở `prod`; `FlutterError.onError` và `PlatformDispatcher.onError` chuyển về Crashlytics.
- **Lọc riêng tư:** wrapper kiểm tra thuộc tính sự kiện chỉ chứa kiểu cho phép (enum string trong whitelist, bool, int đếm); thuộc tính có tên chứa `amount`, `note`, `name` → bị chặn và assert ở debug.
- Tôn trọng consent: ở EU/UK, analytics cá nhân hóa quảng cáo phụ thuộc kết quả UMP (Spec 026) — analytics sản phẩm cơ bản vẫn chạy ở chế độ không định danh quảng cáo (`ad_personalization` tắt cho đến khi có consent).

**Test cases:**
- T20-1: Gửi sự kiện có thuộc tính `amount` → bị chặn (assert trong test).
- T20-2: Mọi tên sự kiện trong code đều nằm trong file hằng số (test quét).
- T20-3: Flavor dev không gửi về project prod.

**Definition of Done:**
- [ ] Funnel onboarding hiển thị trên Firebase DebugView
- [ ] Crash giả lập xuất hiện trên Crashlytics (bản dev)

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
