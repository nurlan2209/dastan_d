import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user_model.dart';

class UserService {
  final String? _token;
  UserService(this._token);

  Future<List<User>> fetchUsers() async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<void> toggleUserStatus(String userId) async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/toggle-status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle user status: ${response.body}');
    }
  }

  Future<void> deleteUser(String userId) async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.body}');
    }
  }
}
