# Nyawit - Aplikasi Pencatat & Pengelola Keuangan

![Flutter](https://img.shields.io/badge/Flutter-3.5.4-blue)
![Dart](https://img.shields.io/badge/Dart-3.5.4-blue)
![SQLite](https://img.shields.io/badge/SQLite-sqflite-green)

**Nyawit** (Nyari Duwit) adalah aplikasi manajemen keuangan pribadi yang dibangun dengan Flutter menggunakan arsitektur MVC untuk memenuhi tugas mata kuliah **Uji Kualitas Perangkat Lunak (UKPL)**.

## 👨‍💻 Developer

- **Danang Adiwibowo** - NIM: 123230143
- **Gorga Doli L** - NIM: 123230147

## 📋 Deskripsi

Nyawit adalah aplikasi mobile untuk mencatat dan mengelola keuangan pribadi dengan fitur-fitur lengkap seperti pencatatan transaksi, dashboard analitik, target budget bulanan, dan reminder pembayaran dengan notifikasi multi-stage. Aplikasi ini dirancang dengan arsitektur MVC yang terstruktur, keamanan password dengan salting, dan mudah diuji untuk memenuhi standar kualitas perangkat lunak.

## ✨ Fitur Utama

### 1. Autentikasi
- ✅ Registrasi user baru (hanya nama, username, password)
- ✅ Login dengan username & password
- ✅ **Password terenkripsi dengan SHA-256 + Salt** (OWASP compliant)
- ✅ Validasi form di Controller layer (MVC pattern)
- ✅ Session management dengan Provider

### 2. Profil User
- ✅ Lihat profil lengkap (Nama, Username, Password tersembunyi)
- ✅ Edit informasi profil (nama, username, password)
- ✅ Username dapat diubah dengan validasi uniqueness
- ✅ Password optional saat edit (kosongkan jika tidak ingin ganti)

### 3. Kelola Transaksi (CRUD)
- ✅ Tambah transaksi pemasukan/pengeluaran
- ✅ Pilih kategori dari dropdown
- ✅ Kategori bawaan:
  - **Pemasukan**: Gaji, Uang Jajan
  - **Pengeluaran**: Makanan, Kos, Hiburan, Lainnya
- ✅ Input nominal, tanggal, dan catatan
- ✅ Edit dan hapus transaksi
- ✅ View semua transaksi di History tab
- ✅ TransactionCard dengan design konsisten

### 4. Dashboard Analitik
- ✅ Balance card dengan background hijau (#10B981)
- ✅ Total pemasukan, pengeluaran, dan saldo
- ✅ **Indikator Target Budget Bulanan** dengan warna dinamis:
  - 🟢 **HIJAU**: Pengeluaran < 50% dari target (aman)
  - 🟡 **KUNING**: Pengeluaran 50-80% dari target (peringatan)
  - 🔴 **MERAH**: Pengeluaran ≥ 80% dari target (bahaya)
- ✅ Progress bar budget dengan persentase real-time
- ✅ **Chart Pie Pengeluaran per Kategori** menggunakan `fl_chart`
- ✅ Legend dengan breakdown nominal per kategori
- ✅ List 5 transaksi terakhir
- ✅ Pull to refresh
- ✅ Floating action button untuk tambah transaksi cepat

### 5. Reminder Pembayaran
- ✅ Tambah reminder dengan judul, deskripsi, tanggal & waktu
- ✅ **Notifikasi Multi-Stage** (H-24 jam, H-12 jam, H-6 jam, H-1 jam)
- ✅ Notifikasi menggunakan `flutter_local_notifications`
- ✅ Timezone Asia/Jakarta
- ✅ Auto-schedule saat tambah reminder
- ✅ Auto-cancel notifikasi saat reminder dihapus/selesai
- ✅ Tandai reminder sebagai selesai
- ✅ Hapus reminder
- ✅ Indikator visual untuk reminder yang sudah lewat

### 6. Bottom Navigation
- ✅ Navigasi 4 tab: Home, History, Reminders, Profile
- ✅ IndexedStack untuk maintain state setiap tab
- ✅ Green accent untuk selected tab
- ✅ Seamless navigation experience

### 7. About Us
- ✅ Informasi aplikasi "Nyawit (Nyari Duwit)"
- ✅ Foto developer (dari assets)
- ✅ Informasi developer dengan NIM
- ✅ Tentang Aplikasi dengan bahasa natural
- ✅ Technology stack yang digunakan
- ✅ Footer "Dibuat di Yogyakarta, Indonesia"

### 8. Developer Testing (STLC)
- ✅ **Load Test**: Insert 1.000 data transaksi
- ✅ **Stress Test**: Insert 20.000 data transaksi secara batch
- ✅ Tampilan waktu eksekusi dalam milidetik
- ✅ Perhitungan kecepatan transaksi per detik
- ✅ Progress indicator untuk stress test
- ✅ **Tombol clear data test** - batch delete transactions, budgets, reminders sekaligus

## 🏗️ Struktur Project (Arsitektur MVC)

```
lib/
├── main.dart                          # Entry point aplikasi
├── models/                            # MODEL - Data models
│   ├── user_model.dart
│   ├── transaction_model.dart
│   ├── category_model.dart
│   ├── budget_model.dart
│   └── reminder_model.dart
├── controllers/                       # CONTROLLER - Business logic
│   ├── auth_controller.dart
│   ├── transaction_controller.dart
│   ├── category_controller.dart
│   ├── budget_controller.dart
│   └── reminder_controller.dart
├── views/                             # VIEW - UI Screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── main/
│   │   └── main_screen.dart           # Bottom Navigation
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   └── edit_profile_screen.dart
│   ├── transaction/
│   │   ├── transaction_list_screen.dart
│   │   ├── add_transaction_screen.dart
│   │   └── edit_transaction_screen.dart
│   ├── reminder/
│   │   ├── reminder_list_screen.dart
│   │   └── add_reminder_screen.dart
│   ├── about/
│   │   └── about_screen.dart
│   └── testing/
│       └── developer_testing_screen.dart
├── providers/                         # State management (Provider)
│   ├── auth_provider.dart
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   ├── budget_provider.dart
│   └── reminder_provider.dart
├── services/                          # External services
│   ├── database_service.dart          # SQLite service
│   └── notification_service.dart      # Notification service
├── widgets/                           # Reusable widgets
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   └── transaction_card.dart
└── utils/                             # Utility classes
    ├── constants.dart                 # App constants & colors
    └── budget_calculator.dart         # Budget logic (White-box testing)

test/
├── models/                            # Model tests
├── controllers/                       # Controller tests
└── utils/
    └── budget_calculator_test.dart    # Unit tests (29 tests)

assets/
├── danankmobile.jpeg                  # Developer photo
└── gorokmobile.jpeg                   # Developer photo
```

## 🎨 Design System

### Color Palette (Light Theme with Green Accent)
- **Background**: `#F9FAFB` - Background utama (abu muda)
- **Card Background**: `#FFFFFF` - White cards
- **Primary Green**: `#006C49` - Hijau tua
- **Accent Green**: `#10B981` - Hijau emerald (balance card, buttons)
- **Border**: `#BBCABF` - Abu kehijauan
- **Text Primary**: `#1F2937` - Hitam
- **Text Secondary**: `#6B7280` - Abu
- **Accent Red**: `#EF4444` - Pengeluaran & danger
- **Accent Blue**: `#3B82F6` - Info
- **Accent Yellow**: `#F59E0B` - Warning

### Typography
- **Font Family**: Manrope (weights: 400, 500, 600, 700, 800)
- **Large Title**: 32px, Bold
- **App Title**: 24px, Bold
- **Heading 2**: 20px, SemiBold
- **Heading 3**: 18px, SemiBold
- **Balance Amount**: 32px, Extrabold (white)
- **Body Large**: 16px
- **Body Medium**: 14px
- **Body Small**: 12px
- **Label Text**: 12px, Bold, Uppercase

### Components
- **Border Radius**: 4px (buttons), 8px (cards), 12px (large cards)
- **Border Width**: 1px
- **Shadows**: Minimal (hanya pada balance card)

## 🧪 Testing

### Unit Testing (White-box)
**Total**: 29 unit tests

Mencakup testing untuk:
- ✅ **Models**: User, Transaction, Category, Budget, Reminder
- ✅ **Controllers**: Auth, Transaction, Category, Budget, Reminder
- ✅ **Utils**: BudgetCalculator

**File utama**: `test/utils/budget_calculator_test.dart`

Menguji logika penentu warna indikator budget dengan coverage:
- ✅ Decision Coverage (semua kondisi if-else)
- ✅ Path Coverage (semua jalur eksekusi)
- ✅ Boundary Value Analysis (nilai batas threshold)
- ✅ **Negative value validation** (expense < 0 atau target <= 0)

Contoh test cases:
```dart
// Test: Expense < 50% target → GREEN
getBudgetColor(40000, 100000) → AppColors.budgetSafe

// Test: Expense 50-80% target → YELLOW
getBudgetColor(65000, 100000) → AppColors.budgetWarning

// Test: Expense ≥ 80% target → RED
getBudgetColor(85000, 100000) → AppColors.budgetDanger

// Test: Negative expense → SAFE (boundary case)
getBudgetColor(-1000, 100000) → AppColors.budgetSafe
```

Jalankan semua test dengan:
```bash
flutter test
```

Jalankan test spesifik:
```bash
flutter test test/utils/budget_calculator_test.dart
```

### Load & Stress Testing
Tersedia di dalam aplikasi pada menu **Developer Testing**:

1. **Load Test**
   - Insert 1.000 transaksi dummy
   - Mengukur waktu eksekusi
   - Menampilkan kecepatan insert per detik

2. **Stress Test**
   - Insert 20.000 transaksi dummy secara batch
   - Menguji batas ketahanan aplikasi
   - Dapat dipantau dengan Flutter DevTools

## 🚀 Cara Instalasi & Menjalankan

### Prerequisites
- Flutter SDK 3.11.0 atau lebih baru
- Dart SDK 3.0.0 atau lebih baru
- Android Studio / VS Code dengan Flutter extension
- Emulator Android atau perangkat fisik

### Langkah Instalasi

1. **Clone atau ekstrak project**
```bash
cd /path/to/project
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Jalankan aplikasi**
```bash
flutter run
```

atau pilih device dan tekan F5 di VS Code

### Troubleshooting

Jika ada error `CocoaPods not installed`:
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

Jika ada error Gradle:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.2
  
  # Database
  sqflite: ^2.3.3+1
  path: ^1.9.0
  
  # UI & Charts
  fl_chart: ^0.69.0
  intl: ^0.19.0
  cupertino_icons: ^1.0.8
  
  # Notifications
  flutter_local_notifications: ^17.2.3
  timezone: ^0.9.4
  
  # Security
  crypto: ^3.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

## 🔐 Security Features

- ✅ **Password hashing dengan SHA-256 + Salt** (Application-wide + User-specific salt)
- ✅ **OWASP Mobile Top 10 compliant** - Resistant terhadap Rainbow Table Attacks
- ✅ **SQL injection prevention** dengan parameterized queries
- ✅ **Input validation** di Controller layer (MVC best practice)
- ✅ **Boundary validation** untuk prevent logical flaws
- ✅ **Cascade delete** untuk data integrity
- ✅ **Session management** dengan Provider

## 📊 Database Schema

**Database File**: `nyawit.db` (SQLite)  
**Current Version**: 3

### users
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
username TEXT NOT NULL UNIQUE
password TEXT NOT NULL (SHA-256 + Salt hashed)
full_name TEXT NOT NULL
created_at TEXT NOT NULL
```

### categories
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
name TEXT NOT NULL
type TEXT NOT NULL (income/expense)
is_default INTEGER NOT NULL DEFAULT 0
user_id INTEGER NOT NULL (FK)
```

### transactions
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
user_id INTEGER NOT NULL (FK)
category_id INTEGER NOT NULL (FK)
amount REAL NOT NULL
type TEXT NOT NULL (income/expense)
date TEXT NOT NULL
note TEXT
created_at TEXT NOT NULL
```

### reminders
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
user_id INTEGER NOT NULL (FK)
title TEXT NOT NULL
description TEXT
reminder_date TEXT NOT NULL
is_completed INTEGER NOT NULL DEFAULT 0
created_at TEXT NOT NULL
```

### budgets
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
user_id INTEGER NOT NULL (FK)
monthly_target REAL NOT NULL
month INTEGER NOT NULL
year INTEGER NOT NULL
```

## 🎯 Testing Scenarios untuk UKPL

### 1. White-box Testing
- **29 unit tests** covering models, controllers, dan utils
- Unit test pada `BudgetCalculator.getBudgetStatus()` dan `getBudgetColor()`
- Coverage: Decision, Path, dan Boundary Value Analysis
- **Boundary cases**: negative values, zero values, threshold edges
- File utama: `test/utils/budget_calculator_test.dart`

### 2. Black-box Testing
Skenario pengujian fungsional:
- Login dengan credentials valid/invalid
- Registrasi dengan username duplikat
- Edit profile (nama, username, password)
- Tambah transaksi pemasukan/pengeluaran
- Edit dan hapus transaksi
- Set target budget dan lihat perubahan warna indicator
- Tambah reminder dan terima notifikasi multi-stage
- Bottom navigation switching antar tabs

### 3. Security Testing
- **Password salting verification** (SHA-256 + Salt)
- **Rainbow table attack resistance**
- SQL injection testing dengan parameterized queries
- Input validation testing di Controller layer
- Authorization testing (user data isolation)

### 4. Load Testing
- Insert 1.000 transaksi dalam satu operasi
- Measure response time dan transactions/second
- Check database performance dengan SQLite
- Available in-app: Developer Testing screen

### 5. Stress Testing
- Insert 20.000 transaksi secara batch
- Monitor memory usage dengan Flutter DevTools
- Check application stability under heavy load
- Available in-app: Developer Testing screen

### 6. Integration Testing
- Test flow: Login → MainScreen → Dashboard → Tambah Transaksi → Lihat di History
- Test Provider integration dengan DatabaseService
- Test NotificationService dengan ReminderProvider
- Test cascade delete (hapus user → hapus semua data terkait)
- Test batch delete (clear test data → hapus transactions + budgets + reminders)

## 📝 Catatan Penting

1. **Password Security**: Password di-hash dengan SHA-256 + Salt (application-wide + user-specific). Sesuai dengan OWASP Mobile Top 10 untuk mencegah rainbow table attacks.

2. **Logika Warna Budget** (untuk White-box Testing):
   - Safe (Green): `expense / target < 0.50` (< 50%)
   - Warning (Yellow): `0.50 ≤ expense / target < 0.80` (50-80%)
   - Danger (Red): `expense / target ≥ 0.80` (≥ 80%)
   - Boundary validation: `if (expense < 0 || target <= 0) return 'safe'`

3. **Developer Testing**: Setelah menjalankan Load/Stress Test, gunakan tombol "Hapus Semua Data Test" untuk membersihkan database. Fungsi ini menggunakan **batch delete** untuk menghapus transactions, budgets, dan reminders sekaligus (no data residual).

4. **Notification Schedule**: Reminder menggunakan 4 notifikasi:
   - H-24 jam: "Besok pada [waktu]"
   - H-12 jam: "12 jam lagi pada [waktu]"
   - H-6 jam: "6 jam lagi pada [waktu]"  
   - H-1 jam: "1 jam lagi pada [waktu]!"
   - Unique ID: `reminderId * 100 + offset` (1-4)

5. **Database Migration**: Aplikasi menggunakan database version 3. Migration otomatis handle upgrade dari version lama ke struktur user table yang disederhanakan (hanya nama, username, password).

6. **Bottom Navigation**: Aplikasi menggunakan MainScreen dengan IndexedStack untuk maintain state setiap tab saat user berpindah-pindah.

7. **Performance Monitoring**: Untuk melihat penggunaan RAM/CPU saat Stress Test, buka Flutter DevTools:
   ```bash
   flutter run
   # Kemudian tekan 'w' untuk membuka DevTools di browser
   ```

## 🐛 Known Issues & Future Enhancements

### Current Limitations:
- Light theme only (belum ada dark theme)
- Export/Import data belum tersedia
- Grafik hanya pie chart (belum ada line chart untuk trend)
- Kategori custom belum bisa ditambah/dihapus manual

### Future Enhancements:
- [ ] Cloud sync & backup
- [ ] Biometric authentication
- [ ] Multi-currency support
- [ ] Recurring transactions
- [ ] Budget per kategori
- [ ] Export to PDF/Excel
- [ ] Dark theme
- [ ] Widget untuk quick add transaction

## 📄 License

MIT License - Dibuat untuk keperluan akademik UKPL

## 🙏 Acknowledgments

- Flutter Team untuk framework yang luar biasa
- fl_chart package untuk chart library yang powerful
- sqflite untuk SQLite database management
- flutter_local_notifications untuk notification system
- Dosen pengampu UKPL untuk guidance dan feedback
- Komunitas Flutter Indonesia untuk support

---

**Dibuat dengan ❤️ oleh Danang Adiwibowo & Gorga Doli L**

*Universitas Pembangunan Nasional "Veteran" Yogyakarta*  
*Teknik Informatika - Semester 6*  
*2024*

---

## 📞 Contact

Untuk pertanyaan atau feedback:
- **Email**: [Contact via GitHub]
- **GitHub**: [Repository Link]

## 📄 License

MIT License - Dibuat untuk keperluan akademik UKPL

Copyright © 2024 Nyawit Team
