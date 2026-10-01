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

## ADR-002: Rollover "Save it" là Dữ Liệu Dẫn Xuất (Derived), Không Lưu DB
- Ngày: 2026-10-02 · Spec: 003
- Bối cảnh: Khi người dùng chọn chế độ `RolloverMode.save`, số dư cuối mỗi ngày chưa tiêu hết được gom vào mục tiêu tiết kiệm (`Goal`).
- Quyết định: Giá trị `derivedGoalSaved` được tính toán động hoàn toàn (pure derived computation) trong `computeSnapshot` tại thời điểm chạy engine; SQLite DB chỉ lưu trữ các khoản nạp thủ công `GoalContribution`.
- Hệ quả: Không làm bẩn cơ sở dữ liệu với hàng chục record phát sinh tự động mỗi tháng. Khi người dùng chỉnh sửa chi tiêu ngày cũ hoặc đổi chế độ rollover, engine tự động tái tính toán kết quả mà không cần rollback hay dọn dẹp DB.

## ADR-003: Đổi payFrequency hoặc payAnchorDate Không Tái Hiện Lại Kỳ Cũ
- Ngày: 2026-10-02 · Spec: 003
- Bối cảnh: Người dùng có thể đổi chu kỳ lương từ biweekly sang monthly hoặc đổi ngày trả lương trong Settings giữa chừng.
- Quyết định: Engine luôn tính snapshot kỳ hiện tại dựa trên `BudgetConfig` đang áp dụng. Các kỳ lịch sử trước đó không cần lưu snapshot tĩnh hay tái hiện phức tạp trong MVP. Lịch sử chi tiêu theo ngày (`Expense`) vẫn được bảo toàn nguyên vẹn.
- Hệ quả: Giữ engine hoàn toàn phi trạng thái (stateless), tránh phân kỳ dữ liệu và loại bỏ hoàn toàn việc phải versioning cấu hình theo thời gian ở MVP.

## ADR-004: Chế Độ Thu Nhập Không Đều (Irregular) Không Dùng Rollover Mode ở MVP
- Ngày: 2026-10-02 · Spec: 003
- Bối cảnh: Người dùng freelance/gig-worker có dòng tiền và số dư biến thiên liên tục.
- Quyết định: Chế độ `irregular` luôn tính lại hạn mức ngày linh hoạt từ số dư thực tế chia đều cho cửa sổ an toàn $H$ (mặc định 14 ngày), tương đương cơ chế `spread` tự nhiên. Các chế độ `tomorrow` và `save` bị vô hiệu hóa cho `irregular` trong MVP.
- Hệ quả: Đơn giản hóa mô hình tư duy tài chính cho người dùng thu nhập không đều, loại bỏ nguy cơ tích lũy thặng dư ảo khi dòng tiền không có chu kỳ cố định.

