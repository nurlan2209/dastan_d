import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  String? _role;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get role => _role;
  String? get userId => _userId;

  Future<void> checkAuth() async {
    _isLoggedIn = await _authService.isLoggedIn();
    _role = await _authService.getRole();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final data = await _authService.login(email, password);
    _isLoggedIn = true;
    _role = data['role'];
    _userId = data['userId'];
    notifyListeners();
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    await _authService.register(name, email, password, role);
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _role = null;
    _userId = null;
    notifyListeners();
  }
}
