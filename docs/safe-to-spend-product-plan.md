# Daily Safe-to-Spend — Phân tích sản phẩm, MVP & Lộ trình

> **Định vị:** "Con số chi tiêu an toàn mỗi ngày, cho cả người có thu nhập không đều. Ghi chi tiêu bằng 1 chạm, không cần đăng nhập ngân hàng."
>
> **Thị trường:** B2C, US / UK / EU · **Mô hình thu phí:** Freemium (Ads + Subscription) · **Kiến trúc:** Local-first (server chỉ triển khai từ Giai đoạn 3)

---

## Mục lục

1. [Kết luận nhanh](#1-kết-luận-nhanh)
2. [Bức tranh đối thủ](#2-bức-tranh-đối-thủ)
3. [Định vị & khác biệt](#3-định-vị--khác-biệt)
4. [Engine tính toán (lõi sản phẩm)](#4-engine-tính-toán-lõi-sản-phẩm)
5. [Bản đồ tính năng tổng thể](#5-bản-đồ-tính-năng-tổng-thể)
6. [Monetization: Ads + Subscription](#6-monetization-ads--subscription)
7. [Kiến trúc kỹ thuật local-first](#7-kiến-trúc-kỹ-thuật-local-first)
8. [Phạm vi MVP (v1.0)](#8-phạm-vi-mvp-v10)
9. [Lộ trình các giai đoạn](#9-lộ-trình-các-giai-đoạn)
10. [KPI theo giai đoạn](#10-kpi-theo-giai-đoạn)
11. [Khả năng mở rộng](#11-khả-năng-mở-rộng)
12. [Rủi ro & cách giảm thiểu](#12-rủi-ro--cách-giảm-thiểu)
13. [Nguồn tham khảo](#13-nguồn-tham-khảo)

---

## 1. Kết luận nhanh

- **Nhu cầu có thật**, nhưng ý tưởng **không mới**: năm 2026 có rất nhiều app indie gần như giống hệt nhau (DaySpend, DaySum, Depo, SafeToSpend, Spendaily, Neverbroke, Daily Wallet…). Phần lớn rất mới và gần như chưa có review, nên **chưa ai thực sự chiếm được ngách**.
- Sẽ không thắng nhờ ý tưởng, mà nhờ **2–3 điểm khác biệt sắc nét + trải nghiệm tốt hơn + ASO tốt hơn**.
- **Không cần kết nối ngân hàng** vừa là lựa chọn kỹ thuật (tránh chi phí và thủ tục open banking) vừa là điểm định vị về quyền riêng tư, đặc biệt ở EU.
- **Local-first** giúp chi phí vận hành gần bằng 0 ở giai đoạn đầu, và củng cố thông điệp "dữ liệu nằm trên máy bạn".

---

## 2. Bức tranh đối thủ

### 2.1. Nhóm lớn, có kết nối ngân hàng

| App | Điểm mạnh | Điểm yếu (khe hở) |
|---|---|---|
| **PocketGuard** | Tính năng "In My Pocket" (safe-to-spend), thương hiệu mạnh | Plus $12.99/tháng hoặc $74.99/năm; bản free chỉ cho 2 tài khoản kết nối |
| **YNAB** | Zero-based budgeting, cộng đồng trung thành | $14.99/tháng hoặc $109/năm, phức tạp, mất thời gian học |
| **Monarch / Copilot** | Đẹp, đầy đủ, hợp cặp đôi | ~$95–100/năm, không có bản free |

→ **Khe hở:** một app **rẻ hơn, đơn giản hơn, không cần đăng nhập ngân hàng**.

### 2.2. Nhóm indie nhập tay (đối thủ trực tiếp)

DaySpend, DaySum, Depo, SafeToSpend, Spendaily, Neverbroke, Daily Wallet Limiter, Daily Budget Original (lâu đời nhất, hơn 10 năm)… Hầu hết có cùng pitch: một con số mỗi ngày, không kết nối ngân hàng, có widget.

### 2.3. Khe hở rút ra từ review thật

| Phàn nàn của người dùng | Cơ hội |
|---|---|
| App chỉ hợp người lương cố định; thu nhập thay đổi mỗi kỳ thì chia theo ngày bị sai | **Chế độ thu nhập không đều** (gig worker, freelancer) |
| Không sửa được giao dịch cũ, không thêm giao dịch cho ngày đã qua | **Ghi lùi ngày, sửa giao dịch** ngay từ MVP |
| Muốn app tự trừ dần vào hạn mức cho đến khi đủ tiền mục tiêu | **Mục tiêu tiết kiệm trừ vào daily** |
| "UI đẹp nhưng có quảng cáo nên không thích" | **Quảng cáo đặt rất khéo**, không chạm luồng chính |

### 2.4. Open banking: không làm ở MVP

- GoCardless Bank Account Data (ex-Nordigen) đã **ngừng nhận khách hàng mới**.
- Plaid: sandbox miễn phí; production ở EU/UK phải qua sales, tính phí theo kết nối.
- → Kết nối ngân hàng chỉ cân nhắc ở **Giai đoạn 4**, như một gói Pro+ giá cao hơn.

---

## 3. Định vị & khác biệt

### 3.1. Đối tượng

- **Chính:** Gen Z và millennials ở US/UK sống theo từng kỳ lương.
- **Ngách mạnh:** gig worker (Uber, DoorDash, Upwork), freelancer có thu nhập không đều.
- **Phụ:** sinh viên, người đi du lịch cần ngân sách theo ngày.

### 3.2. Ba điểm khác biệt cốt lõi

1. **Chu kỳ theo kỳ lương**, không theo tháng dương lịch: hằng tuần, 2 tuần (biweekly, rất phổ biến ở US), nửa tháng, hằng tháng, và **chế độ thu nhập không đều**.
2. **Ghi chi tiêu gần như không ma sát:** widget tương tác có nút "+", và (Giai đoạn 2) **tự ghi khi thanh toán Apple Pay** qua Shortcuts automation (trigger "Transaction", iOS 17+) kết hợp App Intents. Trải nghiệm "bán tự động" mà không cần ngân hàng.
3. **Tiền dư và tiền vượt minh bạch:** người dùng chọn cách xử lý phần dư/vượt và thấy ngay con số ngày mai thay đổi thế nào. Không phán xét khi tiêu vượt.

### 3.3. Thông điệp ASO gợi ý

- Tiêu đề: `Daily Budget: Safe to Spend`
- Phụ đề: `Paycheck budget, no bank login`
- Từ khóa: daily budget, safe to spend, paycheck budget, spending limit, allowance, budget widget, gig income budget

---

## 4. Engine tính toán (lõi sản phẩm)

Engine là thứ quyết định chất lượng app. Viết bằng **Dart thuần**, tách biệt UI, có unit test đầy đủ.

### 4.1. Công thức cơ bản (thu nhập cố định)

```
Pool kỳ này   = Thu nhập kỳ (hoặc số dư hiện có khi bắt đầu kỳ)
              − Hóa đơn cố định đến hạn trước kỳ lương tiếp theo
              − Tiền để dành cho mục tiêu (goals) trong kỳ
              − Buffer an toàn (tùy chọn, ví dụ 5%)

Safe hôm nay  = (Pool − Đã tiêu từ đầu kỳ đến hết hôm qua) / Số ngày còn lại trong kỳ (tính cả hôm nay)
              − Đã tiêu hôm nay
```

### 4.2. Chế độ xử lý tiền dư (Rollover)

| Chế độ | Hành vi | Gói |
|---|---|---|
| **Spread** (mặc định) | Phần dư chia đều cho các ngày còn lại | Free |
| **Tomorrow boost** | Dồn toàn bộ phần dư sang ngày mai | Premium |
| **Save it** | Chuyển phần dư vào mục tiêu tiết kiệm | Premium |

**Tiêu vượt:** luôn trừ dần vào các ngày còn lại; hiển thị rõ ràng ("Ngày mai: $18 thay vì $25"), không dùng ngôn ngữ phán xét.

### 4.3. Chế độ thu nhập không đều

- Người dùng nhập thu nhập **khi tiền về**.
- Hạn mức = (Số dư thực tế − Hóa đơn sắp đến hạn trong cửa sổ − Buffer) / **Số ngày đến "mốc an toàn"** do người dùng đặt (mặc định 14 ngày).
- Buffer mặc định cao hơn (10%) để tránh "những ngày thừa tiền giả" ngay sau khi nhận tiền.
- Premium: dự báo dựa trên thu nhập trung bình 4–8 tuần gần nhất.

### 4.4. Các trường hợp biên bắt buộc có test

- Tháng 28/29/30/31 ngày; kỳ lương nửa tháng (15 & cuối tháng).
- Ngày trả lương rơi vào cuối tuần/ngày lễ (tùy chọn dời sớm).
- Hóa đơn đến hạn đúng ngày đầu/cuối kỳ.
- Tiêu vượt lớn hơn toàn bộ pool còn lại (safe âm).
- Ghi lùi/sửa/xóa giao dịch của ngày đã qua → tính lại toàn bộ.
- Đổi múi giờ (du lịch), đổi giờ mùa hè (DST).
- Thay đổi cấu hình kỳ lương giữa chừng.

> **Nguyên tắc:** engine là **hàm thuần** — nhận vào (cấu hình, giao dịch, hóa đơn, ngày hiện tại) và trả ra kết quả. Không lưu "số dư đã tính" vào DB; luôn tính lại từ dữ liệu gốc. Điều này giúp sửa lùi dữ liệu không bao giờ làm sai con số, và giúp đồng bộ server sau này đơn giản hơn.

---

## 5. Bản đồ tính năng tổng thể

| Module | Tính năng | Free | Premium | Giai đoạn |
|---|---|:-:|:-:|:-:|
| **Onboarding** | Thiết lập 60 giây: thu nhập, kỳ lương, hóa đơn chính → thấy con số ngay | ✔ | | 1 |
| **Engine** | Safe-to-spend theo ngày / tuần / kỳ | ✔ | | 1 |
| | Rollover: Tomorrow boost, Save it | | ✔ | 1 |
| | Thu nhập không đều (cơ bản) | ✔ | | 1 |
| | Thu nhập không đều: dự báo theo trung bình | | ✔ | 2 |
| **Ghi chi tiêu** | Bàn phím số 1 chạm, danh mục nhanh, ghi lùi ngày, sửa/xóa | ✔ | | 1 |
| | Tự ghi qua Apple Pay (Shortcuts), Siri, Action Button | | ✔ | 2 |
| **Hóa đơn** | Hóa đơn định kỳ không giới hạn, nhắc trước hạn | ✔ | | 1 |
| **Widget** | 1 widget Home Screen có nút "+" | ✔ | | 1 |
| | Lock Screen widget, nhiều kiểu, theme | | ✔ | 1 |
| | Apple Watch complication / app | | ✔ | 2 |
| **Mục tiêu** | 1 mục tiêu tiết kiệm | ✔ | | 1 |
| | Không giới hạn mục tiêu | | ✔ | 2 |
| **Insights** | Lịch sử theo ngày | ✔ | | 1 |
| | Recap tuần, xu hướng danh mục, dự báo cuối kỳ | | ✔ | 2 |
| **Dữ liệu** | Lưu cục bộ, sao lưu/khôi phục bằng file | ✔ | | 1 |
| | Xuất CSV | | ✔ | 1 |
| | Đồng bộ đa thiết bị (qua server) | | ✔ | 3 |
| **Mở rộng** | Ngân sách chung cho cặp đôi (shared) | | ✔ | 3 |
| | Travel mode đa tiền tệ, nhiều "pocket" | | ✔ | 3 |
| | Kết nối ngân hàng (Pro+) | | Pro+ | 4 |

**Nguyên tắc chia Free/Premium:** những gì **tạo ra retention** (con số mỗi ngày, ghi nhanh, 1 widget, hóa đơn) thì **miễn phí**. Premium bán **sự tiện lợi và kiểm soát**.

---

## 6. Monetization: Ads + Subscription

### 6.1. Quảng cáo (AdMob)

| Vị trí | Định dạng | Quy tắc |
|---|---|---|
| Màn **Today** | — | **Không có quảng cáo** |
| Luồng **ghi chi tiêu** | — | **Không có quảng cáo** |
| History / Insights | Banner | Cố định cuối màn |
| Mở Insights tuần / thử theme 24h | Rewarded | Người dùng chủ động chọn |
| Khi rời màn phụ | Interstitial | Tối đa **1 lần/ngày**, không hiển thị trong 3 ngày đầu |

- Người dùng Premium: không có quảng cáo.
- Theo dõi sát rating; nếu review nhắc đến quảng cáo tăng, giảm tần suất ngay.

### 6.2. Subscription (RevenueCat)

| Gói | US | EU/UK (gợi ý) |
|---|---|---|
| Tháng | $3.99 | €4.49 / £3.99 |
| **Năm (ưu tiên)** | **$24.99** | **€29.99 / £24.99** |
| Trial | 7 ngày cho gói năm | 7 ngày |

- **Tránh gói tuần**: không hợp sản phẩm dùng lâu dài và dễ làm mất lòng tin trong app tài chính.
- Paywall hiển thị: sau onboarding (soft, có thể bỏ qua), khi chạm tính năng Premium, và sau 7 ngày dùng liên tục.
- Cân nhắc **Lifetime** (~$59.99) ở Giai đoạn 2 để thu từ nhóm ghét subscription.

---

## 7. Kiến trúc kỹ thuật local-first

### 7.1. Nguyên tắc

1. **Toàn bộ dữ liệu nằm trên thiết bị** ở Giai đoạn 1–2. Không có backend, không có tài khoản.
2. App phải **hoạt động 100% offline**.
3. Thiết kế dữ liệu **sẵn sàng đồng bộ** ngay từ đầu, để Giai đoạn 3 chỉ cần thêm lớp sync, không phải migrate lại cấu trúc.
4. Không gửi dữ liệu tài chính đi đâu. Analytics chỉ ghi **sự kiện hành vi** (đã ghi chi tiêu, đã thêm widget), **không ghi số tiền**.

### 7.2. Stack đề xuất

| Lớp | Công nghệ | Ghi chú |
|---|---|---|
| UI | Flutter | iOS + Android |
| State management | Riverpod | Dễ test, tách engine khỏi UI |
| **Database local** | **SQLite qua `drift`** | Typed queries, migration rõ ràng, reactive streams |
| Engine | Dart thuần (package riêng) | Unit test độc lập |
| Widget iOS | Swift — WidgetKit + App Intents | Interactive widget (iOS 17+) |
| Widget Android | Kotlin — Jetpack Glance | Nút "+" mở luồng ghi nhanh |
| Cầu nối widget | `home_widget` + App Group (iOS) / SharedPreferences (Android) | Flutter ghi snapshot, widget đọc |
| Notification | `flutter_local_notifications` | Lịch nhắc cục bộ, không cần server push |
| Subscription | RevenueCat | Không cần backend riêng |
| Ads | Google Mobile Ads (AdMob) + UMP consent | Bắt buộc consent ở EU/UK |
| Analytics | Firebase Analytics hoặc Mixpanel | Chỉ sự kiện, không số tiền |
| Crash | Firebase Crashlytics / Sentry | |
| Sao lưu (Giai đoạn 1) | Xuất/nhập file `.json` mã hóa tùy chọn | Người dùng tự lưu vào Files / Drive |

> **Về widget:** widget không chạy Flutter. Mỗi khi dữ liệu thay đổi, app tính lại và ghi một **snapshot nhỏ** (safe hôm nay, đã tiêu, ngày còn lại, tiền tệ) vào vùng chia sẻ, sau đó yêu cầu widget reload. Nút "+" trên widget mở app vào thẳng màn ghi nhanh (Giai đoạn 1); Giai đoạn 2 có thể ghi số tiền định sẵn trực tiếp qua App Intents.

### 7.3. Data model (sẵn sàng đồng bộ)

Mọi bảng đều có các trường đồng bộ chung:

```
id          TEXT  PRIMARY KEY   -- UUID v4 sinh trên thiết bị (không dùng auto-increment)
created_at  INTEGER             -- epoch ms (UTC)
updated_at  INTEGER             -- epoch ms (UTC), cập nhật mỗi lần sửa
deleted_at  INTEGER NULL        -- soft delete, không xóa cứng
device_id   TEXT                -- thiết bị tạo/sửa gần nhất
```

**Bảng nghiệp vụ:**

```
budget_profile          -- cấu hình ngân sách (MVP: 1 profile; Giai đoạn 3: nhiều / shared)
  currency              TEXT      -- 'USD' | 'EUR' | 'GBP' ...
  income_mode           TEXT      -- 'fixed' | 'irregular'
  pay_frequency         TEXT      -- 'weekly' | 'biweekly' | 'semimonthly' | 'monthly'
  pay_anchor_date       TEXT      -- ngày lương gần nhất (YYYY-MM-DD)
  fixed_income_amount   INTEGER   -- đơn vị nhỏ nhất (cents), NULL nếu irregular
  safety_horizon_days   INTEGER   -- cho irregular, mặc định 14
  buffer_percent        INTEGER   -- 0–20
  rollover_mode         TEXT      -- 'spread' | 'tomorrow' | 'save'
  week_start            INTEGER   -- 0 = CN, 1 = T2
  timezone              TEXT      -- IANA, ví dụ 'America/New_York'

income_entry            -- thu nhập thực nhận (đặc biệt cho irregular)
  profile_id, amount (cents), received_on (YYYY-MM-DD), note

bill                    -- hóa đơn định kỳ
  profile_id, name, amount (cents), recurrence ('weekly'|'monthly'|'yearly'|'custom'),
  due_day / next_due_on, remind_days_before, is_active

transaction             -- chi tiêu
  profile_id, amount (cents), spent_on (YYYY-MM-DD), category_id NULL,
  note NULL, source ('manual'|'widget'|'apple_pay'|'siri'), currency, fx_rate NULL

category
  name, icon, color, sort_order, is_default

goal
  profile_id, name, target_amount (cents), target_date NULL,
  saved_amount_cache (cents, chỉ để hiển thị), is_active

goal_contribution       -- tiền vào mục tiêu (kể cả từ rollover 'save')
  goal_id, amount (cents), on_date, source ('manual'|'rollover')

app_setting             -- key–value: theme, giờ nhắc, đã xem paywall...
```

**Quy ước quan trọng:**

- **Tiền lưu dạng số nguyên (cents)**, không dùng `double`, để tránh sai số làm tròn.
- **Ngày giao dịch lưu dạng ngày địa phương** (`YYYY-MM-DD`) theo `timezone` của profile, tách khỏi timestamp kỹ thuật.
- **Không lưu kết quả tính toán** (safe hôm nay, số dư) làm dữ liệu gốc; chỉ cache để hiển thị/widget.
- Soft delete + `updated_at` → Giai đoạn 3 có thể đồng bộ theo mô hình **last-write-wins theo bản ghi**, đủ cho phần lớn trường hợp.

### 7.4. Lộ trình sang server (Giai đoạn 3)

| Bước | Nội dung |
|---|---|
| 1 | Thêm **tài khoản tùy chọn** (Sign in with Apple / Google). Người dùng không đăng nhập vẫn dùng local như cũ |
| 2 | Backend: **Supabase (Postgres + Auth + Row Level Security)**, hoặc Firebase nếu ưu tiên tốc độ. Server đặt tại **EU region** cho người dùng EU (GDPR) |
| 3 | **Sync engine**: đẩy bản ghi có `updated_at` > mốc đồng bộ cuối; kéo thay đổi từ server; giải quyết xung đột bằng last-write-wins theo bản ghi |
| 4 | **Shared budget**: bảng `profile_member` (profile_id, user_id, role); mọi giao dịch gắn `created_by` |
| 5 | Mã hóa: TLS khi truyền, mã hóa at-rest phía server; cân nhắc end-to-end cho ghi chú |
| 6 | Server push cho nhắc nhở chung (ví dụ partner vừa ghi chi tiêu lớn) |

> Vì dữ liệu đã có UUID, `updated_at`, `deleted_at` ngay từ đầu, việc bật đồng bộ ở Giai đoạn 3 **không cần migrate cấu trúc dữ liệu** của người dùng hiện có.

### 7.5. Quyền riêng tư & tuân thủ

- **App Store Privacy Label:** Giai đoạn 1–2 có thể khai báo dữ liệu tài chính "không thu thập" (chỉ lưu trên thiết bị). Analytics/Ads vẫn phải khai báo đúng.
- **GDPR / UK GDPR:** consent quảng cáo qua Google UMP; chính sách quyền riêng tư nói rõ dữ liệu tài chính chỉ nằm trên máy.
- **Disclaimer:** app là công cụ lập ngân sách, không phải tư vấn tài chính.
- Không có AI tương tác trong MVP nên chưa phát sinh nghĩa vụ minh bạch AI theo EU AI Act; khi thêm tính năng AI (Giai đoạn 4) cần ghi rõ người dùng đang tương tác với AI.

---

## 8. Phạm vi MVP (v1.0)

**Thời gian ước tính:** 6–8 tuần với Flutter (1 dev chính + hỗ trợ design).

### 8.1. Có trong MVP

- [ ] Onboarding 60 giây → hiển thị con số hôm nay ngay
- [ ] Engine theo kỳ lương: hằng tuần, 2 tuần, nửa tháng, hằng tháng
- [ ] Chế độ thu nhập không đều (bản cơ bản)
- [ ] Rollover: Spread (free), Tomorrow boost & Save it (Premium)
- [ ] Ghi chi tiêu 1 chạm, danh mục mặc định, ghi lùi ngày, sửa/xóa
- [ ] Hóa đơn định kỳ + nhắc trước hạn
- [ ] 1 mục tiêu tiết kiệm
- [ ] Màn History theo ngày
- [ ] Widget Home Screen có nút "+" (iOS + Android)
- [ ] Lock Screen widget + theme (Premium)
- [ ] Notification: buổi sáng báo con số hôm nay; buổi tối nhắc nếu chưa ghi
- [ ] Sao lưu / khôi phục bằng file (free); xuất CSV (Premium)
- [ ] Database local SQLite (drift) với schema sẵn sàng đồng bộ
- [ ] Paywall RevenueCat; AdMob + consent UMP theo đúng quy tắc mục 6
- [ ] Analytics funnel: onboarding xong → lần ghi chi tiêu đầu tiên → thêm widget → mở paywall → trial
- [ ] Tiếng Anh; USD / GBP / EUR

### 8.2. Không làm trong MVP

- Backend, tài khoản, đồng bộ đa thiết bị
- Kết nối ngân hàng
- Ngân sách chung (shared)
- Apple Pay auto-log, Siri, Apple Watch
- AI, đa ngôn ngữ, đa tiền tệ trong cùng một profile

### 8.3. Danh sách màn hình MVP

1. **Welcome** (1 màn, giá trị cốt lõi)
2. **Setup:** chế độ thu nhập → kỳ lương & số tiền → hóa đơn chính (có thể bỏ qua) → kết quả "Hôm nay bạn được tiêu $X"
3. **Today:** con số lớn, thanh tiến độ, nút "+" lớn, dự báo ngày mai
4. **Quick Add:** bàn phím số, danh mục, chọn ngày, ghi chú
5. **History:** theo ngày, sửa/xóa
6. **Bills:** danh sách, thêm/sửa
7. **Goal:** 1 mục tiêu, tiến độ
8. **Settings:** kỳ lương, buffer, rollover, nhắc nhở, sao lưu, tiền tệ
9. **Paywall**

### 8.4. Phân bổ thời gian gợi ý

| Tuần | Hạng mục |
|---|---|
| 1 | Data model (drift), engine + unit test |
| 2 | Onboarding, Today, Quick Add |
| 3 | History, Bills, Goal, Settings |
| 4 | Widget iOS (Swift) + Android (Kotlin), cầu nối snapshot |
| 5 | Notification, sao lưu/khôi phục, CSV |
| 6 | RevenueCat, AdMob + UMP, analytics |
| 7 | QA trường hợp biên, polish UI, ASO assets |
| 8 | TestFlight / Internal testing, sửa lỗi, submit |

---

## 9. Lộ trình các giai đoạn

| Giai đoạn | Thời gian | Mục tiêu | Nội dung chính | Server? |
|---|---|---|---|:-:|
| **0. Validate** | 1–2 tuần | Kiểm tra cầu & ASO | Nghiên cứu từ khóa; đọc review 1–3 sao của ~10 đối thủ; landing page đơn giản | Không |
| **1. MVP** | 6–8 tuần | Chứng minh retention | Như mục 8 | Không |
| **2. Retention & Premium** | Tháng 3–4 | Tăng chuyển đổi | Apple Pay auto-log (Shortcuts + App Intents), Siri / Action Button, recap tuần, nhiều mục tiêu, dự báo thu nhập không đều, Apple Watch, chuỗi "no-spend day" nhẹ nhàng (không phạt khi đứt chuỗi), Lifetime plan | Không |
| **3. Mở rộng** | Tháng 5–8 | Tăng tệp người dùng | **Triển khai server** (Supabase, EU region): tài khoản tùy chọn, đồng bộ đa thiết bị, **ngân sách chung cho cặp đôi**, travel mode đa tiền tệ, nhiều "pocket", bản địa hóa DE / FR / ES / NL | **Có** |
| **4. Gói nâng cao** | Sau tháng 9 | Tăng ARPU | Kết nối ngân hàng tùy chọn (US: Plaid / Teller; EU: Enable Banking) làm **Pro+**; Apple FinanceKit nếu đủ điều kiện; quét hóa đơn bằng AI như tính năng phụ | Có |

**Điều kiện đi tiếp giữa các giai đoạn:**

- 0 → 1: từ khóa có volume, top đối thủ trên từ khóa chính có rating/review yếu.
- 1 → 2: đạt KPI retention của Giai đoạn 1 (mục 10).
- 2 → 3: trial → paid ổn định; có tín hiệu người dùng yêu cầu dùng chung / nhiều thiết bị.
- 3 → 4: có ≥ 2.000–3.000 subscriber để bù chi phí API ngân hàng.

---

## 10. KPI theo giai đoạn

| Chỉ số | Giai đoạn 1 | Giai đoạn 2 | Giai đoạn 3 |
|---|---|---|---|
| Hoàn thành onboarding | ≥ 70% | ≥ 75% | ≥ 75% |
| D1 retention | ≥ 35% | ≥ 40% | ≥ 40% |
| D7 retention | ≥ 20% | ≥ 25% | ≥ 25% |
| **D30 retention** | **≥ 10%** | ≥ 14% | ≥ 16% |
| User active ghi chi tiêu ≥ 4 ngày/tuần | ≥ 40% | ≥ 50% | ≥ 50% |
| Tỷ lệ thêm widget | ≥ 25% | ≥ 35% | ≥ 35% |
| Trial → paid | đo baseline | ≥ 8–10% | ≥ 10% |
| Rating trung bình | ≥ 4.5 | ≥ 4.6 | ≥ 4.6 |
| Tỷ lệ user mời partner (shared) | — | — | ≥ 15% user Premium |

---

## 11. Khả năng mở rộng

- **Theo nhóm người dùng:** couples (shared), sinh viên (tiền phụ cấp), gig worker (thu nhập không đều), du lịch. Mỗi nhóm một landing page / Custom Product Page trên App Store, dùng chung một app.
- **Theo nền tảng:** Apple Watch, Wear OS, Live Activity cho những ngày "đi chơi" có ngân sách riêng.
- **Theo danh mục app:** cross-promote với app **"Renewals & Expiry Keeper"** (trial, subscription, bảo hành, hạn giấy tờ). Hai app có chung tệp người dùng quan tâm tài chính cá nhân và có thể chia sẻ engine hóa đơn.
- **Lớp AI sau này:** chỉ thêm khi giải quyết đúng ma sát — chụp hóa đơn để ghi chi tiêu, hay hỏi "tháng này tôi có đủ tiền mua X không?". Không đặt AI làm lõi.

---

## 12. Rủi ro & cách giảm thiểu

| Rủi ro | Mức độ | Cách giảm thiểu |
|---|---|---|
| **Mỏi vì nhập tay** (lý do bỏ app số 1) | Cao | Widget có nút "+", nhắc buổi tối, Apple Pay auto-log (GĐ2), ghi lùi ngày dễ dàng |
| Đối thủ clone nhanh | Cao | Lợi thế dài hạn ở dữ liệu tích lũy, shared budget (GĐ3), thương hiệu & ASO |
| Quảng cáo làm giảm niềm tin | Trung bình | Không quảng cáo ở Today và luồng ghi; giới hạn tần suất; theo dõi review |
| Bug engine làm sai con số | Cao | Engine hàm thuần + unit test trường hợp biên; không lưu kết quả tính làm dữ liệu gốc |
| Mất dữ liệu khi đổi máy (local-only) | Trung bình | Sao lưu/khôi phục file từ MVP; nhắc sao lưu định kỳ; đồng bộ server ở GĐ3 |
| Android thiếu Apple Pay automation | Trung bình | Dựa vào widget + thông báo nhắc; không xin quyền đọc SMS (bị Google Play hạn chế nghiêm ngặt) |
| Chi phí open banking cao | Thấp (đã hoãn) | Chỉ làm ở GĐ4 như gói Pro+ giá cao hơn |

---

## 13. Nguồn tham khảo

- [iLounge – 5 Best Budgeting Apps for iPhone 2026](https://www.ilounge.com/articles/5-best-budgeting-apps-for-iphone-in-2026)
- [The Penny Hoarder – Best Budgeting Apps 2026](https://www.thepennyhoarder.com/budgeting/best-budgeting-apps/)
- [DaySum – App Store](https://apps.apple.com/us/app/daysum-daily-spending-limit/id6778561064)
- [Daily Budget (KVANNLI) – Google Play](https://play.google.com/store/apps/details?id=com.kvannli.simonkvannli.dailybudget&hl=en)
- [Allowance – Google Play](https://play.google.com/store/apps/details?id=com.budget.allowance&hl=en_US)
- [Open Banking Tracker – Best Open Banking APIs for Developers 2026](https://www.openbankingtracker.com/blog/best-open-banking-api-providers-developers-2026)
- [Open Banking Compare – Providers for Developers 2026](https://www.openbankingcompare.com/blog/best-open-banking-api-providers-for-developers-2026)
- [RevenueCat – State of Subscription Apps 2026](https://www.revenuecat.com/state-of-subscription-apps)
- [Adapty – State of In-App Subscriptions 2026](https://adapty.io/state-of-in-app-subscriptions/)
