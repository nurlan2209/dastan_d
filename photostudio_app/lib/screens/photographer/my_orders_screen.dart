import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class PhotographerOrdersScreen extends StatefulWidget {
  const PhotographerOrdersScreen({super.key});

  @override
  _PhotographerOrdersScreenState createState() =>
      _PhotographerOrdersScreenState();
}

class _PhotographerOrdersScreenState extends State<PhotographerOrdersScreen> {
  late Future<void> _loadDataFuture;
  String _currentStatusFilter = 'all'; // Состояние для фильтра

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    // Ваша логика загрузки данных
    try {
      if (!mounted) return;
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

  Future<void> _updateStatus(String orderId, String status) async {
    // Ваша логика обновления статуса
    final orderProvider = context.read<OrderProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await orderProvider.updateOrder(orderId, {'status': status});
      scaffoldMessenger.showSnackBar(
        const SnackBar(
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
    // Ваша логика завершения заказа
    final resultController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершить заказ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добавьте ссылку на результат работы:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resultController,
              decoration: const InputDecoration(
                labelText: 'Ссылка на Google Drive / Яндекс.Диск',
                hintText: 'https://drive.google.com/...',
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
            onPressed: () async {
              final nav = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final orderProvider = context.read<OrderProvider>();
              final resultText = resultController.text;

              if (resultText.isEmpty) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: const Text('Добавьте ссылку на результат'),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
                return;
              }
              nav.pop();

              try {
                await orderProvider.updateOrder(orderId, {
                  'status': 'completed',
                  'result': resultController.text,
                });
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
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
            child: const Text('Завершить'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    // Ваша логика выхода
    await context.read<AuthProvider>().logout();
  }

  // --- UI-хелперы обновлены под новый дизайн ---

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = const Color(0xFFFEF3C7); // Amber 100
        statusText = 'Новый';
        break;
      case 'confirmed':
        chipColor = const Color(0xFFFEF3C7); // Amber 100
        statusText = 'Новый';
        break;
      case 'in_progress':
        chipColor = const Color(0xFFDBEAFE); // Blue 100
        statusText = 'В работе';
        break;
      case 'completed':
        chipColor = const Color(0xFFD1FAE5); // Green 100
        statusText = 'Завершен';
        break;
      default:
        chipColor = const Color(0xFFF3F4F6); // Gray 100
        statusText = status.toUpperCase();
    }

    return Chip(
      label: Text(statusText),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: const Color(0xFF1F2937),
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: chipColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = {
      'all': 'Все',
      'new': 'Новые', // pending + confirmed
      'in_progress': 'В работе',
      'completed': 'Завершенные',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = _currentStatusFilter == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _currentStatusFilter = entry.key);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Заказы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _logout,
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<OrderProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredOrders = provider.orders.where((order) {
                if (_currentStatusFilter == 'all') return true;
                if (_currentStatusFilter == 'new') {
                  return order.status == 'pending' ||
                      order.status == 'confirmed';
                }
                return order.status == _currentStatusFilter;
              }).toList();

              return Column(
                children: [
                  _buildFilterChips(),
                  if (filteredOrders.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Нет заказов по данному фильтру',
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return _buildOrderCard(context, order);
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final theme = Theme.of(context);
    final clientName = order.client?.name ?? 'Неизвестный клиент';
    final clientPhone = order.client?.phone ?? 'Нет номера';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(context, order.status),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              Icons.person_outline,
              '$clientName ($clientPhone)',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.calendar_today_outlined,
              DateFormat('d MMMM y, HH:mm', 'ru_RU').format(order.date),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.location_on_outlined, order.location),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.credit_card_outlined,
              '${order.price.toStringAsFixed(0)} KZT',
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context, order),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Order order) {
    switch (order.status) {
      case 'pending': // Действие для новых заказов
      case 'confirmed':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _updateStatus(order.id, 'in_progress'),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Начать работу'),
          ),
        );
      case 'in_progress':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _completeOrder(order.id),
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: const Text('Завершить и отправить результат'),
          ),
        );
      case 'completed':
        return _buildInfoRow(
          context,
          Icons.check_circle_outline,
          'Результат отправлен',
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
