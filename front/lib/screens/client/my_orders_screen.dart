// photostudio_app/lib/screens/client/my_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  MyOrdersScreenState createState() => MyOrdersScreenState();
}

class MyOrdersScreenState extends State<MyOrdersScreen> {
  late Future<void> _loadDataFuture;
  String _currentStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
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


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Color(0xFF6B7280);
      case 'assigned':
      case 'pending':
      case 'confirmed':
        return Color(0xFFFBBF24);
      case 'in_progress':
        return Color(0xFF3B82F6);
      case 'completed':
        return Color(0xFF10B981);
      case 'cancelled':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'new':
        chipColor = Color(0xFFFEF3C7);
        statusText = 'Новый';
        break;
      case 'assigned':
        chipColor = Color(0xFFDBEAFE);
        statusText = 'Назначен фотограф';
        break;
      case 'pending':
        chipColor = Color(0xFFFEF3C7);
        statusText = 'В ожидании';
        break;
      case 'confirmed':
        chipColor = Color(0xFFDBEAFE);
        statusText = 'Подтверждён';
        break;
      case 'in_progress':
        chipColor = Color(0xFFDBEAFE);
        statusText = 'В работе';
        break;
      case 'completed':
        chipColor = Color(0xFFD1FAE5);
        statusText = 'Завершён';
        break;
      case 'cancelled':
        chipColor = Color(0xFFFEE2E2);
        statusText = 'Отменён';
        break;
      default:
        chipColor = Color(0xFFF3F4F6);
        statusText = status;
    }

    return Chip(
      label: Text(statusText),
      labelStyle: TextStyle(
        color: Color(0xFF030213),
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      backgroundColor: chipColor,
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Color(0xFF717182)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Color(0xFF030213)),
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
      'in_progress': 'Подтверждён',
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
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Color(0xFF2563EB),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/client-profile'),
          tooltip: 'Профиль',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Мои заказы',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text('Клиент',
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.9))),
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
                if (_currentStatusFilter == 'in_progress') {
                  return order.status == 'in_progress' ||
                      order.status == 'confirmed';
                }
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('Нет заказов',
                                style: theme.textTheme.titleLarge),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-order'),
        icon: Icon(Icons.add),
        label: Text('Новый заказ'),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final photographerName = order.photographer?.name ?? 'Не назначен';
    final borderColor = _getStatusColor(order.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: order),
          ),
        );
      },
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.camera_alt_outlined, photographerName),
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
