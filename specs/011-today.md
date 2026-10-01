# Spec 011 · F10 — Today screen

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 011
> **Phụ thuộc:** Spec 010, Spec 005 · **Ước lượng:** 2 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Màn gốc, trả lời một câu hỏi: hôm nay tôi được tiêu bao nhiêu.

**User stories:**
- Tôi mở app và thấy ngay con số an toàn của hôm nay.
- Tôi biết ngày mai thay đổi thế nào nếu tôi tiêu thêm.
- Tôi thấy hóa đơn sắp tới.

**Bố cục (từ trên xuống):**
1. App bar: ngày hôm nay ("Thu, Oct 1"), icon Settings.
2. **Thẻ chính:** label "Safe to spend today" · con số lớn `safeToday` · `ProgressRing` (đã tiêu / hạn mức ngày) · dòng phụ: "Spent $18 of $60".
3. Dòng dự báo: "Tomorrow: $62" (nếu không tiêu thêm). Trạng thái over: "Over by $8 — tomorrow adjusts to $55."
4. Thẻ kỳ: "Until payday · 9 days left · $540 left" (irregular: "Next 14 days · $760 available").
5. **Giao dịch hôm nay:** danh sách (danh mục, ghi chú, số tiền), chạm để sửa (mở Spec 013 edit). Empty state: "Nothing logged today. Tap + when you spend."
6. **Hóa đơn sắp tới:** tối đa 3 mục gần nhất trong kỳ/cửa sổ. Liên kết "See all" → tab Plan.
7. Goal mini (nếu có): tên, % tiến độ.
8. **FAB "+"** lớn → Quick Add (Spec 012).

**Business rules:**
- Dữ liệu từ `BudgetSnapshot` stream; cập nhật tức thì khi thêm/sửa/xóa.
- **Tự đổi ngày:** khi app đang mở qua nửa đêm, hoặc quay lại foreground sang ngày mới → tính lại snapshot (lắng nghe `AppLifecycleState.resumed` + timer đến nửa đêm).
- Khi qua kỳ lương mới (fixed) → banner nhẹ một lần: "New pay period started — your daily number is $58."
- Không quảng cáo trên màn này (cố định, Spec 026 không được chạm).

**Analytics:** `today_view` (mỗi phiên tối đa 1 lần; `status`), `new_period_banner_shown`.

**Edge cases:** safeToday âm; dailyAllowance = 0 (shortfall); kỳ còn 1 ngày; số rất lớn (co chữ tự động `FittedBox`).

**Test cases:**
- T10-1: Hiển thị đúng các số từ snapshot giả.
- T10-2: Thêm expense qua repository → con số cập nhật không cần reload.
- T10-3: FakeClock qua nửa đêm + resume → ngày và số cập nhật.
- T10-4: Trạng thái over hiển thị câu dự báo điều chỉnh.
- T10-5: Empty state khi chưa có giao dịch hôm nay.
- T10-6: Banner kỳ mới chỉ hiện một lần.
- T10-7: Golden: onTrack / caution / over × light/dark × cỡ chữ lớn.

**Design notes:** con số chính căn giữa, `display` 64sp; màu theo status; animation đếm khi số thay đổi (250ms); khoảng trắng rộng; FAB nổi rõ, nằm trong vùng ngón cái.

**Definition of Done:**
- [ ] Cập nhật số ≤ 100 ms sau khi lưu giao dịch (đo trên thiết bị thật)
- [ ] Đọc bằng VoiceOver/TalkBack: "Safe to spend today, 42 dollars" theo đúng thứ tự

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
