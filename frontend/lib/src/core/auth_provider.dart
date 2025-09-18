import 'package:flutter/material.dart';
import 'package:frontend/src/core/api/auth_service.dart';
import 'package:frontend/src/core/services/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureStorageService _storageService = SecureStorageService();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final responseData = await _authService.login(email, password);
      final token = responseData?['acess_token'];

      if (token != null) {
        await _storageService.saveToken(token);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {}

  void checkLoginStatus() {}
}