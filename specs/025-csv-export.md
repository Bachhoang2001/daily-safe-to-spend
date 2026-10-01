# Spec 025 · F24 — Premium: CSV export

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 025
> **Phụ thuộc:** Spec 022 · **Ước lượng:** 0,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Cho người dùng mang dữ liệu đi (ví dụ đưa vào Excel/Google Sheets).

**Mô tả:**
- Settings → Data → Export CSV 🔒: chọn khoảng thời gian (This period · Last 3 months · All time).
- File `safetospend-expenses-YYYYMMDD.csv`: `date, amount, currency, category, note, source` (+ file thứ hai cho income nếu irregular). Định dạng số dùng dấu chấm thập phân, UTF-8 có BOM để Excel mở đúng.
- Chia sẻ qua share sheet.

**Analytics:** `csv_exported` (`range`).

**Test cases:**
- T24-1: Nội dung CSV đúng cột và thứ tự, escape dấu phẩy/ngoặc kép trong ghi chú.
- T24-2: Khoảng thời gian lọc đúng.
- T24-3: Free → paywall.

**Definition of Done:**
- [ ] Mở đúng trên Excel (macOS/Windows) và Google Sheets với ký tự đặc biệt

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
