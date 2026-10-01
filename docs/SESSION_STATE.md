# Session State
_Cập nhật: 2026-10-01 · Spec hiện tại: 001 · Spec tiếp theo: 002_

## Tiến độ
| Spec | Feature | Trạng thái | Tests (pass/total) | Analyze | Ngày |
|------|---------|------------|--------------------|---------|------|
| 001 | Project foundation & bộ nhớ dự án | IN_PROGRESS (IMPLEMENT) | 2/2 | 0 | 2026-10-01 |
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
- Package name: `safe_to_spend`
- Flavor Dev: bundle id / applicationId `org.aveglobal.safetospend.dev`, app name `Safe to Spend (Dev)`
- Flavor Prod: bundle id / applicationId `org.aveglobal.safetospend`, app name `Daily Safe-to-Spend`
- Lệnh chạy flavor:
  - Dev: `flutter run --flavor dev -t lib/main.dart`
  - Prod: `flutter run --flavor prod -t lib/main.dart`
- Lệnh chuẩn:
  - `make test`: chạy unit & widget test cho cả app và engine.
  - `make analyze`: chạy static analyzer cho cả app và engine.
  - `make format`: format code theo chuẩn Dart.
  - `make gen`: chạy build_runner (khi dùng drift/freezed).
- Phiên bản: Flutter 3.44.2 (stable), Dart 3.12.2.

## Known issues / Tech debt
- Chưa có.

## Next
- Spec 002 · Core primitives: Money, LocalDate, Clock, UUID (file `specs/002-core-primitives.md`).
