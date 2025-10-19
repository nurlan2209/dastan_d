// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/screens/admin/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    // Проверка mounted не нужна, т.к. BuildContext используется до await
    await context.read<AuthProvider>().logout();
    // А вот здесь нужна, но pushReplacementNamed безопаснее
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Список экранов для BottomNavBar (если вы решите его добавить)
    // Я пока оставлю только Dashboard
    final List<Widget> screens = [
      _buildDashboardGrid(context), // Экран 0
      // UsersScreen(),            // Экран 1
      // ReportsScreen(),          // Экран 2
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Админ-панель'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _buildDashboardGrid(context),

      // TODO: Вы можете легко добавить BottomNavBar здесь
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   onTap: (index) { /* ... */ },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Главная'),
      //     BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Юзеры'),
      //     BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Отчеты'),
      //   ],
      // ),
    );
  }

  // Виджет сетки (бывший body)
  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16.0),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCard(
          context,
          'Все заказы',
          Icons.assignment_outlined,
          () => Navigator.pushNamed(context, '/admin/orders'),
        ),
        _buildDashboardCard(
          context,
          'Пользователи',
          Icons.people_outline_rounded,
          () => Navigator.pushNamed(context, '/admin/users'),
        ),
        _buildDashboardCard(
          context,
          'Отчёты',
          Icons.analytics_outlined,
          () => Navigator.pushNamed(context, '/admin/reports'),
        ),
        // УДАЛЕНА карточка "Уведомления"
      ],
    );
  }
  
  // "Четкая" карточка (БЕЗ ГРАДИЕНТОВ)
  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2.0, // Из темы
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0), // Из темы
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.primaryColor, // Основной цвет темы
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
