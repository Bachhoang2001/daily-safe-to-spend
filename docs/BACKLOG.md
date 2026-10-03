# Project Backlog (Ngoài phạm vi MVP)

Các ý tưởng, cải tiến và technical debt ghi nhận trong quá trình phát triển:

- [ ] Hỗ trợ đa ngôn ngữ mở rộng (Vietnamese, Japanese, Spanish) sau MVP (Spec 001 hiện tại cố định `en`).
- [ ] CI/CD: Bổ sung bước build artifact (APK/AAB và iOS ipa) khi gắn release tag.
- [ ] Thêm flavor `staging` nếu tích hợp backend sync / cloud API trong tương lai.
- [ ] Dark mode dynamic switcher / theme persistence mở rộng (sẽ hiện thực sâu ở Spec 024).
- [ ] Mở rộng `Money` và `MoneyFormatter` hỗ trợ các đồng tiền không có số thập phân (zero-decimal currencies như JPY, VND) khi mở rộng ra thị trường châu Á sau MVP.
- [ ] Engine - Hỗ trợ `dueOnWeekendShift` cho Bill: Tự động trượt ngày thanh toán sang thứ Hai kế tiếp nếu rơi vào Thứ Bảy / Chủ Nhật (Spec 003 MVP cố định đúng ngày hạn `dueDay`).
- [ ] Engine - Hỗ trợ nhiều mục tiêu tiết kiệm đồng thời (`List<Goal>`): MVP hiện tại tối đa 1 mục tiêu tiết kiệm đang hoạt động.
- [ ] Engine - Mở rộng Rollover Mode cho chế độ Thu nhập không đều (Irregular): Cho phép người dùng irregular chọn Tomorrow boost hoặc Save it thay vì chỉ áp dụng cơ chế Spread tự nhiên.
- [ ] Data layer - Hỗ trợ Full-text search (SQLite FTS5) cho ghi chú chi tiêu (`note`) khi người dùng tích lũy hàng nghìn giao dịch sau thời gian dài sử dụng.
- [ ] Data layer - Tự động đồng bộ hai chiều (Bi-directional Cloud Sync) ở Giai đoạn 3 (đã chuẩn bị sẵn cấu trúc `CommonSyncTable` với `id`, `device_id`, `updated_at`, `deleted_at`).
- [ ] App Shell & Deep Link - Hỗ trợ Universal Links (iOS) và Android App Links thông qua file cấu hình web `apple-app-site-association` và `assetlinks.json` trên domain landing page khi triển khai web marketing sau MVP (hiện tại MVP sử dụng Custom URL scheme `safetospend://quick-add` cho Widget và Native shortcuts).
- [ ] Startup & Bootstrap - Bổ sung Telemetry ghi nhận độ trễ thực thi (execution latency) của từng `IStartupTask` chạy lazy sau frame đầu để phát hiện các third-party SDK gây nghẽn CPU background sau này.
- [ ] Startup & Splash - Nghiên cứu Dynamic Splash Animation (Lottie / Rive) sau MVP nếu nhận diện thương hiệu yêu cầu hiệu ứng chuyển động logo phức tạp thay cho static vector native splash.
- [ ] Onboarding Welcome - Hỗ trợ video demo siêu ngắn hoặc interactive preview card cho phép người dùng nhập thử một số chi tiêu giả định ngay trên Welcome trước khi bắt đầu.
- [ ] Onboarding Legal - Tích hợp In-App Webview (SFSafariViewController / Custom Tabs) khi xem Privacy Policy & Terms để giữ người dùng không bị rời app trong luồng đăng ký ban đầu.
- [ ] Onboarding Income - Tự động phát hiện ngày nhận lương tiếp theo thông qua tích hợp lịch hệ thống (Calendar integration) hoặc gợi ý thông minh dựa trên chu kỳ phổ biến.
- [ ] Onboarding Income - Bổ sung máy tính thuế thu nhập ròng ước tính (Net Pay / Take-Home Calculator) hỗ trợ người dùng không nhớ rõ lương thực nhận sau khấu trừ.
- [ ] Onboarding Bills - Quét và nhận diện hóa đơn tự động qua OCR camera hoặc nhập trực tiếp từ ảnh chụp biên lai / file PDF hóa đơn.
- [ ] Onboarding Bills - Tự động đồng bộ các gói thuê bao định kỳ từ Apple App Store / Google Play Subscriptions hoặc phân tích hóa đơn email receipts.
- [ ] Onboarding Bills - Hỗ trợ hóa đơn có số tiền biến thiên theo mùa (tiền điện, tiền nước) thay vì chỉ một con số cố định mỗi chu kỳ.

