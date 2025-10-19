// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/widgets/order_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // <-- 1. Добавлен импорт для даты
import '../models/order_model.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  // --- 2. Добавлены параметры для имен ---
  // (Они нужны, т.к. в order только ID)
  final String? clientName;
  final String? photographerName;
  final String userRole; // 'client', 'admin', 'photographer'

  const OrderCard({
    super.key,
    required this.order,
    required this.userRole,
    this.clientName,
    this.photographerName,
  });

  // --- 3. "Четкий" чип статуса ---
  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orangeAccent;
        break;
      case 'confirmed':
        chipColor = Colors.blueAccent;
        break;
      case 'in_progress':
        chipColor = Colors.purpleAccent;
        break;
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.redAccent;
        break;
      default:
        chipColor = Colors.grey;
        textColor = Colors.black;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      visualDensity: VisualDensity.compact,
    );
  }

  // --- 4. "Четкая" строка-помощник ---
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 15),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ссылка скопирована'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- 5. "Четкая" карточка ---
    return Card(
      // Использует стиль из AppTheme
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // --- 6. "Четкий" AlertDialog ---
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(order.service, style: theme.textTheme.titleLarge),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Используем _buildInfoRow для чистоты
                    if (userRole != 'client' && clientName != null)
                      _buildInfoRow(context, Icons.person_outline, clientName!),
                    if (userRole != 'photographer' && photographerName != null)
                      _buildInfoRow(
                        context,
                        Icons.camera_alt_outlined,
                        photographerName!,
                      ),

                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      Icons.location_on_outlined,
                      order.location,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      Icons.calendar_today_outlined,
                      DateFormat('d MMMM y, HH:mm', 'ru_RU').format(order.date),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      Icons.monetization_on_outlined,
                      '${order.price} ₸',
                    ),
                    if (order.comment != null && order.comment!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        context,
                        Icons.comment_outlined,
                        order.comment!,
                      ),
                    ],
                    if (order.result != null && order.result!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Результат работы',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              order.result!,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            // Кнопка использует стиль темы
                            TextButton.icon(
                              onPressed: () =>
                                  _copyToClipboard(context, order.result!),
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('Скопировать ссылку'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Закрыть'),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.service,
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // --- 7. "Четкий" блок информации ---
              _buildInfoRow(
                context,
                Icons.calendar_today_outlined,
                DateFormat('d MMMM y, HH:mm', 'ru_RU').format(order.date),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.location_on_outlined,
                order.location,
              ),
              const SizedBox(height: 8),

              // Показываем фотографа (если он есть)
              if (photographerName != null) ...[
                _buildInfoRow(
                  context,
                  Icons.camera_alt_outlined,
                  photographerName!,
                ),
                const SizedBox(height: 8),
              ],

              // Показываем результат (если он есть)
              if (order.status == 'completed' && order.result != null) ...[
                _buildInfoRow(
                  context,
                  Icons.check_circle_outline_rounded,
                  'Результат доступен',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
