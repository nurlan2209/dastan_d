import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _api.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', response.data['accessToken']);
    await prefs.setString('refreshToken', response.data['refreshToken']);
    await prefs.setString('role', response.data['role']);
    await prefs.setString('userId', response.data['userId']);

    return response.data;
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
    String phone,
  ) async {
    await _api.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'phone': phone,
      },
    );
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
