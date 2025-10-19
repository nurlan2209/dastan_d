// photostudio_app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/review_provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/client/create_order_screen.dart';
import 'screens/client/my_orders_screen.dart' as client_orders;
import 'screens/photographer/my_orders_screen.dart' as photographer_orders;
import 'screens/photographer/schedule_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/orders_screen.dart';
import 'screens/admin/users_screen.dart';
import 'screens/admin/reports_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MaterialApp(
        title: 'Photostudio',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => client_orders.MyOrdersScreen(),
          '/create-order': (context) => CreateOrderScreen(),
          '/photographer/orders': (context) =>
              photographer_orders.PhotographerOrdersScreen(),
          '/photographer/schedule': (context) => ScheduleScreen(),
          '/admin/dashboard': (context) => const DashboardScreen(),
          '/admin/orders': (context) => const AdminOrdersScreen(),
          '/admin/users': (context) => const UsersScreen(),
          '/admin/reports': (context) => ReportsScreen(),
        },
      ),
    );
  }
}
