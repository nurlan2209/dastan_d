import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// --- 1. ИСПРАВЛЕН ПУТЬ К ФАЙЛУ ---
import '../models/order_model.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final String userRole; // 'admin', 'photographer', 'client'

  const OrderCard({super.key, required this.order, required this.userRole});

  // Вспомогательный виджет для отображения статуса
  Widget _buildStatusChip(BuildContext context, String status) {
    final theme = Theme.of(context);
    Color chipColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orangeAccent;
        statusText = 'ОЖИДАЕТ';
        break;
      case 'confirmed':
        chipColor = theme.primaryColor;
        statusText = 'НАЗНАЧЕН';
        break;
      case 'in_progress':
        chipColor = Colors.blueAccent;
        statusText = 'В РАБОТЕ';
        break;
      case 'completed':
        chipColor = Colors.green;
        statusText = 'ЗАВЕРШЕН';
        break;
      case 'cancelled':
        chipColor = Colors.redAccent;
        statusText = 'ОТМЕНЕН';
        break;
      default:
        chipColor = Colors.grey;
        statusText = status.toUpperCase();
    }

    return Chip(
      label: Text(
        statusText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      visualDensity: VisualDensity.compact,
    );
  }

  // Вспомогательная строка с иконкой
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  // Вспомогательная строка для телефона с кнопкой "Позвонить"
  Widget _buildPhoneRow(BuildContext context, String phone) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.phone_outlined,
            size: 18,
            color: theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              phone,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.phone_forwarded_rounded,
              color: theme.primaryColor,
            ),
            onPressed: () async {
              // --- 2. ИСПРАВЛЕНО ПРЕДУПРЕЖДЕНИЕ 'use_build_context_synchronously' ---
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
              );

              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              } else {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Не удалось совершить вызов')),
                );
              }
            },
            tooltip: 'Позвонить клиенту',
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientName = order.clientName ?? 'Имя клиента не найдено';
    final photographerName = order.photographerName ?? 'Не назначен';
    final clientPhone = order.clientPhone;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(order.service),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    if (userRole != 'client')
                      _buildInfoRow(
                        dialogContext,
                        Icons.person_outline,
                        'Клиент: $clientName',
                      ),
                    if (userRole == 'admin' &&
                        clientPhone != null &&
                        clientPhone.isNotEmpty)
                      _buildPhoneRow(dialogContext, clientPhone),
                    if (userRole != 'photographer')
                      _buildInfoRow(
                        dialogContext,
                        Icons.camera_alt_outlined,
                        'Фотограф: $photographerName',
                      ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      dialogContext,
                      Icons.calendar_today_outlined,
                      DateFormat('d MMMM y, HH:mm', 'ru_RU').format(order.date),
                    ),
                    _buildInfoRow(
                      dialogContext,
                      Icons.location_on_outlined,
                      order.location,
                    ),
                    _buildInfoRow(
                      dialogContext,
                      Icons.monetization_on_outlined,
                      '${order.price.toStringAsFixed(0)} ₸',
                    ),
                    if (order.comment != null && order.comment!.isNotEmpty)
                      // --- 3. ИСПРАВЛЕНА ОПЕЧАТКА В ИКОНКЕ ---
                      _buildInfoRow(
                        dialogContext,
                        Icons.notes_outlined,
                        order.comment!,
                      ),
                    if (order.result != null && order.result!.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        dialogContext,
                        Icons.link_rounded,
                        'Результат: ${order.result!}',
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Копировать'),
                          onPressed: () => _copyToClipboard(
                            dialogContext,
                            order.result!,
                            'Ссылка скопирована',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.service,
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              if (userRole == 'admin') ...[
                _buildInfoRow(context, Icons.person_outline, clientName),
                if (clientPhone != null && clientPhone.isNotEmpty)
                  _buildInfoRow(context, Icons.phone_outlined, clientPhone),
              ],
              if (userRole == 'photographer') ...[
                _buildInfoRow(context, Icons.person_outline, clientName),
              ],
              if (userRole == 'client') ...[
                _buildInfoRow(
                  context,
                  Icons.camera_alt_outlined,
                  photographerName,
                ),
              ],
              const SizedBox(height: 4),
              _buildInfoRow(
                context,
                Icons.calendar_today_outlined,
                DateFormat('d MMMM y, HH:mm', 'ru_RU').format(order.date),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
