# 🧪 Panduan Testing PocketCare

Dokumen ini menjelaskan cara melakukan berbagai jenis testing pada aplikasi PocketCare untuk memenuhi syarat UKPL.

## 📚 Daftar Isi

1. [Unit Testing (White-box)](#1-unit-testing-white-box)
2. [Integration Testing](#2-integration-testing)
3. [Black-box Testing](#3-black-box-testing)
4. [Security Testing](#4-security-testing)
5. [Load Testing](#5-load-testing)
6. [Stress Testing](#6-stress-testing)
7. [Performance Testing](#7-performance-testing)

---

## 1. Unit Testing (White-box)

### Tujuan
Menguji logika internal fungsi `BudgetCalculator` yang menentukan warna indikator budget berdasarkan persentase pengeluaran.

### File Test
`test/budget_calculator_test.dart`

### Coverage yang Diuji
- ✅ **Decision Coverage**: Semua kondisi if-else
- ✅ **Path Coverage**: Semua jalur eksekusi
- ✅ **Boundary Value Analysis**: Nilai batas (74.9%, 75%, 89.9%, 90%, 100%)

### Cara Menjalankan

```bash
# Jalankan semua test
flutter test

# Jalankan test spesifik
flutter test test/budget_calculator_test.dart

# Jalankan dengan coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Contoh Test Cases

#### Test Case 1: Expense < 75% (Safe - Green)
```dart
Input: expense = 50000, target = 100000
Expected: Color = Green (#4CAF50)
Result: PASS ✅
```

#### Test Case 2: Expense = 75% (Warning - Yellow)
```dart
Input: expense = 75000, target = 100000
Expected: Color = Yellow (#FFC107)
Result: PASS ✅
```

#### Test Case 3: Expense ≥ 90% (Danger - Red)
```dart
Input: expense = 95000, target = 100000
Expected: Color = Red (#E53935)
Result: PASS ✅
```

### Interpretasi Hasil
- ✅ **PASS**: Fungsi mengembalikan warna yang benar sesuai threshold
- ❌ **FAIL**: Ada bug dalam logika kondisional, perlu diperbaiki

---

## 2. Integration Testing

### Tujuan
Menguji integrasi antar komponen (Provider, Database, UI)

### Skenario Test

#### Skenario 1: User Registration Flow
1. Buka aplikasi → Tampil Login Screen
2. Klik "Daftar" → Tampil Register Screen
3. Isi form registrasi dengan data valid
4. Klik "Daftar" → User berhasil dibuat di database
5. Redirect ke Dashboard
6. Kategori default otomatis dibuat

**Verifikasi:**
- User tersimpan di tabel `users` dengan password ter-hash
- 6 kategori default tersimpan di tabel `categories`
- Dashboard menampilkan nama user yang benar

#### Skenario 2: Add Transaction Flow
1. Login → Dashboard
2. Klik FAB "+" → Add Transaction Screen
3. Pilih tipe "Pengeluaran"
4. Pilih kategori "Makanan"
5. Input nominal: 50000
6. Pilih tanggal
7. Input catatan (opsional)
8. Klik "Simpan Transaksi"
9. Kembali ke Dashboard

**Verifikasi:**
- Transaksi tersimpan di database
- Total pengeluaran bertambah 50000
- Saldo berkurang 50000
- Transaksi muncul di list "Transaksi Terakhir"
- Chart pie menampilkan kategori "Makanan"

#### Skenario 3: Budget Target Flow
1. Dashboard → Klik "Atur" pada card Budget
2. Input target: 1000000
3. Klik "Simpan"
4. Tambah transaksi pengeluaran 500000

**Verifikasi:**
- Target tersimpan di tabel `budgets`
- Progress bar menunjukkan 50%
- Warna indikator HIJAU (safe)
- Pesan: "Pengeluaran masih aman (50.0%)"

#### Skenario 4: "Lainnya" Category Flow
1. Add Transaction Screen
2. Pilih tipe "Pengeluaran"
3. Pilih kategori "Lainnya" dari dropdown
4. Text field baru muncul
5. Input nama kategori baru: "Transport"
6. Input nominal: 20000
7. Klik "Simpan Transaksi"

**Verifikasi:**
- Kategori "Transport" tersimpan di tabel `categories`
- Transaksi menggunakan kategori "Transport"
- Kategori "Transport" muncul di dropdown untuk transaksi berikutnya

---

## 3. Black-box Testing

### Tujuan
Menguji fungsionalitas aplikasi dari perspektif user tanpa melihat kode internal.

### Test Cases

#### TC-001: Login dengan Credentials Valid
| No | Langkah | Data Input | Expected Result | Status |
|----|---------|------------|-----------------|--------|
| 1 | Buka aplikasi | - | Tampil Login Screen | ✅ |
| 2 | Input username | "testuser" | Text terisi | ✅ |
| 3 | Input password | "password123" | Text terisi (hidden) | ✅ |
| 4 | Klik "Masuk" | - | Redirect ke Dashboard | ✅ |

#### TC-002: Login dengan Credentials Invalid
| No | Langkah | Data Input | Expected Result | Status |
|----|---------|------------|-----------------|--------|
| 1 | Input username | "wronguser" | Text terisi | ✅ |
| 2 | Input password | "wrongpass" | Text terisi | ✅ |
| 3 | Klik "Masuk" | - | Snackbar error muncul | ✅ |
| 4 | Cek status | - | Tetap di Login Screen | ✅ |

#### TC-003: Registrasi dengan Username Duplikat
| No | Langkah | Data Input | Expected Result | Status |
|----|---------|------------|-----------------|--------|
| 1 | Klik "Daftar" | - | Tampil Register Screen | ✅ |
| 2 | Input username | "existinguser" | Text terisi | ✅ |
| 3 | Input data lain | Valid data | Form terisi | ✅ |
| 4 | Klik "Daftar" | - | Snackbar error: "Username sudah digunakan" | ✅ |

#### TC-004: Form Validation
| Field | Input | Expected | Status |
|-------|-------|----------|--------|
| Username kosong | "" | Error: "Username tidak boleh kosong" | ✅ |
| Password < 6 char | "12345" | Error: "Password minimal 6 karakter" | ✅ |
| Email invalid | "notanemail" | Error: "Format email tidak valid" | ✅ |
| Nominal = 0 | "0" | Error: "Nominal harus lebih dari 0" | ✅ |
| Password mismatch | "pass1" vs "pass2" | Error: "Password tidak cocok" | ✅ |

#### TC-005: Budget Color Indicator
| Expense | Target | Expected Color | Expected Message | Status |
|---------|--------|----------------|------------------|--------|
| 50,000 | 100,000 | 🟢 GREEN | "Pengeluaran masih aman (50.0%)" | ✅ |
| 75,000 | 100,000 | 🟡 YELLOW | "Hati-hati! Pengeluaran mendekati target (75.0%)" | ✅ |
| 90,000 | 100,000 | 🔴 RED | "Bahaya! Pengeluaran sangat tinggi (90.0%)" | ✅ |
| 120,000 | 100,000 | 🔴 RED | "Bahaya! Target terlampaui (120.0%)" | ✅ |

---

## 4. Security Testing

### Test Cases

#### SEC-001: Password Hashing
**Test:**
1. Register user dengan password "mypassword123"
2. Cek database tabel `users`
3. Verifikasi field `password` tidak berisi plain text

**Expected:**
- Password disimpan sebagai hash SHA-256
- Contoh: `"mypassword123"` → `"ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f"`

**Result:** ✅ PASS

#### SEC-002: SQL Injection Prevention
**Test:**
1. Input username: `"admin' OR '1'='1"`
2. Input password: `"anything"`
3. Klik Login

**Expected:**
- Login gagal
- Tidak ada akses unauthorized
- Tidak ada error SQL

**Result:** ✅ PASS (menggunakan parameterized queries)

#### SEC-003: Input Sanitization
**Test:**
Coba input karakter special di berbagai field:
- `<script>alert('xss')</script>`
- `'; DROP TABLE users; --`
- `../../../etc/passwd`

**Expected:**
- Input diterima sebagai string biasa
- Tidak ada eksekusi script/SQL
- Data tersimpan aman di database

**Result:** ✅ PASS

---

## 5. Load Testing

### Tujuan
Menguji performa aplikasi dengan beban normal (1.000 transaksi)

### Cara Menjalankan

1. Login ke aplikasi
2. Buka menu "Developer Testing"
3. Klik tombol "Run Load Test"
4. Tunggu hingga selesai
5. Catat hasil

### Metrik yang Diukur

- ⏱️ **Waktu Eksekusi Total**: Berapa millisecond untuk insert 1.000 data
- ⚡ **Throughput**: Berapa transaksi per detik
- 💾 **Database Size**: Pertambahan ukuran database

### Target Performa

| Metrik | Target | Acceptable | Status |
|--------|--------|------------|--------|
| Waktu Eksekusi | < 5 detik | < 10 detik | Measure |
| Throughput | > 200 tps | > 100 tps | Measure |
| Memory Usage | < 50 MB | < 100 MB | Measure |

### Contoh Hasil

```
✅ Load Test Berhasil!

📊 Data yang diinsert: 1000 transaksi
⏱️ Waktu eksekusi: 3245 ms (3.25 detik)
⚡ Kecepatan: 308.19 transaksi/detik
```

**Interpretasi:**
- ✅ **PASS**: Waktu < 5 detik, throughput > 200 tps
- ⚠️ **ACCEPTABLE**: Waktu 5-10 detik, throughput 100-200 tps
- ❌ **FAIL**: Waktu > 10 detik, throughput < 100 tps

---

## 6. Stress Testing

### Tujuan
Menguji batas ketahanan aplikasi dengan beban ekstrem (20.000 transaksi)

### Cara Menjalankan

1. Login ke aplikasi
2. Buka menu "Developer Testing"
3. Klik tombol "Run Stress Test"
4. **PENTING**: Buka Flutter DevTools untuk monitoring
   ```bash
   flutter run --observatory-port=8888
   ```
5. Pantau penggunaan RAM/CPU real-time
6. Tunggu hingga selesai (bisa 30-60 detik)

### Metrik yang Diukur

- ⏱️ **Waktu Eksekusi Total**
- 🧠 **Peak Memory Usage** (lihat di DevTools)
- 💻 **CPU Usage** (lihat di DevTools)
- 📱 **App Stability** (apakah crash atau tidak)

### Target Performa

| Metrik | Target | Acceptable | Status |
|--------|--------|------------|--------|
| Waktu Eksekusi | < 30 detik | < 60 detik | Measure |
| Peak Memory | < 200 MB | < 500 MB | Measure |
| CPU Usage | < 80% | < 100% | Measure |
| Crash | No | No | Measure |

### Contoh Hasil

```
✅ Stress Test Berhasil!

📊 Data yang diinsert: 20000 transaksi
⏱️ Waktu eksekusi: 28340 ms (28.34 detik)
⚡ Kecepatan: 705.85 transaksi/detik

💡 Tip: Pantau penggunaan RAM/CPU melalui Flutter DevTools
```

### Monitoring dengan DevTools

1. Buka DevTools di browser
2. Tab "Performance" → lihat CPU usage
3. Tab "Memory" → lihat memory allocation
4. Screenshot grafik untuk dokumentasi

**Screenshot yang Diperlukan:**
- 📸 Memory timeline selama stress test
- 📸 CPU usage chart
- 📸 Performance overlay

---

## 7. Performance Testing

### Frame Rate Test

**Tujuan:** Memastikan UI smooth (60 FPS)

**Cara:**
1. Enable "Performance Overlay" di app
2. Scroll dashboard, transaction list, dll
3. Perhatikan FPS counter

**Target:** 
- 🟢 60 FPS: Sempurna
- 🟡 45-60 FPS: Acceptable
- 🔴 < 45 FPS: Perlu optimasi

### Database Query Performance

**Tujuan:** Mengukur kecepatan query database

**Test Queries:**

```dart
// Query 1: Get all transactions
Stopwatch stopwatch = Stopwatch()..start();
var transactions = await db.getTransactionsByUser(userId);
stopwatch.stop();
print('Query Time: ${stopwatch.elapsedMilliseconds}ms');

// Target: < 100ms for 1000 records
```

**Benchmark:**
| Records | Target Query Time | Status |
|---------|-------------------|--------|
| 100 | < 10ms | Measure |
| 1,000 | < 100ms | Measure |
| 10,000 | < 500ms | Measure |
| 20,000 | < 1000ms | Measure |

---

## 📊 Laporan Testing

### Template Laporan

```
=================================================
LAPORAN TESTING POCKETCARE
=================================================
Developer: [Nama] - [NIM]
Tanggal: [DD/MM/YYYY]
Device: [Android/iOS] [Model]
OS Version: [Version]

1. UNIT TESTING (White-box)
   File: test/budget_calculator_test.dart
   Total Tests: 15
   Passed: 15
   Failed: 0
   Coverage: 100%
   Status: ✅ PASS

2. BLACK-BOX TESTING
   Total Test Cases: 20
   Passed: 18
   Failed: 2
   Pass Rate: 90%
   Status: ⚠️ NEEDS IMPROVEMENT
   
   Failed Cases:
   - TC-012: ...
   - TC-018: ...

3. SECURITY TESTING
   Total Tests: 5
   Passed: 5
   Status: ✅ PASS

4. LOAD TESTING
   Data: 1,000 transaksi
   Time: 3.24 seconds
   Throughput: 308 tps
   Status: ✅ PASS

5. STRESS TESTING
   Data: 20,000 transaksi
   Time: 28.34 seconds
   Peak Memory: 180 MB
   Status: ✅ PASS

KESIMPULAN:
Aplikasi PocketCare telah lulus semua jenis testing
dengan hasil memuaskan. Ready for production.

=================================================
```

---

## 🎯 Checklist Testing untuk Tugas UKPL

Pastikan semua poin ini sudah dicek:

### White-box Testing
- [ ] Unit test file dibuat
- [ ] Semua branch tercovered
- [ ] Boundary value ditest
- [ ] Test coverage > 90%
- [ ] Screenshot coverage report

### Black-box Testing
- [ ] Functional test cases dibuat (min 20)
- [ ] Input validation ditest
- [ ] Error handling ditest
- [ ] Happy path & negative case
- [ ] Screenshot test hasil

### Security Testing
- [ ] Password hashing verified
- [ ] SQL injection tested
- [ ] Input sanitization tested
- [ ] Authorization tested
- [ ] Documentation lengkap

### Load Testing
- [ ] 1.000 data test berhasil
- [ ] Waktu eksekusi dicatat
- [ ] Throughput dihitung
- [ ] Screenshot hasil

### Stress Testing
- [ ] 20.000 data test berhasil
- [ ] Memory usage dimonitor (DevTools)
- [ ] CPU usage dimonitor
- [ ] App tidak crash
- [ ] Screenshot DevTools

### Integration Testing
- [ ] Flow end-to-end ditest
- [ ] Provider integration verified
- [ ] Database cascade tested
- [ ] Documentation lengkap

---

## 📝 Tips Dokumentasi

1. **Screenshot Setiap Test**: Ambil screenshot hasil test
2. **Video Demo**: Record screen saat menjalankan test
3. **Log File**: Save console output ke file
4. **Comparison**: Bandingkan hasil dengan target
5. **Analysis**: Tulis analisis hasil test

---

## 🆘 Troubleshooting

### Test Gagal Dijalankan
```bash
flutter clean
flutter pub get
flutter test
```

### DevTools Tidak Muncul
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Memory Leak
- Pastikan semua controller di-dispose
- Check infinite loops
- Monitor dengan DevTools Memory tab

---

**Happy Testing! 🚀**

*Jika ada pertanyaan, hubungi developer di README.md*
