import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Order> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEventsForSelectedDay();
  }

  void _loadEventsForSelectedDay() {
    final allOrders = context.read<OrderProvider>().orders;
    setState(() {
      _selectedEvents = _getEventsForDay(allOrders, _selectedDay!);
    });
  }

  List<Order> _getEventsForDay(List<Order> orders, DateTime day) {
    return orders.where((order) => isSameDay(order.date, day)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      final allOrders = context.read<OrderProvider>().orders;
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents = _getEventsForDay(allOrders, selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Слушаем изменения в заказах
    final allOrders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Мой график')),
      body: Column(
        children: [
          TableCalendar<Order>(
            locale: 'ru_RU',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: (day) => _getEventsForDay(allOrders, day),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: theme.textTheme.titleLarge!.copyWith(
                fontSize: 18,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(theme, events.length),
                  );
                }
                return null;
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                // 1. ИСПРАВЛЕНО: `withOpacity` -> `withAlpha`
                color: theme.colorScheme.secondary.withAlpha(128),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList(theme)),
        ],
      ),
    );
  }

  Widget _buildEventsMarker(ThemeData theme, int count) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.secondary,
      ),
      width: 16,
      height: 16,
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(ThemeData theme) {
    if (_selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'На выбранный день заказов нет',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }
    return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        final event = _selectedEvents[index];
        return Card(
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('HH', 'ru_RU').format(event.date),
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  DateFormat('mm', 'ru_RU').format(event.date),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            title: Text(event.service),
            subtitle: Text(
              'Клиент: ${event.clientName ?? '...'}',
            ), // Показываем имя клиента
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Навигация на экран деталей заказа
            },
          ),
        );
      },
    );
  }
}
