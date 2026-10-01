# Spec 004 · F03 — Data layer (drift schema, DAO, repository)

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 004
> **Phụ thuộc:** Spec 002, Spec 003 · **Ước lượng:** 2 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Lưu trữ cục bộ bền vững, sẵn sàng đồng bộ ở Giai đoạn 3.

**Bảng** (mọi bảng có cột chung: `id`, `created_at`, `updated_at`, `deleted_at`, `device_id`):

| Bảng | Cột nghiệp vụ |
|---|---|
| `budget_profile` | `currency`, `income_mode`, `pay_frequency?`, `pay_anchor_date?`, `income_per_paycheck_cents?`, `first_period_balance_cents?`, `starting_balance_cents?`, `tracking_start_date`, `safety_horizon_days`, `buffer_percent`, `rollover_mode`, `timezone`, `week_start` |
| `income_entry` | `profile_id`, `amount_cents`, `received_on`, `note?` |
| `bill` | `profile_id`, `name`, `amount_cents`, `recurrence`, `first_due_date`, `remind_days_before` (mặc định 1), `is_active` |
| `expense` | `profile_id`, `amount_cents`, `spent_on`, `category_id?`, `note?`, `source` (`manual`/`widget`), `currency` |
| `category` | `name_key` (key l10n) hoặc `custom_name?`, `icon`, `color`, `sort_order`, `is_default` |
| `goal` | `profile_id`, `name`, `target_amount_cents`, `target_date?`, `per_paycheck_cents?`, `created_on`, `is_active` |
| `goal_contribution` | `goal_id`, `amount_cents`, `on_date`, `source` (`manual`) |
| `app_setting` | `key` (PK thay cho id), `value` (TEXT/JSON), `updated_at` |

> Lưu ý: bảng giao dịch tên `expense` (tránh từ khóa `transaction`).

**Danh mục mặc định (seed):** Food & Drink, Groceries, Transport, Shopping, Fun, Bills & Utilities, Health, Other.

**Repository** (interface `I...Repository` ở `lib/domain/repositories/`, hiện thực ở `lib/data/repositories/`, đăng ký qua `Get.put(..., permanent: true)` trong `InitialBinding`):
- `ProfileRepository`: `watchActive()`, `save(profile)`, `hasCompletedOnboarding()`.
- `ExpenseRepository`: `watchRange(from, to)`, `add`, `update`, `softDelete`, `restore` (cho Undo).
- `IncomeRepository`, `BillRepository`, `GoalRepository`, `CategoryRepository`, `SettingsRepository`.
- `BudgetSnapshotService` (`GetxService`, permanent, ở `lib/data/services/`): gộp các stream từ repository → `EngineInput` → gọi engine → phát `Rx<BudgetSnapshot?> snapshot`. Mọi controller cần con số đều đọc từ service này, **không** tự gọi engine.

**Migration:** `schemaVersion = 1`; có test migration bằng `drift_dev` schema dump để chuẩn bị cho các phiên bản sau.

**Test cases:**
- T03-1: Thêm expense → `watchRange` phát giá trị mới.
- T03-2: `softDelete` → không xuất hiện trong query mặc định; `restore` → xuất hiện lại.
- T03-3: `update` thay đổi `updated_at`, giữ `created_at`.
- T03-4: Mọi bản ghi mới có UUID v4 hợp lệ và `device_id`.
- T03-5: Seed danh mục chạy đúng 1 lần (chạy bootstrap 2 lần không nhân đôi).
- T03-6: `BudgetSnapshotService.snapshot` phát giá trị mới khi thêm expense/bill/income.
- T03-7: Tiền lưu/đọc đúng cents (không sai số).
- T03-8: Schema dump v1 được commit và test migration chạy được.

**Definition of Done:**
- [ ] Không có xóa cứng trong toàn bộ data layer (trừ chức năng "Erase all data" ở Spec 017 — ghi rõ ngoại lệ)
- [ ] Mọi query đọc mặc định lọc `deleted_at IS NULL`
- [ ] DB chạy trên background isolate (drift `NativeDatabase.createInBackground`)

**Remember:** `docs/SESSION_STATE.md` (mục Knowledge) — sơ đồ bảng, quy ước soft delete, cách thêm migration.

---

## Bổ sung khi chuyển sang MVC + GetX

- Phụ thuộc thêm Spec 003 vì `BudgetSnapshotService` gọi engine.
- Controller không gọi engine trực tiếp; luôn đọc `IBudgetSnapshotService.snapshot`.

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
