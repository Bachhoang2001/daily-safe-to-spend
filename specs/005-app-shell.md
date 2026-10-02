# Spec 005 · F04 — App shell: theme, router, l10n, component chung

> **Dự án:** Daily Safe-to-Spend (Flutter · MVC + GetX · local-first)
> **Đọc kèm bắt buộc:** `specs/000-conventions.md` (kiến trúc GetX, quy ước, Design System, DoD chung)
> **Chạy bằng:** `specs/AGENT-RUNBOOK.md` → mục Spec 005
> **Phụ thuộc:** Spec 001, Spec 004 · **Ước lượng:** 1,5 ngày
> **Trạng thái:** DONE

---

**Mục tiêu:** Khung giao diện và điều hướng dùng chung.

**Mô tả:**
- `ThemeData` light/dark từ token (`000-conventions.md` mục C, file `lib/core/theme/app_colors.dart`, `app_spacing.dart`, `app_text_styles.dart`); theo cài đặt hệ thống, có tùy chọn ép light/dark lưu ở `app_setting` (dùng ở Spec 017).
- `GetMaterialApp` + `lib/core/routes/app_routes.dart` (hằng số route) + `lib/core/routes/app_pages.dart` (danh sách `GetPage` kèm `binding`). Route: `/splash`, `/onboarding/welcome`, `/onboarding/income`, `/onboarding/bills`, `/onboarding/result`, `/root` (shell 3 tab), `/settings`, `/paywall`, `/expense/edit` (argument: id). Quick Add mở bằng `Get.bottomSheet` (không phải route).
- `OnboardingMiddleware extends GetMiddleware`: chưa onboarding → mọi route (trừ onboarding, splash) `redirect` về `/onboarding/welcome`.
- `RootShellPage` + `RootShellController` (`RxInt tabIndex`) dùng `IndexedStack` cho 3 tab Today · History · Plan, giữ state từng tab; `RootShellBinding` đăng ký controller của cả 3 tab bằng `Get.lazyPut`.
- `InitialBinding` (gắn vào `GetMaterialApp.initialBinding`): đăng ký các service/repository dùng chung (permanent).
- l10n: `app_en.arb`, helper `context.l10n`.
- Component dùng chung ở C3 với widget test cơ bản.
- `AmountKeypad`: phím 0–9, `00`, xóa (giữ để xóa hết), haptic nhẹ mỗi lần chạm.

**Test cases:**
- T04-1: `OnboardingMiddleware.redirect` trả đúng route khi chưa/đã onboarding.
- T04-2: Chuyển tab giữ state từng tab.
- T04-3: `AmountKeypad` nhập "1","2","5","0" → hiển thị `$12.50`; xóa → `$1.25`; giữ xóa → `$0.00`.
- T04-4: `AmountText` đổi màu theo `BudgetStatus`.
- T04-5: Golden component chính light/dark.

**Definition of Done:**
- [x] Deep link `safetospend://quick-add` mở Quick Add (dùng cho widget ở Spec 019)
- [x] Toàn bộ component có semantics label

**Remember:** danh sách route và component vào `docs/SESSION_STATE.md` (mục Knowledge).

---

## Implementation Plan

### 1. Danh sách file tạo/sửa & vai trò (tuân thủ `000-conventions.md` mục B2)

Toàn bộ khung giao diện, định tuyến, theme token và component dùng chung được cấu trúc theo đúng kiến trúc MVC + GetX của dự án:

| STT | Đường dẫn file | Vai trò / Trách nhiệm |
|---|---|---|
| 1 | `pubspec.yaml` | Bổ sung dependency: `app_links: ^6.3.2` phục vụ deep link routing. |
| 2 | `lib/core/theme/app_colors.dart` | Định nghĩa toàn bộ color tokens: primary (`#2E9E6A`/`#4CC38A`), trạng thái onTrack, caution (`#D98E04`/`#F2B544`), over (`#C8553D`/`#E07A5F` - cam đất), background, surface, neutral borders. |
| 3 | `lib/core/theme/app_spacing.dart` | Định nghĩa khoảng cách (`xs 4`, `s 8`, `m 12`, `l 16`, `xl 24`, `xxl 32`, `xxxl 48`), bo góc (`card 20`, `button 14`, `chip 999`), min touch target 44pt. |
| 4 | `lib/core/theme/app_text_styles.dart` | Định nghĩa typography: `display` (56sp, bold, tabular figures), `title` (22sp), `body` (16sp), `label` (14sp), `caption` (12sp). |
| 5 | `lib/core/theme/app_theme.dart` | Cấu hình `ThemeData lightTheme` và `ThemeData darkTheme` chuẩn Material 3, hỗ trợ dark mode và Dynamic Type. |
| 6 | `lib/core/money/money_formatter.dart` | Tiện ích format `Money` theo locale và currency, đảm bảo luôn bật fontFeature tabular figures cho tiền tệ. |
| 7 | `lib/core/l10n/app_en.arb` | File từ điển chuỗi l10n tiếng Anh (tab names, common actions, status text, accessibility labels). |
| 8 | `lib/core/l10n/l10n_extensions.dart` | Extension helper `context.l10n` giúp truy cập an toàn, ngắn gọn tới `AppLocalizations`. |
| 9 | `lib/core/routes/app_routes.dart` | Định nghĩa đầy đủ hằng số tên route theo đặc tả: `/splash`, `/onboarding/welcome`, `/onboarding/income`, `/onboarding/bills`, `/onboarding/result`, `/root`, `/settings`, `/paywall`, `/expense/edit`. |
| 10 | `lib/core/routes/middlewares/onboarding_middleware.dart` | `GetMiddleware` kiểm tra trạng thái onboarding qua `IProfileRepository`, tự động redirect về `/onboarding/welcome` nếu chưa hoàn thành. |
| 11 | `lib/core/routes/app_pages.dart` | Khai báo danh sách `GetPage` kết nối từng route với Page và Binding tương ứng. |
| 12 | `lib/domain/services/i_deep_link_service.dart` | Interface dịch vụ deep link: lắng nghe stream URI và xử lý điều hướng `safetospend://quick-add`. |
| 13 | `lib/data/services/deep_link_service.dart` | Hiện thực `IDeepLinkService` bằng package `app_links` (`GetxService`, permanent). |
| 14 | `lib/core/bindings/initial_binding.dart` | Cập nhật đăng ký `IDeepLinkService` vào danh sách service khởi tạo permanent. |
| 15 | `lib/features/root/controllers/root_shell_controller.dart` | `GetxController` quản trị `RxInt tabIndex = 0.obs` và hành động chuyển đổi tab. |
| 16 | `lib/features/root/bindings/root_shell_binding.dart` | `Bindings` đăng ký `RootShellController` và `lazyPut` controller cho 3 tab Today, History, Plan. |
| 17 | `lib/features/root/pages/root_shell_page.dart` | Màn hình shell chính bọc `IndexedStack` giữ nguyên state của 3 tab khi chuyển đổi, kết hợp `NavigationBar` Material 3. |
| 18 | `lib/core/widgets/app_scaffold.dart` | Component khung scaffold chuẩn với SafeArea, nền theme và padding tiêu chuẩn. |
| 19 | `lib/core/widgets/primary_button.dart` | Nút bấm chính bo góc 14pt, cao $\ge 48\text{pt}$, hỗ trợ loading state, semantics label. |
| 20 | `lib/core/widgets/secondary_button.dart` | Nút bấm phụ dạng outline / surfaceVariant với độ phản hồi haptic. |
| 21 | `lib/core/widgets/amount_text.dart` | Component hiển thị số tiền tabular figures, tự động đổi màu theo `BudgetStatus` (onTrack, caution, over). |
| 22 | `lib/core/widgets/amount_keypad.dart` | Bàn phím số 3x4 kiểu ATM/POS (0–9, 00, xóa 1 số, giữ xóa hết, haptic nhẹ, trần 99.999.999 cents, semantics cho từng phím). |
| 23 | `lib/core/widgets/category_chip.dart` | Chip hiển thị danh mục dạng pill (999pt) với icon và màu đại diện. |
| 24 | `lib/core/widgets/section_card.dart` | Thẻ card nền surface bo góc 20pt nhóm các khối nội dung. |
| 25 | `lib/core/widgets/empty_state.dart` | Khối hiển thị trạng thái chưa có dữ liệu với icon minh họa và nút CTA. |
| 26 | `lib/core/widgets/progress_ring.dart` | Vòng tròn tiến độ ngân sách / mục tiêu tiết kiệm. |
| 27 | `lib/core/widgets/premium_badge.dart` | Huy hiệu "PRO" tinh tế cho các tính năng cao cấp. |
| 28 | `lib/core/widgets/app_bottom_sheet.dart` | Khung bottom sheet chuẩn bo góc trên 24pt kèm drag handle. |
| 29 | `lib/core/widgets/confirm_dialog.dart` | Dialog xác nhận thao tác quan trọng với nút Hủy và Đồng ý rõ ràng. |
| 30 | `test/core/routes/onboarding_middleware_test.dart` | Unit test T04-1: OnboardingMiddleware redirect chính xác theo trạng thái onboarding. |
| 31 | `test/features/root/pages/root_shell_page_test.dart` | Widget test T04-2: Chuyển tab qua IndexedStack giữ nguyên trạng thái từng tab. |
| 32 | `test/core/widgets/amount_keypad_test.dart` | Widget test T04-3: AmountKeypad gõ số ATM/POS, xóa đơn, giữ xóa toàn bộ, giới hạn tối đa. |
| 33 | `test/core/widgets/amount_text_test.dart` | Widget test T04-4: AmountText format tabular figures và đổi màu chuẩn theo BudgetStatus. |
| 34 | `test/core/widgets/goldens/common_widgets_golden_test.dart` | Golden test T04-5: Chụp visual regression cho các component chính ở Light và Dark mode. |
| 35 | `test/core/services/deep_link_service_test.dart` | Unit test DoD: DeepLinkService phân tích URI `safetospend://quick-add` và kích hoạt luồng mở Quick Add. |
| 36 | `test/core/theme/app_theme_test.dart` | Unit test kiểm chứng theme tokens, typography, độ tương phản và semantics tap target $\ge 44\text{pt}$. |

---

### 2. Chốt Danh sách Route trong `AppRoutes` và `GetPage` + Binding

#### A. Định nghĩa Route (`lib/core/routes/app_routes.dart`)
```dart
abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingIncome = '/onboarding/income';
  static const String onboardingBills = '/onboarding/bills';
  static const String onboardingResult = '/onboarding/result';
  static const String root = '/root';
  static const String settings = '/settings';
  static const String paywall = '/paywall';
  static const String expenseEdit = '/expense/edit';
}
```
*Ghi chú:* Quick Add **không** phải là route độc lập; Quick Add được mở qua `Get.bottomSheet` bằng `QuickAddLauncher.open()` theo đúng quy ước `000-conventions.md` mục B3.

#### B. Cấu hình Bảng Điều hướng (`lib/core/routes/app_pages.dart`)
```dart
abstract class AppPages {
  AppPages._();

  static const String initial = AppRoutes.root;

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: () => const SplashPagePlaceholder(),
      binding: SplashBindingPlaceholder(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboardingWelcome,
      page: () => const OnboardingWelcomePlaceholder(),
      binding: OnboardingWelcomeBindingPlaceholder(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboardingIncome,
      page: () => const OnboardingIncomePlaceholder(),
      binding: OnboardingIncomeBindingPlaceholder(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboardingBills,
      page: () => const OnboardingBillsPlaceholder(),
      binding: OnboardingBillsBindingPlaceholder(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboardingResult,
      page: () => const OnboardingResultPlaceholder(),
      binding: OnboardingResultBindingPlaceholder(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.root,
      page: () => const RootShellPage(),
      binding: RootShellBinding(),
      middlewares: [
        OnboardingMiddleware(profileRepo: Get.find<IProfileRepository>()),
      ],
    ),
    GetPage<dynamic>(
      name: AppRoutes.settings,
      page: () => const SettingsPlaceholder(),
      binding: SettingsBindingPlaceholder(),
      middlewares: [
        OnboardingMiddleware(profileRepo: Get.find<IProfileRepository>()),
      ],
    ),
    GetPage<dynamic>(
      name: AppRoutes.paywall,
      page: () => const PaywallPlaceholder(),
      binding: PaywallBindingPlaceholder(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.expenseEdit,
      page: () => const ExpenseEditPlaceholder(),
      binding: ExpenseEditBindingPlaceholder(),
      middlewares: [
        OnboardingMiddleware(profileRepo: Get.find<IProfileRepository>()),
      ],
    ),
  ];
}
```

---

### 3. Chốt `OnboardingMiddleware`

`OnboardingMiddleware` kế thừa `GetMiddleware`, nhận `IProfileRepository` qua constructor để đảm bảo khả năng unit test độc lập không phụ thuộc service locator:

```dart
class OnboardingMiddleware extends GetMiddleware {
  OnboardingMiddleware({
    required this.profileRepo,
    this.hasCompletedOnboardingOverride,
  });

  final IProfileRepository profileRepo;
  final bool? hasCompletedOnboardingOverride;

  @override
  RouteSettings? redirect(String? route) {
    // 1. Ngoại lệ: Cho phép truy cập Splash và toàn bộ chuỗi Onboarding
    if (route == null ||
        route == AppRoutes.splash ||
        route.startsWith('/onboarding/')) {
      return null;
    }

    // 2. Xác định trạng thái onboarding
    final bool completed = hasCompletedOnboardingOverride ??
        profileRepo.hasCompletedOnboardingSync();

    // 3. Nếu chưa hoàn thành onboarding: chuyển hướng về Welcome
    if (!completed) {
      return const RouteSettings(name: AppRoutes.onboardingWelcome);
    }

    // 4. Đã onboarding: cho phép tiếp tục truy cập route đích
    return null;
  }
}
```
*Ghi chú kỹ thuật:* Bổ sung getter / method đồng bộ `hasCompletedOnboardingSync()` vào `IProfileRepository` (được đồng bộ hóa tức thì từ cache in-memory của `ProfileRepository` khi app bootstrap hoặc khi lưu profile) để `redirect` xử lý đồng bộ mượt mà không gây giật nháy frame.

---

### 4. Chốt `RootShellController` & `RootShellBinding`

#### A. Controller (`RootShellController`)
```dart
class RootShellController extends GetxController {
  final RxInt tabIndex = 0.obs;

  void changeTab(int index) {
    if (index >= 0 && index <= 2) {
      tabIndex.value = index;
    }
  }
}
```

#### B. Binding (`RootShellBinding`)
Đăng ký `RootShellController` cùng với `lazyPut` cho controller của 3 tab:
```dart
class RootShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootShellController>(() => RootShellController());
    Get.lazyPut<TodayControllerPlaceholder>(() => TodayControllerPlaceholder());
    Get.lazyPut<HistoryControllerPlaceholder>(() => HistoryControllerPlaceholder());
    Get.lazyPut<PlanControllerPlaceholder>(() => PlanControllerPlaceholder());
  }
}
```

#### C. Giao diện Shell (`RootShellPage`)
- Sử dụng `IndexedStack` để giữ nguyên state của cả 3 tab:
  1. Tab 0: **Today** (`TodayPagePlaceholder` — sẽ thay bằng màn Today thật ở Spec 011).
  2. Tab 1: **History** (`HistoryPagePlaceholder` — sẽ thay bằng màn History thật ở Spec 013).
  3. Tab 2: **Plan** (`PlanPagePlaceholder` — quản lý Bills, Income, Goal ở Spec 014, 015, 016).
- Thanh điều hướng Material 3 `NavigationBar` với semantics label rõ ràng, icon trực quan và vùng chạm $\ge 48\times 48\text{pt}$.

---

### 5. Chốt `DeepLinkService` (`app_links`) cho `safetospend://quick-add`

#### A. Contract (`lib/domain/services/i_deep_link_service.dart`)
```dart
abstract class IDeepLinkService {
  Stream<Uri> get uriStream;
  Future<void> init();
  void handleUri(Uri uri);
}
```

#### B. Implementation (`lib/data/services/deep_link_service.dart`)
- Sử dụng package `app_links: ^6.3.2`.
- Kiểm tra scheme và host/path:
  - Scheme: `safetospend`
  - Host/Path: `quick-add` (khớp với URI `safetospend://quick-add`).
- Khi phát hiện deep link:
  - Nếu người dùng chưa onboarding: bỏ qua hoặc mở sau khi hoàn tất onboarding.
  - Nếu đã onboarding: gọi launcher mở bottom sheet Quick Add. Trong Spec 005, hiển thị bottom sheet placeholder (hoặc callback event); ở Spec 012 sẽ kết nối trực tiếp vào `QuickAddLauncher.open(source: 'deep_link')`.
- Đăng ký `permanent: true` trong `InitialBinding`.
- Hỗ trợ injection stream trong constructor để dễ dàng unit test mà không cần native channels.

---

### 6. Chốt Design System Tokens & API Component Dùng Chung (Mục C3)

#### A. Design System Tokens (`lib/core/theme/`)
- **Màu sắc (`AppColors`):**
  - Brand/Primary: `#2E9E6A` (Light) / `#4CC38A` (Dark).
  - Trạng thái `onTrack`: `#2E9E6A` (Light) / `#4CC38A` (Dark).
  - Trạng thái `caution`: `#D98E04` (Light) / `#F2B544` (Dark) (khi còn < 20% hạn mức ngày).
  - Trạng thái `over`: `#C8553D` (Light) / `#E07A5F` (Dark) — cam đất, dịu mắt, tránh đỏ chói gay gắt.
  - Surface & Background: Tuân thủ chuẩn Material 3.
- **Khoảng cách & Bo góc (`AppSpacing`):**
  - Spacing: `xs: 4`, `s: 8`, `m: 12`, `l: 16`, `xl: 24`, `xxl: 32`, `xxxl: 48`.
  - Bo góc (Radii): Card `20pt`, Button `14pt`, Chip `999pt` (pill).
  - Vùng chạm tối thiểu: `minTouchTarget = 44pt` (các nút bấm mặc định cao 48pt).
- **Typography (`AppTextStyles`):**
  - Con số chính: `display` 56–64sp, weight 700, bắt buộc bật `fontFeatures: [FontFeature.tabularFigures()]` để số không bị nhảy layout khi đếm.
  - Văn bản: `title` 22sp (w600), `body` 16sp (w400), `label` 14sp (w500), `caption` 12sp (w400).

#### B. Component `AmountKeypad` (`lib/core/widgets/amount_keypad.dart`)
- **Bố cục phím:** Lưới 3x4 tiêu chuẩn:
  - Hàng 1: `[1]` `[2]` `[3]`
  - Hàng 2: `[4]` `[5]` `[6]`
  - Hàng 3: `[7]` `[8]` `[9]`
  - Hàng 4: `[00]` `[0]` `[⌫]` (Nút xóa)
- **Cơ chế hoạt động:**
  - Nhập theo mô hình ATM/POS:
    - Bắt đầu: `0` cents ($0.00).
    - Nhập "1" $\rightarrow$ `1` cent ($0.01).
    - Nhập "2" $\rightarrow$ `12` cents ($0.12).
    - Nhập "5" $\rightarrow$ `125` cents ($1.25).
    - Nhập "0" $\rightarrow$ `1250` cents ($12.50).
    - Chạm nút xóa `⌫`: Bỏ chữ số cuối (`cents ~/ 10`) $\rightarrow$ `125` cents ($1.25).
    - Nhấn giữ nút xóa `⌫` (long-press): Xóa trắng về `0` cents ($0.00).
    - Giới hạn trần: Tối đa `99,999,999` cents ($999,999.99) để ngăn chặn tràn số nguyên và lỗi giao diện.
  - Phản hồi xúc giác: Kích hoạt `HapticFeedback.lightImpact()` ở mỗi lần chạm phím.
  - Hỗ trợ Accessibility: Mọi phím đều bọc `Semantics(label: ..., button: true)`.

#### C. Component `AmountText` (`lib/core/widgets/amount_text.dart`)
- **API:**
  ```dart
  class AmountText extends StatelessWidget {
    const AmountText({
      required this.amount,
      super.key,
      this.status,
      this.style,
      this.showSign = false,
    });

    final Money amount;
    final BudgetStatus? status;
    final TextStyle? style;
    final bool showSign;
  }
  ```
- **Hành vi đổi màu thông minh:**
  - Nếu có truyền `status`:
    - `BudgetStatus.great` / `BudgetStatus.good` $\rightarrow$ `AppColors.onTrack`
    - `BudgetStatus.warning` $\rightarrow$ `AppColors.caution`
    - `BudgetStatus.over` $\rightarrow$ `AppColors.over`
  - Nếu `status == null`: tự động dùng `AppColors.over` nếu `amount.isNegative`, ngược lại dùng màu chữ mặc định của theme.
  - Luôn áp dụng font feature `tabular figures` và format chuẩn tiền tệ theo currency code.

#### D. Các Component Dùng Chung Khác
- `AppScaffold`: Bọc chuẩn SafeArea, nền theme và padding an toàn.
- `PrimaryButton`: Nút chính nổi bật, bo góc 14pt, cao $\ge 48\text{pt}$, tích hợp spinner khi đang loading.
- `SecondaryButton`: Nút phụ viền hoặc nền nhẹ, phản hồi tương tác mượt mà.
- `CategoryChip`: Chip danh mục dạng pill (bo góc 999pt) với icon và màu định danh.
- `SectionCard`: Card phân nhóm nội dung, bo góc 20pt, viền border mờ.
- `EmptyState`: Minh họa trạng thái rỗng kèm nút hành động tiếp theo.
- `ProgressRing`: Vòng tròn tiến độ với nét vẽ bo tròn và màu sắc theo trạng thái ngân sách.
- `PremiumBadge`: Huy hiệu "PRO" nhỏ gọn đánh dấu các tính năng nâng cao.
- `AppBottomSheet`: Khung modal chuẩn với thanh kéo (drag handle), tự động co giãn theo bàn phím.
- `ConfirmDialog`: Hộp thoại xác nhận cảnh báo an toàn.

---

### 7. Ánh xạ Test Cases Spec 005 → File Test

| Mã Test Case | Nội dung kiểm thử | File Test đích |
|---|---|---|
| **T04-1** | `OnboardingMiddleware.redirect` trả đúng route khi chưa/đã onboarding | `test/core/routes/onboarding_middleware_test.dart` |
| **T04-2** | Chuyển tab trong `RootShellPage` giữ nguyên trạng thái từng tab qua `IndexedStack` | `test/features/root/pages/root_shell_page_test.dart` |
| **T04-3** | `AmountKeypad` nhập "1","2","5","0" $\rightarrow$ `$12.50`; xóa $\rightarrow$ `$1.25`; giữ xóa $\rightarrow$ `$0.00`; haptic; trần cents | `test/core/widgets/amount_keypad_test.dart` |
| **T04-4** | `AmountText` tabular figures và tự động đổi màu theo `BudgetStatus` (onTrack, caution, over) | `test/core/widgets/amount_text_test.dart` |
| **T04-5** | Golden visual regression cho các component chính ở Light và Dark mode | `test/core/widgets/goldens/common_widgets_golden_test.dart` |
| **DoD Deep Link** | `DeepLinkService` bắt đúng URI `safetospend://quick-add` | `test/core/services/deep_link_service_test.dart` |
| **Theme & Tokens** | Kiểm tra tương thích màu sắc, typography và tap target $\ge 44\text{pt}$ | `test/core/theme/app_theme_test.dart` |

---

### 8. Rủi ro Kỹ thuật & Giải pháp Phòng ngừa

1. **Rủi ro môi trường Test khi gọi `app_links`:**
   - *Phân tích:* Package `app_links` phụ thuộc vào native platform channels (iOS/Android) nên khi chạy `flutter test` có thể gặp lỗi `MissingPluginException`.
   - *Giải pháp:* Thiết kế `DeepLinkService` hỗ trợ constructor injection cho `AppLinks` hoặc cho phép truyền một stream URI giả lập (`Stream<Uri>`), giúp unit test chạy 100% trên JVM/Dart VM mà không cần native channels.
2. **Rủi ro font rendering trong Golden Test giữa các nền tảng (macOS vs CI Linux):**
   - *Phân tích:* Hệ điều hành khác nhau có engine rasterize font chữ khác nhau, dễ gây lệch pixel trong golden tests.
   - *Giải pháp:* Nạp font chữ tiêu chuẩn (Ahem / Roboto) trong test setup và cấu hình dung sai pixel nhỏ thích hợp cho golden tests.
3. **Trải nghiệm gõ tiền tệ trên `AmountKeypad`:**
   - *Phân tích:* Người dùng có thể nhấn giữ phím backspace hoặc gõ nhanh nhiều số 0 gây tràn số.
   - *Giải pháp:* Kẹp chặn toán học nghiêm ngặt: `if (newCents <= 99999999) currentCents = newCents;` và debounce thao tác long-press để đảm bảo an toàn tuyệt đối.
4. **Không có câu hỏi chặn việc (No blocking questions):**
   - Toàn bộ thiết kế route, shell, middleware, component API và design tokens đã được định hình rõ ràng, sẵn sàng 100% để bước sang giai đoạn **DEFINE TEST** của Spec 005.

---

---

## Review & Verify Report

### 1. Số liệu Kiểm thử Thực tế (Automated Quality Suite)
- **Tổng số test pass / tổng số test:** **145 / 145 PASS (0 failed, 100% pass)**
  - Flutter app tests (`flutter test`): **70 / 70 PASS**
  - Budget engine tests (`cd packages/budget_engine && dart test`): **75 / 75 PASS**
- **Số issue từ `flutter analyze` & `dart analyze`:** **0 issues** across all packages (`daily_safe_to_spend` + `budget_engine`).
- **Kiểm tra cấm dùng `double` cho tiền (`make check-money`):** **0 vi phạm** (No 'double' used for monetary values).
- **Kiểm tra định dạng (`make format`):** **132 files formatted cleanly** (0 changed files, exit code 0).

### 2. Trạng thái Checklist Definition of Done (DoD)
- [x] **Deep link `safetospend://quick-add` mở Quick Add:**
  - Hỗ trợ đầy đủ cả cold start (`AppLinks.getInitialLink()`) và luồng stream khi app đang chạy (`AppLinks.uriLinkStream`).
  - Cơ chế debounce 1.500ms chống trùng lặp sự kiện mở modal nếu hệ điều hành broadcast nhiều lần.
  - Đăng ký URL scheme cấp hệ điều hành: `CFBundleURLTypes` trong `ios/Runner/Info.plist` và `intent-filter` trong `android/app/src/main/AndroidManifest.xml`.
  - Khai báo `unknownRoute: AppPages.unknownRoute` giúp GetX định tuyến an toàn, ngăn chặn hoàn toàn exception `Null check operator used on a null value`.
- [x] **Toàn bộ component có Semantics label & tuân thủ Design System:**
  - Tất cả 12/12 component mục C3 (`AmountKeypad`, `AmountText`, `PrimaryButton`, `SecondaryButton`, `CategoryChip`, `SectionCard`, `EmptyState`, `ProgressRing`, `PremiumBadge`, `AppBottomSheet`, `ConfirmDialog`, `AppScaffold`) đều tích hợp `Semantics(label: ..., button: true)`.
  - Không hardcode màu sắc hay khoảng cách; 100% sử dụng token `AppColors`, `AppSpacing`, `AppTextStyles`.
  - Vùng chạm tối thiểu đạt chuẩn tiếp cận $\ge 44\times 44\text{pt}$ (các nút và phím bấm cao 48pt).
  - Phản hồi xúc giác `HapticFeedback.lightImpact()` kích hoạt mượt mà trên bàn phím `AmountKeypad`.
  - Giữ phím xóa trên `AmountKeypad` kích hoạt timer xóa trắng về 0, timer được hủy an toàn khi dispose.
- [x] **Bảo toàn trạng thái chuyển tab (`RootShellPage`):**
  - Sử dụng `IndexedStack` duy trì state của 3 tab Today, History, Plan khi người dùng chuyển đổi qua lại.
- [x] **Bảo vệ vòng lặp chuyển hướng Onboarding:**
  - `OnboardingMiddleware` bỏ qua route splash và toàn bộ chuỗi `/onboarding/*`, chỉ chuyển hướng về `/onboarding/welcome` khi truy cập các route được bảo vệ mà chưa hoàn tất onboarding.
- [x] **Quản lý tài nguyên & Vòng đời (No Resource Leaks):**
  - Mọi Timer, StreamSubscription trong `AmountKeypad`, `DeepLinkService`, `BudgetSnapshotService` đều được `cancel()` đầy đủ trong `dispose()` và `onClose()`.

### 3. Kết quả Kiểm thử Thực tế trên Thiết bị (Simulators & Emulators)
- **iOS Simulator (iPhone 16 Pro · iOS 18.5):**
  - Lệnh: `flutter run -d 1C342DC4-8E9E-4C3D-99AB-7ADEAEA1F0FA`
  - Kết quả: Build thành công (18.4s), giao diện khởi động chuẩn xác tại `/onboarding/welcome`.
  - Deep link: `xcrun simctl openurl 1C342DC4-8E9E-4C3D-99AB-7ADEAEA1F0FA "safetospend://quick-add?source=widget"` → Hoạt động trơn tru (exit code 0).
  - Ảnh chụp màn hình: [ios_simulator_spec005.png](file:///Users/abc/.gemini/antigravity-ide/brain/a0c29bf6-f74f-425e-bdce-6808f94069cc/ios_simulator_spec005.png).
- **Android Emulator (Medium Phone · sdk gphone64 arm64):**
  - Lệnh: `flutter run -d emulator-5554 --flavor dev`
  - Kết quả: Build Gradle và khởi chạy app thành công trên thiết bị ảo.
  - Deep link: `adb shell am start -a android.intent.action.VIEW -d "safetospend://quick-add?source=widget" org.aveglobal.safetospend.dev` → Intent được tiếp nhận và xử lý mượt mà, không gặp exception.
  - Ảnh chụp màn hình: [android_emulator_spec005.png](file:///Users/abc/.gemini/antigravity-ide/brain/a0c29bf6-f74f-425e-bdce-6808f94069cc/android_emulator_spec005.png).

### 4. Lỗi Phát hiện & Đã khắc phục (@silent-failure-hunter & /review-code)
1. **Thiếu khai báo URL Scheme cấp hệ điều hành (Silent Failure):**
   - *Vấn đề:* Ban đầu `CFBundleURLTypes` chưa có trong `Info.plist` và `intent-filter` chưa có trong `AndroidManifest.xml`, khiến iOS Simulator từ chối mở URI `safetospend://quick-add` với lỗi `OSStatus error -10814`.
   - *Khắc phục:* Bổ sung cấu hình URL scheme `safetospend` cho cả iOS (`Info.plist`) và Android (`AndroidManifest.xml`).
2. **Lỗi Null check crash trong GetX Router khi nhận Intent từ Android (Critical Bug):**
   - *Vấn đề:* Khi Android chuyển giao intent deep link vào Flutter thông qua `WidgetsBindingObserver.didPushRouteInformation`, GetX không tìm thấy route tương ứng trong `getPages`. Do `unknownRoute` mặc định là null, biểu thức `(unknownRoute)!` trong `route_middleware.dart:200` văng `_TypeError: Null check operator used on a null value`.
   - *Khắc phục:* Khai báo `unknownRoute: AppPages.unknownRoute` trong `AppPages` và gắn vào `GetMaterialApp`, bọc qua `OnboardingMiddleware` để route fallback an toàn về `RootShellPage` hoặc `/onboarding/welcome`.
3. **DeepLinkService không tự kích hoạt lắng nghe khi app khởi động:**
   - *Vấn đề:* `DeepLinkService` được inject vào `InitialBinding` nhưng không override `onInit()`, dẫn tới method `init()` chưa được gọi tự động.
   - *Khắc phục:* Bổ sung `onInit()` gọi `unawaited(init())` và thêm cờ `_initialized` để đảm bảo khởi tạo idempotent an toàn tuyệt đối.
4. **Leak Guard cho Timer trên AmountKeypad:**
   - *Vấn đề:* Timer giữ để xóa có nguy cơ tiếp tục tick nếu widget bị unmount trong khi đang nhấn giữ.
   - *Khắc phục:* Bổ sung `_clearTimer?.cancel(); _clearTimer = null;` trong `dispose()` và kiểm tra `if (!mounted) return;` trước khi gọi callback.
