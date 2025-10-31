// photostudio_app/lib/screens/admin/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Color(0xFF2563EB),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/admin-profile'),
          tooltip: 'Профиль',
        ),
        title: Text(
          'Панель Администратора',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildDashboardGrid(context),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthProvider>().user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Добро пожаловать,',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.name ?? 'Администратор',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDashboardCard(
                context,
                'Все заказы',
                Icons.list_alt_outlined,
                () => Navigator.pushNamed(context, '/admin/orders'),
              ),
              _buildDashboardCard(
                context,
                'Услуги',
                Icons.work_outline,
                () => Navigator.pushNamed(context, '/admin/services'),
              ),
              _buildDashboardCard(
                context,
                'Пользователи',
                Icons.people_alt_outlined,
                () => Navigator.pushNamed(context, '/admin/users'),
              ),
              _buildDashboardCard(
                context,
                'Отчёты',
                Icons.analytics_outlined,
                () => Navigator.pushNamed(context, '/admin/reports'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
