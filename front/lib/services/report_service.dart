import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
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

    // Делаем HTTP запрос с токеном
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      // Создаем blob и скачиваем файл
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'report-${DateTime.now().millisecondsSinceEpoch}.$format')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      throw Exception('Failed to download report: ${response.body}');
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
