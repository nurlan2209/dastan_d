// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/screens/admin/users_screen.dart

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // <-- 1. УДАЛЕНО (unused)
// import '../../providers/auth_provider.dart'; // <-- 1. УДАЛЕНО (unused)
import '../../services/api_service.dart';
import '../../models/user_model.dart';

class UsersScreen extends StatefulWidget {
  // 2. Добавлен super.key
  const UsersScreen({super.key});

  @override
  // 3. Переименовано в UsersScreenState (без '_')
  UsersScreenState createState() => UsersScreenState();
}

// 3. Переименовано в UsersScreenState (без '_')
class UsersScreenState extends State<UsersScreen> {
  final ApiService _api = ApiService();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.get('/users');
      if (!mounted) return;
      setState(() {
        _users = (response.data as List)
            .map((json) => User.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      // 4. Убрана строка print()
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(String id) async {
    try {
      await _api.delete('/users/$id');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пользователь удалён'),
          backgroundColor: Colors.green,
        ),
      );
      _loadUsers(); // Обновляем список
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка удаления: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // --- Используем цвета из ТЕМЫ ---
  Color _getRoleColor(String role, ThemeData theme) {
    switch (role) {
      case 'admin':
        return theme.primaryColor;
      case 'photographer':
        return theme.colorScheme.secondary; // Янтарный
      case 'client':
        return Colors.green; // Оставим зеленый для клиентов
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'photographer':
        return Icons.camera_alt_rounded;
      case 'client':
        return Icons.person_rounded;
      default:
        return Icons.person_outline_rounded;
    }
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'admin':
        return 'Админ';
      case 'photographer':
        return 'Фотограф';
      case 'client':
        return 'Клиент';
      default:
        return role;
    }
  }

  // --- Диалог удаления ---
  void _showDeleteDialog(User user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Удалить пользователя?'),
        content: Text('Вы уверены, что хотите удалить ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteUser(user.id);
            },
            child: Text(
              'Удалить',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Пользователи'),
        // Убираем actions, т.к. logout есть в Dashboard
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Нет пользователей', style: theme.textTheme.titleLarge),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  final roleColor = _getRoleColor(user.role, theme);

                  return Card(
                    // Используем Card из темы
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      leading: CircleAvatar(
                        // 5. Исправлено 'withOpacity'
                        backgroundColor: roleColor.withAlpha(
                          (255 * 0.15).round(),
                        ),
                        child: Icon(_getRoleIcon(user.role), color: roleColor),
                      ),
                      title: Text(user.name, style: theme.textTheme.labelLarge),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(user.email, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(
                              _getRoleText(user.role),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: roleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // 5. Исправлено 'withOpacity'
                            backgroundColor: roleColor.withAlpha(
                              (255 * 0.1).round(),
                            ),
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                          ),

                          if (user.role == 'photographer') ...[
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: theme.colorScheme.secondary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  user.rating.toStringAsFixed(1),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      trailing: user.role != 'admin'
                          ? IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: () => _showDeleteDialog(user),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
