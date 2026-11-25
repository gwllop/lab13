import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestCatcherService {
  static const String baseUrl = 'https://yana-lab13.requestcatcher.com';

  static Future<http.Response> sendAction({
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final uri = Uri.parse('$baseUrl/$action');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'action': action,
        'sentAt': DateTime.now().toIso8601String(),
        'payload': payload,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Помилка запиту (${response.statusCode}): ${response.body}');
    }

    return response;
  }
}