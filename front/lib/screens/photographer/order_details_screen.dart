import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class PhotographerOrderDetailsScreen extends StatelessWidget {
  final Order order;

  const PhotographerOrderDetailsScreen({super.key, required this.order});

  Future<void> _updateStatus(BuildContext context, String status) async {
    try {
      await context.read<OrderProvider>().updateOrder(
        order.id,
        {'status': status},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Статус обновлен'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _completeOrder(BuildContext context) async {
    final resultController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершить заказ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Добавьте ссылку на результат работы:'),
            const SizedBox(height: 16),
            TextField(
              controller: resultController,
              decoration: const InputDecoration(
                labelText: 'Ссылка на Google Drive / Яндекс.Диск',
                hintText: 'https://drive.google.com/...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (resultController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Добавьте ссылку на результат'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context, resultController.text.trim());
            },
            child: const Text('Завершить'),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      try {
        await context.read<OrderProvider>().updateOrder(
          order.id,
          {
            'status': 'completed',
            'result': result,
          },
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Заказ завершен!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'new':
        return 'Новый';
      case 'assigned':
        return 'Назначен';
      case 'in_progress':
        return 'В работе';
      case 'completed':
        return 'Завершен';
      case 'cancelled':
        return 'Отменен';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
      case 'assigned':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientName = order.client?.name ?? 'Неизвестный клиент';
    final clientPhone = order.client?.phone;
    final clientEmail = order.client?.email;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        title: const Text(
          'Детали заказа',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статус карточка
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _getStatusColor(order.status),
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статус заказа',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(order.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Услуга
                  Text(
                    'Услуга',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.service,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Информация о клиенте
                  Text(
                    'Информация о клиенте',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    [
                      _InfoRow(
                        icon: Icons.person_outline,
                        label: 'Клиент',
                        value: clientName,
                      ),
                      if (clientPhone != null && clientPhone.isNotEmpty)
                        _InfoRow(
                          icon: Icons.phone,
                          label: 'Телефон',
                          value: clientPhone,
                        ),
                      if (clientEmail != null && clientEmail.isNotEmpty)
                        _InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: clientEmail,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Детали заказа
                  Text(
                    'Детали заказа',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    [
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Дата и время',
                        value: DateFormat('dd.MM.yyyy HH:mm', 'ru_RU')
                            .format(order.date),
                      ),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Локация',
                        value: order.location,
                      ),
                      _InfoRow(
                        icon: Icons.attach_money,
                        label: 'Цена',
                        value: '${order.price.toStringAsFixed(0)} ₸',
                      ),
                    ],
                  ),

                  if (order.comment != null && order.comment!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Комментарий клиента',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        order.comment!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],

                  if (order.result != null && order.result!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Результат работы',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.link,
                                  size: 20, color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  order.result!,
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Кнопки действий
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<_InfoRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(row.icon, size: 24, color: Colors.grey.shade600),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        row.value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (order.status) {
      case 'assigned':
      case 'pending':
      case 'confirmed':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _updateStatus(context, 'in_progress'),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Начать работу'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        );
      case 'in_progress':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _completeOrder(context),
            icon: const Icon(Icons.upload_outlined),
            label: const Text('Загрузить результаты'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _InfoRow {
  final IconData icon;
  final String label;
  final String value;

  _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
}
