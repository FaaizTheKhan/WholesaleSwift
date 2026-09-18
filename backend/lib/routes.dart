import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'services/sourcing_aggregator.dart';

class ApiRoutes {
  final SourcingAggregatorService _sourcingService = SourcingAggregatorService();

  Router get router {
    final router = Router();

    router.get('/api/v1/sourcing/search', (Request request) async {
      final queryParams = request.url.queryParameters;
      final query = queryParams['q'];
      final freightType = queryParams['freight'] == 'Fast Sea DDP' ? 'Fast Sea DDP' : 'Air Express';

      if (query == null || query.isEmpty) {
        return Response.badRequest(
            body: jsonEncode({'error': 'Search query (q) is required'}),
            headers: {'Content-Type': 'application/json'});
      }

      final start = DateTime.now();

      try {
        final results = await _sourcingService.search(query, freightType);
        final executionTimeMs = DateTime.now().difference(start).inMilliseconds;

        return Response.ok(jsonEncode(results), headers: {
          'Content-Type': 'application/json',
          'X-Execution-Time-Ms': executionTimeMs.toString(),
          'Access-Control-Allow-Origin': '*'
        });
      } catch (e) {
        print('Sourcing Search Error: $e');
        return Response.internalServerError(
            body: jsonEncode({'error': 'Internal Server Error'}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.get('/api/v1/sourcing/platforms', (Request request) {
      return Response.ok(jsonEncode({'platforms': ['cjdropshipping', 'alibaba', 'aliexpress']}), headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      });
    });

    router.post('/api/v1/integrations/dispatch', (Request request) async {
      try {
        final bodyString = await request.readAsString();
        final payload = jsonDecode(bodyString);

        if (payload['target_url'] == null || payload['payload'] == null) {
          return Response.badRequest(
              body: jsonEncode({'error': 'Invalid dispatch request. target_url and payload are required.'}),
              headers: {'Content-Type': 'application/json'});
        }

        final metadata = payload['metadata'];
        if (metadata != null && metadata['recipient_phone'] != null) {
          final RegExp phoneRegex = RegExp(r'^\+1[2-9]\d{2}[2-9]\d{6}$');
          if (!phoneRegex.hasMatch(metadata['recipient_phone'])) {
            return Response.badRequest(
                body: jsonEncode({'error': 'Invalid phone format. Must be strict US E.164 (e.g., +12345678900).'}),
                headers: {'Content-Type': 'application/json'});
          }

          if (metadata['opt_in_status'] != true) {
            return Response.forbidden(
                jsonEncode({'error': 'TCPA Compliance Violation: explicit opt_in_status must be true.'}),
                headers: {'Content-Type': 'application/json'});
          }
        }

        print('[Webhook Dispatch] Triggered to ${payload['target_url']}');

        return Response(202,
            body: jsonEncode({
              'status': 'accepted',
              'message': 'Dispatch request accepted and queued for processing.',
              'dispatch_id': 'disp_${DateTime.now().millisecondsSinceEpoch}'
            }),
            headers: {
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*'
            });
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'error': 'Internal Server Error'}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    // Handle OPTIONS requests for CORS
    router.all('/<ignored|.*>', (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type',
        });
      }
      return Response.notFound('Not found');
    });

    return router;
  }
}
