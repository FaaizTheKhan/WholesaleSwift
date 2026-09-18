import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

import 'package:flutter/foundation.dart';

class ApiService {
  static String get _baseUrl {
    if (kIsWeb) return 'http://localhost:8080/api/v1';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8080/api/v1';
    return 'http://localhost:8080/api/v1';
  }

  Future<List<UnifiedProduct>> searchProducts(String query, String freightType) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sourcing/search?q=${Uri.encodeComponent(query)}&freight=${Uri.encodeComponent(freightType)}'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final productsJson = jsonResponse['aggregated_products'] as List;
      return productsJson.map((p) => UnifiedProduct.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> dispatchWebhook(String targetUrl, String eventType, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/integrations/dispatch'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'target_url': targetUrl,
        'payload': {
          'event_type': eventType,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'data': data,
        },
        'metadata': {
          'recipient_phone': '+18005550199', // Mock E.164
          'opt_in_status': true,
        }
      }),
    );

    if (response.statusCode != 202) {
      throw Exception('Failed to dispatch webhook');
    }
  }
}
