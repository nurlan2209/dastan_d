import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/service_model.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _commentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  Service? _selectedService;

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, выберите услугу'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<OrderProvider>().createOrder({
        'serviceId': _selectedService!.id,
        'service': _selectedService!.name,
        'location': _locationController.text,
        'price': _selectedService!.price,
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServices();
    });
  }

  Future<void> _loadServices() async {
    final authProvider = context.read<AuthProvider>();
    final serviceProvider = context.read<ServiceProvider>();
    try {
      await serviceProvider.fetchServices(authProvider.token!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки услуг: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // --- UI ЭКРАНА ПОЛНОСТЬЮ ПЕРЕРАБОТАН ---
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Новый заказ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Услуга*', style: textTheme.labelSmall),
              const SizedBox(height: 8),
              Consumer<ServiceProvider>(
                builder: (context, serviceProvider, child) {
                  if (serviceProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (serviceProvider.services.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Услуги пока не добавлены'),
                      ),
                    );
                  }

                  return DropdownButtonFormField<Service>(
                    value: _selectedService,
                    decoration: const InputDecoration(
                      hintText: 'Выберите услугу',
                    ),
                    items: serviceProvider.services.map((service) {
                      return DropdownMenuItem(
                        value: service,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(service.name),
                            Text(
                              '${service.price.toStringAsFixed(0)} ₸ • ${service.duration} мин',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (service) {
                      setState(() {
                        _selectedService = service;
                      });
                    },
                    validator: (v) =>
                        v == null ? 'Пожалуйста, выберите услугу' : null,
                  );
                },
              ),
              if (_selectedService != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedService!.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (_selectedService!.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(_selectedService!.description),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Стоимость: ${_selectedService!.price.toStringAsFixed(0)} ₸',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Длительность: ${_selectedService!.duration} мин',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
