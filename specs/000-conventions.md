# Spec 000 — Quy ước chung: Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)

> **Đây là file bắt buộc đọc trước mọi Spec 001–027.** Mọi spec feature chỉ mô tả *cái gì cần làm*; file này quy định *làm như thế nào*: quy trình agent, kiến trúc MVC + GetX, quy ước code, Design System và Definition of Done chung.
>
> **Tài liệu liên quan:** `docs/safe-to-spend-product-plan.md` (định vị, monetization, lộ trình) · `specs/AGENT-RUNBOOK.md` (lệnh chạy agent cho từng spec).
> **Phạm vi:** Giai đoạn 1 (MVP), **local-first, không backend**. Server chỉ xuất hiện từ Giai đoạn 3.

---

## Mục lục

- [A. Quy trình Agent](#a-quy-trình-agent)
- [B. Kiến trúc & quy ước kỹ thuật (MVC + GetX)](#b-kiến-trúc--quy-ước-kỹ-thuật-mvc--getx)
- [C. Design System](#c-design-system)
- [D. Bản đồ spec & thứ tự triển khai](#d-bản-đồ-spec--thứ-tự-triển-khai)
- [Phụ lục](#phụ-lục)

---

# A. Quy trình Agent

## A1. Sáu bước cho mỗi spec

Agent **chỉ làm một spec mỗi lần**, theo thứ tự ở mục D. Không bắt đầu spec mới khi spec hiện tại chưa qua cổng REVIEW & VERIFY.

| Bước | Vai trò · Skill | Agent làm gì | Đầu ra | Cổng chuyển bước |
|---|---|---|---|---|
| **PLAN** | `@planner` · `/plan-spec` | Đọc spec, file này, `SESSION_STATE.md`, `DECISIONS.md` và code liên quan. Chốt danh sách file, contract (interface, model, trạng thái màn hình), ánh xạ test case → file test | Mục **Implementation Plan** trong file spec | Mọi spec phụ thuộc đã `DONE`. Không còn câu hỏi chặn việc (nếu có: dừng và hỏi) |
| **DEFINE TEST** | `@tdd-guide` · `/tdd-workflow` | Viết test **trước** code thật, đúng mã test case (Txx-y) trong spec. Mock bằng `mocktail` | File test trong `test/` hoặc `packages/budget_engine/test/` | Chạy test thấy **RED** (fail hoặc lỗi compile vì thiếu symbol đều hợp lệ). Ghi lại output |
| **IMPLEMENT** | `@developer` · `/flutter-mobile` | Code tối thiểu để test xanh. Tuân thủ mục B | Model, interface, service, controller, binding | `flutter test` **GREEN**, `flutter analyze` 0 issue |
| **DESIGN** | `@frontend-design` + `@developer` · `/ui-ux-pro-max` | Dựng/hoàn thiện page theo mục C và "Design notes" của spec. **Viết widget test và golden test** cho page/widget mới | Page, widget, binding, route; widget test, golden | Test mới và cũ đều GREEN. Spec không có UI: hoàn thiện API (dartdoc, README) |
| **REVIEW & VERIFY** | `@silent-failure-hunter` · `/review-code` | Rà soát theo danh sách trong runbook + DoD chung (A4) + DoD của spec. Chạy toàn bộ test, analyze, format; chạy app thật | Mục **Review & Verify Report** trong file spec, ghi **số liệu thực tế** | 100% DoD đạt. Nếu không: quay lại IMPLEMENT/DESIGN, rồi REVIEW lại |
| **REMEMBER** | `/session-memory` | Cập nhật bộ nhớ dự án (A3) bằng số liệu từ Review Report | `SESSION_STATE.md`, `DECISIONS.md`, `BACKLOG.md` | Spec chuyển `DONE` |

**Quy tắc vàng:**

1. Spec mâu thuẫn với code hiện có hoặc spec khác → **dừng ở PLAN và hỏi**, không tự đoán.
2. Không mở rộng phạm vi ngoài spec. Ý tưởng hay → ghi `docs/BACKLOG.md`.
3. Không sửa test để "cho xanh" nếu test phản ánh đúng yêu cầu. Nếu yêu cầu sai → ghi ADR và cập nhật spec.
4. Tên file test ở DEFINE TEST phải **trùng khớp** với file được nhắc ở IMPLEMENT và REVIEW.
5. Mọi số liệu trong báo cáo (số test, số warning) phải lấy từ **lần chạy thật**, không ghi trước.
6. Mọi số tiền dùng `Money` (cents, `int`). Mọi ngày nghiệp vụ dùng `LocalDate`. Không ngoại lệ.
7. Không gửi số tiền, ghi chú, tên hóa đơn/mục tiêu ra ngoài thiết bị (analytics, log, crash report).
8. **Quy ước Git:** Sau khi hoàn tất mỗi spec (hoặc tính năng), **USER sẽ tự thực hiện `git commit` và `git push` code**. Agent TUYỆT ĐỐI KHÔNG tự ý thực hiện commit hoặc push lên repository.

## A2. Lệnh chạy chuẩn

```bash
make gen        # dart run build_runner build --delete-conflicting-outputs
make test       # flutter test && (cd packages/budget_engine && dart test)
make analyze    # flutter analyze && (cd packages/budget_engine && dart analyze)
make format     # dart format --set-exit-if-changed .
make golden     # flutter test --update-goldens --tags golden   (chỉ khi thay đổi UI có chủ đích)
make coverage   # coverage cho app + engine, xuất lcov
```

## A3. Bộ nhớ dự án

Tạo ở Spec 001, cập nhật ở bước REMEMBER của mọi spec.

**`docs/SESSION_STATE.md`**

```markdown
# Session State
_Cập nhật: 2026-10-07 · Spec vừa xong: 003 · Spec tiếp theo: 004_

## Tiến độ
| Spec | Feature | Trạng thái | Tests (pass/total) | Analyze | Ngày |
|------|---------|------------|--------------------|---------|------|
| 001 | Project foundation | DONE | 2/2 | 0 | 2026-10-05 |
| 003 | Budget Engine | DONE | 61/61 (coverage 97%) | 0 | 2026-10-07 |
| 004 | Data layer | TODO | – | – | – |

Trạng thái: TODO · IN_PROGRESS (<bước>) · BLOCKED (<lý do>) · DONE

## Knowledge (điều spec sau cần biết)
- Engine: gọi `computeSnapshot(input, today)`; không tự gọi engine trong controller, đọc `BudgetSnapshotService.snapshot`.
- ...

## Known issues / Tech debt
- [Spec 011] ...

## Next
- Spec 004 · Data layer — phụ thuộc 002, 003 (đã DONE).
```

**`docs/DECISIONS.md`** — Architecture Decision Records:

```markdown
## ADR-003: Rollover "save" là dữ liệu dẫn xuất, không lưu DB
- Ngày: 2026-10-07 · Spec: 003
- Bối cảnh: ...
- Quyết định: ...
- Hệ quả: ...
```

**`docs/BACKLOG.md`** — ý tưởng ngoài phạm vi phát sinh trong quá trình làm.

**Trong mỗi file spec:** mục `Implementation Plan` (bước PLAN) và `Review & Verify Report` (bước REVIEW). Dòng `Trạng thái` ở đầu file cập nhật ở bước REMEMBER.

## A4. Definition of Done chung (áp dụng mọi spec)

Ngoài DoD riêng của từng spec:

**Chất lượng**
- [ ] Mọi test case trong spec có test tự động tương ứng và đều GREEN; toàn bộ test suite cũ vẫn GREEN
- [ ] `flutter analyze` → 0 issue (kể cả info); `dart format --set-exit-if-changed .` sạch
- [ ] Không dùng API deprecated
- [ ] Không `TODO`/`FIXME` mới mà không có mục trong `BACKLOG.md`

**GetX & vòng đời**
- [ ] Controller nhận dependency qua **constructor**; binding là nơi duy nhất gọi `Get.find`/`Get.put`/`Get.lazyPut`
- [ ] Không có logic nghiệp vụ trong page; page chỉ đọc state (`Obx`) và gọi method của controller
- [ ] Mọi `AnimationController`, `Timer`, `StreamSubscription`, `TextEditingController`, `ScrollController`, `WidgetsBindingObserver`, ad object được hủy trong `dispose()`/`onClose()`
- [ ] Worker GetX (`ever`, `debounce`, `interval`) được tạo trong `onInit` để tự hủy theo controller

**Không lỗi im lặng**
- [ ] Không có `catch` rỗng hoặc chỉ `print`. Mỗi `catch` phải: (a) chuyển state sang `error` kèm `errorMessage` thân thiện, **và** (b) ghi log qua `IAnalyticsService.recordError` (không kèm dữ liệu tài chính)
- [ ] Parse dữ liệu ngoài (JSON draft, backup, snapshot widget, settings) có xử lý dữ liệu hỏng mà không crash

**Hiển thị & truy cập**
- [ ] Không hardcode chuỗi hiển thị (dùng l10n ARB), màu, spacing, font (dùng token mục C)
- [ ] Đúng ở light và dark mode; Dynamic Type cỡ lớn nhất không vỡ layout
- [ ] Phần tử tương tác có semantics label; vùng chạm ≥ 44×44 pt

**Riêng tư & bộ nhớ**
- [ ] Không có số tiền/ghi chú/tên hóa đơn trong log, analytics, crash report
- [ ] Chạy thử thật trên iOS Simulator và Android Emulator ở luồng chính của spec
- [ ] `SESSION_STATE.md` cập nhật; quyết định mới ghi `DECISIONS.md`

---

# B. Kiến trúc & quy ước kỹ thuật (MVC + GetX)

## B1. Stack

| Lớp | Lựa chọn |
|---|---|
| Framework | Flutter stable mới nhất, Dart 3 |
| State, DI, routing | `get` (GetX): `GetxController`, `GetxService`, `Bindings`, `GetPage`, `GetMiddleware` |
| Database | SQLite qua `drift` (+ `drift_dev`, `sqlite3_flutter_libs`) |
| Engine | Package Dart thuần `packages/budget_engine` (không phụ thuộc Flutter, không phụ thuộc GetX) |
| Model bất biến | `freezed` + `json_serializable` (hoặc `equatable` cho model đơn giản) |
| Localization | `flutter_localizations` + `intl` (ARB), MVP chỉ `en` |
| Deep link | `app_links` |
| Widget cầu nối | `home_widget` |
| Widget native | iOS: Swift WidgetKit + App Intents · Android: Kotlin Jetpack Glance |
| Notification | `flutter_local_notifications` + `timezone` + `flutter_timezone` |
| Subscription | `purchases_flutter` (RevenueCat) |
| Ads | `google_mobile_ads` + UMP (consent) |
| Analytics / Crash | `firebase_analytics`, `firebase_crashlytics` |
| File | `file_picker`, `share_plus`, `path_provider` |
| Mã hóa backup | `cryptography` |
| Test | `flutter_test`, `mocktail`, `integration_test`, golden (`alchemist` hoặc tương đương) |

## B2. Cấu trúc thư mục (MVC + GetX)

```
safe_to_spend/
├─ lib/
│  ├─ main.dart
│  ├─ bootstrap.dart                    # mở DB, Get.put service nền, chọn route đầu
│  ├─ core/
│  │  ├─ bindings/initial_binding.dart  # service & repository dùng chung (permanent)
│  │  ├─ routes/
│  │  │  ├─ app_routes.dart             # hằng số route
│  │  │  ├─ app_pages.dart              # List<GetPage> + binding
│  │  │  └─ middlewares/onboarding_middleware.dart
│  │  ├─ theme/                         # app_colors.dart, app_spacing.dart, app_text_styles.dart, app_theme.dart
│  │  ├─ money/                         # MoneyFormatter, MoneyParser
│  │  ├─ time/                          # Clock, LocalDate ↔ timezone, DayChangeWatcher
│  │  ├─ ids/                           # UuidGenerator
│  │  ├─ analytics/                     # analytics_events.dart (hằng số tên sự kiện)
│  │  ├─ state/view_state.dart          # enum ViewState
│  │  ├─ widgets/                       # component dùng chung (mục C3)
│  │  └─ l10n/                          # app_en.arb
│  ├─ domain/                           # CHỈ interface, không phụ thuộc Flutter/GetX/drift
│  │  ├─ repositories/                  # i_profile_repository.dart, i_expense_repository.dart, ...
│  │  └─ services/                      # i_analytics_service.dart, i_entitlement_service.dart, ...
│  ├─ data/                             # hiện thực
│  │  ├─ db/                            # app_database.dart, tables/, daos/
│  │  ├─ mappers/                       # drift row ↔ model của engine
│  │  ├─ models/                        # model riêng của app (OnboardingDraft, WidgetSnapshot, BackupFile...)
│  │  ├─ repositories/                  # ExpenseRepository implements IExpenseRepository ...
│  │  └─ services/                      # BudgetSnapshotService, NotificationService, ...
│  └─ features/
│     └─ <feature>/
│        ├─ controllers/                # <x>_controller.dart (GetxController)
│        ├─ pages/                      # <x>_page.dart (GetView<XController>)
│        ├─ bindings/                   # <x>_binding.dart
│        └─ widgets/                    # widget riêng của feature
├─ packages/budget_engine/              # Money, LocalDate, model nghiệp vụ, engine — Dart thuần
├─ ios/SafeToSpendWidget/               # WidgetKit extension
├─ android/app/src/main/kotlin/.../widget/
├─ test/                                # mirror cấu trúc lib/; test/helpers/ chứa fake & pump helper
├─ integration_test/
├─ specs/                               # 000-conventions.md, 001…027-*.md, AGENT-RUNBOOK.md
└─ docs/                                # SESSION_STATE.md, DECISIONS.md, BACKLOG.md, product plan
```

**Danh sách feature folder:** `splash`, `onboarding`, `root` (shell 3 tab), `today`, `quick_add`, `history`, `plan`, `income`, `bills`, `goal`, `settings`, `premium`, `ads`.

## B3. Quy ước GetX

**Controller (`GetxController`)**
- Dependency nhận qua **constructor** (interface từ `lib/domain/`). Không gọi `Get.find` trong controller → controller test được bằng `mocktail` mà không cần GetX DI.
- State dạng `Rx`: `final state = ViewState.initial.obs;`, `final errorMessage = RxnString();`, dữ liệu `Rx<T>` / `RxList<T>`.
- Màn có dữ liệu dùng enum chung:
  ```dart
  enum ViewState { initial, loading, success, empty, error }
  ```
- Khởi tạo trong `onInit()` (đăng ký worker, subscribe stream). Dọn dẹp trong `onClose()`.
- Method public đặt tên theo hành động người dùng: `addExpense()`, `selectIncomeMode()`, `reset()`.
- Getter dẫn xuất (`isEmpty`, `canSubmit`) là hàm thuần trên state, có test.

**Service (`GetxService`)**
- Dùng cho thứ sống suốt app: `BudgetSnapshotService`, `EntitlementService`, `AnalyticsService`, `NotificationService`, `WidgetSyncService`, `AdsService`, `ThemeService`.
- Đăng ký trong `InitialBinding` với `permanent: true`. Hiện thực interface ở `lib/domain/services/`.

**Binding**
- Mỗi page có binding riêng; binding là nơi duy nhất gọi `Get.find`/`Get.put`/`Get.lazyPut`:
  ```dart
  class TodayBinding extends Bindings {
    @override
    void dependencies() {
      Get.lazyPut<TodayController>(() => TodayController(
            snapshotService: Get.find<IBudgetSnapshotService>(),
            clock: Get.find<Clock>(),
            analytics: Get.find<IAnalyticsService>(),
          ));
    }
  }
  ```
- Bottom sheet (Quick Add, form) không có route: tạo controller bằng `Get.put(..., tag: uniqueTag)` khi mở và `Get.delete(tag: ...)` khi đóng, qua một launcher duy nhất của feature.

**Page**
- `class TodayPage extends GetView<TodayController>`; render bằng `Obx`.
- Không logic nghiệp vụ, không gọi repository/service trực tiếp.
- Page có animation: `StatefulWidget` + `SingleTickerProviderStateMixin`, `dispose()` hủy `AnimationController`; tôn trọng `MediaQuery.disableAnimations`.

**Điều hướng**
- `Get.toNamed(AppRoutes.x)`, `Get.offAllNamed(AppRoutes.root)` sau onboarding; `OnboardingMiddleware` chặn route khi chưa onboarding.
- Quick Add mở qua `QuickAddLauncher.open(source:, editExpenseId:)` (Spec 012) từ FAB, deep link, widget, thông báo.

## B4. Quy ước dữ liệu

**Tiền tệ**
- `Money { int cents; String currency; }` (trong engine). **Không bao giờ dùng `double`** cho tiền.
- Hiển thị qua `MoneyFormatter` theo locale thiết bị + currency profile (`$12.50`, `£12.50`, `12,50 €`).
- Nhập qua `AmountKeypad` → chuỗi chữ số → cents. Tối đa `99,999,999` cents.

**Ngày giờ**
- Ngày nghiệp vụ: `LocalDate`, lưu DB `TEXT 'YYYY-MM-DD'`. "Hôm nay" theo múi giờ profile.
- Timestamp kỹ thuật (`created_at`, `updated_at`, `deleted_at`): `INTEGER` epoch ms UTC.
- Mọi code lấy thời gian qua `Clock` (inject được); test dùng `FakeClock`.

**ID & đồng bộ (chuẩn bị Giai đoạn 3)**
- Mọi bảng nghiệp vụ: `id TEXT PK (UUID v4)`, `created_at`, `updated_at`, `deleted_at NULL`, `device_id`.
- Không xóa cứng (ngoại lệ duy nhất: "Erase all data" ở Spec 017). Query mặc định lọc `deleted_at IS NULL`. Mọi lần sửa cập nhật `updated_at`.

**Engine**
- Hàm thuần `computeSnapshot(input, today)`; không I/O, không đồng hồ, không Flutter/GetX.
- Không lưu kết quả tính làm dữ liệu gốc; chỉ cache để hiển thị/widget.
- Controller **không** gọi engine trực tiếp; đọc `IBudgetSnapshotService.snapshot` (ngoại lệ: màn xem trước như Onboarding Result, Settings ví dụ rollover — gọi qua method của service, không import engine vào page).

**Analytics**
- Tên sự kiện chỉ lấy từ `lib/core/analytics/analytics_events.dart`. Thuộc tính chỉ là enum string, bool, số đếm. **Cấm** số tiền, ghi chú, tên.

**Premium**
- Kiểm tra qua `IEntitlementService.isPremium` (`RxBool`). Chặn tính năng qua `IPremiumGate.request(PremiumFeature)` (Spec 016 tạo, Spec 022 thay bằng paywall thật).

## B5. Quy ước test

| Loại | Phạm vi | Vị trí | Yêu cầu |
|---|---|---|---|
| Unit — engine | Money, LocalDate, engine | `packages/budget_engine/test/` | Coverage ≥ **95%** |
| Unit — controller | Mọi `GetxController` | `test/features/<f>/controllers/` | Mock interface bằng `mocktail`; gọi `controller.onInit()` thủ công; `Get.testMode = true`; `Get.reset()` ở `tearDown` |
| Unit — data | Repository, service | `test/data/` | DB in-memory `NativeDatabase.memory()` |
| Widget | Mọi page | `test/features/<f>/pages/` | Bọc `GetMaterialApp`; `Get.put<XController>(fakeController)` |
| Golden | Today, Quick Add, Paywall, Onboarding Result, Welcome, component chung | `test/**/goldens/` | Tag `golden`; light + dark; cỡ chữ thường + lớn nhất |
| Integration | Luồng end-to-end | `integration_test/` | Chạy trên simulator/emulator |
| Native | Widget iOS/Android | thủ công | Checklist ghi trong Review & Verify Report |

Fake dùng chung trong `test/helpers/`: `FakeClock`, `FakeUuidGenerator`, `FakeAnalyticsService`, `FakeEntitlementService`, `FakeNotificationsPlugin`, `pumpGetPage()`.

Quy ước đặt tên test: `test('T10-3: qua nửa đêm khi app resume → cập nhật ngày và số', ...)` — mã test case luôn đứng đầu mô tả để truy vết.

---

# C. Design System

> Agent áp dụng ở bước **DESIGN**. Token định nghĩa tại `lib/core/theme/` (`app_colors.dart`, `app_spacing.dart`, `app_text_styles.dart`, `app_theme.dart`) ở Spec 005.

## C1. Nguyên tắc

- **Một con số là trung tâm.** Màn Today chỉ có một tiêu điểm thị giác.
- **Bình tĩnh, không phán xét.** Không dùng đỏ chói cho trạng thái vượt; dùng màu "warning" dịu và ngôn ngữ trung tính ("Over by $8 — tomorrow adjusts to $21").
- **Nhanh hơn ghi giấy.** Ghi một khoản chi ≤ 3 chạm.

## C2. Token

| Nhóm | Token | Giá trị gợi ý |
|---|---|---|
| Màu thương hiệu (`AppColors`) | `primary` | Xanh lá dịu `#2E9E6A` (light) / `#4CC38A` (dark) |
| Trạng thái | `onTrack` | = `primary` |
| | `caution` (còn < 20% hạn mức ngày) | Hổ phách `#D98E04` / `#F2B544` |
| | `over` (âm) | Cam đất `#C8553D` / `#E07A5F` — không dùng đỏ thuần |
| Nền | `surface`, `surfaceVariant`, `background` | Theo Material 3, tùy chỉnh nhẹ |
| Spacing | `xs 4 · s 8 · m 12 · l 16 · xl 24 · xxl 32 · xxxl 48` | |
| Bo góc | `card 20 · button 14 · chip 999` | |
| Typography | `display` (con số chính) | 56–64sp, weight 700, `tabular figures` |
| | `title 22 · body 16 · label 14 · caption 12` | |
| Motion | `fast 150ms · normal 250ms · slow 400ms` | Easing `easeOutCubic` |

- Mọi số tiền dùng **tabular figures** để không nhảy layout khi đổi số.
- Hỗ trợ `prefers reduced motion`: tắt animation đếm số.

## C3. Component dùng chung (tạo ở Spec 005, đặt tại `lib/core/widgets/`)

`AppScaffold`, `PrimaryButton`, `SecondaryButton`, `AmountText` (format + màu theo trạng thái), `AmountKeypad`, `CategoryChip`, `SectionCard`, `EmptyState`, `ProgressRing`, `PremiumBadge`, `AppBottomSheet`, `ConfirmDialog`.

---

# D. Bản đồ spec & thứ tự triển khai

| Thứ tự | Spec | ID gốc | Feature | Phụ thuộc | Ước lượng |
|:-:|---|---|---|---|:-:|
| 1 | [001](001-project-foundation.md) | F00 | Project foundation & bộ nhớ dự án | — | 0,5 ngày |
| 2 | [002](002-core-primitives.md) | F01 | Core primitives: Money, LocalDate, Clock, UUID | 001 | 1 ngày |
| 3 | [003](003-budget-engine.md) | F02 | Budget Engine (package Dart thuần) | 002 | 3–4 ngày |
| 4 | [004](004-data-layer.md) | F03 | Data layer (drift schema, DAO, repository) | 002, 003 | 2 ngày |
| 5 | [005](005-app-shell.md) | F04 | App shell: theme, router, l10n, component chung | 001, 004 | 1,5 ngày |
| 6 | [006](006-splash-bootstrap.md) | F05 | Splash & bootstrap | 004, 005 | 0,5 ngày |
| 7 | [007](007-onboarding-welcome.md) | F06 | Onboarding 1: Welcome | 006 | 0,5 ngày |
| 8 | [008](008-onboarding-income.md) | F07 | Onboarding 2: Income & pay schedule | 007, 003, 005 | 1,5 ngày |
| 9 | [009](009-onboarding-bills.md) | F08 | Onboarding 3: Bills (bỏ qua được) | 008 | 1 ngày |
| 10 | [010](010-onboarding-result.md) | F09 | Onboarding 4: Result reveal & quyền thông báo | 009 | 1 ngày |
| 11 | [011](011-today.md) | F10 | Today screen | 010, 005 | 2 ngày |
| 12 | [012](012-quick-add.md) | F11 | Quick Add expense | 011 | 1,5 ngày |
| 13 | [013](013-history.md) | F12 | History (xem, sửa, xóa, ghi lùi) | 012 | 1,5 ngày |
| 14 | [014](014-income-log.md) | F13 | Income log (chế độ thu nhập không đều) | 011 | 1 ngày |
| 15 | [015](015-bills.md) | F14 | Bills management | 011, 009 | 1 ngày |
| 16 | [016](016-savings-goal.md) | F15 | Savings Goal (1 mục tiêu) | 011 | 1 ngày |
| 17 | [017](017-settings.md) | F16 | Settings | 011, 016 | 1,5 ngày |
| 18 | [018](018-notifications.md) | F17 | Local notifications | 015, 017 | 1,5 ngày |
| 19 | [019](019-home-widget.md) | F18 | Home Screen widget (iOS + Android) | 011, 012, 018 | 3 ngày |
| 20 | [020](020-backup-restore.md) | F19 | Backup & Restore (file) | 017 | 1 ngày |
| 21 | [021](021-analytics-crash.md) | F20 | Analytics & Crash reporting | 006 | 0,5 ngày |
| 22 | [022](022-premium-paywall.md) | F21 | Premium: RevenueCat, entitlement, paywall | 017, 021 | 2 ngày |
| 23 | [023](023-rollover-modes.md) | F22 | Premium: Rollover modes (Tomorrow boost / Save to goal) | 003, 022 | 1 ngày |
| 24 | [024](024-lockscreen-widget-themes.md) | F23 | Premium: Lock Screen widget & themes | 019, 022 | 2 ngày |
| 25 | [025](025-csv-export.md) | F24 | Premium: CSV export | 022 | 0,5 ngày |
| 26 | [026](026-ads.md) | F25 | Ads: AdMob + UMP consent | 022 | 1,5 ngày |
| 27 | [027](027-release-readiness.md) | F26 | Release readiness | 001–026 | 2 ngày |

**Luồng màn hình MVP:**

```
Splash ─┬─(chưa onboard)→ Welcome → Income & Pay → Bills → Result ─┐
        │                                                          ↓
        └─(đã onboard)────────────────────────────────────────→ Root (3 tab)
                                                                   │
        ┌───────────────┬──────────────┬──────────────┬────────────┤
        ↓               ↓              ↓              ↓            ↓
   Quick Add        History          Plan          Settings     Paywall
   (bottom sheet)  (edit/delete)  (Income/Bills/   (budget, reminders,
                                     Goal)          backup, premium)
```

**Điều hướng chính:** Root có bottom navigation 3 tab **Today · History · Plan** (Plan gồm Income khi ở chế độ irregular, Bills, Goal). Settings mở từ icon góc trên của Today.

---

# Phụ lục

## Phụ lục 1. Danh sách sự kiện analytics (tổng hợp)

| Sự kiện | Thuộc tính cho phép |
|---|---|
| `app_open` | `is_first_open`, `has_profile` |
| `onboarding_start` | — |
| `onboarding_income_mode_selected` | `mode` |
| `onboarding_pay_frequency_selected` | `frequency` |
| `onboarding_step_completed` | `step` |
| `onboarding_bills_added` / `onboarding_bills_skipped` | `count` |
| `onboarding_complete` | `income_mode`, `pay_frequency`, `bills_count` |
| `notification_permission_result` | `granted` |
| `today_view` | `status` |
| `new_period_banner_shown` | — |
| `expense_added` | `source`, `has_note`, `has_category`, `is_backdated` |
| `expense_edited` | `field_changed` |
| `expense_deleted` | `via` |
| `history_view` | — |
| `income_added` / `income_deleted` | `is_backdated` |
| `bill_added` / `bill_edited` / `bill_deleted` | `recurrence`, `has_reminder` |
| `goal_created` | `has_target_date`, `has_per_paycheck` |
| `goal_contribution_added` / `goal_completed` | — |
| `settings_changed` | `setting_key`, `value_enum` |
| `data_erased` | — |
| `notification_opened` | `type` |
| `widget_installed` | `platform`, `size` |
| `backup_exported` / `backup_restored` / `backup_restore_failed` | `encrypted`, `reason` |
| `paywall_view` | `trigger` |
| `paywall_plan_selected` | `plan` |
| `purchase_started` / `purchase_success` / `purchase_cancelled` / `purchase_failed` | `plan`, `is_trial`, `reason` |
| `restore_success` / `restore_failed` | — |
| `rollover_mode_changed` | `mode` |
| `theme_changed` / `theme_trial_started` | `theme` |
| `csv_exported` | `range` |
| `ad_impression` / `ad_rewarded_completed` | `format`, `placement` |
| `consent_result` | `status` |

## Phụ lục 2. Free vs Premium (MVP)

| Tính năng | Free | Premium |
|---|:-:|:-:|
| Con số safe-to-spend, fixed & irregular | ✔ | ✔ |
| Ghi chi tiêu, ghi lùi, sửa, xóa | ✔ | ✔ |
| Hóa đơn không giới hạn + nhắc | ✔ | ✔ |
| 1 mục tiêu tiết kiệm | ✔ | ✔ |
| Home Screen widget | ✔ | ✔ |
| Thông báo sáng/tối | ✔ | ✔ |
| Backup / Restore file | ✔ | ✔ |
| Rollover: Tomorrow boost, Save to goal | | ✔ |
| Lock Screen widget | | ✔ |
| App themes (thử 24h bằng rewarded ad) | | ✔ |
| CSV export | | ✔ |
| Không quảng cáo | | ✔ |
| Nhiều mục tiêu | | Giai đoạn 2 |

## Phụ lục 3. Thay đổi so với `safe-to-spend-product-plan.md`

Để engine tất định và triển khai được, spec này bổ sung/điều chỉnh:

1. `budget_profile` thêm `first_period_balance_cents` (fixed, kỳ đầu) và `starting_balance_cents` (irregular), `tracking_start_date`.
2. `goal` thêm `per_paycheck_cents` và `created_on`.
3. Bảng giao dịch đổi tên `transaction` → `expense`; `source` MVP chỉ gồm `manual`/`widget` (`apple_pay`/`siri` thêm ở Giai đoạn 2).
4. Đóng góp từ rollover "Save" là **dữ liệu dẫn xuất**, không lưu vào `goal_contribution` (chỉ lưu đóng góp thủ công).
5. Chế độ irregular không dùng rollover mode trong MVP.
6. Thông báo và widget dùng giá trị **tính sẵn 7 ngày tới, giả định không chi tiêu thêm**.
7. State management đổi từ Riverpod + go_router sang **MVC + GetX** để khớp bộ agent/skill hiện có; engine vẫn là package Dart thuần, data vẫn dùng drift.
8. Engine bổ sung `computeDailyLedger` (Spec 013, cho History) và `projectNextDays` (Spec 018, cho thông báo và widget).
9. Bộ nhớ dự án dùng `docs/SESSION_STATE.md` + `DECISIONS.md` + `BACKLOG.md`; kế hoạch và báo cáo review nằm ngay trong file spec.

> Agent ghi các mục này thành ADR ở `docs/DECISIONS.md` khi làm Spec 003, 004, 013, 018, 019.

## Phụ lục 4. Backlog đã biết (ngoài MVP)

- Dời ngày lương/hóa đơn khi rơi vào cuối tuần.
- Thu nhập phát sinh thêm ở fixed mode.
- Nhiều mục tiêu (Premium, Giai đoạn 2).
- Apple Pay auto-log qua Shortcuts + App Intents, Siri, Action Button, Apple Watch (Giai đoạn 2).
- Recap tuần, dự báo thu nhập không đều (Giai đoạn 2).
- Tài khoản, đồng bộ server (Supabase, EU region), ngân sách chung, travel mode đa tiền tệ, bản địa hóa DE/FR/ES/NL (Giai đoạn 3).
- Kết nối ngân hàng Pro+, quét hóa đơn bằng AI (Giai đoạn 4).
