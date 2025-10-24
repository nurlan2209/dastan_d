import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';
import '../../services/report_service.dart';
import '../../providers/auth_provider.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  late Future<void> _fetchSummaryFuture;

  @override
  void initState() {
    super.initState();
    _fetchSummaryFuture = Provider.of<ReportProvider>(
      context,
      listen: false,
    ).fetchSummary();
  }

  Future<void> _downloadReport(String format) async {
    final token = context.read<AuthProvider>().token;
    final reportService = ReportService(token);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await reportService.downloadReport(format);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Загрузка отчета началась...')),
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
      appBar: AppBar(title: const Text('Отчеты и Статистика')),
      body: FutureBuilder(
        future: _fetchSummaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
          }

          return Consumer<ReportProvider>(
            builder: (context, reportProvider, child) {
              final summary = reportProvider.summary;
              if (summary.isEmpty) {
                return const Center(
                  child: Text('Не удалось загрузить статистику.'),
                );
              }

              final totalRevenue = summary['totalRevenue'] ?? 0;
              final numberFormat = NumberFormat.currency(
                locale: 'kk_KZ',
                symbol: '₸',
                decimalDigits: 0,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ключевые метрики', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildStatCard(
                          context,
                          'Всего заказов',
                          (summary['totalOrders'] ?? 0).toString(),
                          Icons.list_alt_outlined,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          context,
                          'Общий доход',
                          numberFormat.format(totalRevenue),
                          Icons.monetization_on_outlined,
                          Colors.green,
                        ),
                        _buildStatCard(
                          context,
                          'Клиентов',
                          (summary['userStats']?['client'] ?? 0).toString(),
                          Icons.person_outline,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          context,
                          'Фотографов',
                          (summary['userStats']?['photographer'] ?? 0)
                              .toString(),
                          Icons.camera_alt_outlined,
                          Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    Text(
                      'Выгрузить отчет по заказам',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text('PDF'),
                            onPressed: () => _downloadReport('pdf'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.table_chart_outlined),
                            label: const Text('CSV'),
                            onPressed: () => _downloadReport('csv'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
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
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
