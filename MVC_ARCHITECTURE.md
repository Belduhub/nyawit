# 🏗️ Arsitektur MVC - PocketCare

## Penjelasan MVC Pattern

Aplikasi PocketCare dibangun menggunakan **MVC (Model-View-Controller)** pattern untuk memisahkan logika bisnis, tampilan UI, dan data model.

## Struktur Folder MVC

```
lib/
├── main.dart                          # Entry point aplikasi
│
├── models/                            # MODEL - Data Models
│   ├── user_model.dart               # Model untuk User
│   ├── transaction_model.dart        # Model untuk Transaction (dengan alias)
│   ├── category_model.dart           # Model untuk Category
│   └── reminder_model.dart           # Model untuk Reminder
│
├── views/                             # VIEW - UI Layer
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
│
├── controllers/                       # CONTROLLER - Business Logic
│   ├── auth_controller.dart          # Logic autentikasi
│   ├── transaction_controller.dart   # Logic transaksi
│   ├── category_controller.dart      # Logic kategori
│   ├── budget_controller.dart        # Logic budget
│   └── reminder_controller.dart      # Logic reminder
│
├── services/                          # SERVICE Layer
│   └── database_service.dart         # SQLite database service
│
├── providers/                         # State Management (Provider)
│   ├── auth_provider.dart
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   ├── budget_provider.dart
│   └── reminder_provider.dart
│
├── utils/                             # Utilities
│   ├── constants.dart                # App constants & colors
│   └── budget_calculator.dart        # Budget calculation logic
│
└── widgets/                           # Reusable Widgets
    ├── custom_button.dart
    ├── custom_text_field.dart
    └── transaction_card.dart
```

## Komponen MVC

### 1. MODEL (Data Layer)

**Lokasi**: `lib/models/`

**Fungsi**: Mengelola struktur data dan business rules untuk data.

**File**:
- `user_model.dart` - Data user dengan hash password
- `transaction_model.dart` - Data transaksi (income/expense)
- `category_model.dart` - Kategori transaksi
- `reminder_model.dart` - Reminder pembayaran

**Contoh**:
```dart
class User {
  final int? id;
  final String username;
  final String password;
  final String fullName;
  final String email;
  
  // Methods: toMap(), fromMap(), copyWith()
}
```

**Karakteristik**:
- Pure data classes
- Tidak ada logic UI
- Memiliki methods untuk konversi (toMap, fromMap)
- Immutable dengan copyWith()

---

### 2. VIEW (Presentation Layer)

**Lokasi**: `lib/views/`

**Fungsi**: Menampilkan UI dan menerima input dari user.

**Struktur**:
```
views/
├── auth/           # Halaman autentikasi
├── dashboard/      # Halaman utama
├── profile/        # Halaman profil user
├── transaction/    # Halaman transaksi
├── reminder/       # Halaman reminder
├── about/          # Halaman about
└── testing/        # Halaman developer testing
```

**Karakteristik**:
- Widget Flutter untuk UI
- Menggunakan Provider untuk state management
- Memanggil Controller untuk business logic
- Hanya bertanggung jawab untuk tampilan

**Contoh**:
```dart
class LoginScreen extends StatefulWidget {
  // UI components
  // Event handlers yang memanggil Controller
}
```

---

### 3. CONTROLLER (Business Logic Layer)

**Lokasi**: `lib/controllers/`

**Fungsi**: Mengelola business logic dan komunikasi antara View dan Model.

**File**:
- `auth_controller.dart` - Logic login, register, update profile
- `transaction_controller.dart` - Logic CRUD transaksi, bulk insert
- `category_controller.dart` - Logic kelola kategori
- `budget_controller.dart` - Logic perhitungan budget
- `reminder_controller.dart` - Logic reminder & notifikasi

**Contoh**:
```dart
class AuthController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  User? _currentUser;
  
  // Business logic methods
  Future<bool> login(String username, String password) {
    // Validation
    // Call database service
    // Update state
  }
  
  Future<bool> register(...) { }
  Future<bool> updateProfile(...) { }
}
```

**Karakteristik**:
- Tidak ada UI code
- Berisi pure business logic
- Memanggil Service layer (Database)
- Return hasil ke View via Provider

---

### 4. SERVICE Layer

**Lokasi**: `lib/services/`

**Fungsi**: Mengelola operasi database dan external services.

**File**:
- `database_service.dart` - SQLite operations dengan singleton pattern

**Contoh**:
```dart
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  
  // Database operations
  Future<User?> loginUser(String username, String password) { }
  Future<int> createTransaction(models.Transaction t) { }
  Future<List<models.Transaction>> getTransactionsByUser(int userId) { }
}
```

**Karakteristik**:
- Singleton pattern untuk database connection
- CRUD operations
- Raw SQL queries
- No business logic

---

### 5. PROVIDER (State Management)

**Lokasi**: `lib/providers/`

**Fungsi**: Mengelola state aplikasi menggunakan Provider pattern.

**File**:
- `auth_provider.dart` - State autentikasi
- `transaction_provider.dart` - State transaksi
- `category_provider.dart` - State kategori
- `budget_provider.dart` - State budget
- `reminder_provider.dart` - State reminder

**Contoh**:
```dart
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  
  // Getters
  User? get currentUser => _currentUser;
  
  // Methods that call Controller
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners(); // Update UI
    
    // Call controller
    final success = await authController.login(username, password);
    
    _isLoading = false;
    notifyListeners(); // Update UI
    return success;
  }
}
```

---

## Flow Data dalam MVC

### Flow 1: User Login

```
┌──────────┐     ┌──────────┐     ┌────────────┐     ┌─────────┐
│   VIEW   │────▶│ PROVIDER │────▶│ CONTROLLER │────▶│ SERVICE │
│ (Login)  │     │ (Auth)   │     │  (Auth)    │     │  (DB)   │
└──────────┘     └──────────┘     └────────────┘     └─────────┘
     ▲                 │                  │                │
     │                 │                  │                │
     └─────────────────┴──────────────────┴────────────────┘
            notifyListeners() ← Update State
```

**Langkah**:
1. **VIEW**: User input username & password → klik "Masuk"
2. **PROVIDER**: `login()` dipanggil → set loading state
3. **CONTROLLER**: Validasi input → panggil DatabaseService
4. **SERVICE**: Query database → return User atau null
5. **CONTROLLER**: Update current user
6. **PROVIDER**: `notifyListeners()` → update UI
7. **VIEW**: Navigate ke Dashboard atau tampilkan error

### Flow 2: Tambah Transaksi

```
USER INPUT
    ↓
AddTransactionScreen (VIEW)
    ↓
TransactionProvider (PROVIDER)
    ↓
TransactionController (CONTROLLER)
    ↓
DatabaseService (SERVICE)
    ↓
SQLite Database
    ↓
← Return Success/Fail
    ↓
← notifyListeners()
    ↓
UI Updated (Dashboard, List)
```

---

## Keuntungan MVC Pattern

### 1. **Separation of Concerns**
- Model: Data & business rules
- View: UI & presentation
- Controller: Business logic
- Setiap layer punya tanggung jawab jelas

### 2. **Testability**
- Controller bisa ditest tanpa UI
- Model bisa ditest independent
- Business logic terpisah dari UI logic

**Contoh Unit Test**:
```dart
test('login should return true with valid credentials', () async {
  final controller = AuthController();
  final result = await controller.login('testuser', 'testpass');
  expect(result, true);
});
```

### 3. **Maintainability**
- Mudah menemukan dan memperbaiki bug
- Perubahan di satu layer tidak affect layer lain
- Code lebih organized dan readable

### 4. **Reusability**
- Controller bisa dipakai di multiple Views
- Model bisa dipakai di berbagai context
- Service bisa di-share across controllers

### 5. **Scalability**
- Mudah menambah fitur baru
- Mudah mengganti UI tanpa ubah logic
- Mudah mengganti database tanpa ubah Controller

---

## Special Case: Transaction Model

**Problem**: Nama class `Transaction` konflik dengan `sqflite` package.

**Solution**: Gunakan alias untuk model kita.

```dart
// Import dengan alias
import '../models/transaction_model.dart' as models;

// Penggunaan
List<models.Transaction> transactions = [];
models.Transaction newTransaction = models.Transaction(...);
```

**Files yang menggunakan alias**:
- `database_service.dart`
- `transaction_controller.dart`
- `transaction_provider.dart`
- `transaction_card.dart`
- `developer_testing_screen.dart`

---

## Best Practices yang Diterapkan

### 1. Naming Convention
```
Models:     user_model.dart, transaction_model.dart
Controllers: auth_controller.dart, transaction_controller.dart
Providers:   auth_provider.dart, transaction_provider.dart
Views:       login_screen.dart, dashboard_screen.dart
Services:    database_service.dart
```

### 2. Singleton Pattern
```dart
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();
  // Only one instance throughout the app
}
```

### 3. Dependency Injection
```dart
class TransactionController {
  final DatabaseService _dbService = DatabaseService.instance;
  // Controller depends on Service
}
```

### 4. Async/Await Pattern
```dart
Future<bool> login(String username, String password) async {
  try {
    final user = await _dbService.loginUser(username, password);
    return user != null;
  } catch (e) {
    return false;
  }
}
```

### 5. Error Handling
```dart
try {
  // Operation
} catch (e) {
  print('Error: $e');
  _errorMessage = e.toString();
  return false;
}
```

---

## Testing Strategy

### Unit Testing
**Target**: Controllers & Utils

```dart
test('getBudgetColor returns green when safe', () {
  final color = BudgetCalculator.getBudgetColor(50000, 100000);
  expect(color, AppColors.budgetSafe);
});
```

### Integration Testing
**Target**: Controller + Service

```dart
test('login with valid credentials', () async {
  final controller = AuthController();
  final result = await controller.login('test', 'test123');
  expect(result, true);
  expect(controller.currentUser, isNotNull);
});
```

### Widget Testing
**Target**: Views

```dart
testWidgets('Login screen shows error on invalid login', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.enterText(find.byKey(Key('username')), 'wrong');
  await tester.tap(find.text('Masuk'));
  await tester.pump();
  expect(find.text('Username atau password salah'), findsOneWidget);
});
```

---

## Diagram Arsitektur Lengkap

```
┌─────────────────────────────────────────────────────┐
│                    PRESENTATION                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │  Login   │  │Dashboard │  │ Profile  │  ...     │
│  │  Screen  │  │  Screen  │  │  Screen  │          │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘          │
│       │             │              │                 │
└───────┼─────────────┼──────────────┼─────────────────┘
        │             │              │
┌───────▼─────────────▼──────────────▼─────────────────┐
│              STATE MANAGEMENT                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │   Auth   │  │Transaction│ │  Budget  │  ...      │
│  │ Provider │  │ Provider  │  │ Provider │           │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘           │
└───────┼─────────────┼──────────────┼─────────────────┘
        │             │              │
┌───────▼─────────────▼──────────────▼─────────────────┐
│               BUSINESS LOGIC                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │   Auth   │  │Transaction│ │  Budget  │  ...      │
│  │Controller│  │Controller │  │Controller│           │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘           │
└───────┼─────────────┼──────────────┼─────────────────┘
        │             │              │
┌───────▼─────────────▼──────────────▼─────────────────┐
│                   SERVICES                            │
│         ┌──────────────────────────┐                 │
│         │   DatabaseService        │                 │
│         │    (SQLite)              │                 │
│         └────────┬─────────────────┘                 │
└──────────────────┼───────────────────────────────────┘
                   │
┌──────────────────▼───────────────────────────────────┐
│                   DATA                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │   User   │  │Transaction│ │ Category │  ...      │
│  │  Model   │  │   Model   │  │  Model   │           │
│  └──────────┘  └──────────┘  └──────────┘           │
└───────────────────────────────────────────────────────┘
```

---

## Migration dari Provider ke MVC

Jika sebelumnya menggunakan pure Provider pattern:

**Before (Provider Pattern)**:
```dart
// All logic in Provider
class AuthProvider with ChangeNotifier {
  Future<bool> login() {
    // Database access
    // Business logic
    // State management
  }
}
```

**After (MVC Pattern)**:
```dart
// Separated into layers

// Controller: Business logic
class AuthController {
  Future<bool> login() {
    // Business logic only
  }
}

// Provider: State management
class AuthProvider with ChangeNotifier {
  Future<bool> login() {
    // Call controller
    // Update state
    notifyListeners();
  }
}

// Service: Database access
class DatabaseService {
  Future<User?> loginUser() {
    // Database query
  }
}
```

---

## Kesimpulan

MVC Pattern membuat aplikasi PocketCare:
- ✅ **Lebih terstruktur** - Setiap file punya tanggung jawab jelas
- ✅ **Mudah ditest** - Business logic terpisah dari UI
- ✅ **Maintainable** - Mudah debug dan update
- ✅ **Scalable** - Mudah tambah fitur baru
- ✅ **Memenuhi standar UKPL** - Arsitektur yang baik untuk testing

---

**Happy Coding with MVC! 🚀**

Developer: Danang Adiwibowo (123230143) & Gorga Doli L (123230147)
