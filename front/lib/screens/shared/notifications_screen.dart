// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/screens/shared/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:photostudio_app/models/notification_model.dart';
import 'package:intl/intl.dart';

// TODO: Загружать уведомления из 'NotificationProvider'
// Это заглушка
final List<NotificationModel> _dummyNotifications = [
  NotificationModel(
    id: '1',
    userId: '1',
    message: 'Вам назначен новый заказ "Свадебная съемка"',
    type: 'order_assigned',
    read: false,
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
  ),
  NotificationModel(
    id: '2',
    userId: '1',
    message: 'Клиент оставил новый отзыв (5 звезд)',
    type: 'new_review',
    read: false,
    createdAt: DateTime.now().subtract(Duration(hours: 5)),
  ),
  NotificationModel(
    id: '3',
    userId: '1',
    message: 'Заказ "Портрет" был завершен',
    type: 'order_completed',
    read: true,
    createdAt: DateTime.now().subtract(Duration(days: 1)),
  ),
];

class NotificationsScreen extends StatelessWidget {
  IconData _getIconForType(String type, ThemeData theme) {
    switch (type) {
      case 'order_assigned':
        return Icons.assignment_turned_in_rounded;
      case 'new_review':
        return Icons.star_rounded;
      case 'order_completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Уведомления')),
      body: _dummyNotifications.isEmpty
          ? Center(
              child: Text('Уведомлений нет', style: theme.textTheme.bodyMedium),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _dummyNotifications.length,
              itemBuilder: (context, index) {
                final notification = _dummyNotifications[index];
                final icon = _getIconForType(notification.type, theme);
                final color = notification.type == 'new_review'
                    ? theme.colorScheme.secondary
                    : theme.primaryColor;

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(
                      notification.message,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: notification.read
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat(
                        'd MMM y, HH:mm',
                        'ru_RU',
                      ).format(notification.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: !notification.read
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                    onTap: () {
                      // TODO: Отметить как прочитанное
                    },
                  ),
                );
              },
            ),
    );
  }
}
