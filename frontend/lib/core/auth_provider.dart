import 'package:flutter/material.dart';
import 'package:frontend/core/api/auth_service.dart';
import 'package:frontend/core/services/secure_storage_service.dart';
import 'package:frontend/core/api/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureStorageService _storageService = SecureStorageService();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _currentUser;
  User? get currentUser => _currentUser;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _storageService.readUser();
    if (_currentUser != null) {
      _isAuthenticated = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final responseData = await _authService.login(email, password);
      if (responseData != null) {
        final token = responseData['access_token'];
        final user = User.fromJson(responseData['user']);

        if (token != null) {
          await _storageService.saveToken(token);
          await _storageService.saveUser(user);
          _currentUser = user;
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    await _storageService.deleteUser();
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = await _authService.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      if (newUser != null) {
        return await login(email, password);
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}