import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class PhotographerOrdersScreen extends StatefulWidget {
  @override
  _PhotographerOrdersScreenState createState() =>
      _PhotographerOrdersScreenState();
}

class _PhotographerOrdersScreenState extends State<PhotographerOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderProvider>().fetchOrders());
  }

  Future<void> _updateStatus(String orderId, String status) async {
    await context.read<OrderProvider>().updateOrder(orderId, {
      'status': status,
    });
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().role;

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои заказы'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text('Роль: $role', style: TextStyle(fontSize: 14)),
            ),
          ),
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.orders.isEmpty) {
            return Center(child: Text('Нет назначенных заказов'));
          }
          return ListView.builder(
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(order.service),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Место: ${order.location}'),
                      Text('Дата: ${order.date.toString().split(' ')[0]}'),
                      Text('Цена: ${order.price} ₸'),
                      Text('Статус: ${order.status}'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(order.id, 'in_progress'),
                            child: Text('В работе'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(order.id, 'completed'),
                            child: Text('Завершить'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
