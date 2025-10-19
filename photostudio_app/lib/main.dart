import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'providers/report_provider.dart';
import 'providers/schedule_provider.dart';

import 'screens/auth_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/client/my_orders_screen.dart';
import 'screens/client/create_order_screen.dart';
import 'screens/photographer/photographer_home_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/users_screen.dart';
import 'screens/admin/orders_screen.dart';
import 'screens/admin/reports_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (ctx) => OrderProvider(),
          update: (ctx, auth, previous) => previous!..update(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (ctx) => UserProvider(),
          update: (ctx, auth, previous) => previous!..update(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ReportProvider>(
          create: (ctx) => ReportProvider(),
          update: (ctx, auth, previous) => previous!..update(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ScheduleProvider>(
          create: (ctx) => ScheduleProvider(),
          update: (ctx, auth, previous) => previous!..update(auth),
        ),
      ],
      child: MaterialApp(
        title: 'Photostudio App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', ''), // Russian
        ],
        locale: const Locale('ru'),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MyOrdersScreen(),
          '/create-order': (context) => const CreateOrderScreen(),
          '/photographer/home': (context) => const PhotographerHomeScreen(),
          '/admin/dashboard': (context) => const DashboardScreen(),
          '/admin/users': (context) => const UsersScreen(),
          '/admin/orders': (context) => const AdminOrdersScreen(),
          '/admin/reports': (context) => const ReportsScreen(),
        },
      ),
    );
  }
}
