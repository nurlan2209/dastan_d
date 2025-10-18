import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String? _filterStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderProvider>().fetchOrders());
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Все заказы'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filterStatus = value);
              context.read<OrderProvider>().fetchOrders(status: value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'new', child: Text('Новые')),
              PopupMenuItem(value: 'assigned', child: Text('Назначенные')),
              PopupMenuItem(value: 'in_progress', child: Text('В работе')),
              PopupMenuItem(value: 'completed', child: Text('Завершенные')),
            ],
          ),
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(order.service),
                  subtitle: Text(
                    'Статус: ${order.status}\nЦена: ${order.price} ₸',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => provider.deleteOrder(order.id),
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
