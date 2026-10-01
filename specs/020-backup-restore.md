# Spec 020 · F19 — Backup & Restore (file)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 020
> **Phụ thuộc:** Spec 017 · **Ước lượng:** 1 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Bảo vệ dữ liệu khi đổi máy (local-first chưa có sync).

**Mô tả:**
- Settings → Data → **Backup:** xuất file `safetospend-backup-YYYYMMDD.json` qua share sheet (lưu vào Files, Drive, email…).
  - Nội dung: `schemaVersion`, `appVersion`, `exportedAt`, toàn bộ bảng (kể cả bản ghi soft-deleted để giữ nguyên ID cho sync sau này).
  - Tùy chọn **mã hóa bằng mật khẩu** (AES-GCM, khóa dẫn xuất PBKDF2/Argon2) — tùy chọn, mặc định tắt.
- **Restore:** chọn file → kiểm tra `schemaVersion` (cũ hơn → migrate; mới hơn → từ chối với thông báo cập nhật app) → xem trước tóm tắt ("124 expenses, 6 bills, 1 goal") → xác nhận "This will replace all current data" → thay thế trong một transaction → tính lại snapshot, lên lịch lại thông báo, cập nhật widget.
- Nhắc sao lưu: banner nhẹ trong Settings nếu chưa sao lưu > 30 ngày và có ≥ 20 giao dịch.
- Free (cả backup và restore).

**Analytics:** `backup_exported` (`encrypted`), `backup_restored`, `backup_restore_failed` (`reason` enum).

**Test cases:**
- T19-1: Export → import vào DB rỗng → dữ liệu giống hệt (so sánh từng bảng).
- T19-2: File hỏng/không đúng định dạng → báo lỗi, dữ liệu hiện tại không đổi.
- T19-3: File mã hóa sai mật khẩu → báo lỗi.
- T19-4: `schemaVersion` mới hơn → từ chối.
- T19-5: Restore là nguyên tử (lỗi giữa chừng → rollback).

**Definition of Done:**
- [ ] Round-trip export/import không mất dữ liệu (kể cả ID, timestamp)
- [ ] File không chứa gì ngoài dữ liệu của người dùng (không token, không id quảng cáo)

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
