import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';

class OrderService {
  final AuthProvider? authProvider;
  OrderService(this.authProvider);

  String? get _token => authProvider?.token;

  Future<List<Order>> getOrders() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/orders'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Order.fromJson(item)).toList();
    }
    throw Exception('Failed to load orders');
  }

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode(orderData),
    );
    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<Order> updateOrder(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/orders/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update order');
    }
  }

  Future<void> deleteOrder(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/orders/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete order');
    }
  }
}
