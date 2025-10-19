import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/order_model.dart';
import '../../providers/schedule_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  late Future<void> _fetchScheduleFuture;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchScheduleFuture = Provider.of<ScheduleProvider>(
      context,
      listen: false,
    ).fetchSchedule();
  }

  List<Order> _getEventsForDay(List<Order> orders, DateTime day) {
    // Ваша логика получения событий для дня
    return orders.where((order) => isSameDay(order.date, day)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Ваша логика выбора дня
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Мой График')),
      body: FutureBuilder(
        future: _fetchScheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
          }

          return Consumer<ScheduleProvider>(
            builder: (context, scheduleProvider, child) {
              final scheduledOrders = scheduleProvider.scheduledOrders;
              final selectedDayEvents = _getEventsForDay(
                scheduledOrders,
                _selectedDay!,
              );

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCalendar<Order>(
                          locale: 'ru_RU',
                          firstDay: DateTime.utc(2022, 1, 1),
                          lastDay: DateTime.utc(2032, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: _onDaySelected,
                          eventLoader: (day) =>
                              _getEventsForDay(scheduledOrders, day),
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: theme.textTheme.titleMedium!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  Expanded(child: _buildEventList(context, selectedDayEvents)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventList(BuildContext context, List<Order> events) {
    if (events.isEmpty) {
      return const Center(child: Text('На выбранный день заказов нет.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Text(
              DateFormat('HH:mm').format(event.date),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(
              event.service,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Text('Клиент: ${event.client?.name ?? '...'}'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // TODO: Navigate to order details screen
            },
          ),
        );
      },
    );
  }
}
