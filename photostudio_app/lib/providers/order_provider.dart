import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders({String? status}) async {
    _isLoading = true;
    notifyListeners();

    _orders = await _orderService.getOrders(status: status);

    _isLoading = false;
    notifyListeners();
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
