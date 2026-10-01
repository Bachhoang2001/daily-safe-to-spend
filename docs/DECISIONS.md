# Architecture Decision Records (ADR)

## ADR-001: Khởi tạo Project Foundation và Quản trị Bộ nhớ Dự án
- Ngày: 2026-10-01 · Spec: 001
- Bối cảnh: Thiết lập nền tảng dự án Daily Safe-to-Spend tuân thủ kiến trúc MVC + GetX, tách riêng Dart engine logic `packages/budget_engine` và hỗ trợ flavors `dev`/`prod`.
- Quyết định:
  1. Package name Dart được đặt là `safe_to_spend`.
  2. Nền tảng tối thiểu: iOS 17.0 (WidgetKit & App Intents) và Android minSdk 26 (Android 8.0).
  3. Linter: Sử dụng `very_good_analysis: ^7.0.0` kết hợp analyzer strict mode.
  4. Quản lý trạng thái & DI bằng GetX, nhưng áp dụng quy ước nghiêm ngặt: Controller nhận dependency qua constructor, Binding là nơi duy nhất gọi `Get.find`/`Get.put`.
- Hệ quả: Giữ code testable 100%, bảo đảm không lỗi ngầm và dễ mở rộng.
