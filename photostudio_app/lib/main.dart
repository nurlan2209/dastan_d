import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/review_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/client/create_order_screen.dart';
import 'screens/client/my_orders_screen.dart';
import 'screens/photographer/my_orders_screen.dart';
import 'screens/photographer/schedule_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/orders_screen.dart';
import 'screens/admin/users_screen.dart';
import 'screens/admin/reports_screen.dart';
import 'screens/shared/notifications_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => MyOrdersScreen(),
          '/create-order': (context) => CreateOrderScreen(),
          '/photographer/orders': (context) => PhotographerOrdersScreen(),
          '/photographer/schedule': (context) => ScheduleScreen(),
          '/admin/dashboard': (context) => DashboardScreen(),
          '/admin/orders': (context) => AdminOrdersScreen(),
          '/admin/users': (context) => UsersScreen(),
          '/admin/reports': (context) => ReportsScreen(),
          '/notifications': (context) => NotificationsScreen(),
        },
      ),
    );
  }
}
