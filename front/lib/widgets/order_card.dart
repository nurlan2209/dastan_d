// photostudio_app/lib/widgets/order_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final String? clientName;
  final String? photographerName;
  final String userRole;

  const OrderCard({
    super.key,
    required this.order,
    required this.userRole,
    this.clientName,
    this.photographerName,
  });

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

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(order.service, style: theme.textTheme.titleLarge),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- ИСПРАВЛЕНИЕ: Показываем имя клиента для всех ролей кроме клиента ---
                    if (userRole != 'client' && clientName != null)
                      _buildInfoRow(context, Icons.person_outline, clientName!),

                    // --- ДОБАВЛЕНО: Показываем телефон клиента для админа ---
                    if (userRole == 'admin' &&
                        order.clientPhone != null &&
                        order.clientPhone!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        context,
                        Icons.phone_outlined,
                        order.clientPhone!,
                      ),
                    ],

                    if (userRole != 'photographer' &&
                        photographerName != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        context,
                        Icons.camera_alt_outlined,
                        photographerName!,
                      ),
                    ],

                    const SizedBox(height: 8),
                    const Divider(height: 24),

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

              if (photographerName != null) ...[
                _buildInfoRow(
                  context,
                  Icons.camera_alt_outlined,
                  photographerName!,
                ),
                const SizedBox(height: 8),
              ],

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
