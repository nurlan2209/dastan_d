import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        await prefs.setString('role', data['role']);
        await prefs.setString('userId', data['userId']);

        return data;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e');
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
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': name,
          'email': email,
          'password': password,
          'role': role,
          'phoneNumber': phone,
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        // Сохраняем токены после успешной регистрации
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        await prefs.setString('role', data['role']);
        await prefs.setString('userId', data['userId']);

        return data;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      print('Forgot password response status: ${response.statusCode}');
      print('Forgot password response body: ${response.body}');

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to send reset code');
      }
    } catch (e) {
      print('Forgot password error: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
      );

      print('Reset password response status: ${response.statusCode}');
      print('Reset password response body: ${response.body}');

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      print('Reset password error: $e');
      rethrow;
    }
  }

  Future<void> changePassword(String token, String currentPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      print('Change password response status: ${response.statusCode}');
      print('Change password response body: ${response.body}');

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      print('Change password error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') != null;
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
