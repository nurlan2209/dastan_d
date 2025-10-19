import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<void> _fetchUsersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsersFuture = Provider.of<UserProvider>(
      context,
      listen: false,
    ).fetchUsers();
  }

  Future<void> _refreshUsers() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  Widget _buildRoleChip(String role) {
    Color chipColor;
    String roleText;
    IconData iconData;

    switch (role) {
      case 'admin':
        chipColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
        roleText = 'Админ';
        iconData = Icons.shield_outlined;
        break;
      case 'photographer':
        chipColor = Theme.of(context).colorScheme.secondary.withOpacity(0.1);
        roleText = 'Фотограф';
        iconData = Icons.camera_alt_outlined;
        break;
      default: // client
        chipColor = Colors.grey.shade200;
        roleText = 'Клиент';
        iconData = Icons.person_outline;
    }

    return Chip(
      avatar: Icon(
        iconData,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      label: Text(roleText),
      backgroundColor: chipColor,
      side: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Пользователи')),
      body: FutureBuilder(
        future: _fetchUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
          }

          return Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if (userProvider.users.isEmpty) {
                return const Center(child: Text('Пользователи не найдены.'));
              }
              return RefreshIndicator(
                onRefresh: _refreshUsers,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: userProvider.users.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                          foregroundColor: theme.colorScheme.primary,
                          child: Text(user.name.substring(0, 1).toUpperCase()),
                        ),
                        title: Text(
                          user.name,
                          style: theme.textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          user.email,
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: _buildRoleChip(user.role),
                        onTap: () {
                          // TODO: Implement user details/edit screen
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
