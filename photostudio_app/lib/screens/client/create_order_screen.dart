// [ИСПРАВЛЕННЫЙ ФАЙЛ]
// photostudio_app/lib/screens/client/create_order_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- 1. Добавьте импорт для даты
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
// import '../../providers/auth_provider.dart'; // Больше не нужен для 'role'

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _commentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<OrderProvider>().createOrder({
        'service': _serviceController.text,
        'location': _locationController.text,
        'price': double.parse(_priceController.text),
        'date': _selectedDate.toIso8601String(),
        'comment': _commentController.text,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Заказ создан успешно!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- 2. Добавлен выбор времени ---
  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // 3. AppBar и Scaffold теперь берут стили из AppTheme
      appBar: AppBar(
        title: Text('Новый заказ'),
        // 'role' убран, он здесь не нужен
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // 4. Card использует стиль из AppTheme
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Детали заказа',
                      // 5. Текст использует стиль из AppTheme
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 24),
                    // 6. TextFormField использует стиль из AppTheme
                    TextFormField(
                      controller: _serviceController,
                      decoration: InputDecoration(
                        labelText: 'Услуга * (напр. "Свадебная съемка")',
                        prefixIcon: Icon(Icons.camera_alt_outlined),
                      ),
                      validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Место съёмки *',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Предлагаемая цена (₸) *',
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: 'Комментарий (по желанию)',
                        prefixIcon: Icon(Icons.comment_outlined),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                // 7. Цвет иконки из AppTheme
                leading: Icon(Icons.calendar_today, color: theme.primaryColor),
                title: Text('Дата и время съёмки'),
                subtitle: Text(
                  // 8. Форматируем дату и время
                  DateFormat('d MMMM y, HH:mm', 'ru_RU').format(_selectedDate),
                ),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: _selectDate, // 9. Используем новый метод
              ),
            ),
            SizedBox(height: 24),
            // 10. ElevatedButton использует стиль из AppTheme
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _createOrder,
                    // 11. Убраны все стили, используется AppTheme
                    child: Text('СОЗДАТЬ ЗАКАЗ'),
                  ),
          ],
        ),
      ),
    );
  }
}
