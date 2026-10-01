# Spec 008 · F07 — Onboarding 2: Income & pay schedule

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 008
> **Phụ thuộc:** Spec 007, Spec 003, Spec 005 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Thu thập đủ dữ liệu để engine tính con số đầu tiên.

**User stories:**
- Là người lương cố định, tôi chọn kỳ lương và số tiền mỗi kỳ.
- Là gig worker, tôi chọn "My income varies" và nhập số tiền tôi đang có.

**Luồng (các bước con trong cùng màn, dạng step):**

1. **"How do you get paid?"**
   - `Same amount on a schedule` → fixed
   - `My income varies` → irregular
2. **Fixed:**
   - Tần suất: Weekly · Every 2 weeks · Twice a month (1st & 16th) · Monthly.
   - "When is your next payday?" → date picker (chỉ cho chọn từ hôm nay đến +31 ngày; Weekly/Biweekly giới hạn theo kỳ) → engine suy ra `payAnchorDate`.
   - "How much do you take home each paycheck?" → `AmountKeypad`.
   - "How much do you have to spend until then?" → `AmountKeypad`, mặc định gợi ý = thu nhập mỗi kỳ × (số ngày còn lại / độ dài kỳ), người dùng sửa được → `firstPeriodBalance`.
3. **Irregular:**
   - "How much money do you have right now?" → `startingBalance`.
   - "Plan ahead for how many days?" → lựa chọn 7 · **14 (recommended)** · 30 → `safetyHorizonDays`.
4. **Currency:** mặc định theo locale (USD/GBP/EUR), cho phép đổi qua dropdown nhỏ ở đầu màn.

**Business rules:**
- Số tiền > 0 bắt buộc cho thu nhập mỗi kỳ và số dư.
- `trackingStartDate = today`; `bufferPercent` mặc định: fixed 0, irregular 10.
- `timezone` = múi giờ thiết bị.
- Dữ liệu được giữ tạm trong `OnboardingController` (GetX, model `OnboardingDraft`; một controller dùng chung cho cả 4 màn onboarding qua `OnboardingBinding` với `Get.put(..., permanent: false)` và chỉ bị xóa khi rời luồng onboarding), **chỉ ghi DB ở Spec 010** khi hoàn tất — thoát app giữa chừng thì lần sau bắt đầu lại từ Welcome nhưng draft được khôi phục (lưu draft vào `app_setting` dạng JSON).

**Analytics:** `onboarding_income_mode_selected` (`mode`), `onboarding_pay_frequency_selected` (`frequency`), `onboarding_step_completed` (`step: income`).

**Edge cases:** chọn ngày lương là hôm nay; số tiền rất lớn; người dùng quay lại đổi mode → xóa các trường không liên quan khỏi draft.

**Test cases:**
- T07-1: Fixed/monthly: nhập đủ → nút Continue bật; thiếu số tiền → tắt.
- T07-2: Gợi ý `firstPeriodBalance` tính đúng theo công thức.
- T07-3: Irregular: chọn horizon 14 mặc định.
- T07-4: Đổi mode xóa trường của mode cũ trong draft.
- T07-5: Draft được khôi phục sau khi khởi động lại app.
- T07-6: Date picker không cho chọn ngày quá khứ.

**Design notes:** mỗi câu hỏi một khối lớn, chữ to; chuyển bước dùng slide ngang 250ms; bàn phím số là `AmountKeypad` (không dùng bàn phím hệ thống).

**Definition of Done:**
- [ ] Hoàn thành bước này ≤ 30 giây với người dùng thử (đo thủ công, ghi vào mục Review & Verify Report)
- [ ] Tiến trình bước 2/4

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
