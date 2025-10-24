// photostudio_app/lib/screens/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import 'onboarding/onboarding_screen.dart';
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
  late Future<Map<String, bool>> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  Future<Map<String, bool>> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    final isAuthenticated =
        await Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();

    return {
      'onboardingComplete': onboardingComplete,
      'isAuthenticated': isAuthenticated,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _initFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xFF2563EB),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Photostudio',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 48),
                  CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final onboardingComplete = data['onboardingComplete']!;
        final isAuthenticated = data['isAuthenticated']!;

        // Сначала проверяем onboarding
        if (!onboardingComplete) {
          return const OnboardingScreen();
        }

        // Затем проверяем аутентификацию
        final authProvider = Provider.of<AuthProvider>(context);
        if (isAuthenticated && authProvider.isAuthenticated) {
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
