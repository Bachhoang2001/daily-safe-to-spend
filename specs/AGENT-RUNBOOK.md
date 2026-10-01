# AGENT RUNBOOK — Daily Safe-to-Spend (MVP)

> Lệnh chạy agent cho từng spec, theo đúng 6 bước **PLAN → DEFINE TEST → IMPLEMENT → DESIGN → REVIEW & VERIFY → REMEMBER**.
> Mỗi khối `AGENT INSTRUCTION` có thể dán nguyên văn cho agent. Chạy **lần lượt từng bước**, đọc kết quả rồi mới dán bước tiếp theo.
> Nguồn sự thật: `specs/000-conventions.md` + file spec của từng feature. Runbook chỉ là lệnh điều phối.

## Cách dùng

1. Mở `docs/SESSION_STATE.md`, xem spec tiếp theo ở mục **Next**.
2. Tìm khối `Spec <số>` bên dưới, dán từng bước cho agent theo thứ tự.
3. Sau bước **PLAN**, đọc mục Implementation Plan trong file spec trước khi cho chạy tiếp (đặc biệt Spec 003 Budget Engine).
4. Sau bước **REVIEW & VERIFY**, chỉ chạy **REMEMBER** khi Review Report ghi 100% đạt.
5. Nếu agent dừng vì câu hỏi chặn việc: trả lời, ghi quyết định vào `docs/DECISIONS.md` (nếu là quyết định thiết kế), rồi chạy lại bước đó.
6. **Quy ước Git:** Xong mỗi spec (hoặc tính năng), **USER tự thực hiện commit + push code**. Agent KHÔNG tự ý chạy lệnh commit hoặc push lên repository.

## Vai trò & skill

| Bước | Vai trò | Skill |
|---|---|---|
| PLAN | `@planner` | `/plan-spec` |
| DEFINE TEST | `@tdd-guide` | `/tdd-workflow` |
| IMPLEMENT | `@developer` | `/flutter-mobile` |
| DESIGN | `@frontend-design` + `@developer` | `/ui-ux-pro-max` (spec không có UI: `@developer` + `/flutter-mobile`) |
| REVIEW & VERIFY | `@silent-failure-hunter` | `/review-code` |
| REMEMBER | — | `/session-memory` |

## Những điểm đã sửa so với luồng cũ

- **Tên file test thống nhất** giữa DEFINE TEST, IMPLEMENT và REVIEW (luồng cũ nhắc `room_analysis_result_test.dart` nhưng không tạo).
- **DESIGN có widget/golden test** cho page và widget mới, không để logic UI chưa được kiểm thử.
- **REVIEW có cổng chặn**: chưa đạt 100% thì quay lại sửa, không sang REMEMBER.
- **REMEMBER ghi số liệu thực tế** từ Review Report thay vì ghi sẵn kết quả trong lệnh.
- **PLAN không viết lại spec** (spec đã có sẵn) mà bổ sung mục Implementation Plan và kiểm tra điều kiện phụ thuộc.

## Mục lục

- Spec 001 · F00 — Project foundation & bộ nhớ dự án
- Spec 002 · F01 — Core primitives: Money, LocalDate, Clock, UUID
- Spec 003 · F02 — Budget Engine (package Dart thuần)
- Spec 004 · F03 — Data layer (drift schema, DAO, repository)
- Spec 005 · F04 — App shell: theme, router, l10n, component chung
- Spec 006 · F05 — Splash & bootstrap
- Spec 007 · F06 — Onboarding 1: Welcome
- Spec 008 · F07 — Onboarding 2: Income & pay schedule
- Spec 009 · F08 — Onboarding 3: Bills (bỏ qua được)
- Spec 010 · F09 — Onboarding 4: Result reveal & quyền thông báo
- Spec 011 · F10 — Today screen
- Spec 012 · F11 — Quick Add expense
- Spec 013 · F12 — History (xem, sửa, xóa, ghi lùi)
- Spec 014 · F13 — Income log (chế độ thu nhập không đều)
- Spec 015 · F14 — Bills management
- Spec 016 · F15 — Savings Goal (1 mục tiêu)
- Spec 017 · F16 — Settings
- Spec 018 · F17 — Local notifications
- Spec 019 · F18 — Home Screen widget (iOS + Android)
- Spec 020 · F19 — Backup & Restore (file)
- Spec 021 · F20 — Analytics & Crash reporting
- Spec 022 · F21 — Premium: RevenueCat, entitlement, paywall
- Spec 023 · F22 — Premium: Rollover modes (Tomorrow boost / Save to goal)
- Spec 024 · F23 — Premium: Lock Screen widget & themes
- Spec 025 · F24 — Premium: CSV export
- Spec 026 · F25 — Ads: AdMob + UMP consent
- Spec 027 · F26 — Release readiness

---

## Spec 001 · F00 — Project foundation & bộ nhớ dự án

**File spec:** `specs/001-project-foundation.md` · **Phụ thuộc:** không có · **Ước lượng:** 0,5 ngày

```text
AGENT INSTRUCTION — Spec 001

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/001-project-foundation.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điền mục "Implementation Plan" trong specs/001-project-foundation.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt package name, bundle id/applicationId cho flavor `dev` và `prod`, phiên bản Flutter/Dart cố định.
- Chốt danh sách dependency (000-conventions.md mục B1) và phiên bản; bộ lint (`very_good_analysis` hoặc `flutter_lints` nghiêm ngặt).
- Chốt nội dung `Makefile` (mục A2) và workflow CI (format → analyze → test app + engine).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/001-project-foundation.md.
Tạo các file test:
- test/app_smoke_test.dart — T00-1: render `GetMaterialApp` tối thiểu không lỗi
- packages/budget_engine/test/smoke_test.dart — T00-2: `dart test` chạy được trong package engine
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/app_smoke_test.dart && cd packages/budget_engine && dart test
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. pubspec.yaml (dependency theo mục B1), analysis_options.yaml, l10n.yaml
2. lib/main.dart, lib/bootstrap.dart (khung), lib/core/bindings/initial_binding.dart (rỗng)
3. lib/core/routes/app_routes.dart, lib/core/routes/app_pages.dart (1 route placeholder)
4. packages/budget_engine/pubspec.yaml, packages/budget_engine/lib/budget_engine.dart
5. Flavor dev/prod: Android productFlavors, iOS schemes + xcconfig, tên app khác nhau
6. Makefile theo mục A2, .github/workflows/ci.yaml
7. docs/SESSION_STATE.md (bảng Spec 001–027 = TODO), docs/DECISIONS.md, docs/BACKLOG.md theo mẫu mục A3
8. Tạo sẵn các thư mục rỗng theo mục B2 (giữ bằng .gitkeep)
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/app_smoke_test.dart && cd packages/budget_engine && dart test → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Spec này không có giao diện người dùng.
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile để hoàn thiện thiết kế API:
1. Kiểm tra tên app và icon placeholder hiển thị khác nhau giữa dev và prod.
2. Viết README.md ngắn: yêu cầu môi trường, cách chạy từng flavor, các lệnh make.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 001:
1. Build và chạy được cả dev và prod trên iOS Simulator và Android Emulator.
2. CI chạy xanh trên nhánh chính (đẩy thử một commit).
3. Không có dependency thừa; phiên bản được ghim.
4. Cấu trúc thư mục khớp 100% mục B2.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/001-project-foundation.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 001 · Project foundation & bộ nhớ dự án = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Bundle id/applicationId từng flavor; Lệnh chạy flavor, phiên bản Flutter/Dart; Các lệnh make.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/001-project-foundation.md thành DONE.
- Next: Spec 002 · Core primitives: Money, LocalDate, Clock, UUID (file specs/002-core-primitives.md).
```

---

## Spec 002 · F01 — Core primitives: Money, LocalDate, Clock, UUID

**File spec:** `specs/002-core-primitives.md` · **Phụ thuộc:** Spec 001 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 002

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/002-core-primitives.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 001 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/002-core-primitives.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt API public của `Money` và `LocalDate` (trong engine) và vị trí phần phụ thuộc Flutter/timezone (`lib/core/`).
- Chốt quy tắc làm tròn: `divideEvenly` dồn phần dư cents cho các phần đầu; `percent` làm tròn xuống.
- Chốt cách CI chặn dùng `double` cho tiền (lint rule hoặc grep check).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/002-core-primitives.md.
Tạo các file test:
- packages/budget_engine/test/money_test.dart — T01-1, T01-2, T01-3
- packages/budget_engine/test/local_date_test.dart — T01-4, T01-5
- test/core/time/local_date_timezone_test.dart — T01-6
- test/core/money/money_formatter_test.dart — T01-7
- test/core/money/money_parser_test.dart — T01-8
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: cd packages/budget_engine && dart test && flutter test test/core
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. packages/budget_engine/lib/src/money.dart (Money, CurrencyMismatchError)
2. packages/budget_engine/lib/src/local_date.dart
3. lib/core/time/clock.dart (Clock, SystemClock), lib/core/time/local_date_timezone.dart
4. lib/core/ids/uuid_generator.dart
5. lib/core/money/money_formatter.dart, lib/core/money/money_parser.dart
6. test/helpers/fake_clock.dart, test/helpers/fake_uuid_generator.dart
7. Bước CI chặn double cho tiền
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: cd packages/budget_engine && dart test && flutter test test/core → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Spec này không có giao diện người dùng.
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile để hoàn thiện thiết kế API:
1. Viết dartdoc cho mọi API public kèm ví dụ ngắn.
2. Rà soát tên API nhất quán (ví dụ addDays, daysUntil, isBefore).

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 002:
1. Coverage Money và LocalDate ≥ 95%.
2. Phép cộng/trừ khác currency luôn throw, không âm thầm bỏ qua.
3. addMonths kẹp đúng cuối tháng, kể cả năm nhuận.
4. Khởi tạo dữ liệu timezone không làm chậm khởi động (lazy).
5. Không còn double cho tiền ở bất kỳ đâu (chạy check CI).
6. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
7. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
8. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
9. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/002-core-primitives.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 002 · Core primitives: Money, LocalDate, Clock, UUID = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Cách dùng Money, LocalDate, Clock, UuidGenerator kèm ví dụ; Fake dùng chung trong test/helpers/.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/002-core-primitives.md thành DONE.
- Next: Spec 003 · Budget Engine (package Dart thuần) (file specs/003-budget-engine.md).
```

---

## Spec 003 · F02 — Budget Engine (package Dart thuần)

**File spec:** `specs/003-budget-engine.md` · **Phụ thuộc:** Spec 002 · **Ước lượng:** 3–4 ngày

```text
AGENT INSTRUCTION — Spec 003

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/003-budget-engine.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 002 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/003-budget-engine.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt chính xác các model `EngineInput`, `BudgetConfig`, `BudgetSnapshot`, `Expense`, `Bill`, `IncomeEntry`, `Goal`, `GoalContribution`, các enum (mục F02.1).
- Chốt thuật toán mô phỏng từng ngày cho Spread / Tomorrow boost / Save (mục F02.4) và công thức irregular (F02.5) dưới dạng pseudo-code trong Implementation Plan.
- Chốt bộ sinh occurrence hóa đơn (F02.6) và cách xác định kỳ lương (F02.2).
- Liệt kê 3 ADR sẽ ghi (rollover save dẫn xuất; đổi payFrequency không tái hiện kỳ cũ; irregular không dùng rollover).
- Nếu thấy công thức nào mơ hồ hoặc mâu thuẫn bất biến: dừng và hỏi trước khi viết test.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/003-budget-engine.md.
Tạo các file test:
- packages/budget_engine/test/period_resolver_test.dart — T02-5, T02-6, T02-7, T02-8
- packages/budget_engine/test/bill_occurrences_test.dart — Sinh occurrence weekly/monthly/yearly, kẹp ngày 31, không sinh trước `firstDueDate`
- packages/budget_engine/test/engine_fixed_spread_test.dart — T02-1, T02-2, T02-3, T02-4, T02-9, T02-10, T02-11, T02-12, T02-24
- packages/budget_engine/test/engine_rollover_test.dart — T02-13, T02-14, T02-15, T02-16
- packages/budget_engine/test/engine_irregular_test.dart — T02-17, T02-18, T02-19, T02-20
- packages/budget_engine/test/engine_invariants_test.dart — T02-21 (property-based, seed cố định, 1.000 cấu hình), T02-22
- packages/budget_engine/test/engine_performance_test.dart — T02-23
- packages/budget_engine/test/engine_edge_cases_test.dart — Toàn bộ mục F02.9
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: cd packages/budget_engine && dart test
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. packages/budget_engine/lib/src/models/ (engine_input, budget_config, budget_snapshot, expense, bill, income_entry, goal, goal_contribution, bill_occurrence, goal_progress, enums)
2. packages/budget_engine/lib/src/period_resolver.dart
3. packages/budget_engine/lib/src/bill_occurrences.dart
4. packages/budget_engine/lib/src/fixed/day_simulator.dart (Spread, Tomorrow, Save)
5. packages/budget_engine/lib/src/irregular/irregular_calculator.dart
6. packages/budget_engine/lib/src/compute_snapshot.dart (hàm public computeSnapshot)
7. Export qua packages/budget_engine/lib/budget_engine.dart
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: cd packages/budget_engine && dart test → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Spec này không có giao diện người dùng.
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile để hoàn thiện thiết kế API:
1. Hoàn thiện "thiết kế API": dartdoc cho computeSnapshot và từng chế độ, ghi công thức đúng như spec.
2. Viết packages/budget_engine/README.md: ví dụ đầu vào → đầu ra cho fixed, irregular và từng rollover mode.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 003:
1. Engine không import Flutter/GetX, không gọi DateTime.now(), không I/O.
2. Chia nguyên: phần dư cents không bị mất hay nhân đôi qua cả kỳ (T02-22).
3. Danh sách rỗng, pool âm, kỳ còn 1 ngày, today trước trackingStartDate không gây exception.
4. Bất biến tổng (T02-21) đúng cho Spread và Save.
5. Coverage engine ≥ 95% (dart test --coverage + format lcov).
6. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
7. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
8. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
9. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/003-budget-engine.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 003 · Budget Engine (package Dart thuần) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Bảng tóm tắt công thức từng chế độ; Các bất biến engine; Cách gọi computeSnapshot.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Thêm ADR vào docs/DECISIONS.md: Rollover "save" là dữ liệu dẫn xuất.
- Thêm ADR vào docs/DECISIONS.md: Đổi `payFrequency` không tái hiện kỳ cũ.
- Thêm ADR vào docs/DECISIONS.md: Irregular không dùng rollover mode.
- Đổi dòng "Trạng thái" đầu file specs/003-budget-engine.md thành DONE.
- Next: Spec 004 · Data layer (drift schema, DAO, repository) (file specs/004-data-layer.md).
```

---

## Spec 004 · F03 — Data layer (drift schema, DAO, repository)

**File spec:** `specs/004-data-layer.md` · **Phụ thuộc:** Spec 002, Spec 003 · **Ước lượng:** 2 ngày

```text
AGENT INSTRUCTION — Spec 004

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/004-data-layer.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 002, Spec 003 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/004-data-layer.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt schema drift từng bảng (mục spec) và các cột chung đồng bộ.
- Chốt interface `I...Repository` trong `lib/domain/repositories/` và method từng repository.
- Chốt mapper drift row ↔ model engine trong `lib/data/mappers/`.
- Chốt contract `IBudgetSnapshotService` (`Rx<BudgetSnapshot?> snapshot`, cách gộp stream, debounce nếu cần).
- Chốt đăng ký DI trong `InitialBinding` (permanent).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/004-data-layer.md.
Tạo các file test:
- test/data/db/app_database_test.dart — T03-4, T03-5, T03-7
- test/data/repositories/expense_repository_test.dart — T03-1, T03-2, T03-3
- test/data/repositories/profile_bill_goal_repositories_test.dart — CRUD + soft delete cho profile, income, bill, goal, category, settings
- test/data/services/budget_snapshot_service_test.dart — T03-6
- test/data/db/migration_test.dart — T03-8
Dùng DB in-memory `NativeDatabase.memory()`, `FakeClock`, `FakeUuidGenerator`; không mock drift.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/data/db/app_database.dart, lib/data/db/tables/*.dart, lib/data/db/daos/*.dart
2. lib/domain/repositories/i_profile_repository.dart, i_expense_repository.dart, i_income_repository.dart, i_bill_repository.dart, i_goal_repository.dart, i_category_repository.dart, i_settings_repository.dart
3. lib/data/repositories/*_repository.dart (hiện thực)
4. lib/data/mappers/*.dart
5. lib/domain/services/i_budget_snapshot_service.dart, lib/data/services/budget_snapshot_service.dart (GetxService)
6. Đăng ký vào lib/core/bindings/initial_binding.dart
7. Schema dump drift_schemas/ v1
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Spec này không có giao diện người dùng.
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile để hoàn thiện thiết kế API:
1. Thêm sơ đồ bảng (dạng text) vào SESSION_STATE.md mục Knowledge ở bước REMEMBER.
2. Dartdoc cho từng interface repository.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 004:
1. Mọi query đọc lọc deleted_at IS NULL; không có xóa cứng.
2. Mọi update cập nhật updated_at, giữ created_at.
3. DB chạy background isolate (NativeDatabase.createInBackground).
4. BudgetSnapshotService hủy mọi StreamSubscription trong onClose.
5. Lỗi đọc DB trong service không bị nuốt: chuyển trạng thái lỗi và ghi log.
6. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
7. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
8. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
9. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/004-data-layer.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 004 · Data layer (drift schema, DAO, repository) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Sơ đồ bảng; Quy ước soft delete; Cách thêm migration; Mọi controller đọc con số từ IBudgetSnapshotService.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Thêm ADR vào docs/DECISIONS.md: Dùng tên bảng `expense` thay cho `transaction`.
- Đổi dòng "Trạng thái" đầu file specs/004-data-layer.md thành DONE.
- Next: Spec 005 · App shell: theme, router, l10n, component chung (file specs/005-app-shell.md).
```

---

## Spec 005 · F04 — App shell: theme, router, l10n, component chung

**File spec:** `specs/005-app-shell.md` · **Phụ thuộc:** Spec 001, Spec 004 · **Ước lượng:** 1,5 ngày

```text
AGENT INSTRUCTION — Spec 005

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/005-app-shell.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 001, Spec 004 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/005-app-shell.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt danh sách route trong `AppRoutes` và `GetPage` + binding tương ứng.
- Chốt `OnboardingMiddleware` (dựa trên `IProfileRepository.hasCompletedOnboarding`).
- Chốt `RootShellController` (`RxInt tabIndex`) và `RootShellBinding` (lazyPut controller 3 tab, page tab tạm là placeholder).
- Chốt `DeepLinkService` (`app_links`) cho `safetospend://quick-add`.
- Chốt API các component dùng chung (mục C3), đặc biệt `AmountKeypad` và `AmountText`.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/005-app-shell.md.
Tạo các file test:
- test/core/routes/onboarding_middleware_test.dart — T04-1
- test/features/root/controllers/root_shell_controller_test.dart — T04-2
- test/core/widgets/amount_keypad_test.dart — T04-3
- test/core/widgets/amount_text_test.dart — T04-4
- test/core/services/deep_link_service_test.dart — Parse `safetospend://quick-add?source=widget` → sự kiện mở Quick Add
Mock `IProfileRepository`, `IAnalyticsService` bằng mocktail.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/core test/features/root
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/core/theme/app_colors.dart, app_spacing.dart, app_text_styles.dart, app_theme.dart (light/dark)
2. lib/core/routes/app_routes.dart, app_pages.dart, middlewares/onboarding_middleware.dart
3. lib/core/l10n/app_en.arb + cấu hình gen
4. lib/core/state/view_state.dart
5. lib/core/widgets/ theo mục C3
6. lib/features/root/controllers/root_shell_controller.dart, pages/root_shell_page.dart, bindings/root_shell_binding.dart
7. lib/domain/services/i_deep_link_service.dart, lib/data/services/deep_link_service.dart
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/core test/features/root → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/005-app-shell.md:
1. Áp dụng token mục C cho ThemeData light/dark (Material 3), font với tabular figures cho số tiền.
2. Hoàn thiện component C3: trạng thái pressed/disabled, haptic nhẹ cho AmountKeypad.
3. Bottom navigation 3 tab Today · History · Plan với icon + label, đổi tab không mất state.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/core/widgets/goldens/components_golden_test.dart — T04-5 (light/dark, cỡ chữ lớn nhất)
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 005:
1. AmountKeypad: Timer cho giữ-để-xóa được hủy khi dispose.
2. Deep link khi app cold start và khi đang chạy đều xử lý đúng một lần.
3. OnboardingMiddleware không gây vòng lặp redirect.
4. Mọi component có semantics label; không hardcode màu/spacing.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/005-app-shell.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 005 · App shell: theme, router, l10n, component chung = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Danh sách route; Danh sách component dùng chung và cách dùng; Cách đăng ký page mới vào AppPages.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/005-app-shell.md thành DONE.
- Next: Spec 006 · Splash & bootstrap (file specs/006-splash-bootstrap.md).
```

---

## Spec 006 · F05 — Splash & bootstrap

**File spec:** `specs/006-splash-bootstrap.md` · **Phụ thuộc:** Spec 004, Spec 005 · **Ước lượng:** 0,5 ngày

```text
AGENT INSTRUCTION — Spec 006

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/006-splash-bootstrap.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 004, Spec 005 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/006-splash-bootstrap.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt thứ tự `bootstrap()`: mở DB → seed → `InitialBinding` → đọc profile → chọn route.
- Chốt cơ chế khởi tạo lazy cho RevenueCat/AdMob (hook `IStartupTask` chạy sau frame đầu).
- Chốt cách giữ deep link đang chờ và tiêu thụ đúng một lần.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/006-splash-bootstrap.md.
Tạo các file test:
- test/features/splash/controllers/splash_controller_test.dart — T05-1, T05-2, T05-3, T05-4, T05-5
Mock `IProfileRepository`, `IDeepLinkService`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/splash
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. Cấu hình flutter_native_splash (light/dark)
2. lib/features/splash/controllers/splash_controller.dart, bindings/splash_binding.dart
3. lib/features/splash/pages/splash_page.dart, pages/startup_error_page.dart
4. Cập nhật lib/bootstrap.dart; lib/core/startup/startup_task.dart (hook lazy)
5. IAnalyticsService hiện thực no-op tạm (lib/data/services/noop_analytics_service.dart) — Spec 021 thay thế
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/splash → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/006-splash-bootstrap.md:
1. Native splash: logo trên nền thương hiệu, light/dark.
2. Màn lỗi khởi động thân thiện: icon, thông điệp, nút "Try again" và "Contact support" (mailto, không kèm dữ liệu tài chính).
3. Chuyển cảnh fade 250ms vào màn đầu tiên.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/features/splash/pages/startup_error_page_test.dart — Hiển thị lỗi, nút Try again gọi lại bootstrap
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 006:
1. Không gọi mạng trên đường khởi động chính.
2. Lỗi DB không bị nuốt: hiển thị màn lỗi và ghi log.
3. Đo cold start (bản profile) và ghi số liệu thực tế; mục tiêu ≤ 1,0 s.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/006-splash-bootstrap.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 006 · Splash & bootstrap = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Trình tự khởi động; Cách thêm IStartupTask lazy.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/006-splash-bootstrap.md thành DONE.
- Next: Spec 007 · Onboarding 1: Welcome (file specs/007-onboarding-welcome.md).
```

---

## Spec 007 · F06 — Onboarding 1: Welcome

**File spec:** `specs/007-onboarding-welcome.md` · **Phụ thuộc:** Spec 006 · **Ước lượng:** 0,5 ngày

```text
AGENT INSTRUCTION — Spec 007

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/007-onboarding-welcome.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 006 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/007-onboarding-welcome.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `OnboardingController` dùng chung cho 4 màn onboarding (Spec 007–010) và model `OnboardingDraft`.
- Chốt `OnboardingBinding` (controller sống suốt luồng onboarding, bị xóa khi rời luồng).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/007-onboarding-welcome.md.
Tạo các file test:
- test/features/onboarding/controllers/onboarding_controller_test.dart — group `welcome`: `start()` ghi sự kiện `onboarding_start`, điều hướng sang income (T06-1 phần logic)
- test/features/onboarding/pages/welcome_page_test.dart — T06-1, T06-2
Mock `IAnalyticsService`, `ISettingsRepository`, `INavigator` (wrapper mỏng quanh `Get.toNamed` để test điều hướng).
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/onboarding
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/data/models/onboarding_draft.dart
2. lib/features/onboarding/controllers/onboarding_controller.dart (khung + start())
3. lib/features/onboarding/bindings/onboarding_binding.dart
4. lib/features/onboarding/pages/welcome_page.dart
5. lib/features/onboarding/widgets/onboarding_progress.dart (bước x/4)
6. lib/core/navigation/navigator.dart (INavigator + hiện thực GetX) nếu chưa có
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/onboarding → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/007-onboarding-welcome.md:
1. Tiêu đề, phụ đề, 3 điểm nhấn đúng nội dung spec; thẻ số tiền mẫu có animation đếm.
2. Nút "Get started" nổi bật; link Privacy/Terms nhỏ.
3. Tôn trọng reduced motion.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/features/onboarding/pages/goldens/welcome_golden_test.dart — T06-3
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 007:
1. AnimationController của thẻ số tiền được dispose.
2. Nút Back hệ thống ở Welcome đóng app (Android, PopScope).
3. Không có nút Skip.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/007-onboarding-welcome.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 007 · Onboarding 1: Welcome = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: OnboardingController dùng chung cho Spec 007–010; INavigator để test điều hướng.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/007-onboarding-welcome.md thành DONE.
- Next: Spec 008 · Onboarding 2: Income & pay schedule (file specs/008-onboarding-income.md).
```

---

## Spec 008 · F07 — Onboarding 2: Income & pay schedule

**File spec:** `specs/008-onboarding-income.md` · **Phụ thuộc:** Spec 007, Spec 003, Spec 005 · **Ước lượng:** 1,5 ngày

```text
AGENT INSTRUCTION — Spec 008

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/008-onboarding-income.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 007, Spec 003, Spec 005 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/008-onboarding-income.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt các method của `OnboardingController` cho bước income: `selectIncomeMode`, `selectFrequency`, `setNextPayday`, `setIncomePerPaycheck`, `setFirstPeriodBalance`, `setStartingBalance`, `setHorizon`, `setCurrency`, getter `canContinue`, `allowedPaydayRange`, `suggestedFirstPeriodBalance`.
- Chốt cách suy ra `payAnchorDate` từ "next payday" theo từng tần suất.
- Chốt key và định dạng JSON lưu draft trong `app_setting`; xử lý draft hỏng.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/008-onboarding-income.md.
Tạo các file test:
- test/features/onboarding/controllers/onboarding_controller_test.dart — group `income`: T07-1, T07-2, T07-3, T07-4, T07-5, T07-6 + draft hỏng → reset không crash
- test/features/onboarding/pages/income_setup_page_test.dart — Hiển thị đúng bước theo mode, nút Continue bật/tắt
Mock `ISettingsRepository`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/onboarding
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. Mở rộng onboarding_controller.dart theo plan
2. lib/features/onboarding/pages/income_setup_page.dart
3. lib/features/onboarding/widgets/income_mode_step.dart, pay_schedule_step.dart, irregular_balance_step.dart, currency_picker.dart
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/onboarding → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/008-onboarding-income.md:
1. Mỗi câu hỏi một khối lớn; chuyển bước slide ngang 250ms.
2. Dùng AmountKeypad, không dùng bàn phím hệ thống.
3. Thanh tiến trình bước 2/4.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 008:
1. Draft JSON hỏng hoặc thiếu trường không làm crash; reset về draft rỗng và ghi log.
2. Đổi mode xóa trường không liên quan khỏi draft.
3. Gợi ý firstPeriodBalance làm tròn đúng cents.
4. Đo thời gian hoàn thành bước (thủ công) và ghi vào Review Report.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/008-onboarding-income.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 008 · Onboarding 2: Income & pay schedule = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Key lưu draft onboarding; Cách suy ra payAnchorDate.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/008-onboarding-income.md thành DONE.
- Next: Spec 009 · Onboarding 3: Bills (bỏ qua được) (file specs/009-onboarding-bills.md).
```

---

## Spec 009 · F08 — Onboarding 3: Bills (bỏ qua được)

**File spec:** `specs/009-onboarding-bills.md` · **Phụ thuộc:** Spec 008 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 009

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/009-onboarding-bills.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 008 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/009-onboarding-bills.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt method `addDraftBill`, `updateDraftBill`, `removeDraftBill`, getter `billsTotalBeforePayday` (dùng bộ sinh occurrence của engine).
- Chốt `BillFormSheet` đặt ở `lib/features/bills/widgets/` để Spec 015 tái sử dụng.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/009-onboarding-bills.md.
Tạo các file test:
- test/features/onboarding/controllers/onboarding_controller_test.dart — group `bills`: T08-1, T08-2, T08-3, T08-4
- test/features/onboarding/pages/onboarding_bills_page_test.dart — Chạm chip mở sheet, vuốt xóa, Skip
Mock `ISettingsRepository`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/onboarding
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. Mở rộng onboarding_controller.dart
2. lib/features/onboarding/pages/onboarding_bills_page.dart
3. lib/features/bills/widgets/bill_form_sheet.dart (dùng lại ở Spec 015)
4. lib/features/onboarding/widgets/bill_quick_chips.dart
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/onboarding → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/009-onboarding-bills.md:
1. Chip gợi ý có icon; bottom sheet nhập số tiền + ngày + lặp.
2. Dòng tổng "Bills before payday" cập nhật ngay.
3. Thanh tiến trình bước 3/4.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/features/bills/widgets/bill_form_sheet_test.dart — Validation tên/số tiền/ngày
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 009:
1. Validation: tên ≤ 40 ký tự, số tiền > 0, ngày đến hạn từ hôm nay trở đi.
2. Tổng hóa đơn chỉ tính occurrence trong kỳ (fixed) hoặc cửa sổ (irregular).
3. Thêm một hóa đơn ≤ 4 chạm (đo thủ công).
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/009-onboarding-bills.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 009 · Onboarding 3: Bills (bỏ qua được) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: BillFormSheet dùng chung.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Thêm ADR vào docs/DECISIONS.md: Onboarding chỉ cho chọn ngày đến hạn từ hôm nay trở đi.
- Đổi dòng "Trạng thái" đầu file specs/009-onboarding-bills.md thành DONE.
- Next: Spec 010 · Onboarding 4: Result reveal & quyền thông báo (file specs/010-onboarding-result.md).
```

---

## Spec 010 · F09 — Onboarding 4: Result reveal & quyền thông báo

**File spec:** `specs/010-onboarding-result.md` · **Phụ thuộc:** Spec 009 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 010

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/010-onboarding-result.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 009 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/010-onboarding-result.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt method `computePreview()` (qua `IBudgetSnapshotService.preview(draft)`), `completeOnboarding()` (một transaction qua `IProfileRepository.saveOnboarding`), `requestNotifications()`.
- Chốt interface `INotificationService` phần quyền (`requestPermission`, `hasPermission`) — phần lên lịch làm ở Spec 018.
- Chốt cờ `show_paywall_after_onboarding` (mặc định false) và giờ nhắc mặc định trong `app_setting`.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/010-onboarding-result.md.
Tạo các file test:
- test/features/onboarding/controllers/onboarding_controller_test.dart — group `result`: T09-1, T09-2, T09-3, T09-4, T09-5 + chống bấm hai lần (`isSaving`)
- test/features/onboarding/pages/onboarding_result_page_test.dart — Hiển thị số, thẻ quyền thông báo, nút Go to Today
Mock `IProfileRepository`, `IBudgetSnapshotService`, `INotificationService`, `ISettingsRepository`, `IAnalyticsService`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/onboarding
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. Mở rộng onboarding_controller.dart
2. IProfileRepository.saveOnboarding(profile, bills) (transaction) nếu chưa có
3. lib/domain/services/i_notification_service.dart (phần quyền), lib/data/services/notification_service.dart (phần quyền)
4. lib/features/onboarding/pages/onboarding_result_page.dart
5. Sau hoàn tất: Get.offAllNamed(AppRoutes.root) qua INavigator
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/onboarding → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/010-onboarding-result.md:
1. Con số dùng style display, nền gradient nhẹ màu primary, animation đếm.
2. Thẻ xin quyền giải thích trước khi gọi hộp thoại hệ thống.
3. Thông điệp thiếu hụt nhẹ nhàng khi pool âm.
4. Thanh tiến trình bước 4/4.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/features/onboarding/pages/goldens/onboarding_result_golden_test.dart — Trạng thái bình thường và thiếu hụt, light/dark
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 010:
1. Ghi DB nguyên tử; draft chỉ bị xóa sau khi ghi thành công.
2. Lỗi ghi DB hiển thị cho người dùng và cho thử lại, không nuốt lỗi.
3. AnimationController đếm số được dispose.
4. Đo toàn luồng Welcome → Today (thủ công), mục tiêu ≤ 60 giây.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/010-onboarding-result.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 010 · Onboarding 4: Result reveal & quyền thông báo = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: INotificationService phần quyền; Giờ nhắc mặc định trong app_setting.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/010-onboarding-result.md thành DONE.
- Next: Spec 011 · Today screen (file specs/011-today.md).
```

---

## Spec 011 · F10 — Today screen

**File spec:** `specs/011-today.md` · **Phụ thuộc:** Spec 010, Spec 005 · **Ước lượng:** 2 ngày

```text
AGENT INSTRUCTION — Spec 011

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/011-today.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 010, Spec 005 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/011-today.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt state `TodayController`: `ViewState`, `snapshot`, getter hiển thị (status, tomorrow text, period text), `todayExpenses`, `upcomingBills`, `goalProgress`, `showNewPeriodBanner`.
- Chốt `DayChangeWatcher` (`lib/core/time/`): lắng nghe lifecycle resume + `Timer` đến nửa đêm, báo `IBudgetSnapshotService` tính lại.
- Chốt cờ banner kỳ mới trong `app_setting` (hiện một lần mỗi kỳ).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/011-today.md.
Tạo các file test:
- test/features/today/controllers/today_controller_test.dart — T10-1, T10-2, T10-4, T10-5, T10-6
- test/core/time/day_change_watcher_test.dart — T10-3
- test/features/today/pages/today_page_test.dart — Render đúng các khối, FAB, empty state
Mock `IBudgetSnapshotService`, `IExpenseRepository`, `ISettingsRepository`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/today test/core/time
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/features/today/controllers/today_controller.dart, bindings/today_binding.dart (gộp vào RootShellBinding)
2. lib/features/today/pages/today_page.dart
3. lib/features/today/widgets/safe_amount_card.dart, period_card.dart, today_expenses_list.dart, upcoming_bills_list.dart, goal_mini_card.dart
4. lib/core/time/day_change_watcher.dart
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/today test/core/time → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/011-today.md:
1. Con số chính display 64sp, căn giữa, màu theo status, FittedBox cho số lớn.
2. ProgressRing đã tiêu / hạn mức; animation đếm 250ms khi số đổi.
3. FAB "+" lớn trong vùng ngón cái; không có quảng cáo trên màn này.
4. Thứ tự đọc VoiceOver/TalkBack: "Safe to spend today, 42 dollars".
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/features/today/pages/goldens/today_golden_test.dart — T10-7: onTrack/caution/over × light/dark × cỡ chữ lớn
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 011:
1. Timer nửa đêm và WidgetsBindingObserver được hủy trong onClose.
2. Trạng thái snapshot null (đang tải) và lỗi hiển thị đúng, không màn trắng.
3. Đo thời gian cập nhật số sau khi lưu giao dịch trên thiết bị thật, mục tiêu ≤ 100 ms.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/011-today.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 011 · Today screen = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: DayChangeWatcher; Cấu trúc widget của Today.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/011-today.md thành DONE.
- Next: Spec 012 · Quick Add expense (file specs/012-quick-add.md).
```

---

## Spec 012 · F11 — Quick Add expense

**File spec:** `specs/012-quick-add.md` · **Phụ thuộc:** Spec 011 · **Ước lượng:** 1,5 ngày

```text
AGENT INSTRUCTION — Spec 012

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/012-quick-add.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 011 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/012-quick-add.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `QuickAddController` (amount, category, note, date, `livePreview`, `canSubmit`, `submit()`, `undo()`), thiết kế sẵn cho chế độ sửa (Spec 013 dùng).
- Chốt `QuickAddLauncher.open({required source, String? editExpenseId})`: `Get.put` controller theo tag khi mở, `Get.delete` khi đóng.
- Chốt cách tính `livePreview` qua `IBudgetSnapshotService.previewWithExpense(...)`.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/012-quick-add.md.
Tạo các file test:
- test/features/quick_add/controllers/quick_add_controller_test.dart — T11-1, T11-2, T11-3, T11-4, T11-5, T11-6, T11-7 + chống submit hai lần
- test/features/quick_add/pages/quick_add_sheet_test.dart — Nhập số, chọn danh mục, Add, snackbar Undo
Mock `IExpenseRepository`, `ICategoryRepository`, `IBudgetSnapshotService`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/quick_add
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/features/quick_add/controllers/quick_add_controller.dart
2. lib/features/quick_add/quick_add_launcher.dart
3. lib/features/quick_add/pages/quick_add_sheet.dart
4. lib/features/quick_add/widgets/category_chips.dart, date_chip.dart, live_preview_line.dart
5. Nối FAB của Today và DeepLinkService vào QuickAddLauncher
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/quick_add → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/012-quick-add.md:
1. Bottom sheet gần full chiều cao, animation spring nhẹ; AmountKeypad luôn hiển thị.
2. Chip danh mục có icon + màu, danh mục dùng gần nhất đứng đầu.
3. Live preview đổi màu theo trạng thái; nút Add rộng toàn chiều ngang; haptic success khi lưu.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/features/quick_add/pages/goldens/quick_add_golden_test.dart — Trống / có số / vượt hạn mức, light/dark
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 012:
1. Controller bị Get.delete khi sheet đóng (kể cả vuốt xuống), không rò bộ nhớ.
2. Undo dùng soft delete, không xóa cứng.
3. Số tiền bị chặn ở giá trị tối đa; ngày ngoài khoảng cho phép không chọn được.
4. Đếm số chạm: FAB → nhập số → Add ≤ 3 chạm.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/012-quick-add.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 012 · Quick Add expense = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: API QuickAddLauncher; Chế độ sửa sẵn sàng cho Spec 013.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/012-quick-add.md thành DONE.
- Next: Spec 013 · History (xem, sửa, xóa, ghi lùi) (file specs/013-history.md).
```

---

## Spec 013 · F12 — History (xem, sửa, xóa, ghi lùi)

**File spec:** `specs/013-history.md` · **Phụ thuộc:** Spec 012 · **Ước lượng:** 1,5 ngày

```text
AGENT INSTRUCTION — Spec 013

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/013-history.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 012 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/013-history.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Mở rộng engine: thêm `computeDailyLedger(input, from, to) → List<DaySummary>` (ngày, hạn mức, đã tiêu, status) để History hiển thị `Spent $45 / $60` cho ngày đã qua. Ghi rõ trong plan và thêm test vào engine.
- Chốt `HistoryController`: nhóm theo ngày, phân trang "Load earlier" theo kỳ hoặc 30 ngày, xóa nhanh + Undo.
- Chốt chế độ sửa trong `QuickAddController` (load expense theo id, `save()`, `delete()`).
- Chốt widget `AdSlot` (no-op cho tới Spec 026) đặt cuối danh sách.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/013-history.md.
Tạo các file test:
- packages/budget_engine/test/daily_ledger_test.dart — Hạn mức và đã tiêu theo ngày khớp `computeSnapshot`
- test/features/history/controllers/history_controller_test.dart — T12-1, T12-4, T12-6
- test/features/quick_add/controllers/quick_add_controller_edit_test.dart — T12-2, T12-3, T12-5
- test/features/history/pages/history_page_test.dart — Nhóm theo ngày, vuốt xóa, empty state
Mock `IExpenseRepository`, `IIncomeRepository`, `IGoalRepository`, `IBudgetSnapshotService`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: cd packages/budget_engine && dart test && flutter test test/features/history test/features/quick_add
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. packages/budget_engine/lib/src/daily_ledger.dart + export
2. IBudgetSnapshotService.ledger(from, to)
3. lib/features/history/controllers/history_controller.dart, bindings/ (gộp RootShellBinding)
4. lib/features/history/pages/history_page.dart
5. lib/features/history/widgets/day_group_header.dart, history_item_tile.dart
6. Chế độ sửa trong quick_add_controller.dart, QuickAddLauncher.open(editExpenseId:)
7. lib/core/widgets/ad_slot.dart (no-op)
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: cd packages/budget_engine && dart test && flutter test test/features/history test/features/quick_add → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/013-history.md:
1. Header ngày dính (sticky) có tổng chi, hạn mức và chấm màu trạng thái.
2. Thu nhập và đóng góp goal hiển thị kiểu khác (icon mũi tên vào / con heo).
3. Vuốt trái để xóa có Undo; nút "+" trên app bar để ghi lùi.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 013:
1. Cuộn 2.000 giao dịch mượt (ListView.builder), đo trên thiết bị thật.
2. Phân trang không trùng hoặc sót ngày ở ranh giới.
3. Undo hoạt động cho cả vuốt và xóa trong màn sửa.
4. Coverage engine vẫn ≥ 95% sau khi thêm ledger.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/013-history.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 013 · History (xem, sửa, xóa, ghi lùi) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: computeDailyLedger; Chế độ sửa của Quick Add; AdSlot chờ Spec 026.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Thêm ADR vào docs/DECISIONS.md: Thêm API `computeDailyLedger` vào engine cho History.
- Đổi dòng "Trạng thái" đầu file specs/013-history.md thành DONE.
- Next: Spec 014 · Income log (chế độ thu nhập không đều) (file specs/014-income-log.md).
```

---

## Spec 014 · F13 — Income log (chế độ thu nhập không đều)

**File spec:** `specs/014-income-log.md` · **Phụ thuộc:** Spec 011 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 014

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/014-income-log.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 011 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/014-income-log.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `IncomeController` (danh sách, thêm/sửa/xóa, hiển thị theo `incomeMode`).
- Chốt khung `PlanPage` (tab Plan) gồm các section: Income (chỉ irregular), Bills (Spec 015), Goal (Spec 016).
- Chốt nút "Got paid?" trên Today (chỉ irregular).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/014-income-log.md.
Tạo các file test:
- test/features/income/controllers/income_controller_test.dart — T13-1, T13-3
- test/features/plan/pages/plan_page_test.dart — T13-2: section Income ẩn ở fixed, hiện ở irregular
Mock `IIncomeRepository`, `IProfileRepository`, `IBudgetSnapshotService`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/income test/features/plan
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/features/income/controllers/income_controller.dart
2. lib/features/income/widgets/income_section.dart, income_form_sheet.dart
3. lib/features/plan/pages/plan_page.dart (khung section), lib/features/plan/controllers/plan_controller.dart nếu cần
4. Nút "Got paid?" trên Today
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/income test/features/plan → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/014-income-log.md:
1. Section Income dạng SectionCard, danh sách gần đây, sửa/xóa giống History.
2. Form thêm thu nhập dùng AmountKeypad, ngày cho chọn lùi.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 014:
1. Hiển thị phản ứng ngay khi đổi incomeMode trong Settings (không cần khởi động lại).
2. Thêm income ≤ 3 chạm.
3. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
4. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
5. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
6. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/014-income-log.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 014 · Income log (chế độ thu nhập không đều) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Cấu trúc PlanPage theo section.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Thêm ADR vào docs/DECISIONS.md: Fixed mode chưa hỗ trợ thu nhập phát sinh thêm (BACKLOG).
- Đổi dòng "Trạng thái" đầu file specs/014-income-log.md thành DONE.
- Next: Spec 015 · Bills management (file specs/015-bills.md).
```

---

## Spec 015 · F14 — Bills management

**File spec:** `specs/015-bills.md` · **Phụ thuộc:** Spec 011, Spec 009 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 015

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/015-bills.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 011, Spec 009 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/015-bills.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `BillsController` (danh sách theo ngày đến hạn kế tiếp, tổng trong kỳ/cửa sổ, thêm/sửa/xóa, Active toggle, nhắc trước).
- Tái sử dụng `BillFormSheet` từ Spec 009, mở rộng trường nhắc trước và Active.
- Chốt sự kiện thay đổi hóa đơn (stream từ `IBillRepository.watchAll`) để Spec 018 lắng nghe.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/015-bills.md.
Tạo các file test:
- test/features/bills/controllers/bills_controller_test.dart — T14-1, T14-2, T14-3, T14-4
- test/features/bills/widgets/bills_section_test.dart — Danh sách, tổng, thêm/sửa/xóa
Mock `IBillRepository`, `IBudgetSnapshotService`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/bills
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/features/bills/controllers/bills_controller.dart
2. lib/features/bills/widgets/bills_section.dart, mở rộng bill_form_sheet.dart
3. Gắn section vào PlanPage
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/bills → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/015-bills.md:
1. Dòng hóa đơn: tên, số tiền, "Due in 3 days", kiểu lặp.
2. Tổng "Bills this pay period" (irregular: "next 14 days").
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 015:
1. Today phản ánh thay đổi hóa đơn ngay lập tức.
2. Xóa là soft delete có xác nhận.
3. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
4. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
5. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
6. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/015-bills.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 015 · Bills management = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Stream thay đổi hóa đơn cho Spec 018.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/015-bills.md thành DONE.
- Next: Spec 016 · Savings Goal (1 mục tiêu) (file specs/016-savings-goal.md).
```

---

## Spec 016 · F15 — Savings Goal (1 mục tiêu)

**File spec:** `specs/016-savings-goal.md` · **Phụ thuộc:** Spec 011 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 016

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/016-savings-goal.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 011 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/016-savings-goal.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `GoalController` (tạo, gợi ý per-paycheck, đóng góp, hoàn thành, giới hạn 1 goal active khi free).
- Chốt `IPremiumGate.request(PremiumFeature)` + hiện thực tạm `InfoOnlyPremiumGate` (hiển thị thông báo); Spec 022 thay bằng paywall.
- Chốt enum `PremiumFeature` (multipleGoals, rolloverTomorrow, rolloverSave, lockScreenWidget, themes, csvExport, noAds).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/016-savings-goal.md.
Tạo các file test:
- test/features/goal/controllers/goal_controller_test.dart — T15-1, T15-2, T15-3, T15-4, T15-5
- test/features/goal/widgets/goal_section_test.dart — Trạng thái chưa có goal / đang có / hoàn thành
Mock `IGoalRepository`, `IProfileRepository`, `IBudgetSnapshotService`, `IEntitlementService` (tạm: fake luôn free), `IPremiumGate`, `IAnalyticsService`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/goal
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/domain/services/i_premium_gate.dart, lib/data/services/info_only_premium_gate.dart, lib/domain/services/i_entitlement_service.dart (interface; hiện thực fake luôn free tới Spec 022)
2. lib/features/goal/controllers/goal_controller.dart
3. lib/features/goal/widgets/goal_section.dart, goal_form_sheet.dart, add_money_sheet.dart, goal_completed_dialog.dart
4. Gắn section vào PlanPage; mini goal trên Today
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/goal → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/016-savings-goal.md:
1. Thẻ "Save for something" khi chưa có goal; tiến độ %, đã có / mục tiêu, ngày dự kiến đạt.
2. Màn chúc mừng nhẹ khi đạt mục tiêu (confetti tôn trọng reduced motion).
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 016:
1. Gợi ý per-paycheck làm tròn lên đến dollar đúng.
2. Controller confetti/animation được dispose.
3. Free không tạo được goal thứ hai; IPremiumGate được gọi đúng feature.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/016-savings-goal.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 016 · Savings Goal (1 mục tiêu) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: IPremiumGate, PremiumFeature; IEntitlementService interface (hiện thực ở Spec 022).
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/016-savings-goal.md thành DONE.
- Next: Spec 017 · Settings (file specs/017-settings.md).
```

---

## Spec 017 · F16 — Settings

**File spec:** `specs/017-settings.md` · **Phụ thuộc:** Spec 011, Spec 016 · **Ước lượng:** 1,5 ngày

```text
AGENT INSTRUCTION — Spec 017

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/017-settings.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 011, Spec 016 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/017-settings.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `SettingsController` theo 6 nhóm mục của spec; mục 🔒 gọi `IPremiumGate`.
- Chốt `IDataEraser` (xóa DB, `app_setting`, snapshot widget, lịch thông báo — hai phần sau gọi qua interface, hiện thực đầy đủ ở Spec 018/019).
- Chốt luồng đổi income mode (tái dùng widget bước income của onboarding).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/017-settings.md.
Tạo các file test:
- test/features/settings/controllers/settings_controller_test.dart — T16-1, T16-2, T16-3, T16-4, T16-5
- test/data/services/data_eraser_test.dart — Xóa sạch mọi bảng và setting, gọi hủy thông báo và xóa snapshot widget
- test/features/settings/pages/settings_page_test.dart — Hiển thị nhóm mục, mục 🔒, xác nhận gõ DELETE
Mock `IProfileRepository`, `ISettingsRepository`, `IPremiumGate`, `IEntitlementService`, `IDataEraser`, `INotificationService`, `IAnalyticsService`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/features/settings test/data/services/data_eraser_test.dart
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/features/settings/controllers/settings_controller.dart, bindings/settings_binding.dart
2. lib/features/settings/pages/settings_page.dart
3. lib/features/settings/widgets/ (budget_section, reminders_section, appearance_section, data_section, about_section, erase_confirm_dialog)
4. lib/domain/services/i_data_eraser.dart, lib/data/services/data_eraser.dart
5. Route AppRoutes.settings + icon trên Today
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/features/settings test/data/services/data_eraser_test.dart → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/017-settings.md:
1. Nhóm mục rõ ràng, mục 🔒 có PremiumBadge.
2. Đổi currency hiện cảnh báo không quy đổi.
3. Erase all data: xác nhận hai lần, gõ chữ "DELETE".
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 017:
1. Mọi thay đổi lưu ngay và snapshot cập nhật.
2. Erase all data là ngoại lệ xóa cứng duy nhất; sau khi xóa về Welcome.
3. Contact support không kèm dữ liệu tài chính.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/017-settings.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 017 · Settings = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: IDataEraser; Cấu trúc Settings theo section.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Thêm ADR vào docs/DECISIONS.md: "Erase all data" là ngoại lệ duy nhất được xóa cứng.
- Đổi dòng "Trạng thái" đầu file specs/017-settings.md thành DONE.
- Next: Spec 018 · Local notifications (file specs/018-notifications.md).
```

---

## Spec 018 · F17 — Local notifications

**File spec:** `specs/018-notifications.md` · **Phụ thuộc:** Spec 015, Spec 017 · **Ước lượng:** 1,5 ngày

```text
AGENT INSTRUCTION — Spec 018

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/018-notifications.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 015, Spec 017 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/018-notifications.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Mở rộng engine: `projectNextDays(input, today, days) → List<DayProjection>` (hạn mức từng ngày tới, giả định không chi thêm). Spec 019 dùng lại.
- Chốt `NotificationScheduler` (hàm thuần: projection + settings + bills → `List<PlannedNotification>`) và `NotificationService` (gọi plugin qua wrapper `ILocalNotificationsPlugin`).
- Chốt quy tắc: 7 ngày tới, tổng ≤ 40 thông báo, hủy evening hôm nay khi đã ghi chi tiêu, hide amounts.
- Chốt điều hướng khi chạm thông báo (Today, Quick Add, Plan).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/018-notifications.md.
Tạo các file test:
- packages/budget_engine/test/projection_test.dart — Projection khớp engine khi không chi thêm
- test/data/services/notification_scheduler_test.dart — T17-1, T17-3, T17-4, T17-6, T17-7
- test/data/services/notification_service_test.dart — T17-2, T17-5
`FakeNotificationsPlugin` (implement `ILocalNotificationsPlugin`); mock `IBudgetSnapshotService`, `ISettingsRepository`, `IBillRepository`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: cd packages/budget_engine && dart test && flutter test test/data/services/notification_scheduler_test.dart test/data/services/notification_service_test.dart
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. packages/budget_engine/lib/src/projection.dart + export
2. lib/data/services/notification_scheduler.dart
3. Hoàn thiện lib/domain/services/i_notification_service.dart, lib/data/services/notification_service.dart
4. lib/data/services/local_notifications_plugin.dart (wrapper)
5. Cấu hình Android (POST_NOTIFICATIONS, exact alarm có điều kiện) và iOS
6. Lắng nghe snapshot/bill/settings → lên lịch lại (debounce)
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: cd packages/budget_engine && dart test && flutter test test/data/services/notification_scheduler_test.dart test/data/services/notification_service_test.dart → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/018-notifications.md:
1. Settings → Reminders: hiển thị trạng thái quyền; nếu bị từ chối có nút mở cài đặt hệ thống.
2. Nội dung thông báo theo bảng trong spec, qua l10n.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 018:
1. Không vượt 40 thông báo chờ; đổi múi giờ lên lịch lại đúng.
2. Hide amounts: không thông báo nào chứa số tiền.
3. Lỗi plugin không bị nuốt: ghi log, không crash.
4. Kiểm tra thủ công trên thiết bị thật iOS + Android, ghi kết quả.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/018-notifications.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 018 · Local notifications = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: projectNextDays trong engine; Quy tắc lên lịch thông báo.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Thêm ADR vào docs/DECISIONS.md: Thông báo và widget dùng projection giả định không chi thêm.
- Đổi dòng "Trạng thái" đầu file specs/018-notifications.md thành DONE.
- Next: Spec 019 · Home Screen widget (iOS + Android) (file specs/019-home-widget.md).
```

---

## Spec 019 · F18 — Home Screen widget (iOS + Android)

**File spec:** `specs/019-home-widget.md` · **Phụ thuộc:** Spec 011, Spec 012, Spec 018 · **Ước lượng:** 3 ngày

```text
AGENT INSTRUCTION — Spec 019

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/019-home-widget.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 011, Spec 012, Spec 018 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/019-home-widget.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt schema JSON snapshot (thêm trường `schemaVersion`) và `WidgetSnapshotBuilder` (hàm thuần từ snapshot + projection 7 ngày).
- Chốt `IWidgetSyncService` (`home_widget`): ghi snapshot, yêu cầu reload; App Group id.
- Chốt cấu trúc native: iOS WidgetKit (Small, Medium, timeline nửa đêm), Android Glance (2×2, 4×2, cập nhật nửa đêm).
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/019-home-widget.md.
Tạo các file test:
- test/data/services/widget_snapshot_builder_test.dart — T18-1, T18-2, snapshot cũ > 7 ngày
- test/data/services/widget_sync_service_test.dart — Ghi snapshot khi snapshot đổi, gọi reload
- test/core/services/deep_link_service_test.dart — T18-3 (bổ sung)
Wrapper `IHomeWidgetClient` để fake `home_widget`; mock `IBudgetSnapshotService`, `ISettingsRepository`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services/widget_snapshot_builder_test.dart test/data/services/widget_sync_service_test.dart test/core/services/deep_link_service_test.dart
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/data/models/widget_snapshot.dart, lib/data/services/widget_snapshot_builder.dart
2. lib/domain/services/i_widget_sync_service.dart, lib/data/services/widget_sync_service.dart, home_widget_client.dart
3. ios/SafeToSpendWidget/ (Provider, SmallView, MediumView, App Group)
4. android/.../widget/ (Glance widget 2×2, 4×2, receiver, cập nhật nửa đêm)
5. Hoàn thiện IDataEraser xóa snapshot widget
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services/widget_snapshot_builder_test.dart test/data/services/widget_sync_service_test.dart test/core/services/deep_link_service_test.dart → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/019-home-widget.md:
1. Widget tối giản, con số là tiêu điểm, màu theo status, nền theo hệ thống.
2. Medium/4×2 có "Spent · Tomorrow" và nút "+" tròn góc phải dưới.
3. Hide amounts hiển thị "••••"; snapshot quá cũ hiển thị "Open to update".
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 019:
1. Native parse JSON hỏng hoặc thiếu trường không crash widget.
2. App Group id khớp giữa app và extension.
3. Checklist thủ công trong spec (thêm widget, cập nhật ≤ 5 giây, qua ngày khi app đóng, dark mode, cỡ chữ lớn, hide amounts) — ghi kết quả từng mục.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/019-home-widget.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 019 · Home Screen widget (iOS + Android) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Cách build/chạy widget extension; App Group id; Schema JSON snapshot.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/019-home-widget.md thành DONE.
- Next: Spec 020 · Backup & Restore (file) (file specs/020-backup-restore.md).
```

---

## Spec 020 · F19 — Backup & Restore (file)

**File spec:** `specs/020-backup-restore.md` · **Phụ thuộc:** Spec 017 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 020

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/020-backup-restore.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 017 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/020-backup-restore.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt định dạng `BackupFile` (`schemaVersion`, `appVersion`, `exportedAt`, toàn bộ bảng kể cả soft-deleted).
- Chốt mã hóa tùy chọn (AES-GCM, PBKDF2/Argon2 qua `cryptography`) và định dạng phong bì.
- Chốt luồng restore: kiểm tra version → xem trước → thay thế trong transaction → tính lại snapshot, lên lịch thông báo, cập nhật widget.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/020-backup-restore.md.
Tạo các file test:
- test/data/services/backup_service_test.dart — T19-1, T19-2, T19-3, T19-4, T19-5
- test/features/settings/controllers/backup_section_controller_test.dart — Banner nhắc sao lưu (> 30 ngày và ≥ 20 giao dịch)
DB in-memory; mock `IFilePicker`, `IShareService`, `INotificationService`, `IWidgetSyncService`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services/backup_service_test.dart test/features/settings
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/data/models/backup_file.dart
2. lib/domain/services/i_backup_service.dart, lib/data/services/backup_service.dart, backup_crypto.dart
3. Wrapper IFilePicker, IShareService
4. Section Backup/Restore trong Settings + sheet xem trước restore
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services/backup_service_test.dart test/features/settings → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/020-backup-restore.md:
1. Xem trước tóm tắt ("124 expenses, 6 bills, 1 goal") và cảnh báo thay thế toàn bộ dữ liệu.
2. Ô mật khẩu tùy chọn, hiển thị lỗi sai mật khẩu rõ ràng.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 020:
1. Round-trip không mất dữ liệu (ID, timestamp, soft-deleted).
2. Restore lỗi giữa chừng rollback hoàn toàn.
3. File không chứa token hay id quảng cáo.
4. File lớn không làm treo UI (xử lý ngoài main isolate nếu cần).
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/020-backup-restore.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 020 · Backup & Restore (file) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Định dạng file backup; Luồng restore.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/020-backup-restore.md thành DONE.
- Next: Spec 021 · Analytics & Crash reporting (file specs/021-analytics-crash.md).
```

---

## Spec 021 · F20 — Analytics & Crash reporting

**File spec:** `specs/021-analytics-crash.md` · **Phụ thuộc:** Spec 006 · **Ước lượng:** 0,5 ngày

```text
AGENT INSTRUCTION — Spec 021

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/021-analytics-crash.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 006 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/021-analytics-crash.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `analytics_events.dart` từ Phụ lục 1 và kiểm tra mọi lời gọi analytics hiện có đều dùng hằng số.
- Chốt `PrivacyGuard` (whitelist thuộc tính, chặn `amount`/`note`/`name`).
- Chốt cấu hình Firebase theo flavor và Crashlytics trong bootstrap.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/021-analytics-crash.md.
Tạo các file test:
- test/data/services/analytics_privacy_guard_test.dart — T20-1
- test/core/analytics/analytics_events_usage_test.dart — T20-2 (quét mã nguồn)
- test/core/config/flavor_config_test.dart — T20-3
Wrapper `IFirebaseAnalyticsClient` để fake Firebase.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services/analytics_privacy_guard_test.dart test/core
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/core/analytics/analytics_events.dart
2. Hoàn thiện lib/domain/services/i_analytics_service.dart (logEvent, setUserProperty, recordError)
3. lib/data/services/firebase_analytics_service.dart, analytics_privacy_guard.dart
4. Firebase options theo flavor, Crashlytics trong bootstrap.dart
5. Thay NoopAnalyticsService trong InitialBinding (giữ no-op cho test)
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services/analytics_privacy_guard_test.dart test/core → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Spec này không có giao diện người dùng.
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile để hoàn thiện thiết kế API:
1. Không có UI. Dartdoc cho IAnalyticsService và danh sách sự kiện.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 021:
1. Không sự kiện nào mang số tiền, ghi chú, tên.
2. Flavor dev không gửi về project prod.
3. Kiểm tra funnel onboarding trên Firebase DebugView và một crash giả lập (bản dev); ghi kết quả.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/021-analytics-crash.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 021 · Analytics & Crash reporting = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Cách thêm sự kiện analytics mới.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/021-analytics-crash.md thành DONE.
- Next: Spec 022 · Premium: RevenueCat, entitlement, paywall (file specs/022-premium-paywall.md).
```

---

## Spec 022 · F21 — Premium: RevenueCat, entitlement, paywall

**File spec:** `specs/022-premium-paywall.md` · **Phụ thuộc:** Spec 017, Spec 021 · **Ước lượng:** 2 ngày

```text
AGENT INSTRUCTION — Spec 022

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/022-premium-paywall.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 017, Spec 021 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/022-premium-paywall.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `EntitlementService` (`RxBool isPremium`, cache offline trong `app_setting`) với wrapper `IPurchasesClient` quanh RevenueCat.
- Chốt `PaywallController` (offering, gói chọn, mua, khôi phục, `ViewState`) và `PaywallTriggerPolicy` (7 ngày, một lần).
- Chốt `PaywallPremiumGate` thay `InfoOnlyPremiumGate`.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/022-premium-paywall.md.
Tạo các file test:
- test/data/services/entitlement_service_test.dart — T21-1, T21-3, T21-4
- test/features/premium/controllers/paywall_controller_test.dart — T21-2, T21-6 + chọn gói, trạng thái mua
- test/features/premium/paywall_trigger_policy_test.dart — T21-5
Mock `IPurchasesClient`, `ISettingsRepository`, `IAnalyticsService`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services/entitlement_service_test.dart test/features/premium
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/data/services/revenuecat_purchases_client.dart, lib/data/services/entitlement_service.dart
2. lib/features/premium/controllers/paywall_controller.dart, bindings/paywall_binding.dart, pages/paywall_page.dart
3. lib/features/premium/paywall_trigger_policy.dart
4. lib/data/services/paywall_premium_gate.dart thay vào InitialBinding
5. Khởi tạo RevenueCat qua IStartupTask lazy
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services/entitlement_service_test.dart test/features/premium → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/022-premium-paywall.md:
1. Tiêu đề, lợi ích, chọn gói (Annual "Best value" mặc định), nút Start trial/Subscribe đúng nội dung spec.
2. Dòng giá sau trial, tự gia hạn, Terms/Privacy, Restore; nút đóng luôn hiển thị.
3. Trạng thái lỗi tải offering có nút thử lại.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/features/premium/pages/goldens/paywall_golden_test.dart — T21-7
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 022:
1. Hủy giao dịch không bị coi là lỗi; lỗi thật hiển thị và được ghi log.
2. Listener RevenueCat được gỡ khi service đóng.
3. Mua thật trong Sandbox (iOS) và License testing (Android); ghi kết quả.
4. Đáp ứng App Store Review 3.1.2.
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/022-premium-paywall.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 022 · Premium: RevenueCat, entitlement, paywall = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: IEntitlementService hiện thực thật; PaywallPremiumGate; Cách test mua hàng sandbox.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/022-premium-paywall.md thành DONE.
- Next: Spec 023 · Premium: Rollover modes (Tomorrow boost / Save to goal) (file specs/023-rollover-modes.md).
```

---

## Spec 023 · F22 — Premium: Rollover modes (Tomorrow boost / Save to goal)

**File spec:** `specs/023-rollover-modes.md` · **Phụ thuộc:** Spec 003, Spec 022 · **Ước lượng:** 1 ngày

```text
AGENT INSTRUCTION — Spec 023

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/023-rollover-modes.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 003, Spec 022 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/023-rollover-modes.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `EffectiveRolloverModeResolver` trong `BudgetSnapshotService` (premium hết hạn → Spread, giữ lựa chọn cũ).
- Chốt section Leftover money trong Settings với ví dụ tính bằng dữ liệu thật qua service.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/023-rollover-modes.md.
Tạo các file test:
- test/data/services/effective_rollover_mode_test.dart — T22-2, T22-3
- test/features/settings/controllers/rollover_settings_test.dart — T22-1, T22-4
Mock `IEntitlementService`, `IProfileRepository`, `IPremiumGate`, `IGoalRepository`, `IBudgetSnapshotService`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services/effective_rollover_mode_test.dart test/features/settings
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. Resolver trong budget_snapshot_service.dart
2. Section rollover trong Settings + dòng phụ trên Today theo mode
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services/effective_rollover_mode_test.dart test/features/settings → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/023-rollover-modes.md:
1. Mỗi lựa chọn có giải thích ngắn và ví dụ trực quan bằng số thật.
2. Thông báo nhẹ một lần khi premium hết hạn và quay về Spread.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 023:
1. Đổi mode cập nhật Today ngay.
2. Không mất lựa chọn cũ khi premium hết hạn rồi đăng ký lại.
3. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
4. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
5. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
6. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/023-rollover-modes.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 023 · Premium: Rollover modes (Tomorrow boost / Save to goal) = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Resolver rollover hiệu lực.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/023-rollover-modes.md thành DONE.
- Next: Spec 024 · Premium: Lock Screen widget & themes (file specs/024-lockscreen-widget-themes.md).
```

---

## Spec 024 · F23 — Premium: Lock Screen widget & themes

**File spec:** `specs/024-lockscreen-widget-themes.md` · **Phụ thuộc:** Spec 019, Spec 022 · **Ước lượng:** 2 ngày

```text
AGENT INSTRUCTION — Spec 024

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/024-lockscreen-widget-themes.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 019, Spec 022 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/024-lockscreen-widget-themes.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `ThemeService` (`GetxService`): 5 bảng màu, theme hiệu lực theo premium hoặc trial 24 giờ.
- Chốt trường `theme`, `isPremium` trong snapshot widget.
- Chốt iOS accessory widgets (circular, rectangular, inline) và widget nhỏ Android.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/024-lockscreen-widget-themes.md.
Tạo các file test:
- test/data/services/theme_service_test.dart — T23-1, T23-2, T23-3
- test/data/services/widget_snapshot_builder_test.dart — T23-4 (bổ sung)
Mock `IEntitlementService`, `ISettingsRepository`, `IPremiumGate`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/core/theme/app_palettes.dart (5 bảng màu light/dark)
2. lib/domain/services/i_theme_service.dart, lib/data/services/theme_service.dart
3. Section Appearance trong Settings
4. iOS Lock Screen widgets; Android widget nhỏ 1×1 / 2×1
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/024-lockscreen-widget-themes.md:
1. Bộ chọn theme dạng lưới có xem trước; theme 🔒 có PremiumBadge.
2. Lock Screen widget free ở trạng thái khóa "Upgrade to see".
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Viết thêm widget/golden test:
- test/core/theme/goldens/palettes_golden_test.dart — 5 bảng màu × light/dark
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 024:
1. Mọi theme đạt tương phản WCAG AA cho text chính (kiểm tra bằng test tính tỷ lệ tương phản).
2. Theme trial hết hạn đúng 24 giờ, kể cả khi app đóng.
3. Checklist thủ công Lock Screen widget iOS 17+.
4. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
5. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
6. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
7. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/024-lockscreen-widget-themes.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 024 · Premium: Lock Screen widget & themes = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: ThemeService; Lock Screen widget.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/024-lockscreen-widget-themes.md thành DONE.
- Next: Spec 025 · Premium: CSV export (file specs/025-csv-export.md).
```

---

## Spec 025 · F24 — Premium: CSV export

**File spec:** `specs/025-csv-export.md` · **Phụ thuộc:** Spec 022 · **Ước lượng:** 0,5 ngày

```text
AGENT INSTRUCTION — Spec 025

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/025-csv-export.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 022 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/025-csv-export.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `CsvExportService` (cột, escape, UTF-8 BOM, khoảng thời gian) và section trong Settings.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/025-csv-export.md.
Tạo các file test:
- test/data/services/csv_export_service_test.dart — T24-1, T24-2
- test/features/settings/controllers/csv_export_settings_test.dart — T24-3
DB in-memory; mock `IShareService`, `IPremiumGate`, `IEntitlementService`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services/csv_export_service_test.dart test/features/settings
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/domain/services/i_csv_export_service.dart, lib/data/services/csv_export_service.dart
2. Section Export CSV trong Settings (chọn khoảng thời gian)
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services/csv_export_service_test.dart test/features/settings → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/025-csv-export.md:
1. Bộ chọn khoảng thời gian (This period · Last 3 months · All time), mục 🔒 khi free.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 025:
1. Mở đúng trên Excel và Google Sheets với ký tự đặc biệt (thủ công, ghi kết quả).
2. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
3. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
4. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
5. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/025-csv-export.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 025 · Premium: CSV export = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Định dạng CSV.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/025-csv-export.md thành DONE.
- Next: Spec 026 · Ads: AdMob + UMP consent (file specs/026-ads.md).
```

---

## Spec 026 · F25 — Ads: AdMob + UMP consent

**File spec:** `specs/026-ads.md` · **Phụ thuộc:** Spec 022 · **Ước lượng:** 1,5 ngày

```text
AGENT INSTRUCTION — Spec 026

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/026-ads.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 022 đã DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/026-ads.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Chốt `AdPolicy` (hàm thuần, toàn bộ quy tắc tần suất) và bộ đếm trong `app_setting`.
- Chốt `IAdsService` (AdMob), `IConsentService` (UMP), thứ tự consent → ATT (không trong phiên đầu).
- Chốt `AdSlot` thật (banner), hook interstitial khi rời History/Plan về Today trong `RootShellController`, rewarded thử theme 24 giờ.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/026-ads.md.
Tạo các file test:
- test/data/services/ad_policy_test.dart — T25-1
- test/features/ads/ad_placement_test.dart — T25-2, T25-3
- test/data/services/ads_service_test.dart — T25-4, T25-5
Wrapper `IMobileAdsClient` để fake AdMob; mock `IConsentService`, `IEntitlementService`, `IThemeService`, `ISettingsRepository`; `FakeClock`.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test test/data/services/ad_policy_test.dart test/data/services/ads_service_test.dart test/features/ads
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. lib/data/services/ad_policy.dart
2. lib/domain/services/i_ads_service.dart, i_consent_service.dart; lib/data/services/admob_ads_service.dart, ump_consent_service.dart, mobile_ads_client.dart
3. lib/core/widgets/ad_slot.dart (thật), hook trong root_shell_controller.dart
4. Mục "Privacy choices" trong Settings
5. Ad unit id theo flavor (dev dùng test id)
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test test/data/services/ad_policy_test.dart test/data/services/ads_service_test.dart test/features/ads → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/026-ads.md:
1. Banner thích ứng cuối History (≥ 5 mục) và Plan; lỗi tải ẩn vùng quảng cáo, không để khoảng trống.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 026:
1. Premium: không khởi tạo SDK quảng cáo.
2. Không có widget quảng cáo trong cây Today, Quick Add, Onboarding, Paywall.
3. BannerAd/InterstitialAd/RewardedAd được dispose.
4. app-ads.txt và Privacy label/Data safety cập nhật (ghi chú).
5. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
6. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
7. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
8. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/026-ads.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 026 · Ads: AdMob + UMP consent = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: AdPolicy; Thứ tự consent và ATT.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/026-ads.md thành DONE.
- Next: Spec 027 · Release readiness (file specs/027-release-readiness.md).
```

---

## Spec 027 · F26 — Release readiness

**File spec:** `specs/027-release-readiness.md` · **Phụ thuộc:** Tất cả spec 001–026 · **Ước lượng:** 2 ngày

```text
AGENT INSTRUCTION — Spec 027

PLAN
Hãy đóng vai @planner và kích hoạt skill /plan-spec.
Đọc: specs/000-conventions.md, specs/027-release-readiness.md, docs/SESSION_STATE.md, docs/DECISIONS.md.
Điều kiện: Spec 001–026 đều DONE trong docs/SESSION_STATE.md. Nếu chưa → dừng và báo.
Điền mục "Implementation Plan" trong specs/027-release-readiness.md, gồm:
- Danh sách file tạo/sửa (đường dẫn đầy đủ theo 000-conventions.md mục B2) và vai trò từng file.
- Lập kế hoạch QA tổng theo hạng mục 1–6 của spec; liệt kê integration test cần viết và checklist thủ công.
- Liệt kê store assets và tài liệu tuân thủ cần chuẩn bị.
- Ánh xạ từng test case của spec → file test (dùng đúng tên file ở bước DEFINE TEST bên dưới).
- Rủi ro và câu hỏi mở.
Nếu có câu hỏi chặn việc: dừng, liệt kê câu hỏi và chờ tôi trả lời. Không viết code ở bước này.

DEFINE TEST
Hãy đóng vai @tdd-guide và kích hoạt skill /tdd-workflow.
Đọc mục Test cases và Implementation Plan trong specs/027-release-readiness.md.
Tạo các file test:
- integration_test/onboarding_fixed_flow_test.dart — Onboarding fixed → Today → ghi chi tiêu → History
- integration_test/onboarding_irregular_flow_test.dart — Onboarding irregular → Got paid → con số cập nhật
- integration_test/expense_lifecycle_test.dart — Thêm, sửa ngày, xóa, Undo; qua nửa đêm; qua kỳ lương
- integration_test/backup_restore_flow_test.dart — Backup → Erase → Restore
- integration_test/premium_flow_test.dart — Paywall → mua (fake) → mở khóa rollover/theme/CSV, ẩn quảng cáo
Dùng fake purchases/ads/notifications qua flavor `dev` hoặc override binding trong integration test.
Mỗi test bắt đầu bằng mã test case (ví dụ 'T02-1: ...').
LƯU Ý: Chỉ tạo file test (và fake/helper trong test/helpers/ nếu cần), CHƯA tạo code thật.
Chạy: flutter test integration_test
Ghi lại output RED (test fail hoặc lỗi compile do thiếu symbol đều hợp lệ).

IMPLEMENT
Hãy đóng vai @developer và kích hoạt skill /flutter-mobile.
Hiện thực các file mã nguồn tối thiểu để toàn bộ test ở bước DEFINE TEST chuyển GREEN:
1. Chỉ sửa lỗi phát hiện từ integration test và QA; không thêm tính năng.
Tuân thủ 000-conventions.md mục B: MVC + GetX, dependency qua constructor, binding là nơi duy nhất gọi Get.find/Get.put,
Money (cents) và LocalDate, soft delete, không catch rỗng.
Chạy lại: flutter test integration_test → GREEN; flutter analyze → 0 issue.
Không sửa test để cho xanh. Nếu test mâu thuẫn với spec → dừng và báo.

DESIGN
Hãy đóng vai @frontend-design kết hợp @developer và kích hoạt skill /ui-ux-pro-max.
Dùng Design System trong 000-conventions.md mục C (AppColors, AppSpacing, AppTextStyles, component dùng chung)
và mục Design notes của specs/027-release-readiness.md:
1. Screenshot store (6.7", 6.1", Android), icon cuối cùng.
2. Tên Daily Budget: Safe to Spend, phụ đề Paycheck budget, no bank login, mô tả ngắn/dài, từ khóa.
Đảm bảo: light/dark, Dynamic Type cỡ lớn nhất, semantics label, reduced motion, không hardcode chuỗi/màu/spacing.
Bổ sung widget test cho mọi page/widget mới hoặc thay đổi ở bước này (đặt trong test/features/<feature>/pages|widgets/).
Chạy flutter test → toàn bộ GREEN.

REVIEW & VERIFY
Hãy đóng vai @silent-failure-hunter kết hợp skill /review-code.
Rà soát toàn bộ file đã tạo/sửa trong Spec 027:
1. Toàn bộ test (unit, widget, golden, integration) xanh trên CI.
2. Hiệu năng: cold start, cuộn History 2.000 mục, kích thước app — ghi số liệu.
3. VoiceOver/TalkBack và Dynamic Type toàn luồng chính.
4. Privacy label, Data safety, Privacy Policy, Terms, disclaimer.
5. TestFlight/Internal chạy ổn định ≥ 3 ngày không crash.
6. Không có catch rỗng hoặc lỗi bị nuốt; mọi lỗi chuyển state error và ghi log (không kèm dữ liệu tài chính).
7. Mọi AnimationController/Timer/StreamSubscription/observer được hủy trong dispose()/onClose().
8. Parse dữ liệu bất thường (null, rỗng, sai định dạng, số âm, số rất lớn) không gây crash.
9. Zero-warning, không dùng deprecated API, đạt DoD chung (000-conventions.md mục A4) và DoD của spec.
Chạy: make test, make analyze, make format. Chạy app thật trên iOS Simulator và Android Emulator ở luồng chính của spec.
Ghi kết quả THỰC TẾ vào mục "Review & Verify Report" của specs/027-release-readiness.md:
số test pass/tổng, số issue analyze, DoD đã tick, kết quả kiểm tra thủ công, lỗi đã phát hiện và đã sửa.
CỔNG: còn test fail, còn warning hoặc còn mục DoD chưa đạt → quay lại IMPLEMENT/DESIGN để sửa rồi REVIEW lại.
Không chuyển sang REMEMBER khi chưa đạt 100%.

REMEMBER
Kích hoạt skill /session-memory.
Cập nhật docs/SESSION_STATE.md:
- Đánh dấu Spec 027 · Release readiness = DONE, ghi số test pass/tổng và số warning lấy từ Review & Verify Report (không ghi số ước đoán).
- Mục Knowledge: Quy trình phát hành; Checklist QA trước mỗi bản.
- Known issues / Tech debt phát sinh (nếu có); ý tưởng ngoài phạm vi ghi docs/BACKLOG.md.
- Đổi dòng "Trạng thái" đầu file specs/027-release-readiness.md thành DONE.
- Next: MVP hoàn tất. Chuẩn bị Giai đoạn 2 theo docs/safe-to-spend-product-plan.md mục 9.
```

---
