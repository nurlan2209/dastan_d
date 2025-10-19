import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'client/my_orders_screen.dart';
import 'photographer/photographer_home_screen.dart';
import 'admin/dashboard_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _autoLoginFuture;

  @override
  void initState() {
    super.initState();
    _autoLoginFuture =
        Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder<bool>(
      future: _autoLoginFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isAuthenticated) {
          print('User authenticated, role: ${authProvider.role}');
          switch (authProvider.role) {
            case 'admin':
              return const DashboardScreen();
            case 'photographer':
              return const PhotographerHomeScreen();
            case 'client':
              return const MyOrdersScreen();
            default:
              return const LoginScreen();
          }
        }

        return const LoginScreen();
      },
    );
  }
}
