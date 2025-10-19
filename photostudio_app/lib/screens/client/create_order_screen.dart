import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

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
    // Ваша логика создания заказа остается без изменений
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<OrderProvider>().createOrder({
        'service': _serviceController.text,
        'location': _locationController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'date': _selectedDate.toIso8601String(),
        'comment': _commentController.text,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

  Future<void> _selectDate() async {
    // Ваша логика выбора даты и времени остается без изменений
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

  // --- UI ЭКРАНА ПОЛНОСТЬЮ ПЕРЕРАБОТАН ---
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Новый заказ')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Услуга*', style: textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _serviceController,
                decoration: const InputDecoration(
                  hintText: 'Напр. "Свадебная съемка"',
                ),
                validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 20),
              Text('Место съёмки*', style: textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'Напр. "Парк Горького"',
                ),
                validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 20),
              Text('Предлагаемая цена (₸)*', style: textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(hintText: 'Введите сумму'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Обязательное поле';
                  if (double.tryParse(v) == null)
                    return 'Введите корректное число';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Дата и время*', style: textTheme.labelSmall),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    DateFormat(
                      'd MMMM y, HH:mm',
                      'ru_RU',
                    ).format(_selectedDate),
                    style: textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Комментарий', style: textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Любые пожелания к заказу',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _createOrder,
                        child: const Text('Создать заказ'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
