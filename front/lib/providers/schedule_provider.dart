import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/schedule_service.dart';
import 'auth_provider.dart';

class ScheduleProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  List<Order> _scheduledOrders = [];
  bool _isLoading = false;

  ScheduleProvider();

  List<Order> get scheduledOrders => _scheduledOrders;
  bool get isLoading => _isLoading;

  void update(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<void> fetchSchedule() async {
    if (_authProvider?.token == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final scheduleService = ScheduleService(_authProvider!.token);
      _scheduledOrders = await scheduleService.fetchSchedule();
    } catch (error) {
      print('Error fetching schedule: $error');
      _scheduledOrders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
