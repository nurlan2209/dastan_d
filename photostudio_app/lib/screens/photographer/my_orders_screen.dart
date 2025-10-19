// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/screens/photographer/my_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:photostudio_app/models/user_model.dart'; // <-- 1. УДАЛЕНО
// import 'package:photostudio_app/services/api_service.dart'; // <-- 1. УДАЛЕНО
import 'package:provider/provider.dart';
import '../../models/order_model.dart'; // <-- Нужна для _buildInfoRow
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class PhotographerOrdersScreen extends StatefulWidget {
  // 2. Добавлен const и key
  const PhotographerOrdersScreen({super.key});

  @override
  _PhotographerOrdersScreenState createState() =>
      _PhotographerOrdersScreenState();
}

class _PhotographerOrdersScreenState extends State<PhotographerOrdersScreen> {
  // --- 3. УДАЛЕНА логика загрузки Users ---
  // final ApiService _api = ApiService(); // <-- УДАЛЕНО
  // Map<String, String> _userMap = {}; // <-- УДАЛЕНО
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  // --- 4. УПРОЩЕНА функция загрузки ---
  Future<void> _loadData() async {
    try {
      if (!mounted) return;
      // Просто загружаем заказы. Имена уже будут в них.
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
  // --- Конец логики загрузки ---

  Future<void> _updateStatus(String orderId, String status) async {
    final orderProvider = context.read<OrderProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await orderProvider.updateOrder(orderId, {'status': status});
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Статус обновлён'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _completeOrder(String orderId) async {
    final _resultController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Завершить заказ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добавьте ссылку на результат работы:',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _resultController,
              decoration: InputDecoration(
                labelText: 'Ссылка на Google Drive / Яндекс.Диск',
                hintText: 'https://drive.google.com/...',
                prefixIcon: Icon(Icons.link),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final orderProvider = context.read<OrderProvider>();
              final resultText = _resultController.text;

              if (resultText.isEmpty) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Добавьте ссылку на результат'),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
                return;
              }
              nav.pop();

              try {
                await orderProvider.updateOrder(orderId, {
                  'status': 'completed',
                  'result': _resultController.text,
                });
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Заказ завершён!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Ошибка: $e'),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Завершить'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

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
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои заказы'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                        'Нет назначенных заказов',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: provider.orders.length,
                  itemBuilder: (context, index) {
                    final order = provider.orders[index];

                    // --- 5. ИСПРАВЛЕНИЕ: Берем имя из модели ---
                    final clientName = order.clientName ?? 'Неизвестный клиент';

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    order.service,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: 18,
                                    ),
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
                              Icons.person_outline,
                              'Клиент: $clientName',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              Icons.calendar_today_outlined,
                              DateFormat(
                                'd MMMM y, HH:mm',
                                'ru_RU',
                              ).format(order.date),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              Icons.location_on_outlined,
                              order.location,
                            ),

                            if (order.comment != null &&
                                order.comment!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withAlpha(
                                    (255 * 0.05).round(),
                                  ), // Linter fix
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: _buildInfoRow(
                                  context,
                                  Icons.comment_outlined,
                                  order.comment!,
                                ),
                              ),
                            ],

                            const SizedBox(height: 16),

                            if (order.status == 'confirmed') ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _updateStatus(order.id, 'in_progress'),
                                  icon: Icon(Icons.play_arrow_rounded),
                                  label: Text('Начать работу'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    foregroundColor:
                                        theme.colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                            ],
                            if (order.status == 'in_progress') ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => _completeOrder(order.id),
                                  icon: Icon(
                                    Icons.check_circle_outline_rounded,
                                  ),
                                  label: Text(
                                    'Завершить и отправить результат',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                            if (order.status == 'completed' &&
                                order.result != null) ...[
                              _buildInfoRow(
                                context,
                                Icons.check_circle_rounded,
                                'Результат отправлен',
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
