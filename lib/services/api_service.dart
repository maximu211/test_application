import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/path_result.dart';
import '../models/task_item.dart';

class ApiService {
  const ApiService();

  Uri _resolveUri(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw const FormatException('Invalid server URL');
    }
    return uri;
  }

  Future<List<TaskItem>> fetchTasks(String rawUrl) async {
    final uri = _resolveUri(rawUrl);
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Unexpected response: ${response.statusCode}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (payload['error'] == true) {
      throw Exception(payload['message']?.toString() ?? 'Request failed');
    }

    final items = payload['data'] as List<dynamic>? ?? const <dynamic>[];
    return items.map((item) => TaskItem.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> sendResults(String rawUrl, List<PathResult> results) async {
    final uri = _resolveUri(rawUrl);
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(results.map((result) => result.toApiPayload()).toList()),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Failed to send results: ${response.statusCode}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (payload['error'] == true) {
      throw Exception(payload['message']?.toString() ?? 'Upload failed');
    }
  }
}
