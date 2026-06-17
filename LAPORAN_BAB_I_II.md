# LAPORAN TUGAS AKHIR
# UJI KUALITAS PERANGKAT LUNAK

---

## PENGEMBANGAN DAN PENGUJIAN APLIKASI MOBILE NYAWIT
### (Aplikasi Pencatatan dan Pengelolaan Keuangan Pribadi Berbasis Flutter dengan Arsitektur MVC)

---

**Disusun oleh:**

**Nama**: [Nama Lengkap]  
**NIM**: [NIM Anda]

---

**PROGRAM STUDI TEKNIK INFORMATIKA**  
**FAKULTAS TEKNOLOGI INDUSTRI**  
**UNIVERSITAS PEMBANGUNAN NASIONAL "VETERAN" YOGYAKARTA**  
**2024**

---

# BAB I  
# PENDAHULUAN

## 1.1 Latar Belakang

Pengelolaan keuangan pribadi merupakan aspek penting dalam kehidupan sehari-hari, terutama bagi mahasiswa dan pekerja muda yang perlu mengatur pengeluaran dengan cermat. Keterbatasan literasi keuangan dan kurangnya alat bantu yang mudah digunakan sering menyebabkan kesulitan dalam melacak arus kas, mengontrol pengeluaran, dan mencapai target keuangan.

Di era digital saat ini, aplikasi mobile menjadi solusi praktis untuk mengatasi permasalahan tersebut. Namun, banyak aplikasi pengelolaan keuangan yang tersedia di pasaran memiliki interface yang kompleks, memerlukan koneksi internet, atau tidak menyediakan fitur notifikasi reminder pembayaran yang efektif.

**Nyawit** (singkatan dari "Nyari Duwit" dalam bahasa Jawa) dikembangkan sebagai aplikasi mobile berbasis Flutter untuk pencatatan dan pengelolaan keuangan pribadi. Aplikasi ini dirancang dengan interface yang sederhana namun fungsional, dapat bekerja secara offline menggunakan database lokal SQLite, dan dilengkapi sistem notifikasi multi-stage untuk reminder pembayaran.

Dalam konteks mata kuliah **Uji Kualitas Perangkat Lunak (UKPL)**, pengembangan aplikasi Nyawit tidak hanya fokus pada implementasi fitur, tetapi juga pada penerapan metodologi pengujian yang komprehensif. Aplikasi ini dibangun menggunakan arsitektur **Model-View-Controller (MVC)** untuk memudahkan testing dan maintenance, serta menerapkan **best practices** keamanan seperti password hashing dengan salt sesuai standar OWASP Mobile Top 10.

Proses pengembangan aplikasi melibatkan berbagai jenis pengujian mulai dari **White-box Testing** untuk menguji logika bisnis, **Black-box Testing** untuk validasi fungsional, **Integration Testing** untuk memastikan integritas data, hingga **Load & Stress Testing** untuk menguji ketahanan aplikasi dengan volume data besar. Setiap bug dan defect yang ditemukan selama proses testing didokumentasikan dan diperbaiki sebagai bagian dari **Software Testing Life Cycle (STLC)**.


## 1.2 Rumusan Masalah

Berdasarkan latar belakang di atas, rumusan masalah dalam penelitian ini adalah:

1. Bagaimana merancang dan mengimplementasikan aplikasi mobile pengelolaan keuangan dengan arsitektur MVC yang mudah diuji (testable)?

2. Bagaimana menerapkan metodologi White-box Testing untuk menguji logika bisnis pada komponen budget calculator?

3. Bagaimana melakukan Black-box Testing untuk memvalidasi fungsionalitas CRUD (Create, Read, Update, Delete) pada fitur transaksi dan reminder?

4. Bagaimana menguji integritas data dan Foreign Key Constraints pada database SQLite untuk memastikan tidak ada data orphan?

5. Bagaimana mengimplementasikan keamanan password dengan teknik salting untuk mencegah Rainbow Table Attacks sesuai standar OWASP?

6. Bagaimana melakukan Load Testing dan Stress Testing untuk menguji performa aplikasi dengan volume data 1.000 hingga 20.000 transaksi?

7. Bagaimana mendokumentasikan dan memperbaiki defect yang ditemukan selama proses testing (Defect Management)?

## 1.3 Batasan Masalah

Untuk menjaga fokus penelitian, batasan masalah yang ditetapkan adalah:

1. **Platform**: Aplikasi dikembangkan khusus untuk platform Android (API Level 21+), tidak mencakup iOS dan web.

2. **Arsitektur**: Menggunakan pola arsitektur Model-View-Controller (MVC) dengan state management Provider.

3. **Database**: Menggunakan SQLite lokal (sqflite), tidak ada fitur cloud sync atau backup online.

4. **Autentikasi**: Sistem autentikasi lokal tanpa integrasi OAuth atau biometric authentication.

5. **Notifikasi**: Notifikasi reminder menggunakan flutter_local_notifications (local notifications), bukan push notification dari server.

6. **Pengujian**: Fokus pada White-box Testing (budget logic), Black-box Testing (functional), Integration Testing (data integrity), dan Performance Testing (load & stress). Tidak mencakup Penetration Testing atau Security Audit eksternal.

7. **User**: Single-user application, tidak ada fitur multi-user atau sharing data antar pengguna.

8. **Bahasa**: Interface aplikasi menggunakan Bahasa Indonesia, tidak ada fitur multi-language.


## 1.4 Tujuan Penelitian

Tujuan dari penelitian dan pengembangan aplikasi Nyawit adalah:

1. Merancang dan mengimplementasikan aplikasi mobile pengelolaan keuangan dengan arsitektur MVC yang clean, maintainable, dan testable.

2. Menerapkan White-box Testing dengan coverage Decision, Path, dan Boundary Value Analysis pada fungsi budget calculator.

3. Melakukan Black-box Testing untuk memvalidasi fungsionalitas utama aplikasi (autentikasi, CRUD transaksi, reminder, budget tracking).

4. Menguji integritas data dengan Integration Testing untuk memastikan Foreign Key Constraints dan Cascade Delete berfungsi dengan baik.

5. Mengimplementasikan keamanan password menggunakan SHA-256 dengan salting (immutable timestamp) sesuai best practices OWASP Mobile Top 10.

6. Melakukan Load Testing (1.000 transaksi) dan Stress Testing (20.000 transaksi) untuk mengukur performa dan ketahanan aplikasi.

7. Mendokumentasikan defect yang ditemukan selama testing, melakukan root cause analysis, dan memverifikasi hasil perbaikan (Fix Verification).

8. Menghasilkan aplikasi yang siap pakai (production-ready) dengan kualitas kode yang baik dan telah melalui proses pengujian yang komprehensif.

## 1.5 Manfaat Penelitian

### 1.5.1 Manfaat Teoritis

1. Memberikan studi kasus nyata tentang penerapan Software Testing Life Cycle (STLC) dalam pengembangan aplikasi mobile.

2. Menunjukkan implementasi praktis dari berbagai metodologi testing: White-box, Black-box, Integration, dan Performance Testing.

3. Memberikan contoh penerapan arsitektur MVC pada Flutter yang memisahkan concerns dengan jelas untuk meningkatkan testability.

4. Mendemonstrasikan pentingnya security best practices (password salting) dalam pengembangan aplikasi mobile.

### 1.5.2 Manfaat Praktis

1. **Bagi Pengguna**: Tersedianya aplikasi pengelolaan keuangan yang mudah digunakan, dapat bekerja offline, dan memiliki fitur reminder dengan notifikasi multi-stage.

2. **Bagi Developer**: Mendapatkan insight tentang proses testing yang comprehensive dan dokumentasi defect management untuk quality assurance.

3. **Bagi Akademisi**: Menyediakan referensi praktis tentang pengujian aplikasi mobile Flutter dengan focus pada data integrity dan security.

4. **Bagi Industri**: Menunjukkan pentingnya integrasi testing sejak awal development cycle untuk menghasilkan software berkualitas tinggi.


## 1.6 Metodologi Penelitian

### 1.6.1 Metode Pengembangan Perangkat Lunak

Penelitian ini menggunakan pendekatan **Iterative Development** dengan prinsip-prinsip Agile, di mana setiap iterasi menghasilkan increment yang dapat diuji. Tahapan pengembangan meliputi:

1. **Requirements Analysis**: Identifikasi kebutuhan fungsional dan non-fungsional aplikasi.
2. **Design**: Perancangan arsitektur MVC, database schema, dan UI/UX design.
3. **Implementation**: Coding dengan Flutter/Dart mengikuti clean code principles.
4. **Testing**: Pengujian di setiap level (unit, integration, system, acceptance).
5. **Bug Fixing & Refinement**: Perbaikan defect dan optimization berdasarkan hasil testing.

### 1.6.2 Metode Pengujian Perangkat Lunak

Penelitian ini menerapkan **Multi-Level Testing Strategy** dengan fokus pada:

#### a. White-box Testing (Structural Testing)
- **Target**: Fungsi `BudgetCalculator.getBudgetStatus()` dan `getBudgetColor()`
- **Coverage**: Decision Coverage, Path Coverage, Boundary Value Analysis
- **Tools**: Flutter Test Framework dengan 29 unit tests
- **Metrics**: Statement coverage, branch coverage, condition coverage

#### b. Black-box Testing (Functional Testing)
- **Target**: Semua fitur user-facing (login, register, CRUD transaksi, reminder, profile)
- **Techniques**: Equivalence Partitioning, Boundary Value Testing
- **Test Cases**: Positive testing, negative testing, edge cases
- **Tools**: Manual testing dengan test scenarios terdokumentasi

#### c. Integration Testing
- **Target**: Integrasi antar komponen (Controller-Service-Database)
- **Focus**: Foreign Key Constraints, Cascade Delete, Data Integrity
- **Verification**: Orphan row detection, referential integrity checks

#### d. Performance Testing
- **Load Testing**: 1.000 transaksi untuk mengukur response time normal
- **Stress Testing**: 20.000 transaksi untuk menemukan breaking point
- **Metrics**: Transactions per second, memory usage, database performance

#### e. Security Testing
- **Focus**: Password hashing dengan SHA-256 + Salt (immutable)
- **Verification**: Rainbow table resistance, salt desynchronization testing
- **Standard**: OWASP Mobile Top 10 compliance

### 1.6.3 Tools dan Teknologi

1. **Development**: Flutter SDK 3.5.4, Dart 3.5.4, Android Studio
2. **Testing**: Flutter Test, Flutter DevTools, SQLite Browser
3. **Version Control**: Git & GitHub
4. **Documentation**: Markdown, Defect Tracking Spreadsheet


## 1.7 Sistematika Penulisan

Laporan tugas akhir ini disusun dengan sistematika sebagai berikut:

**BAB I PENDAHULUAN**  
Berisi latar belakang masalah, rumusan masalah, batasan masalah, tujuan penelitian, manfaat penelitian, metodologi penelitian, dan sistematika penulisan.

**BAB II LANDASAN TEORI**  
Berisi teori-teori yang menjadi dasar pengembangan dan pengujian aplikasi, meliputi: Software Testing, Arsitektur MVC, Flutter Framework, Database SQLite, Keamanan Aplikasi Mobile, dan metodologi pengujian (White-box, Black-box, Integration, Performance Testing).

**BAB III ANALISIS DAN PERANCANGAN SISTEM**  
Berisi analisis kebutuhan sistem, perancangan arsitektur aplikasi, perancangan database, perancangan antarmuka pengguna, dan strategi pengujian yang akan diterapkan.

**BAB IV IMPLEMENTASI DAN PENGUJIAN**  
Berisi implementasi kode aplikasi, hasil pengujian dari setiap level testing (unit, integration, system, performance), dokumentasi defect yang ditemukan, proses bug fixing, dan verifikasi hasil perbaikan.

**BAB V PENUTUP**  
Berisi kesimpulan dari seluruh proses pengembangan dan pengujian, serta saran untuk pengembangan lebih lanjut.

**DAFTAR PUSTAKA**  
Berisi referensi yang digunakan dalam penelitian.

**LAMPIRAN**  
Berisi source code, test cases, defect reports, screenshot aplikasi, dan dokumentasi pendukung lainnya.

---

# BAB II  
# LANDASAN TEORI

## 2.1 Software Testing

### 2.1.1 Definisi Software Testing

Software testing adalah proses evaluasi sistem perangkat lunak atau komponen-komponennya dengan tujuan untuk menemukan apakah sistem memenuhi persyaratan yang ditentukan atau tidak, serta untuk mengidentifikasi perbedaan antara hasil yang diharapkan dengan hasil aktual (IEEE, 1990).

Menurut ISTQB (International Software Testing Qualifications Board), software testing adalah proses yang terdiri dari semua aktivitas siklus hidup, baik statis maupun dinamis, yang berkaitan dengan perencanaan, persiapan, dan evaluasi produk perangkat lunak dan hasil terkait untuk menentukan bahwa mereka memenuhi persyaratan yang ditentukan, untuk mendemonstrasikan bahwa mereka sesuai untuk tujuan dan untuk mendeteksi cacat.

### 2.1.2 Tujuan Software Testing

Tujuan utama dari software testing antara lain:

1. **Menemukan Defect**: Mengidentifikasi bug, error, atau cacat dalam perangkat lunak sebelum dirilis ke pengguna.

2. **Verifikasi Requirement**: Memastikan bahwa perangkat lunak memenuhi spesifikasi dan kebutuhan yang telah didefinisikan.

3. **Validasi Fungsionalitas**: Memvalidasi bahwa sistem berfungsi sesuai dengan ekspektasi pengguna.

4. **Meningkatkan Kualitas**: Meningkatkan kualitas produk dengan mengidentifikasi area yang perlu diperbaiki.

5. **Membangun Kepercayaan**: Memberikan informasi tentang level kualitas perangkat lunak kepada stakeholder.

6. **Mencegah Cacat**: Mencegah terjadinya cacat di masa depan dengan pembelajaran dari testing.


### 2.1.3 Software Testing Life Cycle (STLC)

Software Testing Life Cycle (STLC) adalah serangkaian aktivitas yang dilakukan selama proses testing. STLC memiliki fase-fase yang berbeda yang dijalankan secara terencana dan sistematis.

**Fase-fase STLC:**

1. **Requirement Analysis**: Mempelajari requirement untuk menentukan aspek yang dapat diuji.

2. **Test Planning**: Menentukan strategi testing, resource, timeline, dan tools yang akan digunakan.

3. **Test Case Development**: Membuat test case, test script, dan test data berdasarkan requirement.

4. **Test Environment Setup**: Menyiapkan environment testing (hardware, software, network, test data).

5. **Test Execution**: Menjalankan test case dan membandingkan hasil aktual dengan hasil yang diharapkan.

6. **Test Cycle Closure**: Evaluasi test completion, dokumentasi lessons learned, dan archiving test artifacts.

### 2.1.4 Level Testing

Berdasarkan ISTQB, testing dapat dibagi menjadi beberapa level:

#### a. Unit Testing
Testing pada level komponen individual atau unit terkecil dari kode (fungsi, method, class). Dilakukan oleh developer untuk memverifikasi bahwa setiap unit bekerja sesuai spesifikasi.

**Dalam konteks aplikasi Nyawit:**
- Unit test pada fungsi `BudgetCalculator` untuk testing logika perhitungan budget
- Unit test pada Model classes untuk validasi data structure
- Total 29 unit tests covering models, controllers, dan utilities

#### b. Integration Testing
Testing pada integrasi antar komponen untuk memverifikasi bahwa komponen-komponen yang berbeda dapat bekerja sama dengan baik.

**Dalam konteks aplikasi Nyawit:**
- Testing integrasi Controller dengan DatabaseService
- Testing Foreign Key Constraints dan Cascade Delete di SQLite
- Testing Provider integration dengan UI components

#### c. System Testing
Testing pada sistem secara keseluruhan dalam environment yang menyerupai production untuk memverifikasi bahwa sistem memenuhi requirement.

**Dalam konteks aplikasi Nyawit:**
- End-to-end testing flow: Login → Dashboard → Add Transaction → View History
- Testing notification system dengan ReminderProvider
- Testing complete user journey scenarios

#### d. Acceptance Testing
Testing yang dilakukan untuk memverifikasi bahwa sistem memenuhi acceptance criteria dan siap untuk delivery.

**Dalam konteks aplikasi Nyawit:**
- User Acceptance Testing (UAT) untuk verifikasi kegunaan aplikasi
- Demo di depan dosen pengampu sebagai acceptance criteria


## 2.2 White-box Testing

### 2.2.1 Definisi White-box Testing

White-box testing, juga dikenal sebagai structural testing, clear box testing, atau glass box testing, adalah metodologi pengujian yang berfokus pada struktur internal, desain, dan implementasi kode. Tester memiliki akses penuh ke source code dan menggunakan pengetahuan tentang struktur internal untuk merancang test case.

### 2.2.2 Coverage Criteria

#### a. Statement Coverage
Persentase statement dalam kode yang telah dieksekusi minimal satu kali selama testing.

**Formula**: `Statement Coverage = (Statements Executed / Total Statements) × 100%`

#### b. Decision Coverage (Branch Coverage)
Persentase decision point (if, switch, loop) yang telah dievaluasi ke true dan false minimal satu kali.

**Formula**: `Decision Coverage = (Decisions Tested / Total Decisions) × 100%`

#### c. Path Coverage
Persentase semua possible path dalam control flow graph yang telah dieksekusi.

**Formula**: `Path Coverage = (Paths Executed / Total Paths) × 100%`

#### d. Condition Coverage
Persentase boolean sub-expression dalam setiap decision yang telah dievaluasi ke true dan false.

### 2.2.3 Boundary Value Analysis

Boundary Value Analysis (BVA) adalah teknik testing yang fokus pada nilai batas (boundary) dari input domain. Konsep dasar BVA adalah bahwa error lebih sering terjadi di batas input daripada di tengah input domain.

**Strategi BVA:**
- Test nilai minimum boundary
- Test nilai maximum boundary
- Test nilai tepat di bawah minimum
- Test nilai tepat di atas maximum
- Test nilai normal di tengah range

**Contoh dalam Budget Calculator:**
```
Target Budget: 100.000
Threshold: 50% (Safe), 80% (Warning)

Test Cases:
- Expense = 0 (minimum)
- Expense = 49.999 (tepat sebelum warning)
- Expense = 50.000 (boundary warning)
- Expense = 79.999 (tepat sebelum danger)
- Expense = 80.000 (boundary danger)
- Expense = 100.000 (maximum = target)
- Expense = 150.000 (over budget)
- Expense = -1000 (negative - invalid boundary)
```

### 2.2.4 Aplikasi White-box Testing pada Nyawit

Pada aplikasi Nyawit, white-box testing diterapkan pada fungsi `BudgetCalculator.getBudgetStatus()` dengan coverage:

1. **Decision Coverage**: Semua if-else branch diuji (safe, warning, danger)
2. **Path Coverage**: Semua execution path dieksekusi
3. **Boundary Value Analysis**: Test pada threshold 50%, 80%, negative values, zero values

Test cases dirancang untuk mencapai 100% code coverage pada fungsi target.
