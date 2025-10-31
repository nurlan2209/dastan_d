import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import 'my_reviews_screen.dart';
import 'order_details_screen.dart';

class PhotographerOrdersScreen extends StatefulWidget {
  const PhotographerOrdersScreen({super.key});

  @override
  _PhotographerOrdersScreenState createState() =>
      _PhotographerOrdersScreenState();
}

class _PhotographerOrdersScreenState extends State<PhotographerOrdersScreen> {
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

  Future<void> _updateStatus(String orderId, String status) async {
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

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }

  Future<void> _completeOrder(String orderId) async {
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.grey.shade600;
      case 'assigned':
      case 'pending':
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
      case 'new':
        chipColor = const Color(0xFFFEF3C7);
        statusText = 'Новый';
        break;
      case 'assigned':
        chipColor = const Color(0xFFDBEAFE);
        statusText = 'Назначен';
        break;
      case 'pending':
      case 'confirmed':
        chipColor = const Color(0xFFFEF3C7);
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
      'new': 'В ожидании',
      'in_progress': 'Подтверждён',
      'completed': 'Завершённые',
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Мои заказы',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text('Фотограф',
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.9))),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.rate_review, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhotographerReviewsScreen(),
                ),
              );
            },
            tooltip: 'Мои отзывы',
          ),
          IconButton(
            icon: Icon(Icons.logout_outlined, color: Colors.white),
            onPressed: () => _logout(context),
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
              final filteredOrders = provider.orders.where((order) {
                if (_currentStatusFilter == 'all') return true;
                if (_currentStatusFilter == 'new') {
                  return order.status == 'assigned' ||
                      order.status == 'pending' ||
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
                            Text('Нет заказов по данному фильтру',
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
    final clientPhone = order.client?.phone;
    final clientEmail = order.client?.email;
    final borderColor = _getStatusColor(order.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotographerOrderDetailsScreen(order: order),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.person_outline, clientName),
              if (clientPhone != null && clientPhone.isNotEmpty)
                _buildInfoRow(Icons.phone, clientPhone),
              if (clientEmail != null && clientEmail.isNotEmpty)
                _buildInfoRow(Icons.email_outlined, clientEmail),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                DateFormat('yyyy-MM-dd', 'ru_RU').format(order.date),
              ),
              _buildInfoRow(Icons.location_on_outlined, order.location),
              const SizedBox(height: 12),
              _buildActionButtons(order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Order order) {
    switch (order.status) {
      case 'assigned':
      case 'pending':
      case 'confirmed':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _updateStatus(order.id, 'in_progress'),
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text('Начать работу'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        );
      case 'in_progress':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _completeOrder(order.id),
            icon: const Icon(Icons.upload_outlined, size: 20),
            label: const Text('Загрузить результаты'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
