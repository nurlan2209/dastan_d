import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ReportsScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отчеты'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Общая статистика'),
                subtitle: Text('Доход, количество заказов'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Экспорт в PDF'),
                trailing: Icon(Icons.download),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Экспорт в CSV'),
                trailing: Icon(Icons.download),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
