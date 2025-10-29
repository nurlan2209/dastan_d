import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/user_provider.dart';

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
      await context.read<UserProvider>().fetchUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки: $e'),
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
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Заказ: ${order.service}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Статус',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),

              // FIXED: Wrap the content in Expanded + SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildDetailRow(
                          Icons.person_outline, 'Клиент', clientName),
                      _buildDetailRow(
                          Icons.phone_outlined, 'Телефон', clientPhone),
                      _buildDetailRow(Icons.camera_alt_outlined, 'Фотограф',
                          photographerName),
                      _buildDetailRow(
                        Icons.calendar_today_outlined,
                        'Дата съёмки',
                        DateFormat('yyyy-MM-dd HH:mm', 'ru_RU')
                            .format(order.date),
                      ),
                      _buildDetailRow(Icons.location_on_outlined, 'Локация',
                          order.location),
                      _buildDetailRow(Icons.credit_card_outlined, 'Цена',
                          '${order.price.toStringAsFixed(0)} ₸'),

                      if (order.comment != null &&
                          order.comment!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(Icons.comment_outlined, 'Комментарий',
                            order.comment!),
                      ],

                      // Назначение фотографа (только если не назначен или статус новый/в ожидании)
                      if (order.photographerId == null ||
                          order.status == 'new' ||
                          order.status == 'pending') ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          'Назначить фотографа',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        _AssignPhotographerSection(order: order),
                      ],
                      const SizedBox(height: 16), // Extra padding at bottom
                    ],
                  ),
                ),
              ),
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
      case 'new':
      case 'pending':
        return Colors.yellow.shade700;
      case 'confirmed':
      case 'assigned':
        return Colors.blue.shade600;
      case 'in_progress':
        return Colors.purple.shade600;
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
      case 'pending':
        chipColor = const Color(0xFFFEF3C7);
        statusText = 'Новый';
        break;
      case 'confirmed':
      case 'assigned':
        chipColor = const Color(0xFFDBEAFE);
        statusText = 'Назначен';
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
      labelStyle: TextStyle(
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
      'new': 'Новые',
      'assigned': 'Назначен',
      'in_progress': 'В работе',
      'completed': 'Завершён',
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
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Color(0xFF2563EB),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Управление заказами',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text('Администратор',
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
                if (_currentStatusFilter == 'new') {
                  return order.status == 'new' || order.status == 'pending';
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
                            Text('Заказы не найдены',
                                style: Theme.of(context).textTheme.titleLarge),
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

// Секция назначения фотографа
class _AssignPhotographerSection extends StatefulWidget {
  final Order order;

  const _AssignPhotographerSection({required this.order});

  @override
  State<_AssignPhotographerSection> createState() =>
      _AssignPhotographerSectionState();
}

class _AssignPhotographerSectionState
    extends State<_AssignPhotographerSection> {
  String? _selectedPhotographerId;
  bool _isAssigning = false;

  Future<void> _assignPhotographer() async {
    if (_selectedPhotographerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выберите фотографа')),
      );
      return;
    }

    setState(() => _isAssigning = true);

    try {
      await context.read<OrderProvider>().updateOrder(
        widget.order.id,
        {
          'photographerId': _selectedPhotographerId,
          'status': 'assigned',
        },
      );

      if (!mounted) return;
      Navigator.pop(context); // Закрыть диалог
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Фотограф назначен!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isAssigning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final photographers = userProvider.users
            .where((user) => user.role == 'photographer')
            .toList();

        if (photographers.isEmpty) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Нет доступных фотографов. Создайте аккаунт фотографа.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Выберите фотографа',
                prefixIcon: Icon(Icons.camera_alt_outlined),
              ),
              value: _selectedPhotographerId,
              items: photographers.map((photographer) {
                return DropdownMenuItem(
                  value: photographer.id,
                  child: Text(photographer.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedPhotographerId = value);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _isAssigning
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _assignPhotographer,
                      icon: Icon(Icons.check_circle_outline),
                      label: Text('Назначить фотографа'),
                    ),
            ),
          ],
        );
      },
    );
  }
}
