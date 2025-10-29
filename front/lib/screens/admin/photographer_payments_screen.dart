import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/report_provider.dart';

class PhotographerPaymentsScreen extends StatefulWidget {
  const PhotographerPaymentsScreen({super.key});

  @override
  State<PhotographerPaymentsScreen> createState() =>
      _PhotographerPaymentsScreenState();
}

class _PhotographerPaymentsScreenState
    extends State<PhotographerPaymentsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  double _percentage = 70.0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Устанавливаем дату по умолчанию - текущий месяц
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    // Устанавливаем конец диапазона на сегодня или последний день месяца (что раньше)
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _endDate = now.isBefore(lastDayOfMonth) ? now : lastDayOfMonth;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPayments();
    });
  }

  Future<void> _loadPayments() async {
    try {
      await context.read<ReportProvider>().fetchPhotographerPayments(
            startDate: _startDate?.toIso8601String(),
            endDate: _endDate?.toIso8601String(),
            percentage: _percentage,
          );
      setState(() => _isLoaded = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
    }
  }

  Future<void> _selectDateRange() async {
    final now = DateTime.now();

    // Убедимся, что initialDateRange не выходит за пределы lastDate
    DateTimeRange? initialRange;
    if (_startDate != null && _endDate != null) {
      final safeEndDate = _endDate!.isAfter(now)
          ? DateTime(now.year, now.month, now.day)
          : _endDate!;
      initialRange = DateTimeRange(start: _startDate!, end: safeEndDate);
    }

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: initialRange,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadPayments();
    }
  }

  Future<void> _selectPercentage() async {
    final controller =
        TextEditingController(text: _percentage.toStringAsFixed(0));
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Процент выплаты'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Процент (%)',
            hintText: 'Например: 70',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0 && value <= 100) {
                Navigator.pop(context, value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Введите число от 1 до 100')),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _percentage = result);
      _loadPayments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₸',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выплаты фотографам'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _selectDateRange,
            tooltip: 'Выбрать период',
          ),
          IconButton(
            icon: const Icon(Icons.percent),
            onPressed: _selectPercentage,
            tooltip: 'Изменить процент',
          ),
        ],
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoadingPayments) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_isLoaded) {
            return const Center(child: Text('Загрузка данных...'));
          }

          final data = reportProvider.photographerPayments;
          final summary = data['summary'] ?? {};
          final payments = (data['payments'] ?? []) as List;

          if (payments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Нет данных за выбранный период'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Изменить период'),
                    onPressed: _selectDateRange,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadPayments,
            child: Column(
              children: [
                // Фильтры и сводка
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Период:',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            '${DateFormat('dd.MM.yyyy').format(_startDate!)} - ${DateFormat('dd.MM.yyyy').format(_endDate!)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Процент выплаты:',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            '${_percentage.toStringAsFixed(0)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Фотографов',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                '${summary['totalPhotographers'] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Общая выручка',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                numberFormat
                                    .format(summary['totalRevenue'] ?? 0),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Итого к выплате:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              numberFormat
                                  .format(summary['totalPayments'] ?? 0),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Список выплат
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              (payment['name'] ?? '?')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            payment['name'] ?? 'Неизвестно',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(payment['email'] ?? ''),
                              if (payment['phone'] != null &&
                                  payment['phone'].toString().isNotEmpty)
                                Text(
                                  payment['phone'],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                'Заказов: ${payment['totalOrders']} • Выручка: ${numberFormat.format(payment['totalRevenue'])}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              numberFormat.format(payment['payment']),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
