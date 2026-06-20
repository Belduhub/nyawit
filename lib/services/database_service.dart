import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/transaction_model.dart' as models;
import '../models/category_model.dart';
import '../models/reminder_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nyawit.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      // CRITICAL: Aktifkan Foreign Key Constraints di SQLite
      // Tanpa ini, CASCADE DELETE tidak akan berfungsi!
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Migrate to simplified user table (only name, username, password)
      await db.execute('''
        CREATE TABLE users_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          full_name TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
      
      // Copy existing data (without email and phone)
      await db.execute('''
        INSERT INTO users_new (id, username, password, full_name, created_at)
        SELECT id, username, password, full_name, created_at FROM users
      ''');
      
      // Drop old table
      await db.execute('DROP TABLE users');
      
      // Rename new table
      await db.execute('ALTER TABLE users_new RENAME TO users');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        username $textType UNIQUE,
        password $textType,
        full_name $textType,
        created_at $textType
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id $idType,
        name $textType,
        type $textType,
        is_default $intType DEFAULT 0,
        user_id $intType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        user_id $intType,
        category_id $intType,
        amount $realType,
        type $textType,
        date $textType,
        note TEXT,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id $idType,
        user_id $intType,
        title $textType,
        description TEXT,
        reminder_date $textType,
        is_completed $intType DEFAULT 0,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Budget table for monthly targets
    await db.execute('''
      CREATE TABLE budgets (
        id $idType,
        user_id $intType,
        monthly_target $realType,
        month $intType,
        year $intType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // Hash password for security with salt
  // Salt mencegah rainbow table attacks sesuai OWASP Mobile Top 10
  // CRITICAL: Menggunakan created_at sebagai user-specific salt (immutable)
  // Tidak pakai username karena username bisa berubah (salt desynchronization bug)
  String _hashPassword(String password, String userCreatedAtString) {
    // Tambahkan salt unik untuk setiap user
    const appSalt = 'nyawit_secure_2024'; // Application-wide salt
    final userSalt = userCreatedAtString; // User-specific salt (immutable timestamp string)
    final saltedPassword = password + appSalt + userSalt;
    
    var bytes = utf8.encode(saltedPassword);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ========== USER OPERATIONS ==========
  Future<User?> createUser(User user) async {
    final db = await database;
    // Hash password dengan created_at string sebagai salt (immutable)
    final hashedUser = user.copyWith(
      password: _hashPassword(user.password, user.createdAt.toIso8601String()),
    );
    
    try {
      // Check if username already exists
      final existing = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [user.username],
      );
      
      if (existing.isNotEmpty) {
        print('Username already exists: ${user.username}');
        return null;
      }
      
      final id = await db.insert('users', hashedUser.toMap());
      return hashedUser.copyWith(id: id);
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await database;
    
    // Ambil user dulu untuk dapat created_at sebagai salt
    final userMaps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    
    if (userMaps.isEmpty) {
      return null; // Username tidak ditemukan
    }
    
    final user = User.fromMap(userMaps.first);
    // Hash password dengan created_at string sebagai salt (immutable)
    final hashedPassword = _hashPassword(password, user.createdAt.toIso8601String());
    
    // Verifikasi password
    if (user.password == hashedPassword) {
      return user;
    }
    
    return null; // Password salah
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Update user profile (name, username, and/or password)
  Future<bool> updateUserProfile({
    required int userId,
    required String newFullName,
    String? newUsername,
    String? newPassword,
  }) async {
    try {
      final db = await database;
      
      Map<String, dynamic> updates = {
        'full_name': newFullName,
      };

      // Update username if provided
      if (newUsername != null && newUsername.isNotEmpty) {
        // Check if username already exists (for other users)
        final existing = await db.query(
          'users',
          where: 'username = ? AND id != ?',
          whereArgs: [newUsername, userId],
        );
        
        if (existing.isNotEmpty) {
          print('Username already taken');
          return false;
        }
        
        updates['username'] = newUsername;
      }

      // Only update password if provided
      if (newPassword != null && newPassword.isNotEmpty) {
        // CRITICAL: Gunakan created_at sebagai salt (immutable)
        // Tidak terpengaruh perubahan username (fix salt desynchronization bug)
        final user = await getUserById(userId);
        if (user != null) {
          updates['password'] = _hashPassword(newPassword, user.createdAt.toIso8601String());
        }
      }

      final rowsAffected = await db.update(
        'users',
        updates,
        where: 'id = ?',
        whereArgs: [userId],
      );

      return rowsAffected > 0;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // ========== CATEGORY OPERATIONS ==========
  Future<int> createCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getCategoriesByUser(int userId, String type) async {
    final db = await database;
    final maps = await db.query(
      'categories',
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, type],
      orderBy: 'is_default DESC, name ASC',
    );

    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<void> initializeDefaultCategories(int userId) async {
    final incomeCategories = [
      Category(name: 'Gaji', type: 'income', isDefault: true, userId: userId),
      Category(name: 'Uang Jajan', type: 'income', isDefault: true, userId: userId),
      Category(name: 'Lainnya', type: 'income', isDefault: true, userId: userId),
    ];

    final expenseCategories = [
      Category(name: 'Makanan', type: 'expense', isDefault: true, userId: userId),
      Category(name: 'Kos', type: 'expense', isDefault: true, userId: userId),
      Category(name: 'Hiburan', type: 'expense', isDefault: true, userId: userId),
      Category(name: 'Lainnya', type: 'expense', isDefault: true, userId: userId),
    ];

    for (var category in [...incomeCategories, ...expenseCategories]) {
      await createCategory(category);
    }
  }

  // ========== TRANSACTION OPERATIONS ==========
  Future<int> createTransaction(models.Transaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<models.Transaction>> getTransactionsByUser(int userId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT t.*, c.name as category_name
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      WHERE t.user_id = ?
      ORDER BY t.date DESC, t.created_at DESC
    ''', [userId]);

    return List.generate(maps.length, (i) => models.Transaction.fromMap(maps[i]));
  }

  Future<List<models.Transaction>> getRecentTransactions(int userId, int limit) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT t.*, c.name as category_name
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      WHERE t.user_id = ?
      ORDER BY t.date DESC, t.created_at DESC
      LIMIT ?
    ''', [userId, limit]);

    return List.generate(maps.length, (i) => models.Transaction.fromMap(maps[i]));
  }

  Future<int> updateTransaction(models.Transaction transaction) async {
    final db = await database;
    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get total income
  Future<double> getTotalIncome(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE user_id = ? AND type = 'income'
    ''', [userId]);

    return result.first['total'] != null 
        ? (result.first['total'] as num).toDouble() 
        : 0.0;
  }

  // Get total expense
  Future<double> getTotalExpense(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE user_id = ? AND type = 'expense'
    ''', [userId]);

    return result.first['total'] != null 
        ? (result.first['total'] as num).toDouble() 
        : 0.0;
  }

  // Get expense by category for charts
  Future<Map<String, double>> getExpenseByCategory(int userId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT c.name, SUM(t.amount) as total
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      WHERE t.user_id = ? AND t.type = 'expense'
      GROUP BY c.name
      ORDER BY total DESC
    ''', [userId]);

    Map<String, double> result = {};
    for (var map in maps) {
      result[map['name'] as String] = (map['total'] as num).toDouble();
    }
    return result;
  }

  // ========== REMINDER OPERATIONS ==========
  Future<int> createReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getRemindersByUser(int userId) async {
    final db = await database;
    final maps = await db.query(
      'reminders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'reminder_date ASC',
    );

    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await database;
    return db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== BUDGET OPERATIONS ==========
  Future<int> setMonthlyBudget(int userId, double target, int month, int year) async {
    final db = await database;
    
    // Check if budget exists for this month
    final existing = await db.query(
      'budgets',
      where: 'user_id = ? AND month = ? AND year = ?',
      whereArgs: [userId, month, year],
    );

    if (existing.isNotEmpty) {
      return await db.update(
        'budgets',
        {'monthly_target': target},
        where: 'user_id = ? AND month = ? AND year = ?',
        whereArgs: [userId, month, year],
      );
    } else {
      return await db.insert('budgets', {
        'user_id': userId,
        'monthly_target': target,
        'month': month,
        'year': year,
      });
    }
  }

  Future<double?> getMonthlyBudget(int userId, int month, int year) async {
    final db = await database;
    final maps = await db.query(
      'budgets',
      where: 'user_id = ? AND month = ? AND year = ?',
      whereArgs: [userId, month, year],
    );

    if (maps.isNotEmpty) {
      return (maps.first['monthly_target'] as num).toDouble();
    }
    return null;
  }

  Future<double> getMonthlyExpense(int userId, int month, int year) async {
    final db = await database;
    
    final startDate = DateTime(year, month, 1).toIso8601String();
    final endDate = DateTime(year, month + 1, 1).toIso8601String();
    
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE user_id = ? AND type = 'expense' 
      AND date >= ? AND date < ?
    ''', [userId, startDate, endDate]);

    return result.first['total'] != null 
        ? (result.first['total'] as num).toDouble() 
        : 0.0;
  }

  // ========== TESTING OPERATIONS ==========
  // Bulk insert for load testing
  Future<int> bulkInsertTransactions(List<models.Transaction> transactions) async {
    final db = await database;
    final batch = db.batch();
    
    for (var transaction in transactions) {
      batch.insert('transactions', transaction.toMap());
    }
    
    final results = await batch.commit();
    return results.length;
  }

  // Clear all test data (transactions, budgets, reminders) untuk testing cleanup
  // Menggunakan batch untuk efisiensi dan menghindari data residual
  Future<int> clearAllTransactions(int userId) async {
    final db = await database;
    final batch = db.batch();
    
    // Hapus semua transactions
    batch.delete('transactions', where: 'user_id = ?', whereArgs: [userId]);
    
    // Hapus semua budgets (data testing bisa bikin banyak budget entries)
    batch.delete('budgets', where: 'user_id = ?', whereArgs: [userId]);
    
    // Hapus semua reminders (data testing bisa bikin banyak reminder entries)
    batch.delete('reminders', where: 'user_id = ?', whereArgs: [userId]);
    
    final results = await batch.commit();
    // Hitung total rows yang dihapus
    int totalDeleted = 0;
    for (var result in results) {
      if (result is int) {
        totalDeleted += result;
      }
    }
    return totalDeleted;
  }

  // Delete entire database (for fresh start)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nyawit.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // Get all users (for debugging)
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
