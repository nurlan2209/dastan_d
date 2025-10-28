import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/report_provider.dart';
import '../../services/report_service.dart';
import '../../providers/auth_provider.dart';
import 'photographer_payments_screen.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  late Future<void> _fetchSummaryFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchSummaryFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<ReportProvider>(context, listen: false).fetchSummary();
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    await _loadData();
    setState(() => _isRefreshing = false);
  }

  Future<void> _downloadReport(String format) async {
    final token = context.read<AuthProvider>().token;
    final reportService = ReportService(token);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await reportService.downloadReport(format);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Загрузка отчета началась...'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки отчета: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отчеты и Статистика'),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refresh,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchSummaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Ошибка загрузки: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повторить'),
                    onPressed: _refresh,
                  ),
                ],
              ),
            );
          }

          return Consumer<ReportProvider>(
            builder: (context, reportProvider, child) {
              final summary = reportProvider.summary;
              if (summary.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.analytics_outlined,
                          size: 64, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text(
                        'Нет данных для отображения',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Создайте заказы для просмотра статистики',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              final totalRevenue = summary['totalRevenue'] ?? 0;
              final totalOrders = summary['totalOrders'] ?? 0;
              final avgOrderPrice = summary['avgOrderPrice'] ?? 0;
              final completionRate = summary['completionRate'] ?? 0.0;
              final userStats = summary['userStats'] ?? {};
              final ordersByStatus = summary['ordersByStatus'] ?? {};
              final topPhotographersByOrders =
                  summary['topPhotographersByOrders'] ?? [];
              final topPhotographersByRating =
                  summary['topPhotographersByRating'] ?? [];
              final ordersByMonth = summary['ordersByMonth'] ?? [];

              final numberFormat = NumberFormat.currency(
                locale: 'ru_RU',
                symbol: '₸',
                decimalDigits: 0,
              );

              return RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ключевые метрики
                      Text(
                        'Ключевые метрики',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildKeyMetricsGrid(
                        context,
                        totalOrders,
                        totalRevenue,
                        avgOrderPrice,
                        completionRate,
                        userStats,
                        numberFormat,
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      // График заказов по месяцам
                      if (ordersByMonth.isNotEmpty) ...[
                        Text(
                          'Динамика заказов',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMonthlyChart(context, ordersByMonth),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                      ],

                      // Статистика по статусам
                      if (ordersByStatus.isNotEmpty) ...[
                        Text(
                          'Распределение заказов по статусам',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatusDistribution(context, ordersByStatus),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                      ],

                      // Топ фотографов
                      if (topPhotographersByOrders.isNotEmpty) ...[
                        Text(
                          'Топ фотографов по заказам',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTopPhotographers(
                            context, topPhotographersByOrders, true),
                        const SizedBox(height: 24),
                      ],

                      if (topPhotographersByRating.isNotEmpty) ...[
                        Text(
                          'Топ фотографов по рейтингу',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTopPhotographers(
                            context, topPhotographersByRating, false),
                        const SizedBox(height: 24),
                      ],

                      const Divider(),
                      const SizedBox(height: 24),

                      // Выплаты фотографам
                      Text(
                        'Выплаты фотографам',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.payments, color: Colors.green),
                          title: const Text('Расчет выплат'),
                          subtitle: const Text('Просмотр ведомости выплат фотографам'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhotographerPaymentsScreen(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Экспорт отчетов
                      Text(
                        'Экспорт отчетов',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildExportButtons(context),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildKeyMetricsGrid(
    BuildContext context,
    int totalOrders,
    num totalRevenue,
    num avgOrderPrice,
    double completionRate,
    Map<String, dynamic> userStats,
    NumberFormat numberFormat,
  ) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard(
          context,
          'Всего заказов',
          totalOrders.toString(),
          Icons.shopping_bag_outlined,
          Colors.blue,
        ),
        _buildMetricCard(
          context,
          'Общий доход',
          numberFormat.format(totalRevenue),
          Icons.monetization_on_outlined,
          Colors.green,
        ),
        _buildMetricCard(
          context,
          'Средний чек',
          numberFormat.format(avgOrderPrice),
          Icons.receipt_long_outlined,
          Colors.orange,
        ),
        _buildMetricCard(
          context,
          'Завершенность',
          '${completionRate.toStringAsFixed(1)}%',
          Icons.check_circle_outline,
          Colors.teal,
        ),
        _buildMetricCard(
          context,
          'Клиентов',
          (userStats['client'] ?? 0).toString(),
          Icons.person_outline,
          Colors.purple,
        ),
        _buildMetricCard(
          context,
          'Фотографов',
          (userStats['photographer'] ?? 0).toString(),
          Icons.camera_alt_outlined,
          Colors.pink,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: color.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart(BuildContext context, List<dynamic> ordersByMonth) {
    if (ordersByMonth.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final spots = <FlSpot>[];

    for (int i = 0; i < ordersByMonth.length; i++) {
      final month = ordersByMonth[i];
      spots.add(FlSpot(i.toDouble(), (month['count'] ?? 0).toDouble()));
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: theme.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < ordersByMonth.length) {
                            final month = ordersByMonth[value.toInt()]['month']
                                .toString()
                                .split('-')[1];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                month,
                                style: theme.textTheme.bodySmall,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDistribution(
      BuildContext context, Map<String, dynamic> ordersByStatus) {
    final theme = Theme.of(context);
    final statusTranslate = {
      'new': 'Новые',
      'assigned': 'Назначены',
      'in_progress': 'В работе',
      'completed': 'Завершены',
      'cancelled': 'Отменены',
      'archived': 'Архив',
    };

    final statusColors = {
      'new': Colors.blue,
      'assigned': Colors.orange,
      'in_progress': Colors.purple,
      'completed': Colors.green,
      'cancelled': Colors.red,
      'archived': Colors.grey,
    };

    final total = ordersByStatus.values.fold<num>(0, (sum, val) => sum + val);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: ordersByStatus.entries.map((entry) {
            final status = entry.key;
            final count = entry.value as num;
            final percentage = total > 0 ? (count / total * 100) : 0.0;
            final statusName = statusTranslate[status] ?? status;
            final color = statusColors[status] ?? Colors.grey;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            statusName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$count (${percentage.toStringAsFixed(1)}%)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: total > 0 ? count / total : 0,
                      backgroundColor: color.withOpacity(0.2),
                      color: color,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTopPhotographers(
      BuildContext context, List<dynamic> photographers, bool byOrders) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: photographers.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final photographer = photographers[index];
          final name = photographer['name'] ?? 'Неизвестно';
          final email = photographer['email'] ?? '';
          final rating = photographer['rating'] ?? 0.0;
          final orderCount = photographer['orderCount'];
          final reviewsCount = photographer['reviewsCount'];

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: _getMedalColor(index),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              email,
              style: theme.textTheme.bodySmall,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (byOrders && orderCount != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$orderCount заказов',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (!byOrders) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (reviewsCount != null)
                    Text(
                      '$reviewsCount отзывов',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getMedalColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildExportButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Скачать PDF'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _downloadReport('pdf'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.table_chart_outlined),
            label: const Text('Скачать CSV'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _downloadReport('csv'),
          ),
        ),
      ],
    );
  }
}
