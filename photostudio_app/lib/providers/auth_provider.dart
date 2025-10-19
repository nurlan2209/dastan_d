import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _role;
  User? _user;

  // --- ГЕТТЕРЫ ДЛЯ ДОСТУПА ИЗВНЕ ---
  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get role => _role;
  User? get user => _user;

  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    try {
      final responseData = await _authService.login(email, password);
      _token = responseData['token'];
      _userId = responseData['user']['id'];
      _role = responseData['user']['role'];
      _user = User.fromJson(responseData['user']);

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'role': _role,
        'user': responseData['user'],
      });
      await prefs.setString('userData', userData);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
    String phone,
  ) async {
    try {
      await _authService.register(name, email, password, role, phone);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _role = extractedUserData['role'];
    _user = User.fromJson(extractedUserData['user']);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _role = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    notifyListeners();
  }
}
