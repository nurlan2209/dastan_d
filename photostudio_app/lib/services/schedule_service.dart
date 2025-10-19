import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/order_model.dart';

class ScheduleService {
  final String? _token;
  ScheduleService(this._token);

  Future<List<Order>> fetchSchedule() async {
    if (_token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/schedule'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Бэкенд возвращает заказы, поэтому мы можем использовать Order.fromJson
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schedule: ${response.body}');
    }
  }
}
