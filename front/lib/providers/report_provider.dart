import 'package:flutter/material.dart';
import '../services/report_service.dart';
import 'auth_provider.dart';

class ReportProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  Map<String, dynamic> _summary = {};
  Map<String, dynamic> _photographerPayments = {};
  bool _isLoading = false;
  bool _isLoadingPayments = false;

  ReportProvider();

  Map<String, dynamic> get summary => _summary;
  Map<String, dynamic> get photographerPayments => _photographerPayments;
  bool get isLoading => _isLoading;
  bool get isLoadingPayments => _isLoadingPayments;

  void update(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<void> fetchSummary() async {
    if (_authProvider?.token == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final reportService = ReportService(_authProvider!.token);
      _summary = await reportService.getSummary();
    } catch (error) {
      print('Error fetching summary: $error');
      _summary = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPhotographerPayments({
    String? startDate,
    String? endDate,
    double percentage = 70,
  }) async {
    if (_authProvider?.token == null) return;
    _isLoadingPayments = true;
    notifyListeners();

    try {
      final reportService = ReportService(_authProvider!.token);
      _photographerPayments = await reportService.getPhotographerPayments(
        startDate: startDate,
        endDate: endDate,
        percentage: percentage,
      );
    } catch (error) {
      print('Error fetching photographer payments: $error');
      _photographerPayments = {};
      rethrow;
    } finally {
      _isLoadingPayments = false;
      notifyListeners();
    }
  }
}
