// photostudio_app/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'providers/report_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/service_provider.dart';
import 'providers/review_provider.dart';
import 'providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/auth_wrapper.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/client/my_orders_screen.dart';
import 'screens/client/create_order_screen.dart';
import 'screens/photographer/photographer_home_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/users_screen.dart' as users;
import 'screens/admin/orders_screen.dart' as orders;
import 'screens/admin/reports_screen.dart' as reports;
import 'screens/admin/create_photographer_screen.dart';
import 'screens/shared/settings_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => LocaleProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (ctx) => OrderProvider(),
          update: (ctx, auth, previous) {
            if (previous == null) {
              return OrderProvider()..update(auth);
            }
            return previous..update(auth);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (ctx) => UserProvider(),
          update: (ctx, auth, previous) {
            if (previous == null) {
              return UserProvider()..update(auth);
            }
            return previous..update(auth);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ReportProvider>(
          create: (ctx) => ReportProvider(),
          update: (ctx, auth, previous) {
            if (previous == null) {
              return ReportProvider()..update(auth);
            }
            return previous..update(auth);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ScheduleProvider>(
          create: (ctx) => ScheduleProvider(),
          update: (ctx, auth, previous) {
            if (previous == null) {
              return ScheduleProvider()..update(auth);
            }
            return previous..update(auth);
          },
        ),
        ChangeNotifierProvider(create: (ctx) => ServiceProvider()),
        ChangeNotifierProvider(create: (ctx) => ReviewProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Photostudio App',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('kk'), // Казахский
              Locale('ru'), // Русский
            ],
            locale: localeProvider.locale,
            home: const AuthWrapper(),
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MyOrdersScreen(),
          '/create-order': (context) => const CreateOrderScreen(),
          '/photographer/home': (context) => const PhotographerHomeScreen(),
          '/admin/dashboard': (context) => const DashboardScreen(),
          '/admin/users': (context) => const users.AdminUsersScreen(),
          '/admin/orders': (context) => const orders.AdminOrdersScreen(),
          '/admin/reports': (context) => const reports.AdminReportsScreen(),
          '/admin/create-photographer': (context) =>
              const CreatePhotographerScreen(),
          '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
