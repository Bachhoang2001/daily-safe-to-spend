# Session State
_Cập nhật: 2026-10-01 · Spec vừa xong: 001 · Spec tiếp theo: 002_

## Tiến độ
| Spec | Feature | Trạng thái | Tests (pass/total) | Analyze (warnings) | Ngày |
|------|---------|------------|--------------------|--------------------|------|
| 001 | Project foundation & bộ nhớ dự án | DONE | 2/2 | 0 | 2026-10-01 |
| 002 | Core primitives | TODO | – | – | – |
| 003 | Budget engine | TODO | – | – | – |
| 004 | Data layer | TODO | – | – | – |
| 005 | App shell | TODO | – | – | – |
| 006 | Splash & bootstrap | TODO | – | – | – |
| 007 | Onboarding welcome | TODO | – | – | – |
| 008 | Onboarding income | TODO | – | – | – |
| 009 | Onboarding bills | TODO | – | – | – |
| 010 | Onboarding result | TODO | – | – | – |
| 011 | Today | TODO | – | – | – |
| 012 | Quick add | TODO | – | – | – |
| 013 | History | TODO | – | – | – |
| 014 | Income log | TODO | – | – | – |
| 015 | Bills | TODO | – | – | – |
| 016 | Savings goal | TODO | – | – | – |
| 017 | Settings | TODO | – | – | – |
| 018 | Notifications | TODO | – | – | – |
| 019 | Home widget | TODO | – | – | – |
| 020 | Backup & restore | TODO | – | – | – |
| 021 | Analytics & crash | TODO | – | – | – |
| 022 | Premium paywall | TODO | – | – | – |
| 023 | Rollover modes | TODO | – | – | – |
| 024 | Lockscreen widget & themes | TODO | – | – | – |
| 025 | CSV export | TODO | – | – | – |
| 026 | Ads | TODO | – | – | – |
| 027 | Release readiness | TODO | – | – | – |

Trạng thái: TODO · IN_PROGRESS (<bước>) · BLOCKED (<lý do>) · DONE

## Knowledge (điều spec sau cần biết)
- **Bundle ID / Application ID:**
  - Flavor `dev`: `org.aveglobal.safetospend.dev` (App Name: `Safe to Spend (Dev)`)
  - Flavor `prod`: `org.aveglobal.safetospend` (App Name: `Daily Safe-to-Spend`)
- **Lệnh chạy flavor:**
  - Dev: `flutter run --flavor dev -t lib/main.dart`
  - Prod: `flutter run --flavor prod -t lib/main.dart`
- **Phiên bản Runtime cố định:**
  - Flutter: `3.44.2` (channel stable)
  - Dart: `3.12.2` (SDK: `>=3.12.2 <4.0.0`)
- **Các lệnh make (`Makefile`):**
  - `make test`: Chạy toàn bộ unit & widget test suites cho cả app và engine package (`flutter test` + engine `dart test`).
  - `make analyze`: Chạy static analyzer (`very_good_analysis` strict mode) cho cả app và engine.
  - `make format`: Kiểm tra format code theo chuẩn Dart (`dart format --set-exit-if-changed .`).
  - `make gen`: Chạy `build_runner` sinh mã nguồn (`dart run build_runner build --delete-conflicting-outputs`).
  - `make golden`: Cập nhật golden tests (`flutter test --update-goldens`).
- **Quy chuẩn kiến trúc:**
  - Package chính: `safe_to_spend`
  - Package tính toán ngân sách thuần Dart: `packages/budget_engine` (độc lập, zero Flutter dependency)
  - Kiến trúc: MVC + GetX. Phụ thuộc tiêm qua constructor; Binding là nơi duy nhất gọi `Get.put`/`Get.find`/`Get.lazyPut`.

## Known issues / Tech debt
- Không có issue hoặc tech debt phát sinh. Đạt 100% test pass (2/2) và 0 analyze warning.
- Các tính năng mở rộng ngoài MVP đã ghi nhận trong `docs/BACKLOG.md`.

## Next
- Spec 002 · Core primitives: Money, LocalDate, Clock, UUID (file `specs/002-core-primitives.md`).
