# 🔄 Migration Guide - Nyawit v1.2.0

## ⚠️ BREAKING CHANGES Alert!

Jika kamu mengalami masalah setelah update kode (navbar hilang, tidak bisa login, fitur tidak muncul), ini karena ada **breaking changes** pada security fixes:

---

## 🐛 Problem: Navbar & Fitur Hilang

### Gejala:
- ✅ Aplikasi bisa dibuka
- ❌ Navbar di bawah tidak muncul
- ❌ Fitur-fitur dashboard kosong
- ❌ Tidak bisa login dengan user lama

### Root Cause:

#### 1. Database File Berubah
- **OLD**: `pocketcare.db`
- **NEW**: `nyawit.db`
- **Impact**: Data user lama tidak ter-load

#### 2. Password Hashing Algorithm Berubah
- **OLD**: `SHA256(password + salt + username)`
- **NEW**: `SHA256(password + salt + created_at_timestamp)`
- **Impact**: Hash password lama tidak cocok dengan algorithm baru

---

## ✅ Solusi: 3 Options

### Option 1: Register User Baru (RECOMMENDED untuk Testing)

**Steps:**
1. Buka aplikasi
2. Klik tombol "Register"
3. Isi data:
   - Nama Lengkap: [nama]
   - Username: [username_baru]
   - Password: [password] (min 6 karakter)
4. Klik "Register"
5. Login dengan credentials yang baru dibuat

**Result:**
- ✅ User baru tersimpan di `nyawit.db`
- ✅ Password ter-hash dengan algorithm baru
- ✅ Navbar dan semua fitur muncul normal
- ✅ Dashboard, History, Reminders, Profile tab berfungsi

---

### Option 2: Clear App Data (Hard Reset)

Untuk device fisik atau emulator:

#### Android Emulator:
1. Tutup aplikasi
2. Buka Settings → Apps → Nyawit
3. Storage → Clear Data → Clear Cache
4. Buka aplikasi lagi
5. Register user baru

#### Command Line:
```bash
# Uninstall dan install ulang
flutter clean
flutter pub get
flutter run
```

---

### Option 3: Manual Database Delete (untuk Developer)

Jika kamu punya akses ke file system:

#### Lokasi Database:
```
Android: /data/data/com.example.nyawit/databases/
File lama: pocketcare.db
File baru: nyawit.db
```

**Steps:**
1. Hapus file `pocketcare.db` (jika ada)
2. Hapus file `nyawit.db` (jika ada)
3. Restart aplikasi
4. Register user baru

**Command via ADB:**
```bash
adb shell
cd /data/data/com.example.nyawit/databases/
ls
rm pocketcare.db
rm nyawit.db
exit
```

---

## 🔍 Verification Checklist

Setelah register user baru, verify bahwa:

- [ ] **Login berhasil** dengan credentials baru
- [ ] **Bottom Navigation** muncul dengan 4 tabs (Home, History, Reminders, Profile)
- [ ] **Dashboard** menampilkan:
  - [ ] Balance card (hijau)
  - [ ] Total pemasukan/pengeluaran
  - [ ] Target budget (set dulu)
  - [ ] Grafik pengeluaran (setelah ada data)
  - [ ] Transaksi terakhir (setelah ada data)
- [ ] **History Tab** bisa diakses (kosong jika belum ada transaksi)
- [ ] **Reminders Tab** bisa diakses (kosong jika belum ada reminder)
- [ ] **Profile Tab** menampilkan:
  - [ ] Info cards (Nama, Username, Password tersembunyi)
  - [ ] Button Edit Profile
  - [ ] Button Developer Testing
  - [ ] Button About Us
  - [ ] Button Logout
- [ ] **Floating Action Button** (+) untuk tambah transaksi muncul di Dashboard

---

## 📝 Test Flow Lengkap

### 1. Test Register & Login
```
1. Register user baru
2. Logout
3. Login kembali dengan credentials yang sama
4. Pastikan masuk ke MainScreen dengan navbar
```

### 2. Test Bottom Navigation
```
1. Klik tab "Home" → Dashboard muncul
2. Klik tab "History" → Transaction list muncul
3. Klik tab "Reminders" → Reminder list muncul
4. Klik tab "Profile" → Profile screen dengan menu muncul
```

### 3. Test Add Transaction
```
1. Di Dashboard, klik FAB (+) hijau
2. Pilih tipe: Pemasukan/Pengeluaran
3. Isi nominal: 50000
4. Pilih kategori: Makanan
5. Isi catatan: "Makan siang"
6. Pilih tanggal
7. Klik "Simpan"
8. Verify transaksi muncul di Dashboard
9. Verify transaksi muncul di History tab
```

### 4. Test Profile Menu
```
1. Klik tab "Profile"
2. Klik "Edit Profile" → bisa edit nama, username, password
3. Klik "Developer Testing" → masuk ke testing screen
4. Klik "About Us" → masuk ke about screen
5. Klik "Logout" → kembali ke login screen
```

---

## 🚨 Troubleshooting

### Problem: Masih tidak bisa login setelah register
**Solution:**
- Pastikan password minimal 6 karakter
- Pastikan username unique (belum dipakai)
- Cek console log untuk error message

### Problem: Navbar masih tidak muncul
**Solution:**
- Verify kamu berhasil login (check console log)
- Pastikan `main_screen.dart` sudah ter-import di `login_screen.dart`
- Cek `MainScreen` di file `lib/views/main/main_screen.dart` exist

### Problem: Fitur kosong semua
**Solution:**
- Normal! Database baru kosong
- Tambah data transaksi dulu dengan FAB (+)
- Set target budget dulu dari dashboard
- Tambah reminder dari Reminders tab

### Problem: Error saat build
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 💡 Why These Changes?

### 1. Database Name Change (pocketcare.db → nyawit.db)
- **Reason**: Konsistensi identitas aplikasi
- **Benefit**: Clear separation dari template lama
- **Impact**: Data lama tidak ter-migrate otomatis

### 2. Password Hashing Change (username → created_at)
- **Reason**: Fix **Salt Desynchronization Bug**
- **Problem**: Username bisa berubah → hash password jadi invalid
- **Solution**: Gunakan `created_at` timestamp (immutable)
- **Benefit**: User bisa edit username tanpa lockout

---

## 📚 Untuk Laporan TA

Dokumentasikan breaking changes ini di:

**BAB IV - Implementasi & Pengujian**
- Sub-bab: Defect Management
- Defect ID: DEF-002 (Salt Desynchronization)
- Severity: Critical
- Fix: Change salt from mutable (username) to immutable (created_at)
- Migration: Require user re-registration

**BAB IV - Hasil Pengujian**
- Sub-bab: Security Testing Results
- Test: Username edit without breaking authentication
- Before Fix: FAIL (permanent lockout)
- After Fix: PASS (seamless login)

---

## ✅ Final Checklist Before Demo

- [ ] Fresh install aplikasi
- [ ] Register 1-2 user test
- [ ] Tambah 10-20 transaksi sample
- [ ] Set target budget
- [ ] Tambah 2-3 reminder
- [ ] Test semua bottom navigation tabs
- [ ] Test edit profile (nama & username)
- [ ] Screenshot semua screen untuk laporan
- [ ] Backup database file untuk safety

---

**Status**: ✅ Breaking changes documented  
**Impact**: User must re-register after security fixes  
**Workaround**: None (security upgrade necessary)  
**Long-term**: Consider implementing data migration script

---

Jika masih ada masalah, cek file:
- `CRITICAL_FIXES_ROUND2.md` untuk detail technical fix
- `SECURITY_FIXES.md` untuk context security improvements
- `DEVELOPMENT_SUMMARY.md` untuk full changelog
