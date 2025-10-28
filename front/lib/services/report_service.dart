import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/api_config.dart';

class ReportService {
  final String? _token;
  ReportService(this._token);

  Future<Map<String, dynamic>> getSummary() async {
    if (_token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/reports/summary'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load report summary: ${response.body}');
    }
  }

  Future<void> downloadReport(String format) async {
    if (_token == null) throw Exception('Not authenticated');

    final url = '${ApiConfig.baseUrl}/reports/export/$format';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Future<Map<String, dynamic>> getPhotographerPayments({
    String? startDate,
    String? endDate,
    double percentage = 70,
  }) async {
    if (_token == null) throw Exception('Not authenticated');

    final queryParams = <String, String>{
      'percentage': percentage.toString(),
    };
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;

    final uri = Uri.parse('${ApiConfig.baseUrl}/reports/photographer-payments')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load photographer payments: ${response.body}');
    }
  }
}
