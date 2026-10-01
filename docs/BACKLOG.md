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
