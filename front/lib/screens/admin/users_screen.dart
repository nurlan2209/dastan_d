// photostudio_app/lib/screens/admin/users_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'create_photographer_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<void> _fetchUsersFuture;
  String _roleFilter = 'all';

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

  Future<void> _navigateToCreatePhotographer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePhotographerScreen(),
      ),
    );

    if (result == true && mounted) {
      // Обновить список пользователей
      _refreshUsers();
    }
  }

  Widget _buildRoleChip(String role) {
    Color chipColor;
    String roleText;
    IconData iconData;

    switch (role) {
      case 'admin':
        chipColor = Color(0xFFDBEAFE);
        roleText = 'Админ';
        iconData = Icons.shield_outlined;
        break;
      case 'photographer':
        chipColor = Color(0xFFD1FAE5);
        roleText = 'Фотограф';
        iconData = Icons.camera_alt_outlined;
        break;
      default:
        chipColor = Color(0xFFFEF3C7);
        roleText = 'Клиент';
        iconData = Icons.person_outline;
    }

    return Chip(
      avatar: Icon(
        iconData,
        size: 16,
        color: Color(0xFF1F2937),
      ),
      label: Text(roleText),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F2937),
      ),
      backgroundColor: chipColor,
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildFilterChips() {
    final filters = {
      'all': 'Все',
      'client': 'Клиенты',
      'photographer': 'Фотографы',
      'admin': 'Админы',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = _roleFilter == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _roleFilter = entry.key);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Color(0xFF2563EB),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Пользователи',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text('Управление аккаунтами',
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.9))),
          ],
        ),
      ),
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
              final filteredUsers = userProvider.users.where((user) {
                if (_roleFilter == 'all') return true;
                return user.role == _roleFilter;
              }).toList();

              return Column(
                children: [
                  _buildFilterChips(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Найдено: ${filteredUsers.length}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.refresh, size: 18),
                          label: Text('Обновить'),
                          onPressed: _refreshUsers,
                        ),
                      ],
                    ),
                  ),
                  if (filteredUsers.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('Пользователи не найдены',
                                style: theme.textTheme.titleLarge),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshUsers,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color(0xFF2563EB).withOpacity(0.1),
                                  foregroundColor: Color(0xFF2563EB),
                                  child: Text(
                                    user.name.substring(0, 1).toUpperCase(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  user.name,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.email),
                                    if (user.phone != null &&
                                        user.phone!.isNotEmpty)
                                      Text(
                                        user.phone!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600),
                                      ),
                                  ],
                                ),
                                trailing: _buildRoleChip(user.role),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreatePhotographer,
        icon: Icon(Icons.add_rounded),
        label: Text('Создать фотографа'),
        backgroundColor: Color(0xFF2563EB),
      ),
    );
  }
}
