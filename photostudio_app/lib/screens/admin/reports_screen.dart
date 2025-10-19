// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/screens/admin/reports_screen.dart

import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Отчеты')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // TODO: Здесь будет логика для загрузки статистики
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Общая статистика', style: theme.textTheme.titleLarge),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(context, '1,200,000 ₸', 'Доход (Месяц)'),
                      _buildStatColumn(context, '32', 'Заказов (Месяц)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('Экспорт данных', style: theme.textTheme.titleMedium),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.picture_as_pdf_rounded,
                color: theme.colorScheme.error,
              ),
              title: Text('Экспорт в PDF'),
              subtitle: Text('Сгенерировать PDF-отчет'),
              trailing: Icon(Icons.download_rounded),
              onTap: () {
                // TODO: Вызвать API /reports/pdf
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.table_chart_rounded,
                color: Colors.green[700],
              ),
              title: Text('Экспорт в CSV'),
              subtitle: Text('Сгенерировать CSV-таблицу'),
              trailing: Icon(Icons.download_rounded),
              onTap: () {
                // TODO: Вызвать API /reports/csv
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.primaryColor,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
