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

## ADR-005: Dùng Tên Bảng `expense` Thay Cho `transaction`
- Ngày: 2026-10-02 · Spec: 004
- Bối cảnh: Ứng dụng quản lý các khoản chi tiêu hàng ngày của người dùng. Trong các hệ thống tài chính truyền thống, bảng lưu dữ liệu giao dịch thường được đặt tên là `transactions`.
- Quyết định: Đặt tên bảng là `expenses` (`lib/data/db/tables/expenses_table.dart`) và model là `Expense`.
- Lý do:
  1. `transaction` là từ khóa dành riêng (reserved SQL keyword) trong SQLite và hầu hết các RDBMS (dùng cho `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`), dễ gây lỗi cú pháp hoặc yêu cầu escape quotes (`[transaction]` / `"transaction"`) liên tục.
  2. Về mặt ngữ nghĩa domain, ứng dụng Daily Safe-to-Spend tập trung vào việc theo dõi chi tiêu cá nhân để tính toán số tiền an toàn còn lại trong ngày; từ `expense` mô tả trực diện và chính xác hơn nghiệp vụ này so với từ chung chung `transaction`.
  3. Thu nhập được tách riêng thành bảng `income_entries` nhằm phục vụ mô hình thu nhập không đều (irregular mode).
- Hệ quả: Loại bỏ nguy cơ xung đột từ khóa SQL với Drift/SQLite, code DAO/Repository sạch hơn, không cần backticks hay ngoặc vuông bảo vệ từ khóa SQL.

## ADR-006: Onboarding Chỉ Cho Phép Chọn Ngày Đến Hạn Của Hóa Đơn Từ Hôm Nay Trở Đi
- Ngày: 2026-10-03 · Spec: 009
- Bối cảnh: Trong bước Onboarding 3 (Bills), người dùng khai báo các hóa đơn định kỳ sắp tới để hệ thống bảo lưu hạn mức chi tiêu. Người dùng có thể có hóa đơn định kỳ hàng tháng (ví dụ tiền nhà ngày 1 hàng tháng), và nếu hôm nay là ngày 3 thì hóa đơn của tháng này có thể đã được thanh toán hoặc chưa thanh toán. Nếu cho phép chọn ngày quá khứ (ví dụ ngày 1), phát sinh sự nhập nhằng: Hóa đơn tháng này đã trả chưa? Nếu đã trả thì có cần trừ vào kỳ lương hiện tại không?
- Quyết định: Trong phạm vi Onboarding (MVP), chỉ cho phép chọn ngày đến hạn đầu tiên (`firstDueDate`) từ hôm nay trở đi (`firstDueDate >= today`). DatePicker chặn toàn bộ ngày trong quá khứ (`firstDate = today`).
- Lý do:
  1. Tránh hiểu lầm tài chính: Onboarding có nhiệm vụ tính toán số tiền "An toàn để chi tiêu hôm nay" (`safeToday`) cho khoảng thời gian còn lại đến kỳ lương tiếp theo. Nếu hóa đơn đã thanh toán trước khi dùng app, số tiền đó đã phản ánh vào số dư ban đầu (`firstPeriodBalance` hoặc `startingBalance`).
  2. Đơn giản hóa trải nghiệm (DoD $\le 4$ chạm): Loại bỏ câu hỏi phụ phức tạp "Hóa đơn này tháng này đã trả chưa?".
  3. Quản lý toàn diện ở Spec 015: Người dùng có thể điều chỉnh ngày gốc hoặc quản lý chi tiết trạng thái thanh toán trong màn Bills đầy đủ sau khi vào app.
- Hệ quả: Loại bỏ khả năng phát sinh bug trừ trùng lặp hóa đơn đã thanh toán trước ngày onboard, bảo đảm con số `billsTotalBeforePayday` luôn đại diện chính xác cho các khoản nợ sắp phải chi trong kỳ hiện tại.



