# Spec 001 · F00 — Project foundation & bộ nhớ dự án

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 001
> **Phụ thuộc:** không có · **Ước lượng:** 0,5 ngày
> **Trạng thái:** TODO

---

**Mục tiêu:** Dựng khung dự án chuẩn để mọi feature sau làm theo cùng một nền.

**Phạm vi — In:**
- Tạo project Flutter `safe_to_spend` (org `org.aveglobal` hoặc theo cấu hình công ty), iOS min **17.0**, Android minSdk **26**.
- Cấu trúc thư mục như B2; tạo package rỗng `packages/budget_engine`.
- `analysis_options.yaml` với `very_good_analysis` (hoặc `flutter_lints` nghiêm ngặt).
- Flavors: `dev`, `prod` (bundle id khác nhau, tên app khác nhau).
- Script `Makefile` hoặc `melos`: `make test`, `make analyze`, `make gen` (build_runner), `make golden`.
- CI (GitHub Actions): format check, analyze, test (app + engine).
- Tạo `docs/SESSION_STATE.md` (bảng tiến độ Spec 001–027 trạng thái TODO, mục Knowledge, mục Next), `docs/DECISIONS.md`, `docs/BACKLOG.md` theo mẫu trong `000-conventions.md` mục A3.
- Tạo khung thư mục MVC + GetX như `000-conventions.md` mục B2 (`lib/core`, `lib/data`, `lib/domain`, `lib/features`), `GetMaterialApp` tối thiểu, `InitialBinding` rỗng.

**Phạm vi — Out:** Firebase, RevenueCat, AdMob (làm ở feature riêng).

**Test cases:**
- T00-1: `flutter test` chạy được với 1 smoke test render app.
- T00-2: `dart test` trong `packages/budget_engine` chạy được.
- T00-3: CI chạy xanh trên nhánh chính.

**Definition of Done:**
- [ ] Build được `dev` và `prod` trên iOS Simulator và Android Emulator
- [ ] CI xanh
- [ ] 4 file bộ nhớ trong `docs/` đã tạo đúng mẫu A3
- [ ] `SESSION_STATE.md` mục Knowledge ghi lệnh build/test/gen

**Remember:** ghi bundle id, lệnh chạy flavor, phiên bản Flutter vào `docs/SESSION_STATE.md` (mục Knowledge).

---

## Implementation Plan

### 1. Thông số nhận diện & Môi trường Runtime cố định
- **Dart Package Name (`pubspec.yaml`):** `safe_to_spend` (theo đúng yêu cầu chốt của dự án và `000-conventions.md`).
- **Application ID (Android):**
  - Flavor `dev`: `org.aveglobal.safetospend.dev`
  - Flavor `prod`: `org.aveglobal.safetospend`
- **Bundle Identifier (iOS):**
  - Flavor `dev`: `org.aveglobal.safetospend.dev`
  - Flavor `prod`: `org.aveglobal.safetospend`
- **Tên hiển thị ứng dụng (App Display Name):**
  - Flavor `dev`: `Safe to Spend (Dev)`
  - Flavor `prod`: `Daily Safe-to-Spend`
- **Nền tảng tối thiểu:**
  - Android: `minSdk = 26` (Android 8.0 Oreo), `compileSdk = 35`, `targetSdk = 35`
  - iOS: Deployment target tối thiểu `17.0` (đáp ứng WidgetKit và App Intents ở Spec 019)
- **Phiên bản Runtime cố định:**
  - Flutter: `3.44.2` (channel stable)
  - Dart: `3.12.2` (SDK constraint: `>=3.12.2 <4.0.0`)

---

### 2. Danh sách Dependency & Bộ Lint chốt

#### A. Ứng dụng chính (`pubspec.yaml`)
Tuân thủ nguyên tắc: *"Chỉ cài dependency phục vụ đúng phạm vi Spec 001; không cài thừa; phiên bản được ghim rõ ràng."* (Các thư viện như `drift`, `purchases_flutter`, `google_mobile_ads`, `firebase_*` sẽ được thêm tại các spec tương ứng).

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.6.6                    # State management, DI, routing (MVC + GetX)
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2                  # Định dạng và ARB localization (pinned by Flutter 3.44.2 SDK)
  budget_engine:                 # Local engine package thuần Dart
    path: packages/budget_engine

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4               # Mocking framework cho unit test
  very_good_analysis: ^7.0.0     # Bộ quy tắc lint nghiêm ngặt
```

#### B. Package thuần Dart (`packages/budget_engine/pubspec.yaml`)
```yaml
name: budget_engine
description: Pure Dart business logic & calculation engine for Daily Safe-to-Spend.
version: 0.0.1
publish_to: 'none'

environment:
  sdk: '>=3.12.2 <4.0.0'

dev_dependencies:
  lints: ^5.1.1
  test: ^1.25.8
```

#### C. Cấu hình Lint (`analysis_options.yaml`)
Sử dụng `very_good_analysis: ^7.0.0`, đồng thời kích hoạt strict mode của Dart analyzer và tắt `public_member_api_docs` để tránh ép viết doc comment cho widget nội bộ:
```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    missing_required_param: error
    missing_return: error

linter:
  rules:
    public_member_api_docs: false
    lines_longer_than_80_chars: false
```

---

### 3. Nội dung `Makefile` & Workflow CI (`.github/workflows/ci.yaml`)

#### A. `Makefile` (chuẩn mục A2)
```makefile
.PHONY: gen test analyze format golden coverage

gen:
	dart run build_runner build --delete-conflicting-outputs

test:
	flutter test && (cd packages/budget_engine && dart test)

analyze:
	flutter analyze && (cd packages/budget_engine && dart analyze)

format:
	dart format --set-exit-if-changed .

golden:
	flutter test --update-goldens --tags golden

coverage:
	flutter test --coverage && (cd packages/budget_engine && dart test --coverage=coverage)
```

#### B. CI Workflow (`.github/workflows/ci.yaml`)
Trình tự: **Format check → Analyze (app + engine) → Test engine → Test app**.
```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  verify:
    name: Format, Analyze & Test
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Java 17
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.44.2'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: |
          flutter pub get
          cd packages/budget_engine && dart pub get

      - name: Format Check
        run: dart format --output=none --set-exit-if-changed .

      - name: Analyze (App & Engine)
        run: |
          flutter analyze
          cd packages/budget_engine && dart analyze

      - name: Run Engine Tests
        run: cd packages/budget_engine && dart test

      - name: Run App Tests
        run: flutter test
```

---

### 4. Danh sách File tạo / sửa (đường dẫn đầy đủ theo mục B2) & Vai trò

| Đường dẫn file | Thao tác | Vai trò / Mô tả chi tiết |
|---|---|---|
| **Cấu hình & Tooling** | | |
| `pubspec.yaml` | Sửa | Khai báo package name `safe_to_spend`, Dart SDK `^3.12.2`, dependencies (`get`, `intl`, `budget_engine`), dev dependencies (`very_good_analysis`, `mocktail`). |
| `analysis_options.yaml` | Sửa | Cấu hình linter `very_good_analysis` kèm analyzer strict mode. |
| `l10n.yaml` | Tạo | Cấu hình sinh mã đa ngôn ngữ Flutter từ file ARB (`lib/core/l10n`). |
| `Makefile` | Tạo | Quản lý các lệnh chạy chuẩn của dự án: `gen`, `test`, `analyze`, `format`, `golden`, `coverage`. |
| `.github/workflows/ci.yaml` | Tạo | Pipeline CI tự động kiểm tra format, analyze và chạy test app + engine trên GitHub Actions. |
| **Bộ nhớ dự án (`docs/`)** | | |
| `docs/SESSION_STATE.md` | Tạo | Theo dõi tiến độ toàn diện 27 specs (trạng thái ban đầu TODO), lưu Knowledge (lệnh chạy, flavor, bundle id), Known issues, Next spec. |
| `docs/DECISIONS.md` | Tạo | Sổ ghi chép Architecture Decision Records (ADR) cho toàn bộ quyết định kỹ thuật của dự án. |
| `docs/BACKLOG.md` | Tạo | Lưu trữ các ý tưởng, tính năng phát sinh ngoài phạm vi MVP và technical debt. |
| **Mã nguồn ứng dụng (`lib/`)** | | |
| `lib/main.dart` | Sửa | Điểm vào chính của ứng dụng; gọi `bootstrap()`. |
| `lib/bootstrap.dart` | Tạo | Thiết lập môi trường bất đồng bộ (`WidgetsFlutterBinding.ensureInitialized`), chạy `runApp(const SafeToSpendApp())`. |
| `lib/app.dart` | Tạo | Widget gốc `SafeToSpendApp` trả về `GetMaterialApp` tối thiểu với initialBinding, getPages, routes, theme và localization. |
| `lib/core/bindings/initial_binding.dart` | Tạo | `InitialBinding` rỗng (kế thừa `Bindings`), chuẩn bị cho DI các permanent service sau này. |
| `lib/core/routes/app_routes.dart` | Tạo | Hằng số đường dẫn route (`AppRoutes.root`, `AppRoutes.splash`). |
| `lib/core/routes/app_pages.dart` | Tạo | Danh sách `GetPage` của ứng dụng (khởi tạo với 1 route placeholder ban đầu). |
| `lib/core/l10n/app_en.arb` | Tạo | File ARB tiếng Anh mẫu khởi tạo (ví dụ chuỗi `appTitle`). |
| **Thư mục khung kiến trúc (giữ cấu trúc theo mục B2 bằng `.gitkeep`)** | | |
| `lib/core/theme/.gitkeep` | Tạo | Thư mục token màu, typography, spacing (Spec 005). |
| `lib/core/money/.gitkeep` | Tạo | MoneyFormatter, MoneyParser (Spec 002). |
| `lib/core/time/.gitkeep` | Tạo | Clock, LocalDate, DayChangeWatcher (Spec 002). |
| `lib/core/ids/.gitkeep` | Tạo | UuidGenerator (Spec 002). |
| `lib/core/analytics/.gitkeep` | Tạo | AnalyticsEvents constants (Spec 021). |
| `lib/core/state/.gitkeep` | Tạo | ViewState enum (Spec 002). |
| `lib/core/widgets/.gitkeep` | Tạo | Shared widgets / Design system components (Spec 005). |
| `lib/domain/repositories/.gitkeep` | Tạo | Domain repository interfaces. |
| `lib/domain/services/.gitkeep` | Tạo | Domain service interfaces. |
| `lib/data/db/.gitkeep` | Tạo | Drift AppDatabase, tables, DAOs (Spec 004). |
| `lib/data/mappers/.gitkeep` | Tạo | Data mappers giữa database row và domain model. |
| `lib/data/models/.gitkeep` | Tạo | Local data models. |
| `lib/data/repositories/.gitkeep` | Tạo | Repository implementations. |
| `lib/data/services/.gitkeep` | Tạo | Service implementations (BudgetSnapshotService, etc.). |
| `lib/features/splash/.gitkeep` | Tạo | Feature splash screen (Spec 006). |
| `lib/features/onboarding/.gitkeep` | Tạo | Feature onboarding flow (Specs 007–010). |
| `lib/features/root/.gitkeep` | Tạo | Feature root bottom tab shell (Spec 005). |
| `lib/features/today/.gitkeep` | Tạo | Feature Today screen (Spec 011). |
| `lib/features/quick_add/.gitkeep` | Tạo | Feature Quick Add bottom sheet (Spec 012). |
| `lib/features/history/.gitkeep` | Tạo | Feature History screen (Spec 013). |
| `lib/features/plan/.gitkeep` | Tạo | Feature Plan screen (Spec 014–016). |
| `lib/features/income/.gitkeep` | Tạo | Feature Income log (Spec 014). |
| `lib/features/bills/.gitkeep` | Tạo | Feature Recurring Bills (Spec 015). |
| `lib/features/goal/.gitkeep` | Tạo | Feature Savings Goal (Spec 016). |
| `lib/features/settings/.gitkeep` | Tạo | Feature Settings (Spec 017). |
| `lib/features/premium/.gitkeep` | Tạo | Feature Paywall & Entitlements (Spec 022). |
| `lib/features/ads/.gitkeep` | Tạo | Feature Ads banner/interstitial (Spec 026). |
| **Package Dart thuần `packages/budget_engine/`** | | |
| `packages/budget_engine/pubspec.yaml` | Tạo | File mô tả package thuần Dart, độc lập với Flutter/GetX. |
| `packages/budget_engine/analysis_options.yaml` | Tạo | Cấu hình lint riêng cho pure Dart package. |
| `packages/budget_engine/lib/budget_engine.dart` | Tạo | Export entry point của thư viện `budget_engine`. |
| `packages/budget_engine/test/smoke_test.dart` | Tạo | Smoke test T00-2 cho package `budget_engine`. |
| **Cấu hình Native & Flavors (Android & iOS)** | | |
| `android/app/build.gradle.kts` | Sửa | Cập nhật `minSdk = 26`, thêm `flavorDimensions += "default"`, khai báo `dev` (suffix `.dev`) và `prod`, bind `app_name`. |
| `android/app/src/dev/res/values/strings.xml` | Tạo | Định nghĩa resource `app_name = "Safe to Spend (Dev)"`. |
| `android/app/src/prod/res/values/strings.xml` | Tạo | Định nghĩa resource `app_name = "Daily Safe-to-Spend"`. |
| `ios/Flutter/Debug-dev.xcconfig` | Tạo | Cấu hình iOS debug cho flavor `dev` (bundle id `org.aveglobal.safetospend.dev`, app name `Safe to Spend (Dev)`). |
| `ios/Flutter/Release-dev.xcconfig` | Tạo | Cấu hình iOS release cho flavor `dev`. |
| `ios/Flutter/Debug-prod.xcconfig` | Tạo | Cấu hình iOS debug cho flavor `prod` (bundle id `org.aveglobal.safetospend`, app name `Daily Safe-to-Spend`). |
| `ios/Flutter/Release-prod.xcconfig` | Tạo | Cấu hình iOS release cho flavor `prod`. |
| `ios/Runner.xcodeproj/project.pbxproj` | Sửa | Cấu hình build configurations & schemes cho `dev` và `prod`, set min iOS version `17.0`. |
| `ios/Runner/Info.plist` | Sửa | Gán `CFBundleDisplayName` thành `$(APP_DISPLAY_NAME)`. |
| **Test Files** | | |
| `test/app_smoke_test.dart` | Tạo | Test case T00-1: render `SafeToSpendApp` (`GetMaterialApp`) tối thiểu không lỗi. |
| `test/helpers/.gitkeep` | Tạo | Thư mục chứa các fake objects và test helpers dùng chung (FakeClock, pumpGetPage). |

---

### 5. Ánh xạ Test Case → File Test

| Mã Test Case | Nội dung kiểm thử | File Test thực tế | Kịch bản chi tiết |
|---|---|---|---|
| **T00-1** | `flutter test` chạy được với 1 smoke test render app | `test/app_smoke_test.dart` | Viết `testWidgets('T00-1: render GetMaterialApp tối thiểu không lỗi', (tester) async { ... })`: khởi tạo `SafeToSpendApp`, gọi `tester.pumpWidget(const SafeToSpendApp())`, kiểm tra `GetMaterialApp` xuất hiện trên cây widget mà không ném ngoại lệ. |
| **T00-2** | `dart test` trong `packages/budget_engine` chạy được | `packages/budget_engine/test/smoke_test.dart` | Viết `test('T00-2: budget_engine package smoke test passes', () { ... })`: import thư viện `package:budget_engine/budget_engine.dart` và assert logic khởi tạo trả về kết quả hợp lệ. |
| **T00-3** | CI chạy xanh trên nhánh chính | `.github/workflows/ci.yaml` | Tự động kích hoạt khi push/PR lên `main`: thực thi 4 bước liên hoàn (format check → analyze 0 warning → engine test pass → app test pass). |

---

### 6. Thứ tự triển khai chi tiết (Vertical Slices cho các bước sau)

1. **Bước 1 (DEFINE TEST):**
   - Tạo `test/app_smoke_test.dart` với test case `T00-1`.
   - Tạo `packages/budget_engine/test/smoke_test.dart` với test case `T00-2`.
   - Chạy lệnh test để xác nhận trạng thái **RED** (compile error hoặc test fail hợp lệ do chưa có mã nguồn).
2. **Bước 2 (IMPLEMENT - Tooling & Core):**
   - Tạo package `packages/budget_engine` (pubspec, analysis_options, lib file) để `T00-2` chuyển **GREEN**.
   - Cập nhật root `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`.
   - Tạo mã nguồn ứng dụng: `lib/main.dart`, `lib/bootstrap.dart`, `lib/app.dart`, `lib/core/bindings/initial_binding.dart`, `lib/core/routes/app_routes.dart`, `lib/core/routes/app_pages.dart` để `T00-1` chuyển **GREEN**.
   - Khởi tạo `Makefile` và `.github/workflows/ci.yaml`.
3. **Bước 3 (IMPLEMENT - Skeletons & Docs):**
   - Tạo khung thư mục MVC + GetX theo B2 với các file `.gitkeep`.
   - Tạo 3 file bộ nhớ dự án trong `docs/`: `docs/SESSION_STATE.md`, `docs/DECISIONS.md`, `docs/BACKLOG.md`.
4. **Bước 4 (IMPLEMENT - Flavors Native):**
   - Cấu hình Android `build.gradle.kts` (productFlavors, minSdk 26, string resources).
   - Cấu hình iOS xcconfig, scheme và `project.pbxproj` (iOS 17.0, CFBundleDisplayName, bundle id dev/prod).
5. **Bước 5 (REVIEW & VERIFY):**
   - Chạy `make format`, `make analyze`, `make test`.
   - Kiểm tra build thử flavor dev/prod.
   - Điền kết quả thực tế vào mục Review & Verify Report.
6. **Bước 6 (REMEMBER):**
   - Cập nhật `docs/SESSION_STATE.md` (chuyển Spec 001 thành DONE, ghi Knowledge).

---

### 7. Rủi ro & Câu hỏi mở

#### Rủi ro kỹ thuật:
1. **iOS Flavor & `project.pbxproj`**: Việc sửa file `project.pbxproj` bằng tay hoặc script có thể gây lỗi workspace Xcode nếu cấu hình scheme/xcconfig không khớp chính xác. *Giải pháp:* Kiểm tra kỹ git diff trước khi commit, đối chiếu với xcconfig mẫu chuẩn của Flutter.
2. **Android Gradle Plugin 8+ & Kotlin DSL**: Project đang sử dụng `android/app/build.gradle.kts` (Kotlin DSL). Cần đảm bảo cú pháp flavor `flavorDimensions += "default"` và `create("dev") { ... }` đúng chuẩn Kotlin DSL để tránh lỗi sync Gradle.

#### Quyết định đã chốt cùng User:
1. **Vị trí thư mục `specs/` & `docs/`:** ĐÃ THỰC HIỆN — Đã di chuyển toàn bộ từ `specs_project/specs/` và `specs_project/docs/` ra thư mục gốc `specs/` và `docs/`, đồng thời đã xóa `/specs_project` khỏi `.gitignore` để Git theo dõi đầy đủ.
2. **Dart Package Name:** ĐÃ CHỐT — Sử dụng `safe_to_spend` trong `pubspec.yaml`.
3. **Bộ Linter:** ĐÃ CHỐT — Sử dụng `very_good_analysis: ^7.0.0` với cấu hình điều chỉnh (tắt `public_member_api_docs`) và kích hoạt strict mode.

---

## Review & Verify Report

> Bước REVIEW & VERIFY điền phần này: kết quả **thực tế** của `flutter test` (số test pass/fail), `flutter analyze` (số issue), checklist DoD đã tick, kết quả kiểm tra thủ công, lỗi đã sửa. Không ghi số liệu chưa chạy.
