import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  final DatabaseService _dbHelper = DatabaseService.instance;

  // Register new user
  Future<bool> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = User(
        username: username,
        password: password,
        fullName: fullName,
      );

      final createdUser = await _dbHelper.createUser(user);
      
      if (createdUser != null) {
        // Initialize default categories for new user
        await _dbHelper.initializeDefaultCategories(createdUser.id!);
        _currentUser = createdUser;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Username sudah digunakan';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _dbHelper.loginUser(username, password);
      
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Username atau password salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Update profile (name, username, and/or password)
  Future<bool> updateProfile({
    required String newName,
    String? newUsername,
    String? newPassword,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _dbHelper.updateUserProfile(
        userId: _currentUser!.id!,
        newFullName: newName,
        newUsername: newUsername,
        newPassword: newPassword,
      );

      if (success) {
        // Update current user object
        _currentUser = User(
          id: _currentUser!.id,
          username: newUsername ?? _currentUser!.username,
          password: newPassword ?? _currentUser!.password,
          fullName: newName,
          createdAt: _currentUser!.createdAt,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Gagal memperbarui profil';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
