# ⚡ Quick Start Guide - PocketCare

Panduan cepat untuk menjalankan aplikasi PocketCare.

## 🚀 Langkah Cepat (5 Menit)

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Jalankan Aplikasi
```bash
flutter run
```

### 3. Register Akun Baru
- Buka aplikasi
- Klik "Daftar"
- Isi form registrasi
- Klik "Daftar"

### 4. Coba Fitur Utama

#### a. Tambah Transaksi
1. Klik tombol **+** (FAB) di Dashboard
2. Pilih tipe: Pemasukan atau Pengeluaran
3. Pilih kategori
4. Input nominal
5. Klik "Simpan Transaksi"

#### b. Set Target Budget
1. Di Dashboard, cek card "Target Bulanan"
2. Klik tombol "Atur"
3. Input target (misal: 1000000)
4. Klik "Simpan"
5. Lihat perubahan warna indikator berdasarkan pengeluaran

#### c. Coba Kategori "Lainnya" (Fitur Spesial)
1. Tambah transaksi pengeluaran
2. Pilih kategori **"Lainnya"**
3. Text field baru akan muncul
4. Ketik nama kategori baru (misal: "Transport")
5. Input nominal
6. Klik "Simpan Transaksi"
7. Cek kategori "Transport" sudah tersedia untuk transaksi berikutnya

#### d. Tambah Reminder
1. Dashboard → Klik icon 🔔 (bell) di header
   ATAU
   Menu → Reminder Pembayaran
2. Klik tombol **+**
3. Input judul reminder
4. Pilih tanggal dan waktu
5. Klik "Simpan Reminder"

#### e. Lihat Grafik Pengeluaran
1. Scroll Dashboard ke bawah
2. Lihat "Grafik Pengeluaran per Kategori"
3. Chart Pie menampilkan persentase per kategori
4. Legend menampilkan nominal per kategori

## 🧪 Testing Cepat

### Run Unit Test
```bash
flutter test
```

### Run Load Test (di dalam aplikasi)
1. Menu → Developer Testing
2. Klik "Run Load Test"
3. Tunggu hasil (1.000 data)

### Run Stress Test (di dalam aplikasi)
1. Menu → Developer Testing
2. Klik "Run Stress Test"
3. Tunggu hasil (20.000 data)
4. Cek waktu eksekusi

## 📱 User Flow Lengkap

```
START
  ↓
Login/Register
  ↓
Dashboard (Lihat Saldo, Budget, Grafik)
  ↓
[4 Opsi]
  ├─ Tambah Transaksi (FAB +)
  ├─ Lihat Semua Transaksi (Menu)
  ├─ Atur Reminder (Bell icon)
  └─ Menu
      ├─ Profil (Edit data user)
      ├─ Developer Testing
      └─ About Us
```

## 🎯 Demo Flow untuk Presentasi

### Skenario 1: First Time User (5 menit)
1. **Register** dengan data:
   - Username: `demo123`
   - Password: `demo123`
   - Nama: `Demo User`
   - Email: `demo@email.com`

2. **Set Target Budget**:
   - Target: `Rp 1.000.000`

3. **Tambah Transaksi Pemasukan**:
   - Kategori: Gaji
   - Nominal: `Rp 5.000.000`

4. **Tambah Transaksi Pengeluaran**:
   - Makanan: `Rp 200.000`
   - Kos: `Rp 1.500.000`
   - Hiburan: `Rp 300.000`

5. **Lihat Dashboard**:
   - Saldo otomatis terhitung
   - Budget indicator menunjukkan warna
   - Chart pie menampilkan breakdown

### Skenario 2: Test Kategori "Lainnya" (3 menit)
1. **Tambah Transaksi Pengeluaran**
2. **Pilih kategori "Lainnya"**
3. **Input kategori custom**: `Transport`
4. **Input nominal**: `Rp 50.000`
5. **Simpan**
6. **Tambah transaksi baru lagi**
7. **Cek dropdown** → Kategori "Transport" sudah ada!

### Skenario 3: Test Budget Warning (3 menit)
1. **Set target**: `Rp 1.000.000`
2. **Tambah pengeluaran**:
   - Transaksi 1: `Rp 400.000` → Indikator 🟢 HIJAU
   - Transaksi 2: `Rp 400.000` → Indikator 🟡 KUNING (80%)
   - Transaksi 3: `Rp 300.000` → Indikator 🔴 MERAH (110%)

### Skenario 4: Load & Stress Test (5 menit)
1. **Menu → Developer Testing**
2. **Run Load Test**:
   - Lihat progress
   - Catat waktu eksekusi
   - Screenshot hasil
3. **Run Stress Test**:
   - Monitor di DevTools (optional)
   - Catat waktu eksekusi
4. **Hapus data test**:
   - Klik "Hapus Semua Data Test"
   - Confirm

## 🐛 Common Issues & Fixes

### Issue: "No device found"
```bash
# Check connected devices
flutter devices

# Start emulator
flutter emulators
flutter emulators --launch <emulator_id>
```

### Issue: "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "CocoaPods not installed" (iOS/macOS)
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### Issue: "Hot reload not working"
```bash
# Press 'R' in terminal untuk hot restart
# atau
flutter run --hot
```

## 📊 Data untuk Testing

### User Test Accounts
```
Username: test1
Password: test123
Email: test1@email.com

Username: test2
Password: test123
Email: test2@email.com
```

### Sample Transactions
```
PEMASUKAN:
- Gaji: Rp 5.000.000
- Uang Jajan: Rp 500.000

PENGELUARAN:
- Makanan: Rp 150.000 (per hari x 30 = 4.500.000)
- Kos: Rp 1.500.000
- Hiburan: Rp 300.000
- Transport: Rp 500.000
```

### Budget Scenarios
```
Scenario A: Aman (Green)
Target: Rp 3.000.000
Expense: Rp 2.000.000 (66%)
Expected: 🟢 GREEN

Scenario B: Warning (Yellow)
Target: Rp 3.000.000
Expense: Rp 2.400.000 (80%)
Expected: 🟡 YELLOW

Scenario C: Danger (Red)
Target: Rp 3.000.000
Expense: Rp 2.800.000 (93%)
Expected: 🔴 RED
```

## 📸 Screenshot Checklist

Ambil screenshot untuk dokumentasi:

- [ ] Login Screen
- [ ] Register Screen
- [ ] Dashboard (dengan data)
- [ ] Add Transaction Screen
- [ ] Transaction List
- [ ] Budget Indicator - Green
- [ ] Budget Indicator - Yellow
- [ ] Budget Indicator - Red
- [ ] Pie Chart dengan data
- [ ] Reminder List
- [ ] Profile Screen
- [ ] About Screen
- [ ] Developer Testing (Load Test Result)
- [ ] Developer Testing (Stress Test Result)

## 🎥 Video Demo Checklist

Record screen untuk demo (max 5 menit):

1. Splash/Login (5 detik)
2. Register new account (15 detik)
3. Dashboard overview (10 detik)
4. Add transaction (20 detik)
5. Show budget indicator (15 detik)
6. Show pie chart (10 detik)
7. Test "Lainnya" category (30 detik)
8. Add reminder (15 detik)
9. View profile (10 detik)
10. Load/Stress test (60 detik)
11. About screen (10 detik)

Total: ~3 menit

## ⚡ Performance Tips

### Untuk Demo yang Smooth
1. **Clear cache sebelum demo**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build release untuk performance**:
   ```bash
   flutter build apk --release
   # atau
   flutter run --release
   ```

3. **Warm up sebelum record**:
   - Buka semua screen sekali
   - Test semua fitur
   - Restart app

### Untuk Testing yang Akurat
1. **Close aplikasi lain**
2. **Gunakan emulator dengan specs tinggi**:
   - RAM: min 4GB
   - Storage: min 8GB
3. **Disable animations** (optional):
   Settings → Developer Options → Animation Scale → Off

## 📞 Need Help?

Check documentation:
- README.md → Overview & Setup
- TESTING_GUIDE.md → Detailed testing instructions

---

**Selamat Menggunakan PocketCare! 💰✨**

Developer: Danang Adiwibowo (123230143) & Gorga Doli L (123230147)
