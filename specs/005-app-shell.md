# Spec 005 · F04 — App shell: theme, router, l10n, component chung

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 005
> **Phụ thuộc:** Spec 001, Spec 004 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Khung giao diện và điều hướng dùng chung.

**Mô tả:**
- `ThemeData` light/dark từ token (`000-conventions.md` mục C, file `lib/core/theme/app_colors.dart`, `app_spacing.dart`, `app_text_styles.dart`); theo cài đặt hệ thống, có tùy chọn ép light/dark lưu ở `app_setting` (dùng ở Spec 017).
- `GetMaterialApp` + `lib/core/routes/app_routes.dart` (hằng số route) + `lib/core/routes/app_pages.dart` (danh sách `GetPage` kèm `binding`). Route: `/splash`, `/onboarding/welcome`, `/onboarding/income`, `/onboarding/bills`, `/onboarding/result`, `/root` (shell 3 tab), `/settings`, `/paywall`, `/expense/edit` (argument: id). Quick Add mở bằng `Get.bottomSheet` (không phải route).
- `OnboardingMiddleware extends GetMiddleware`: chưa onboarding → mọi route (trừ onboarding, splash) `redirect` về `/onboarding/welcome`.
- `RootShellPage` + `RootShellController` (`RxInt tabIndex`) dùng `IndexedStack` cho 3 tab Today · History · Plan, giữ state từng tab; `RootShellBinding` đăng ký controller của cả 3 tab bằng `Get.lazyPut`.
- `InitialBinding` (gắn vào `GetMaterialApp.initialBinding`): đăng ký các service/repository dùng chung (permanent).
- l10n: `app_en.arb`, helper `context.l10n`.
- Component dùng chung ở C3 với widget test cơ bản.
- `AmountKeypad`: phím 0–9, `00`, xóa (giữ để xóa hết), haptic nhẹ mỗi lần chạm.

**Test cases:**
- T04-1: `OnboardingMiddleware.redirect` trả đúng route khi chưa/đã onboarding.
- T04-2: Chuyển tab giữ state từng tab.
- T04-3: `AmountKeypad` nhập "1","2","5","0" → hiển thị `$12.50`; xóa → `$1.25`; giữ xóa → `$0.00`.
- T04-4: `AmountText` đổi màu theo `BudgetStatus`.
- T04-5: Golden component chính light/dark.

**Definition of Done:**
- [ ] Deep link `safetospend://quick-add` mở Quick Add (dùng cho widget ở Spec 019)
- [ ] Toàn bộ component có semantics label

**Remember:** danh sách route và component vào `docs/SESSION_STATE.md` (mục Knowledge).

---

## Implementation Plan

> Bước PLAN điền phần này (danh sách file tạo/sửa, contract, thứ tự làm, rủi ro, câu hỏi mở). Để trống cho đến khi chạy PLAN.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
