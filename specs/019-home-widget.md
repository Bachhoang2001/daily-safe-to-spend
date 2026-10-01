# Spec 019 · F18 — Home Screen widget (iOS + Android)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 019
> **Phụ thuộc:** Spec 011, Spec 012, Spec 018 · **Ước lượng:** 3 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Động cơ retention thứ hai: thấy con số mà không cần mở app, thêm chi tiêu từ màn hình chính.

**Phạm vi MVP (free):**
- **iOS:** widget Small và Medium (WidgetKit).
  - Small: "Safe today" + số tiền + vòng tiến độ nhỏ.
  - Medium: thêm "Spent $18 · Tomorrow $62" + nút **"+"** (deep link `safetospend://quick-add?source=widget`).
- **Android:** widget 2×2 và 4×2 (Jetpack Glance), nội dung tương đương, nút "+" mở Quick Add.

**Cơ chế dữ liệu:**
- Flutter ghi **snapshot JSON** vào App Group (iOS) / SharedPreferences (Android) qua `home_widget` mỗi khi snapshot thay đổi:
  ```json
  {
    "date": "2026-10-01",
    "safeTodayCents": 4200,
    "spentTodayCents": 1800,
    "allowanceTodayCents": 6000,
    "tomorrowCents": 6200,
    "currency": "USD",
    "status": "onTrack",
    "dailyBaseForNextDays": [{"date":"2026-10-02","allowanceCents":6200}],
    "hideAmounts": false,
    "theme": "default"
  }
  ```
- Sau khi ghi → yêu cầu reload widget.
- **Qua nửa đêm khi app không mở:** widget dùng `dailyBaseForNextDays` (7 ngày, tính sẵn giả định không chi thêm) để tự hiển thị con số ngày mới. iOS: timeline entry tại 00:00 mỗi ngày; Android: cập nhật lúc nửa đêm bằng WorkManager/AlarmManager inexact.
- Nếu snapshot quá cũ (> 7 ngày) → hiển thị "Open to update".

**Analytics:** `widget_installed` (phát hiện qua `home_widget` khi có thể; nếu không thì ghi khi app mở bằng deep link widget lần đầu), `expense_added` với `source=widget`.

**Test cases (tự động):**
- T18-1: Snapshot JSON tạo đúng từ `BudgetSnapshot` (unit test Dart).
- T18-2: `dailyBaseForNextDays` có đúng 7 phần tử, khớp engine.
- T18-3: Deep link widget mở Quick Add với `source=widget`.

**Kiểm tra thủ công (checklist ghi trong mục Review & Verify Report):**
- [ ] Thêm widget Small/Medium iOS, 2×2/4×2 Android; hiển thị đúng
- [ ] Thêm chi tiêu trong app → widget cập nhật ≤ 5 giây
- [ ] Đổi ngày thiết bị sang ngày mai khi app đóng → widget hiển thị con số ngày mới
- [ ] Dark mode, cỡ chữ lớn
- [ ] Hide amounts → widget hiển thị "••••"

**Design notes:** widget tối giản, con số là tiêu điểm; màu theo status; nền theo hệ thống; nút "+" tròn góc phải dưới.

**Definition of Done:**
- [ ] Toàn bộ checklist thủ công đạt trên thiết bị/simulator iOS 17+ và Android 12+
- [ ] Ghi vào `docs/SESSION_STATE.md` (mục Knowledge): cách build/chạy widget extension, App Group id, cấu trúc JSON

---

## Bổ sung khi chuyển sang MVC + GetX

- Phụ thuộc thêm Spec 018 (dùng `projectNextDays` cho `dailyBaseForNextDays`).
- Snapshot JSON có thêm trường `schemaVersion`.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
