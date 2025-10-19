import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'auth_provider.dart';

class OrderProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  late OrderService _orderService;
  List<Order> _orders = [];
  bool _isLoading = false;

  OrderProvider() {
    _orderService = OrderService(null);
  }

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  void update(AuthProvider authProvider) {
    _authProvider = authProvider;
    _orderService = OrderService(_authProvider);
  }

  Future<void> fetchOrders({String? status}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderService.getOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    await _orderService.createOrder(orderData);
    await fetchOrders();
  }

  Future<void> updateOrder(String id, Map<String, dynamic> updates) async {
    await _orderService.updateOrder(id, updates);
    await fetchOrders();
  }

  Future<void> deleteOrder(String id) async {
    await _orderService.deleteOrder(id);
    await fetchOrders();
  }
}
