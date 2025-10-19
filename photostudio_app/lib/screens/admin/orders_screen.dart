import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/order_card.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final ApiService _api = ApiService();
  String? _filterStatus;
  List<User> _photographers = [];
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  // Загружаем заказы и фотографов (для диалога назначения)
  Future<void> _loadData() async {
    try {
      // Выполняем запросы параллельно для скорости
      await Future.wait([
        context.read<OrderProvider>().fetchOrders(status: _filterStatus),
        _loadPhotographers(),
      ]);
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

  // Функция для загрузки ТОЛЬКО фотографов
  Future<void> _loadPhotographers() async {
    try {
      // Бэкенд должен поддерживать /users?role=photographer
      final response = await _api.get('/users?role=photographer');
      if (!mounted) return;

      final photographerList = (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();

      setState(() {
        _photographers = photographerList;
      });
    } catch (e) {
      print('Could not load photographers: $e');
      if (mounted) setState(() => _photographers = []);
    }
  }

  // Диалог назначения фотографа
  Future<void> _assignPhotographer(String orderId) async {
    if (_photographers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет доступных фотографов для назначения'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Назначить фотографа'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _photographers.length,
            itemBuilder: (context, index) {
              final photographer = _photographers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(photographer.name),
                subtitle: Text(
                  'Рейтинг: ${photographer.rating.toStringAsFixed(1)} ★',
                ),
                onTap: () async {
                  final orderProvider = context.read<OrderProvider>();
                  Navigator.of(dialogContext).pop();

                  try {
                    await orderProvider.updateOrder(orderId, {
                      'photographerId': photographer.id,
                      'status': 'confirmed',
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Назначен: ${photographer.name}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  // Диалог удаления заказа
  void _showDeleteDialog(Order order) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить заказ?'),
        content: Text(
          'Вы уверены, что хотите удалить заказ "${order.service}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<OrderProvider>().deleteOrder(order.id);
            },
            child: Text(
              'Удалить',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Все заказы'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Фильтр по статусу',
            onSelected: (value) {
              setState(() => _filterStatus = value == 'all' ? null : value);
              context.read<OrderProvider>().fetchOrders(status: _filterStatus);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'all', child: Text('Все')),
              PopupMenuItem(value: 'pending', child: Text('Ожидают')),
              PopupMenuItem(value: 'confirmed', child: Text('Назначенные')),
              PopupMenuItem(value: 'completed', child: Text('Завершенные')),
              PopupMenuItem(value: 'cancelled', child: Text('Отмененные')),
            ],
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

              if (provider.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text('Нет заказов', style: theme.textTheme.titleLarge),
                      if (_filterStatus != null)
                        Text(
                          'в категории "$_filterStatus"',
                          style: theme.textTheme.bodyMedium,
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: provider.orders.length,
                  itemBuilder: (context, index) {
                    final order = provider.orders[index];
                    return Column(
                      children: [
                        OrderCard(order: order, userRole: 'admin'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _assignPhotographer(order.id),
                                  icon: Icon(
                                    order.photographerId == null
                                        ? Icons.person_add_alt_1_rounded
                                        : Icons.swap_horiz_rounded,
                                    size: 20,
                                  ),
                                  label: Text(
                                    order.photographerId == null
                                        ? 'Назначить'
                                        : 'Сменить',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        order.photographerId == null
                                        ? theme.primaryColor
                                        : theme.colorScheme.secondary,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: theme.colorScheme.error,
                                ),
                                onPressed: () => _showDeleteDialog(order),
                                tooltip: 'Удалить заказ',
                              ),
                            ],
                          ),
                        ),
                      ],
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
