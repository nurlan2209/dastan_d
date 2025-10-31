// photostudio_app/lib/providers/auth_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

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
      _token = responseData['accessToken'];
      _userId = responseData['userId'];
      _role = responseData['role'];

      print('Token received: $_token');
      print('Role: $_role');
      print('UserId: $_userId');

      // Получаем данные пользователя
      try {
        final userResponse = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/auth/me'),
          headers: {'Authorization': 'Bearer $_token'},
        ).timeout(Duration(seconds: 5));

        print('User response status: ${userResponse.statusCode}');
        print('User response body: ${userResponse.body}');

        if (userResponse.statusCode == 200) {
          _user = User.fromJson(json.decode(userResponse.body));
          print('User loaded: ${_user?.name}');
        }
      } catch (e) {
        print('Error fetching user data: $e');
        // Создаем базовый объект пользователя если не удалось загрузить
        _user = User(
          id: _userId ?? '',
          name: email.split('@')[0],
          email: email,
          role: _role ?? 'client',
        );
      }

      // Сохраняем данные
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'role': _role,
        'user': _user?.toJson(),
      });
      await prefs.setString('userData', userData);

      print('Data saved to SharedPreferences');

      // ВАЖНО: уведомляем слушателей об изменении
      notifyListeners();

      print('Login completed successfully');
    } catch (e) {
      print('Login error in provider: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role,
    String phone,
  ) async {
    try {
      return await _authService.register(name, email, password, role, phone);
    } catch (e) {
      rethrow;
    }
  }

  // Загрузка данных пользователя после успешной авторизации
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final userId = prefs.getString('userId');
      final role = prefs.getString('role');

      if (token != null && userId != null && role != null) {
        _token = token;
        _userId = userId;
        _role = role;

        // Получаем данные пользователя
        try {
          final userResponse = await http.get(
            Uri.parse('${ApiConfig.baseUrl}/auth/me'),
            headers: {'Authorization': 'Bearer $_token'},
          ).timeout(Duration(seconds: 5));

          if (userResponse.statusCode == 200) {
            _user = User.fromJson(json.decode(userResponse.body));
          }
        } catch (e) {
          print('Error fetching user data: $e');
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        print('No saved user data found');
        return false;
      }

      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _role = extractedUserData['role'];

      if (extractedUserData['user'] != null) {
        _user = User.fromJson(extractedUserData['user']);
      }

      print('Auto-login successful. Role: $_role');
      notifyListeners();
      return true;
    } catch (e) {
      print('Auto-login error: $e');
      return false;
    }
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

  // Метод для обновления провайдеров
  void update(AuthProvider authProvider) {
    // Этот метод нужен для ChangeNotifierProxyProvider
  }
}
