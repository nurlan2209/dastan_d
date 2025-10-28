import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'auth_provider.dart';

class UserProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  List<User> _users = [];
  bool _isLoading = false;

  UserProvider();

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  void update(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<void> fetchUsers() async {
    if (_authProvider?.token == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final userService = UserService(_authProvider!.token);
      _users = await userService.fetchUsers();
    } catch (error) {
      print('Error fetching users: $error');
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleUserStatus(String userId) async {
    if (_authProvider?.token == null) return;

    try {
      final userService = UserService(_authProvider!.token);
      await userService.toggleUserStatus(userId);
      // Обновить локальный список
      await fetchUsers();
    } catch (error) {
      print('Error toggling user status: $error');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    if (_authProvider?.token == null) return;

    try {
      final userService = UserService(_authProvider!.token);
      await userService.deleteUser(userId);
      // Удалить из локального списка
      _users.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (error) {
      print('Error deleting user: $error');
      rethrow;
    }
  }
}
