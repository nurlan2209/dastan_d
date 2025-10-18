import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Расписание')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Дата: ${_selectedDate.toString().split(' ')[0]}'),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: Text('Выбрать дату'),
            ),
            TextField(
              controller: _startTimeController,
              decoration: InputDecoration(labelText: 'Время начала (HH:MM)'),
            ),
            TextField(
              controller: _endTimeController,
              decoration: InputDecoration(labelText: 'Время окончания (HH:MM)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}
