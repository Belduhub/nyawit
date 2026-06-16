# PocketCare - Aplikasi Pencatat & Pengelola Keuangan

![Flutter](https://img.shields.io/badge/Flutter-3.11.0-blue)
![Dart](https://img.shields.io/badge/Dart-3.0.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)

Aplikasi manajemen keuangan pribadi yang dibangun dengan Flutter untuk memenuhi tugas mata kuliah **Uji Kualitas Perangkat Lunak (UKPL)**.

## 👨‍💻 Developer

- **Danang Adiwibowo** - NIM: 123230143
- **Gorga Doli L** - NIM: 123230147

## 📋 Deskripsi

PocketCare adalah aplikasi mobile untuk mencatat dan mengelola keuangan pribadi dengan fitur-fitur lengkap seperti pencatatan transaksi, dashboard analitik, target budget bulanan, dan reminder pembayaran. Aplikasi ini dirancang dengan arsitektur yang terstruktur dan mudah diuji untuk memenuhi standar kualitas perangkat lunak.

## ✨ Fitur Utama

### 1. Autentikasi
- ✅ Registrasi user baru
- ✅ Login dengan username & password
- ✅ Password terenkripsi dengan SHA-256
- ✅ Validasi form input

### 2. Profil User
- ✅ Lihat profil lengkap
- ✅ Edit informasi profil (nama, email, telepon)
- ✅ Display avatar dengan inisial nama

### 3. Kelola Transaksi (CRUD)
- ✅ Tambah transaksi pemasukan/pengeluaran
- ✅ Pilih kategori dari dropdown
- ✅ Kategori bawaan:
  - **Pemasukan**: Gaji, Uang Jajan
  - **Pengeluaran**: Makanan, Kos, Hiburan, Lainnya
- ✅ **Fitur Khusus "Lainnya"**: Ketika user memilih kategori "Lainnya", muncul text field baru untuk menambah kategori custom ke database
- ✅ Input nominal, tanggal, dan catatan
- ✅ Edit dan hapus transaksi
- ✅ Filter transaksi (semua/pemasukan/pengeluaran)

### 4. Dashboard Analitik
- ✅ Card saldo dengan gradient design
- ✅ Total pemasukan, pengeluaran, dan saldo
- ✅ **Indikator Target Budget Bulanan** dengan warna dinamis:
  - 🟢 **HIJAU**: Pengeluaran < 75% dari target (aman)
  - 🟡 **KUNING**: Pengeluaran 75-89% dari target (peringatan)
  - 🔴 **MERAH**: Pengeluaran ≥ 90% dari target (bahaya)
- ✅ Progress bar budget dengan persentase
- ✅ **Chart Pie Pengeluaran per Kategori** menggunakan `fl_chart`
- ✅ Legend dengan breakdown nominal per kategori
- ✅ List 5 transaksi terakhir
- ✅ Pull to refresh

### 5. Reminder Pembayaran
- ✅ Tambah reminder dengan judul, deskripsi, tanggal & waktu
- ✅ Tandai reminder sebagai selesai
- ✅ Hapus reminder
- ✅ Indikator visual untuk reminder yang sudah lewat

### 6. About Us
- ✅ Informasi aplikasi
- ✅ Informasi developer dengan NIM
- ✅ Daftar fitur aplikasi

### 7. Developer Testing (STLC)
- ✅ **Load Test**: Insert 1.000 data transaksi
- ✅ **Stress Test**: Insert 20.000 data transaksi secara massal
- ✅ Tampilan waktu eksekusi dalam milidetik
- ✅ Perhitungan kecepatan transaksi per detik
- ✅ Progress indicator untuk stress test
- ✅ Tombol clear data test

## 🏗️ Struktur Project

```
lib/
├── main.dart                          # Entry point aplikasi
├── models/                            # Data models
│   ├── user.dart
│   ├── transaction.dart
│   ├── category.dart
│   └── reminder.dart
├── providers/                         # State management (Provider)
│   ├── auth_provider.dart
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   ├── budget_provider.dart
│   └── reminder_provider.dart
├── database/                          # Database layer
│   └── database_helper.dart           # SQLite helper
├── screens/                           # UI Screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
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
├── widgets/                           # Reusable widgets
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   └── transaction_card.dart
└── utils/                             # Utility classes
    ├── constants.dart                 # App constants & colors
    └── budget_calculator.dart         # Budget logic (White-box testing)

test/
└── budget_calculator_test.dart        # Unit tests
```

## 🎨 Design System

### Color Palette (Dark Theme)
- **Primary Dark**: `#122032` - Background utama
- **Secondary Dark**: `#1E2A3A` - Background sekunder
- **Accent Blue**: `#2196F3` - Tombol utama
- **Accent Green**: `#4CAF50` - Pemasukan & success
- **Accent Red**: `#E53935` - Pengeluaran & danger
- **Accent Yellow**: `#FFC107` - Warning
- **Card Background**: `#263647` - Background card

### Typography
- **Heading 1**: 32px, Bold
- **Heading 2**: 24px, Bold
- **Heading 3**: 20px, SemiBold
- **Body Large**: 16px
- **Body Medium**: 14px
- **Body Small**: 12px

## 🧪 Testing

### Unit Testing (White-box)
File: `test/budget_calculator_test.dart`

Menguji logika penentu warna indikator budget dengan coverage:
- ✅ Decision Coverage (semua kondisi if-else)
- ✅ Path Coverage (semua jalur eksekusi)
- ✅ Boundary Value Analysis (nilai batas threshold)

Contoh test cases:
```dart
// Test: Expense < 75% target → GREEN
getBudgetColor(50000, 100000) → AppColors.budgetSafe

// Test: Expense 75-89% target → YELLOW
getBudgetColor(80000, 100000) → AppColors.budgetWarning

// Test: Expense ≥ 90% target → RED
getBudgetColor(95000, 100000) → AppColors.budgetDanger
```

Jalankan test dengan:
```bash
flutter test test/budget_calculator_test.dart
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
  provider: ^6.1.1              # State management
  sqflite: ^2.3.0              # SQLite database
  path_provider: ^2.1.1        # Path utilities
  fl_chart: ^0.65.0            # Charts
  intl: ^0.18.1                # Internationalization & formatting
  flutter_local_notifications: ^16.3.0  # Notifications
  timezone: ^0.9.2             # Timezone support
  crypto: ^3.0.3               # Password hashing
```

## 🔐 Security Features

- ✅ Password hashing dengan SHA-256
- ✅ SQL injection prevention dengan parameterized queries
- ✅ Input validation di semua form
- ✅ Cascade delete untuk data integrity

## 📊 Database Schema

### users
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
username TEXT NOT NULL UNIQUE
password TEXT NOT NULL (SHA-256 hashed)
full_name TEXT NOT NULL
email TEXT NOT NULL
phone TEXT
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
- Unit test pada `BudgetCalculator.getBudgetColor()`
- Coverage: semua branch, path, dan boundary values
- File: `test/budget_calculator_test.dart`

### 2. Black-box Testing
Skenario pengujian fungsional:
- Login dengan credentials valid/invalid
- Registrasi dengan data duplikat
- Tambah transaksi dengan kategori "Lainnya"
- Edit dan hapus transaksi
- Set target budget dan lihat perubahan warna
- Tambah reminder dengan tanggal masa depan

### 3. Security Testing
- Password hashing verification
- SQL injection testing
- Input validation testing
- Authorization testing

### 4. Load Testing
- Insert 1.000 transaksi dalam satu operasi
- Measure response time
- Check database performance

### 5. Stress Testing
- Insert 20.000 transaksi secara massal
- Monitor memory usage dengan DevTools
- Check application stability

### 6. Integration Testing
- Test flow: Login → Dashboard → Tambah Transaksi → Lihat di Dashboard
- Test Provider integration dengan Database
- Test cascade delete (hapus user → hapus semua data terkait)

## 📝 Catatan Penting

1. **Kategori "Lainnya"**: Saat user memilih kategori "Lainnya" di form transaksi, akan muncul text field tambahan untuk input nama kategori baru. Jika diisi, kategori tersebut akan ditambahkan ke database dan bisa digunakan untuk transaksi berikutnya.

2. **Logika Warna Budget** (untuk White-box Testing):
   - Safe (Green): `expense / target < 0.75`
   - Warning (Yellow): `0.75 ≤ expense / target < 0.90`
   - Danger (Red): `expense / target ≥ 0.90`

3. **Developer Testing**: Setelah menjalankan Load/Stress Test, gunakan tombol "Hapus Semua Data Test" untuk membersihkan database.

4. **Performance Monitoring**: Untuk melihat penggunaan RAM/CPU saat Stress Test, buka Flutter DevTools:
   ```bash
   flutter run --observatory-port=8888
   # Kemudian buka browser ke URL yang ditampilkan
   ```

## 🐛 Known Issues & Limitations

- Notifikasi reminder belum fully implemented (hanya placeholder)
- Export/Import data belum tersedia
- Dark theme only (belum ada light theme)

## 📄 License

MIT License - Dibuat untuk keperluan akademik UKPL

## 🙏 Acknowledgments

- Flutter Team untuk framework yang luar biasa
- fl_chart package untuk chart library
- SQLite untuk database management
- Dosen pengampu UKPL untuk guidance

---

**Dibuat dengan ❤️ oleh Danang Adiwibowo & Gorga Doli L**

*Universitas Pembangunan Nasional "Veteran" Yogyakarta*  
*Semester 6 - 2024*
