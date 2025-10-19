// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/screens/client/my_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  // 1. Исправлено: Добавлен const и super.key
  const MyOrdersScreen({super.key});

  @override
  // 2. Исправлено: Переименовано в MyOrdersScreenState (без '_')
  MyOrdersScreenState createState() => MyOrdersScreenState();
}

// 2. Исправлено: Переименовано в MyOrdersScreenState (без '_')
class MyOrdersScreenState extends State<MyOrdersScreen> {
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (!mounted) return;
      await context.read<OrderProvider>().fetchOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки данных: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  // 3. ИСПРАВЛЕНА ОШИБКА КОПИРОВАНИЯ
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои заказы'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<OrderProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.orders.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              if (provider.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'У вас пока нет заказов',
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        'Нажмите "+", чтобы создать новый заказ',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: provider.orders.length,
                  itemBuilder: (context, index) {
                    final order = provider.orders[index];

                    return OrderCard(
                      order: order,
                      userRole: auth.role ?? 'client',
                      clientName: order.clientName,
                      photographerName: order.photographerName,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-order'),
        child: Icon(Icons.add),
      ),
    );
  }
}
