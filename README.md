# Daily Safe-to-Spend

Ứng dụng quản lý tài chính cá nhân theo phương pháp "Safe-to-Spend", kiến trúc **Flutter (MVC + GetX · Local-first)** kết hợp Dart pure package `packages/budget_engine`.

---

## 1. Yêu cầu môi trường (Prerequisites)

* **Flutter:** `3.44.2` (channel stable)
* **Dart:** `3.12.2`
* **Java:** `17`
* **Android:** minSdk `26` (Android 8.0 Oreo), compileSdk / targetSdk `35`
* **iOS:** Deployment Target min `17.0`, Xcode 15+

---

## 2. Các lệnh Make chuẩn (Mục A2)

```bash
make test       # Chạy toàn bộ test của ứng dụng Flutter và pure engine
make analyze    # Phân tích tĩnh (Flutter analyze + Dart analyze)
make format     # Kiểm tra format code nghiêm ngặt
make gen        # Chạy build_runner sinh mã (drift, freezed khi cần)
make golden     # Cập nhật golden tests UI
make coverage   # Xuất báo cáo độ phủ mã nguồn lcov
```

---

## 3. Chạy ứng dụng theo từng Flavor

### Flavor `dev`:
* **Tên hiển thị:** `Safe to Spend (Dev)`
* **Application ID / Bundle ID:** `org.aveglobal.safetospend.dev`
* **Lệnh chạy:**
  ```bash
  flutter run --flavor dev -t lib/main.dart
  ```

### Flavor `prod`:
* **Tên hiển thị:** `Daily Safe-to-Spend`
* **Application ID / Bundle ID:** `org.aveglobal.safetospend`
* **Lệnh chạy:**
  ```bash
  flutter run --flavor prod -t lib/main.dart
  ```
