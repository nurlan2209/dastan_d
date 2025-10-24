import 'package:flutter/material.dart';
import '../services/report_service.dart';
import 'auth_provider.dart';

class ReportProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  Map<String, dynamic> _summary = {};
  bool _isLoading = false;

  ReportProvider();

  Map<String, dynamic> get summary => _summary;
  bool get isLoading => _isLoading;

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
}
