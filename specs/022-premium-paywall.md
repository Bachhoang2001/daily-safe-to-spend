# Spec 022 · F21 — Premium: RevenueCat, entitlement, paywall

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 022
> **Phụ thuộc:** Spec 017, Spec 021 · **Ước lượng:** 2 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Hạ tầng thu phí và màn paywall.

**Mô tả:**
- RevenueCat: entitlement `premium`; offering `default` gồm `annual` ($24.99, trial 7 ngày) và `monthly` ($3.99). Giá EU/UK theo bảng trong product plan (cấu hình trên store, không hardcode).
- `EntitlementService` (`GetxService`, permanent): `RxBool isPremium`, cache cục bộ trạng thái cuối cùng để app chạy offline (người dùng premium mở app không mạng vẫn là premium theo cache).
- **Paywall:**
  - Tiêu đề: "Make every day easier".
  - Danh sách lợi ích (icon + 1 dòng): Choose what happens to leftover money · Lock Screen widgets & themes · Export to CSV · No ads · More coming: Apple Pay auto-log, Watch app.
  - Chọn gói: Annual (đánh dấu "Best value", hiển thị giá/tháng tương đương) mặc định chọn; Monthly.
  - Nút "Start 7-day free trial" (annual) / "Subscribe" (monthly).
  - Dòng nhỏ: giá sau trial, tự gia hạn, hủy bất cứ lúc nào. Links Terms & Privacy. "Restore purchases".
  - Nút đóng (X) luôn hiển thị (không dùng hard paywall).
- **Điểm kích hoạt paywall:** chạm mục 🔒; tạo goal thứ hai; Settings → Upgrade; sau 7 ngày dùng liên tục (tối đa 1 lần, có cờ trong `app_setting`); sau onboarding (cờ, mặc định tắt).
- Không gọi mạng chặn UI; nếu không tải được offering → hiển thị trạng thái lỗi và nút thử lại.

**Analytics:** `paywall_view` (`trigger`), `paywall_plan_selected` (`plan`), `purchase_started`, `purchase_success` (`plan`, `is_trial`), `purchase_cancelled`, `purchase_failed` (`reason` enum), `restore_success`, `restore_failed`.

**Test cases (với fake RevenueCat):**
- T21-1: Mua thành công → `isPremium` = true, mục 🔒 mở khóa ngay.
- T21-2: Hủy giao dịch → không đổi trạng thái, không hiển thị lỗi.
- T21-3: Restore khi có entitlement → premium.
- T21-4: Offline với cache premium → vẫn premium.
- T21-5: Paywall 7 ngày chỉ hiển thị 1 lần.
- T21-6: Offering lỗi → trạng thái lỗi có nút thử lại.
- T21-7: Golden paywall light/dark.

**Definition of Done:**
- [ ] Mua thật trong Sandbox (iOS) và License testing (Android) thành công; ghi lại trong mục Review & Verify Report
- [ ] Đáp ứng yêu cầu App Store Review 3.1.2 (thông tin giá, thời hạn, link Terms/Privacy)

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
