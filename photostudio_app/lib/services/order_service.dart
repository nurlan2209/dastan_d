import '../models/order_model.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _api = ApiService();

  Future<List<Order>> getOrders({String? status}) async {
    final queryParams = status != null ? '?status=$status' : '';
    final response = await _api.get('/orders$queryParams');
    return (response.data as List).map((json) => Order.fromJson(json)).toList();
  }

  Future<Order> getOrderById(String id) async {
    final response = await _api.get('/orders/$id');
    return Order.fromJson(response.data);
  }

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    final response = await _api.post('/orders', data: orderData);
    return Order.fromJson(response.data);
  }

  Future<Order> updateOrder(String id, Map<String, dynamic> updates) async {
    final response = await _api.put('/orders/$id', data: updates);
    return Order.fromJson(response.data);
  }

  Future<void> deleteOrder(String id) async {
    await _api.delete('/orders/$id');
  }
}
