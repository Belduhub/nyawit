import '../services/database_service.dart';
import '../models/user_model.dart';

/// AuthController - CONTROLLER layer dalam MVC
/// Mengelola business logic untuk autentikasi user
class AuthController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  User? _currentUser;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Register user baru
  Future<bool> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    // Validasi input di layer Controller sesuai kaidah MVC
    if (username.isEmpty || password.isEmpty || fullName.isEmpty) {
      _errorMessage = 'Semua field harus diisi';
      return false;
    }
    
    // Validasi panjang password
    if (password.length < 6) {
      _errorMessage = 'Password minimal 6 karakter';
      return false;
    }
    
    try {
      final user = User(
        username: username.trim(),
        password: password,
        fullName: fullName.trim(),
      );

      final createdUser = await _dbService.createUser(user);
      
      if (createdUser != null) {
        // Initialize default categories for new user
        await _dbService.initializeDefaultCategories(createdUser.id!);
        _currentUser = createdUser;
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = 'Username sudah digunakan';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      return false;
    }
  }

  /// Login user
  Future<bool> login(String username, String password) async {
    // Validasi input di layer Controller sesuai kaidah MVC
    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Username dan password harus diisi';
      return false;
    }
    
    try {
      final user = await _dbService.loginUser(username.trim(), password);
      
      if (user != null) {
        _currentUser = user;
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = 'Username atau password salah';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      return false;
    }
  }

  /// Logout user
  void logout() {
    _currentUser = null;
    _errorMessage = null;
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
  }

  /// Get user by ID
  Future<User?> getUserById(int id) async {
    try {
      return await _dbService.getUserById(id);
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      return null;
    }
  }
}
