import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'client/my_orders_screen.dart';
import 'photographer/my_orders_screen.dart';
import 'photographer/photographer_home_screen.dart';
import 'admin/dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder(
      future: authProvider.tryAutoLogin(),
      builder: (ctx, authResultSnapshot) {
        if (authResultSnapshot.connectionState == ConnectionState.waiting) {
          // Пока идет проверка, показываем экран загрузки
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

      if (authProvider.isAuthenticated) {
        // --- ИЗМЕНЕНИЕ 2: Добавляем логику распределения по ролям ---
        switch (authProvider.role) {
          case 'admin':
            return const DashboardScreen();
          case 'photographer':
            // Теперь фотограф попадает на главный экран с навигацией
            return const PhotographerHomeScreen();
          case 'client':
            return const MyOrdersScreen();
          default:
            // Если роль не определена, возвращаем на экран входа
            return const LoginScreen();
      }

        // Пользователь не авторизован, показываем экран входа
        return const LoginScreen();
      },
    );
  }
}
