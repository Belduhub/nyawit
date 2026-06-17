# Rangkuman Pengembangan Aplikasi Nyawit

## Informasi Aplikasi
- **Nama Aplikasi**: Nyawit (Nyari Duwit)
- **Platform**: Flutter (Android)
- **Arsitektur**: MVC (Model-View-Controller)
- **Bahasa**: Dart
- **Database**: SQLite (sqflite)
- **Developer**: 
  - Danang Adiwibowo (123230143)
  - Gorga Doli L (123230147)

## Deskripsi Aplikasi
Nyawit adalah aplikasi mobile untuk pencatatan dan pengelolaan keuangan pribadi. Aplikasi ini membantu user untuk mencatat transaksi pemasukan dan pengeluaran, mengatur budget bulanan, serta mengatur reminder untuk pembayaran.

---

## 🚀 TAHAP 1: Pembuatan Aplikasi dengan Arsitektur MVC

### Fitur yang Diimplementasikan:

#### 1. **Authentication System**
- **Login**: User bisa login dengan username dan password
- **Register**: User bisa daftar akun baru dengan nama lengkap, username, dan password
- **Session Management**: Aplikasi menyimpan session user yang sedang login
- Password disimpan dengan hashing SHA-256 untuk keamanan

**File Terkait:**
- `lib/models/user_model.dart` - Model data user
- `lib/controllers/auth_controller.dart` - Logic authentication
- `lib/providers/auth_provider.dart` - State management untuk auth
- `lib/views/auth/login_screen.dart` - UI Login
- `lib/views/auth/register_screen.dart` - UI Register

#### 2. **Dashboard**
- Menampilkan total saldo (pemasukan - pengeluaran)
- Card untuk total pemasukan dengan icon panah ke bawah
- Card untuk total pengeluaran dengan icon panah ke atas
- Indikator target budget bulanan dengan progress bar
- Grafik pie chart pengeluaran per kategori
- List 5 transaksi terakhir
- Floating action button untuk tambah transaksi cepat

**File Terkait:**
- `lib/views/dashboard/dashboard_screen.dart`
- `lib/utils/budget_calculator.dart` - Helper untuk kalkulasi budget

#### 3. **Transaction Management (CRUD)**
- **Create**: Tambah transaksi baru (pemasukan/pengeluaran)
- **Read**: Lihat semua transaksi dengan filter dan sorting
- **Update**: Edit transaksi yang sudah ada
- **Delete**: Hapus transaksi

Fitur Transaksi:
- Pilih tipe: Pemasukan atau Pengeluaran
- Input jumlah uang
- Pilih kategori dari list yang tersedia
- Input catatan/deskripsi
- Pilih tanggal transaksi

**File Terkait:**
- `lib/models/transaction_model.dart`
- `lib/controllers/transaction_controller.dart`
- `lib/providers/transaction_provider.dart`
- `lib/views/transaction/add_transaction_screen.dart`
- `lib/views/transaction/edit_transaction_screen.dart`
- `lib/views/transaction/transaction_list_screen.dart`
- `lib/widgets/transaction_card.dart`

#### 4. **Category Management**
- User bisa mengelola kategori transaksi
- Setiap user punya kategori default (Makanan, Transport, Belanja, dll)
- User bisa tambah kategori custom

**File Terkait:**
- `lib/models/category_model.dart`
- `lib/controllers/category_controller.dart`
- `lib/providers/category_provider.dart`

#### 5. **Budget Tracking**
- User bisa set target pengeluaran bulanan
- Aplikasi tracking pengeluaran vs target
- Progress bar dengan color coding:
  - Hijau: < 50% dari target
  - Kuning: 50-80% dari target
  - Merah: > 80% dari target
- Notifikasi status budget

**File Terkait:**
- `lib/models/budget_model.dart`
- `lib/controllers/budget_controller.dart`
- `lib/providers/budget_provider.dart`

#### 6. **Reminder System**
- User bisa buat reminder untuk pembayaran
- Input nama reminder, jumlah, dan waktu
- Mark reminder as complete
- Delete reminder

**File Terkait:**
- `lib/models/reminder_model.dart`
- `lib/controllers/reminder_controller.dart`
- `lib/providers/reminder_provider.dart`
- `lib/views/reminder/add_reminder_screen.dart`
- `lib/views/reminder/reminder_list_screen.dart`

#### 7. **Profile Management**
- Lihat info profile (nama, username, password tersembunyi)
- Edit profile (ubah nama, username, password)
- Logout dari aplikasi

**File Terkait:**
- `lib/views/profile/profile_screen.dart`
- `lib/views/profile/edit_profile_screen.dart`

#### 8. **Developer Testing**
- Load testing: Generate random transactions untuk test performa
- Stress testing: Test dengan data besar
- Berguna untuk keperluan testing UKPL

**File Terkait:**
- `lib/views/testing/developer_testing_screen.dart`

#### 9. **About Us**
- Info tentang aplikasi
- Foto dan biodata developer
- Technology stack yang digunakan

**File Terkait:**
- `lib/views/about/about_screen.dart`

#### 10. **Database Layer**
- SQLite database dengan sqflite
- Migration system untuk update schema database
- CRUD operations untuk semua entity
- Foreign key constraints untuk data integrity

**File Terkait:**
- `lib/services/database_service.dart`

#### 11. **Testing**
- 29 unit tests untuk testing business logic
- Test untuk models, controllers, dan utilities
- Command: `flutter test`

**File Terkait:**
- `test/models/` - Test untuk models
- `test/controllers/` - Test untuk controllers
- `test/utils/` - Test untuk utilities

---

## 🎨 TAHAP 2: Simplifikasi Registrasi User

### Perubahan:
Awalnya form register meminta banyak field (nama, username, password, email, phone). User minta disederhanakan.

### Yang Dilakukan:
1. **Update User Model**
   - Hapus field `email` dan `phoneNumber`
   - Hanya simpan: `id`, `username`, `password`, `fullName`, `createdAt`

2. **Update Database Schema**
   - Upgrade ke versi 3
   - Tabel `users` hanya punya 5 kolom
   - Migration otomatis saat aplikasi dijalankan

3. **Update Register Form**
   - Form hanya minta: Nama Lengkap, Username, Password
   - Validasi username unique
   - Password min 6 karakter

4. **Hapus Edit Profile** (sementara)
   - Karena user belum minta fitur edit, halaman edit profile dihapus dulu
   - Profile screen hanya view-only dengan tombol logout

**Dampak:**
- Registrasi jadi lebih cepat dan sederhana
- Database lebih ringkas
- User experience lebih baik

---

## 🎨 TAHAP 3: Design Overhaul Sesuai NEWDESIGN.md

### Masalah:
Design awal tidak sesuai dengan spesifikasi di file `NEWDESIGN.md`. User minta rombak total design.

### Design System Baru:

#### Color Palette:
```dart
Background: #F9FAFB (abu-abu sangat muda)
Card Background: #FFFFFF (putih)
Primary Green: #006C49 (hijau tua)
Accent Green: #10B981 (hijau muda/emerald)
Border: #BBCABF (abu-abu kehijauan)
Text Primary: #1F2937
Text Secondary: #6B7280
Danger: #EF4444 (merah)
```

#### Typography:
- **Font Family**: Manrope
- **Weights**: 400 (Regular), 500 (Medium), 600 (Semibold), 700 (Bold), 800 (Extrabold)

#### Design Principles:
- Light theme dengan white cards
- Green accent untuk primary actions
- Border tipis 1px pada cards
- Border radius 8px untuk cards, 4px untuk buttons
- Minimal shadow (hanya pada balance card)

### Yang Dirombak:

1. **Ganti Nama Aplikasi**
   - Dari "PocketCare" → "Nyawit"
   - Update di constants, splash, dan semua screen

2. **Update Semua Screen:**
   - **Login & Register**: Form dengan white card, green button
   - **Dashboard**: 
     - Balance card dengan background hijau (#10B981)
     - White cards untuk budget dan chart
     - Green progress bar
   - **Transaction Screens**: White cards dengan green accent
   - **Reminder Screens**: Consistent dengan design system
   - **Profile**: Clean white cards untuk info
   - **About Us**: White cards dengan proper spacing

3. **Update Custom Widgets:**
   - `lib/widgets/custom_button.dart` - Green button
   - `lib/widgets/custom_text_field.dart` - Input dengan border hijau saat focus
   - `lib/widgets/transaction_card.dart` - White card dengan border

4. **Update Constants:**
   - `lib/utils/constants.dart` - Semua warna dan text styles

**Hasil:**
- Design konsisten di semua halaman
- Professional dan modern look
- Sesuai dengan color palette hijau yang diminta

---

## 👤 TAHAP 4: Implementasi Edit Profile

### Masalah:
User minta bisa edit profile sendiri, tapi di profile screen cuma ada info view-only.

### Yang Diimplementasikan:

1. **Buat Edit Profile Screen**
   - Form untuk edit Nama Lengkap
   - Form untuk edit Username
   - Form untuk ganti Password (optional)
   - Note: "Kosongkan jika tidak ingin mengganti password"

2. **Update Database Method**
   - `updateUserProfile()` di DatabaseService
   - Validasi username unique (cek tidak dipakai user lain)
   - Update password hanya jika diisi

3. **Update Auth Provider**
   - Method `updateProfile()` untuk handle update
   - Refresh current user setelah update

4. **Update Profile Screen**
   - Tambah button "Edit Profile"
   - Navigate ke edit profile screen
   - Refresh data setelah edit

**File Baru:**
- `lib/views/profile/edit_profile_screen.dart`

---

## 🔔 TAHAP 5: Implementasi Notifikasi Reminder

### Masalah:
Reminder yang dibuat tidak memunculkan notifikasi di HP.

### Yang Diminta:
Notifikasi muncul di 4 waktu:
- **H-24 jam**: "Besok pada [waktu]"
- **H-12 jam**: "12 jam lagi pada [waktu]"
- **H-6 jam**: "6 jam lagi pada [waktu]"
- **H-1 jam**: "1 jam lagi pada [waktu]!"

### Implementasi:

1. **Install Dependencies**
   ```yaml
   flutter_local_notifications: ^17.2.3
   timezone: ^0.9.4
   ```

2. **Buat Notification Service**
   - Initialize notification channel untuk Android
   - Setup timezone (Asia/Jakarta)
   - Method untuk schedule notifications
   - Unique ID system: `reminderId * 100 + offset`
   - offset 1 = H-24, offset 2 = H-12, offset 3 = H-6, offset 4 = H-1

3. **Schedule Logic**
   - Saat tambah reminder → schedule 4 notifikasi
   - Saat update reminder → cancel yang lama, schedule yang baru
   - Saat delete reminder → cancel semua notifikasinya
   - Saat mark complete → cancel semua notifikasinya

4. **Update Android Manifest**
   - Tambah permission untuk notifications
   - Tambah permission untuk schedule exact alarms (Android 13+)

5. **Initialize di Main**
   - Call `NotificationService.instance.initialize()` saat app start

**File Terkait:**
- `lib/services/notification_service.dart` - Service untuk handle notifications
- `android/app/src/main/AndroidManifest.xml` - Permissions
- `pubspec.yaml` - Dependencies

**Hasil:**
- Notifikasi muncul tepat waktu sesuai jadwal
- User dapat reminder sebelum waktu pembayaran
- Notifikasi otomatis dibatalkan jika reminder dihapus/selesai

---

## ℹ️ TAHAP 6: Update About Us Screen

### Masalah:
About Us screen masih menampilkan:
- Nama aplikasi "PocketCare"
- Version number "1.0.0"
- Logo placeholder
- Deskripsi yang terlihat AI-generated

### Perubahan:

1. **Header Section**
   - Hapus app logo
   - Hapus version number
   - Judul hanya "Nyawit"
   - Subtitle: "Aplikasi pencatat & pengelola keuangan"

2. **Developer Section**
   - Tambah foto developer dari folder assets:
     - `assets/danankmobile.jpeg` untuk Danang
     - `assets/gorokmobile.jpeg` untuk Gorga
   - Tampilkan foto dalam circle avatar
   - Info: Nama dan NIM

3. **Tentang Aplikasi Section**
   - Deskripsi dengan bahasa natural mahasiswa semester 6
   - Tidak pakai emoji/stiker
   - Menjelaskan fitur-fitur utama
   - Tone: professional tapi tetap santai

4. **Technology Stack Section**
   - List tech yang dipakai:
     - Flutter & Dart
     - SQLite (sqflite)
     - Provider (state management)
     - fl_chart (grafik)
     - flutter_local_notifications
     - dll

5. **Footer**
   - "© 2024 Nyawit"
   - "Dibuat di Yogyakarta, Indonesia"

**File Diupdate:**
- `lib/views/about/about_screen.dart`
- `pubspec.yaml` - Register assets

---

## 📝 TAHAP 7: Simplifikasi Profile Screens

### Perubahan 1: Profile Screen

#### Masalah:
Profile screen terlalu sepi, hanya ada avatar dan button.

#### Solusi:
1. **Tampilkan Info Profile dalam Cards:**
   - Card untuk Nama Lengkap (icon: person)
   - Card untuk Username dengan @ prefix (icon: account_circle)
   - Card untuk Password dengan asterisks (icon: lock)

2. **Layout:**
   - White card besar sebagai container
   - 3 info cards di dalam dengan border dan background abu
   - Icon hijau di setiap info card
   - Label dan value jelas terbaca

3. **Buttons di Bawah:**
   - Edit Profile button (green)
   - Logout button (red outline)

### Perubahan 2: Edit Profile Screen

#### Masalah:
- Ada profile picture dengan icon camera yang tidak diperlukan
- Ada nested boxes untuk setiap field (kotakan dalam-dalam)
- Username tidak bisa diedit (locked)
- Password field baru muncul kalau centang checkbox

#### Solusi:
1. **Hapus Profile Picture:**
   - Tidak ada avatar/foto
   - Fokus ke form data saja

2. **Simplify Layout:**
   - Satu white card besar untuk semua form
   - Tidak ada kotakan dalam lagi
   - Semua field langsung di dalam card

3. **Enable Edit Username:**
   - Username sekarang bisa diubah
   - Validasi tetap cek uniqueness

4. **Always Show Password Fields:**
   - Tidak pakai checkbox
   - Field password dan confirm password langsung tampil
   - Note: "Kosongkan jika tidak ingin mengganti password"

**Hasil:**
- UI lebih clean dan fokus
- Tidak ada elemen yang tidak perlu
- Form data lebih mudah diisi

---

## 🔄 TAHAP 8: Implementasi Bottom Navigation Bar

### Masalah:
Dashboard punya bottom nav sendiri dengan 2 tab (Dashboard & Menu), dan semua fitur diakses lewat Menu. User minta:
- Bottom nav di level aplikasi
- 4 tabs: Home, History, Reminders, Profile
- Menu items dipindah ke Profile tab

### Implementasi:

#### 1. Buat Main Screen dengan Bottom Nav

**File Baru:** `lib/views/main/main_screen.dart`

**Fitur:**
- Bottom navigation bar dengan 4 tabs:
  - **Home** (icon: home) → Dashboard
  - **History** (icon: history) → Transaction List
  - **Reminders** (icon: notifications) → Reminder List
  - **Profile** (icon: person) → Profile
- IndexedStack untuk maintain state setiap tab
- Selected tab dengan warna hijau (#10B981)
- Unselected tab dengan warna abu-abu

**Design:**
- White background untuk navbar
- Shadow tipis di atas
- Icon size 28px
- Label text 12px
- Spacing dan padding yang proper
- Border radius 12px untuk tap effect

#### 2. Simplifikasi Dashboard Screen

**Yang Dihapus:**
- `_selectedIndex` state untuk bottom nav lama
- `bottomNavigationBar` widget
- `_buildMenu()` method
- `_buildMenuItem()` method
- Import untuk screen yang tidak diperlukan (ReminderList, Profile, About, Testing)
- Parameter `showBottomNav` dari constructor

**Yang Dipertahankan:**
- Dashboard content (balance card, budget, chart, transactions)
- Floating action button untuk tambah transaksi
- Refresh functionality

**Hasil:**
- Dashboard jadi pure content screen
- Tidak ada navigasi internal lagi
- Lebih simple dan clean

#### 3. Update Profile Screen

**Perubahan:**
Tambah 3 menu buttons di bawah Edit Profile:

1. **Developer Testing Button**
   - Icon: bug_report
   - Label: "Developer Testing"
   - Navigate ke: `DeveloperTestingScreen`
   - Style: Outline button dengan border abu-abu

2. **About Us Button**
   - Icon: info_outline
   - Label: "About Us"
   - Navigate ke: `AboutScreen`
   - Style: Outline button dengan border abu-abu

3. **Logout Button** (dipindah dari atas)
   - Icon: logout
   - Label: "Keluar dari Akun"
   - Style: Outline button dengan border merah
   - Tetap ada dialog konfirmasi

**Import Tambahan:**
```dart
import '../testing/developer_testing_screen.dart';
import '../about/about_screen.dart';
```

**Layout:**
```
Profile Info Cards (Nama, Username, Password)
↓
Edit Profile Button (green)
↓
Developer Testing Button (outline)
↓
About Us Button (outline)
↓
Logout Button (red outline)
```

#### 4. Update Login Navigation

**Perubahan di LoginScreen:**
- Import: `DashboardScreen` → `MainScreen`
- Navigate ke: `MainScreen()` setelah login berhasil

**Sebelum:**
```dart
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => const DashboardScreen()),
);
```

**Sesudah:**
```dart
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => const MainScreen()),
);
```

#### 5. Update Main App

**File:** `lib/main.dart`

**Tidak Ada Perubahan:**
- Entry point tetap `LoginScreen`
- Setelah login, baru masuk ke `MainScreen`

### User Flow Baru:

```
Login Screen
    ↓
Main Screen (Bottom Nav)
    ├── Tab 1: Home
    │   └── Dashboard dengan balance, budget, chart, transactions
    ├── Tab 2: History
    │   └── Transaction List (semua transaksi)
    ├── Tab 3: Reminders
    │   └── Reminder List (semua reminder)
    └── Tab 4: Profile
        ├── Info Cards (Nama, Username, Password)
        ├── [Edit Profile] → Edit Profile Screen
        ├── [Developer Testing] → Testing Screen
        ├── [About Us] → About Screen
        └── [Logout] → Confirm Dialog → Login Screen
```

### Keuntungan:

1. **Navigasi Lebih Intuitif:**
   - User bisa langsung switch ke screen utama dari bottom nav
   - Tidak perlu balik-balik ke menu

2. **Consistent Navigation:**
   - Bottom nav selalu visible di 4 screen utama
   - User tahu posisi mereka di aplikasi

3. **Better UX:**
   - 1 tap untuk switch screen
   - Faster access ke fitur utama

4. **Clean Code:**
   - Separation of concerns yang lebih baik
   - Dashboard fokus ke content
   - Profile fokus ke user settings

### Testing:

**Build Status:**
```bash
flutter build apk --debug
# ✅ BUILD SUCCESSFUL
# Output: app-debug.apk
```

**Lint Check:**
- ⚠️ 11 info warnings (deprecated API, minor issues)
- ✅ 0 errors
- ✅ Aplikasi berjalan normal

---

## 📂 Struktur Project

```
lib/
├── controllers/          # Business logic layer
│   ├── auth_controller.dart
│   ├── transaction_controller.dart
│   ├── category_controller.dart
│   ├── budget_controller.dart
│   └── reminder_controller.dart
├── models/              # Data models
│   ├── user_model.dart
│   ├── transaction_model.dart
│   ├── category_model.dart
│   ├── budget_model.dart
│   └── reminder_model.dart
├── providers/           # State management (Provider)
│   ├── auth_provider.dart
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   ├── budget_provider.dart
│   └── reminder_provider.dart
├── services/            # External services
│   ├── database_service.dart
│   └── notification_service.dart
├── utils/               # Helper & utilities
│   ├── constants.dart
│   └── budget_calculator.dart
├── views/               # UI Layer
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── main/
│   │   └── main_screen.dart         # Bottom Nav
│   ├── transaction/
│   │   ├── transaction_list_screen.dart
│   │   ├── add_transaction_screen.dart
│   │   └── edit_transaction_screen.dart
│   ├── reminder/
│   │   ├── reminder_list_screen.dart
│   │   └── add_reminder_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   └── edit_profile_screen.dart
│   ├── about/
│   │   └── about_screen.dart
│   └── testing/
│       └── developer_testing_screen.dart
├── widgets/             # Reusable widgets
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   └── transaction_card.dart
└── main.dart            # App entry point

test/                    # Unit tests
├── models/
├── controllers/
└── utils/

assets/                  # Images & assets
├── danankmobile.jpeg
└── gorokmobile.jpeg
```

---

## 🛠️ Tech Stack

### Core Framework:

#### **Flutter** (^3.5.4)
- **Apa itu?**: Framework UI dari Google untuk bikin aplikasi mobile cross-platform
- **Kenapa dipake?**: 
  - Satu codebase untuk Android & iOS
  - Fast development dengan hot reload
  - Performance native-like
  - Rich UI components
- **Digunakan untuk**: Base framework untuk seluruh aplikasi

#### **Dart** (^3.5.4)
- **Apa itu?**: Bahasa pemrograman dari Google untuk Flutter
- **Kenapa dipake?**: 
  - Strongly-typed language (type safety)
  - Null safety untuk avoid bugs
  - Fast compilation
  - Modern syntax yang mudah dipahami
- **Digunakan untuk**: Bahasa pemrograman utama aplikasi

---

### State Management:

#### **provider** (^6.1.2)
- **Apa itu?**: State management solution recommended by Flutter team
- **Kenapa dipake?**: 
  - Simple dan easy to learn
  - Efficient (hanya rebuild widget yang perlu)
  - Built-in dengan Flutter ecosystem
  - Tidak perlu setup rumit seperti BLoC
- **Digunakan untuk**: 
  - Manage state auth (login/logout)
  - Manage state transactions
  - Manage state categories, budgets, reminders
  - Share data antar screens
- **Contoh Class**: `AuthProvider`, `TransactionProvider`, `BudgetProvider`

---

### Database:

#### **sqflite** (^2.3.3+1)
- **Apa itu?**: SQLite plugin untuk Flutter
- **Kenapa dipake?**: 
  - Lightweight database yang cocok untuk mobile
  - Support SQL queries (familiar untuk developer)
  - Data tersimpan lokal di device
  - Support transactions dan foreign keys
  - No internet required
- **Digunakan untuk**: 
  - Simpan data users
  - Simpan data transactions
  - Simpan data categories, budgets, reminders
  - Migration database schema
- **Database File**: `nyawit.db` di device storage

#### **path** (^1.9.0)
- **Apa itu?**: Utility untuk manipulasi file paths
- **Kenapa dipake?**: Untuk dapetin path directory database di device
- **Digunakan untuk**: Get database path dengan `getDatabasesPath()`

---

### UI Components & Charting:

#### **fl_chart** (^0.69.0)
- **Apa itu?**: Library charting untuk Flutter
- **Kenapa dipake?**: 
  - Beautiful dan customizable charts
  - Support berbagai jenis chart (pie, bar, line, dll)
  - Smooth animations
  - Good documentation
- **Digunakan untuk**: 
  - Pie chart pengeluaran per kategori di dashboard
  - Visualisasi data keuangan
- **Contoh**: `PieChart` dengan `PieChartData`

#### **intl** (^0.19.0)
- **Apa itu?**: Internationalization and localization library
- **Kenapa dipake?**: 
  - Formatting angka dengan locale Indonesia
  - Formatting tanggal
  - Currency formatting
- **Digunakan untuk**: 
  - Format rupiah: `Rp 10.000`
  - Format tanggal: `15 Jan 2024`
- **Contoh**: `NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')`

#### **cupertino_icons** (^1.0.8)
- **Apa itu?**: Icon pack iOS-style
- **Kenapa dipake?**: Default Flutter asset untuk icons
- **Digunakan untuk**: Icons di seluruh aplikasi (tambahan dari Material Icons)

---

### Notifications:

#### **flutter_local_notifications** (^17.2.3)
- **Apa itu?**: Plugin untuk local notifications di Flutter
- **Kenapa dipake?**: 
  - Support Android & iOS notifications
  - Schedule notifications di waktu tertentu
  - Customizable notification (title, body, sound, dll)
  - Support notification channels (Android)
- **Digunakan untuk**: 
  - Kirim notifikasi reminder H-24, H-12, H-6, H-1
  - Schedule notifications dengan exact time
  - Cancel notifications saat reminder dihapus
- **Setup**: Notification channel, permissions, initialization

#### **timezone** (^0.9.4)
- **Apa itu?**: Timezone database untuk Dart
- **Kenapa dipake?**: 
  - Convert waktu ke timezone tertentu (Asia/Jakarta)
  - Diperlukan oleh flutter_local_notifications untuk schedule
  - Handle waktu dengan benar sesuai timezone Indonesia
- **Digunakan untuk**: 
  - Set timezone `Asia/Jakarta`
  - Convert `DateTime` ke `TZDateTime` untuk scheduling
- **Contoh**: `tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Jakarta'))`

---

### Security:

#### **crypto** (^3.0.3)
- **Apa itu?**: Cryptographic library untuk Dart
- **Kenapa dipake?**: 
  - Hashing password dengan SHA-256
  - Secure password storage
  - One-way encryption (tidak bisa di-decrypt)
- **Digunakan untuk**: 
  - Hash password sebelum simpan ke database
  - Verify password saat login
  - Security best practice (tidak simpan plain text password)
- **Contoh**: 
  ```dart
  import 'package:crypto/crypto.dart';
  import 'dart:convert';
  
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  ```

---

### Architecture Pattern:

#### **MVC (Model-View-Controller)**
- **Apa itu?**: Design pattern untuk organize code
- **Kenapa dipake?**: 
  - Separation of concerns yang jelas
  - Code lebih maintainable
  - Testing lebih mudah
  - Standard industry pattern
- **Struktur**:
  - **Model** (`lib/models/`): Data structure dan business objects
  - **View** (`lib/views/`): UI dan presentation layer
  - **Controller** (`lib/controllers/`): Business logic dan data processing
  - **Provider** (`lib/providers/`): State management (link antara Controller dan View)
  - **Service** (`lib/services/`): External services (database, notifications)

---

### Development Tools:

#### **Flutter SDK**
- Hot reload untuk fast development
- DevTools untuk debugging
- Widget inspector
- Performance profiler

#### **Android Studio / VS Code**
- IDE untuk development
- Flutter extension/plugin
- Debugging tools
- Emulator/simulator

#### **Git**
- Version control
- Collaboration
- Track changes

---

### Build & Deployment:

#### **Gradle**
- Build system untuk Android
- Dependency management
- APK building

#### **Android SDK**
- Target: Android 13+ (API 33)
- Min SDK: Android 5.0 (API 21)
- Compile SDK: Android 14 (API 34)

---

### Testing:

#### **flutter_test**
- Built-in testing framework
- Unit testing
- Widget testing
- Integration testing

#### **test** package
- Dart testing library
- Assertions dan matchers
- Test runner

---

## 📊 Dependency Tree

```
nyawit/
├── Flutter Framework (Core)
│   ├── Material Design Components
│   ├── Cupertino (iOS-style) Components
│   └── Widget System
│
├── State Management
│   └── Provider
│       ├── ChangeNotifier
│       ├── Consumer
│       └── MultiProvider
│
├── Local Storage
│   └── sqflite
│       ├── SQLite Database
│       └── path (helper)
│
├── UI & Visualization
│   ├── fl_chart (charting)
│   ├── intl (formatting)
│   └── cupertino_icons
│
├── Notifications
│   ├── flutter_local_notifications
│   └── timezone
│
└── Security
    └── crypto (SHA-256 hashing)
```

---

## 🔧 Kenapa Memilih Tech Stack Ini?

### 1. **Simplicity**
- Tech stack yang dipilih mudah dipelajari
- Dokumentasi lengkap dan banyak tutorial
- Cocok untuk project tugas kuliah dengan timeline terbatas

### 2. **Performance**
- Flutter menggunakan native code (ARM compiled)
- sqflite sangat cepat untuk operasi database lokal
- Provider efficient untuk state management

### 3. **Reliability**
- Semua package official atau widely-used
- Maintained dengan baik
- Production-ready

### 4. **Offline-First**
- Semua data tersimpan lokal
- Tidak butuh internet untuk core functionality
- Fast response time

### 5. **Security**
- Password hashing dengan SHA-256
- SQLite tidak expose data ke internet
- Local storage yang aman

### 6. **Testability**
- MVC architecture mudah di-test
- Flutter punya testing framework yang bagus
- 29 unit tests sudah implemented

### 7. **Future-Proof**
- Flutter terus berkembang
- Dart modern language dengan null safety
- Easy to add features later (cloud sync, etc)

---

## 📦 Package Size Comparison

| Package | Size | Purpose |
|---------|------|---------|
| flutter | Base | Framework |
| provider | ~50KB | State management |
| sqflite | ~200KB | Database |
| fl_chart | ~500KB | Charting |
| flutter_local_notifications | ~300KB | Notifications |
| crypto | ~100KB | Hashing |
| intl | ~150KB | Formatting |

**Total Additional Size**: ~1.3 MB (sangat kecil untuk fitur yang didapat)

---

## 🧪 Testing

### Unit Tests:
Total: 29 tests

**Coverage:**
- Models (User, Transaction, Category, Budget, Reminder)
- Controllers (Auth, Transaction, Category, Budget, Reminder)
- Utilities (Budget Calculator)

**Command:**
```bash
flutter test
```

**Status:** ✅ All tests passing

---

## 🚀 Build & Run

### Development:
```bash
flutter run
```

### Build APK (Debug):
```bash
flutter build apk --debug
```

### Build APK (Release):
```bash
flutter build apk --release
```

### Testing:
```bash
flutter test
```

### Analyze Code:
```bash
flutter analyze
```

---

## 📱 Fitur Utama Aplikasi

1. ✅ **Autentikasi** - Login & Register dengan keamanan password
2. ✅ **Dashboard** - Overview keuangan dengan grafik
3. ✅ **Transaksi** - CRUD transaksi pemasukan/pengeluaran
4. ✅ **Kategori** - Kelola kategori transaksi
5. ✅ **Budget** - Set target dan tracking pengeluaran bulanan
6. ✅ **Reminder** - Pengingat pembayaran dengan notifikasi multi-stage
7. ✅ **Profile** - Lihat dan edit info profile
8. ✅ **Bottom Navigation** - Navigasi cepat ke 4 screen utama
9. ✅ **Developer Testing** - Tools untuk testing performa
10. ✅ **About Us** - Info developer dan tech stack

---

## 🎨 Design System

### Colors:
- Background: `#F9FAFB`
- Card: `#FFFFFF`
- Primary: `#006C49`
- Accent: `#10B981`
- Border: `#BBCABF`
- Text: `#1F2937` & `#6B7280`
- Danger: `#EF4444`

### Typography:
- Font: **Manrope**
- Sizes: 12-32px
- Weights: 400-800

### Components:
- Border Radius: 4px (buttons), 8px (cards), 12px (large)
- Border Width: 1px
- Shadows: Minimal (hanya pada balance card)

---

## 👨‍💻 Developer Notes

### Database Schema Version:
- **Current**: Version 3
- Migration otomatis handle perubahan schema

### Password Security:
- Hash dengan SHA-256
- Tidak pernah simpan plain text password

### Notification IDs:
- Formula: `reminderId * 100 + offset`
- Offset 1-4 untuk 4 notifikasi per reminder

### Bottom Navigation:
- Pakai `IndexedStack` untuk maintain state
- Screen tidak rebuild saat switch tab

---

## 📝 Changelog

### v1.0.0 - Initial Release
- ✅ Implementasi MVC architecture
- ✅ 10 fitur utama
- ✅ 29 unit tests
- ✅ Design system lengkap

### v1.1.0 - Simplifikasi & Notifikasi
- ✅ Simplifikasi form register
- ✅ Edit profile feature
- ✅ Multi-stage notifications
- ✅ About Us update
- ✅ Profile screen improvement

### v1.2.0 - Bottom Navigation
- ✅ Bottom nav 4 tabs (Home, History, Reminders, Profile)
- ✅ Dashboard simplification
- ✅ Profile menu items (Developer Testing, About Us, Logout)
- ✅ Improved navigation flow

---

## 🔮 Future Improvements (Optional)

- [ ] Backup & Restore data
- [ ] Export transaksi ke PDF/Excel
- [ ] Dark mode theme
- [ ] Multi-currency support
- [ ] Recurring transactions
- [ ] Cloud sync
- [ ] Biometric authentication

---

## 📄 License

Aplikasi ini dibuat untuk keperluan tugas UKPL (Uji Kualitas Perangkat Lunak).

**© 2024 Nyawit - Dibuat di Yogyakarta, Indonesia**

Developed by:
- **Danang Adiwibowo** (123230143)
- **Gorga Doli L** (123230147)
