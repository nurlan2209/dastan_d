import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late Future<void> _loadDataFuture;
  String _currentStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Admin fetches all orders
      await context.read<OrderProvider>().fetchOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки заказов: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // --- UI Helper Widgets ---

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = const Color(0xFFFEF3C7); // Amber 100
        statusText = 'В ожидании';
        break;
      case 'confirmed':
        chipColor = const Color(0xFFDBEAFE); // Blue 100
        statusText = 'Подтвержден';
        break;
      case 'in_progress':
        chipColor = const Color(0xFFDBEAFE); // Blue 100
        statusText = 'В работе';
        break;
      case 'completed':
        chipColor = const Color(0xFFD1FAE5); // Green 100
        statusText = 'Завершен';
        break;
      case 'cancelled':
        chipColor = const Color(0xFFFEE2E2); // Red 100
        statusText = 'Отменен';
        break;
      default:
        chipColor = const Color(0xFFF3F4F6); // Gray 100
        statusText = status.toUpperCase();
    }

    return Chip(
      label: Text(statusText),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: const Color(0xFF1F2937), // Gray 800
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
      'pending': 'В ожидании',
      'confirmed': 'Подтвержденные',
      'in_progress': 'В работе',
      'completed': 'Завершенные',
      'cancelled': 'Отмененные',
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
                if (selected) setState(() => _currentStatusFilter = entry.key);
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
      appBar: AppBar(title: const Text('Все Заказы')),
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<OrderProvider>(
            builder: (context, provider, child) {
              final filteredOrders = provider.orders.where((order) {
                if (_currentStatusFilter == 'all') return true;
                return order.status == _currentStatusFilter;
              }).toList();

              return Column(
                children: [
                  _buildFilterChips(),
                  if (provider.isLoading && filteredOrders.isEmpty)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (filteredOrders.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Заказы с таким статусом не найдены.',
                          style: theme.textTheme.titleMedium,
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
    final photographerName = order.photographer?.name ?? 'Не назначен';

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'ID: ${order.id}',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.person_outline, 'Клиент: $clientName'),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.camera_alt_outlined,
              'Фотограф: $photographerName',
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
              Icons.credit_card_outlined,
              '${order.price.toStringAsFixed(0)} KZT',
            ),
            const SizedBox(height: 16),
            // TODO: Add admin actions like assigning a photographer
            if (order.status == 'pending')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Placeholder for assigning photographer
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Функционал назначения в разработке'),
                      ),
                    );
                  },
                  child: const Text('Назначить фотографа'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
