// photostudio_app/lib/screens/admin/create_photographer_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../config/api_config.dart';
import '../../providers/auth_provider.dart';

class CreatePhotographerScreen extends StatefulWidget {
  const CreatePhotographerScreen({super.key});

  @override
  State<CreatePhotographerScreen> createState() =>
      _CreatePhotographerScreenState();
}

class _CreatePhotographerScreenState extends State<CreatePhotographerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createPhotographer() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final token = context.read<AuthProvider>().token;
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'phone': _phoneController.text,
          'role': 'photographer',
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Фотограф успешно создан!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Ошибка создания: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать аккаунт фотографа'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF2563EB).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF2563EB)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Создание аккаунта для фотографа. Он сможет войти с этими данными.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text('Имя фотографа*',
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Иван Иванов',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Введите имя' : null,
              ),
              const SizedBox(height: 20),

              Text('Email*', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'photographer@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Введите Email' : null,
              ),
              const SizedBox(height: 20),

              Text('Телефон*', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: '+7 7XX XXX XXXX',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'Введите телефон' : null,
              ),
              const SizedBox(height: 20),

              Text('Пароль*', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Минимум 6 символов',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Минимум 6 символов' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: _createPhotographer,
                        icon: Icon(Icons.add_rounded),
                        label: Text('Создать фотографа'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}