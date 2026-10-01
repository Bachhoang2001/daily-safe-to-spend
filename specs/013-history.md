# Spec 013 · F12 — History (xem, sửa, xóa, ghi lùi)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 013
> **Phụ thuộc:** Spec 012 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Xem lại và sửa dữ liệu dễ dàng (khe hở lớn của đối thủ).

**Mô tả:**
- Tab History: danh sách nhóm theo ngày (mới nhất trên cùng), mỗi nhóm có tiêu đề ngày + tổng chi ngày + hạn mức ngày đó (`Spent $45 / $60`) và chấm màu trạng thái.
- Trong MVP hiển thị kỳ hiện tại; nút "Load earlier" để tải các kỳ trước (phân trang theo kỳ hoặc 30 ngày).
- Chạm giao dịch → màn Edit (tái sử dụng UI Quick Add): sửa số tiền, danh mục, ghi chú, ngày → Save. Nút "Delete" → xác nhận → soft delete + snackbar Undo.
- Vuốt trái để xóa nhanh (có Undo).
- Nút "+" trên app bar: thêm khoản chi cho ngày bất kỳ (ghi lùi).
- Thu nhập (irregular) và đóng góp goal hiển thị xen kẽ với kiểu khác (icon mũi tên vào / con heo).
- Vị trí banner quảng cáo cuối danh sách được **chừa sẵn** (Spec 026 gắn vào).

**Analytics:** `history_view`, `expense_edited` (`field_changed`), `expense_deleted` (`via: swipe|edit`).

**Test cases:**
- T12-1: Nhóm theo ngày và tổng ngày đúng.
- T12-2: Sửa ngày của giao dịch → Today và History cập nhật đúng.
- T12-3: Xóa + Undo hoạt động.
- T12-4: Load earlier tải đúng khoảng ngày kế tiếp.
- T12-5: Không cho sửa ngày ra ngoài `[trackingStartDate, today]`.
- T12-6: Empty state khi chưa có dữ liệu.

**Definition of Done:**
- [ ] Cuộn mượt (60 fps) với 2.000 giao dịch (ListView.builder, kiểm tra trên thiết bị thật)
- [ ] Undo hoạt động cho cả vuốt và xóa trong màn Edit

---

## Bổ sung khi chuyển sang MVC + GetX

- **Mở rộng engine:** thêm `computeDailyLedger(input, from, to) → List<DaySummary>` (ngày, hạn mức, đã tiêu, status) để History hiển thị hạn mức của các ngày đã qua. Có test riêng trong engine, coverage engine vẫn ≥ 95%.
- Màn sửa giao dịch dùng lại Quick Add ở chế độ sửa qua `QuickAddLauncher.open(editExpenseId:)` thay cho route riêng.
- Widget `AdSlot` (no-op) đặt sẵn cuối danh sách, Spec 026 gắn quảng cáo thật.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
