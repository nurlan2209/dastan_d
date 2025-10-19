import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

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

  Future<void> _cancelOrder(String orderId) async {
    // Ваша логика отмены заказа
    final orderProvider = context.read<OrderProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await orderProvider.updateOrder(orderId, {'status': 'cancelled'});
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Заказ успешно отменен'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Ошибка отмены заказа: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _viewResult(String url) async {
    // Логика для просмотра результата
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось открыть ссылку: $url'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    // Ваша логика выхода
    await context.read<AuthProvider>().logout();
    // Навигация произойдет автоматически через AuthWrapper
  }

  // --- UI-хелперы для нового дизайна ---

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

  // --- ОСНОВНОЙ UI ЭКРАНА ПОЛНОСТЬЮ ПЕРЕРАБОТАН ---
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
                if (_currentStatusFilter == 'in_progress') {
                  return order.status == 'in_progress' ||
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
                              'Нет заказов',
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              'Нажмите "+", чтобы создать новый заказ',
                              style: theme.textTheme.bodyMedium,
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-order'),
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- КАРТОЧКА ЗАКАЗА В НОВОМ ДИЗАЙНЕ ---
  Widget _buildOrderCard(BuildContext context, Order order) {
    final theme = Theme.of(context);
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
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
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

  // --- КНОПКИ ДЕЙСТВИЙ ДЛЯ КЛИЕНТА ---
  Widget _buildActionButtons(BuildContext context, Order order) {
    switch (order.status) {
      case 'pending':
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Отменить заказ'),
            onPressed: () => _cancelOrder(order.id),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
              ),
            ),
          ),
        );
      case 'completed':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: order.result != null
                  ? () => _viewResult(order.result!)
                  : null,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Посмотреть результат'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Функционал отзывов в разработке'),
                  ),
                );
              },
              icon: const Icon(Icons.star_outline_rounded),
              label: const Text('Оставить отзыв'),
            ),
          ],
        );
      default:
        // Для статусов 'confirmed', 'in_progress', 'cancelled' кнопок нет
        return const SizedBox.shrink();
    }
  }
}
