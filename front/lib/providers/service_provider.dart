import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/service_service.dart';

class ServiceProvider with ChangeNotifier {
  final ServiceService _serviceService = ServiceService();
  List<Service> _services = [];
  bool _isLoading = false;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;

  Future<void> fetchServices(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await _serviceService.getServices(token);
    } catch (e) {
      print('Error fetching services: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createService(String token, Map<String, dynamic> data) async {
    try {
      final newService = await _serviceService.createService(token, data);
      _services.add(newService);
      notifyListeners();
    } catch (e) {
      print('Error creating service: $e');
      rethrow;
    }
  }

  Future<void> updateService(
      String token, String serviceId, Map<String, dynamic> data) async {
    try {
      final updatedService =
          await _serviceService.updateService(token, serviceId, data);
      final index = _services.indexWhere((s) => s.id == serviceId);
      if (index != -1) {
        _services[index] = updatedService;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  Future<void> deleteService(String token, String serviceId) async {
    try {
      await _serviceService.deleteService(token, serviceId);
      _services.removeWhere((s) => s.id == serviceId);
      notifyListeners();
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }
}
