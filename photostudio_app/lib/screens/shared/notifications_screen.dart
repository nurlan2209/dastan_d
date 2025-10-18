import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Уведомления')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Новый заказ назначен'),
            subtitle: Text('2 часа назад'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Получен новый отзыв'),
            subtitle: Text('5 часов назад'),
          ),
        ],
      ),
    );
  }
}
