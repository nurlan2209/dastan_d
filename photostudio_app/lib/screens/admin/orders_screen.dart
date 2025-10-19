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

  void _showOrderDetails(Order order) {
    final clientName = order.client?.name ?? 'Неизвестный клиент';
    final clientPhone = order.client?.phone ?? 'Нет телефона';
    final photographerName = order.photographer?.name ?? 'Не назначен';

    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(128),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 700),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Детали заказа #ORD001',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Статус',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow(Icons.person_outline, 'Клиент', clientName),
              _buildDetailRow(Icons.phone_outlined, 'Телефон', clientPhone),
              _buildDetailRow(
                  Icons.camera_alt_outlined, 'Фотограф', photographerName),
              _buildDetailRow(
                Icons.calendar_today_outlined,
                'Дата съёмки',
                DateFormat('yyyy-MM-dd', 'ru_RU').format(order.date),
              ),
              _buildDetailRow(
                  Icons.location_on_outlined, 'Локация', order.location),
              _buildDetailRow(Icons.credit_card_outlined, 'Цена',
                  '${order.price.toStringAsFixed(0)} ₽'),
              const SizedBox(height: 24),
              if (order.status == 'pending') ...[
                Text(
                  'Назначить фотографа',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Выберите фотографа',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Анна Петрова')),
                    DropdownMenuItem(value: '2', child: Text('Иван Сидоров')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Функционал назначения в разработке')),
                      );
                    },
                    child: Text('Завершить заказ'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Назначить фотографа'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow.shade700;
      case 'confirmed':
        return Colors.yellow.shade700;
      case 'in_progress':
        return Colors.blue.shade600;
      case 'completed':
        return Colors.green.shade600;
      case 'cancelled':
        return Colors.red.shade600;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = const Color(0xFFFEF3C7);
        statusText = 'В ожидании';
        break;
      case 'confirmed':
        chipColor = const Color(0xFFDBEAFE);
        statusText = 'Подтверждён';
        break;
      case 'in_progress':
        chipColor = const Color(0xFFDBEAFE);
        statusText = 'В работе';
        break;
      case 'completed':
        chipColor = const Color(0xFFD1FAE5);
        statusText = 'Завершён';
        break;
      case 'cancelled':
        chipColor = const Color(0xFFFEE2E2);
        statusText = 'Отменён';
        break;
      default:
        chipColor = const Color(0xFFF3F4F6);
        statusText = status;
    }

    return Chip(
      label: Text(statusText),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
      backgroundColor: chipColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = {
      'all': 'Все',
      'pending': 'В ожидании',
      'confirmed': 'Подтверждён',
      'in_progress': 'В работе',
      'completed': 'Завершён',
      'cancelled': 'Отменён',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Управление заказами',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Text('Администратор',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Найдено заказов: ${filteredOrders.length}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.refresh, size: 18),
                          label: Text('Обновить'),
                          onPressed: _loadData,
                        ),
                      ],
                    ),
                  ),
                  if (filteredOrders.isEmpty)
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
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return _buildOrderCard(order);
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

  Widget _buildOrderCard(Order order) {
    final clientName = order.client?.name ?? 'Неизвестный клиент';
    final photographerName = order.photographer?.name ?? 'Не назначен';
    final borderColor = _getStatusColor(order.status);

    return InkWell(
      onTap: () => _showOrderDetails(order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: borderColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${order.id.substring(0, 8)}...',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.person_outline, 'Клиент: $clientName'),
              _buildInfoRow(
                  Icons.camera_alt_outlined, 'Фотограф: $photographerName'),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                DateFormat('yyyy-MM-dd', 'ru_RU').format(order.date),
              ),
              _buildInfoRow(Icons.location_on_outlined, order.location),
            ],
          ),
        ),
      ),
    );
  }
}
