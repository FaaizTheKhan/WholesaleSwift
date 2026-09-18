import '../models/product.dart';
import '../adapters/sourcing_adapter.dart';
import '../adapters/cj_dropshipping_adapter.dart';
import '../adapters/multi_platform_adapters.dart';

class SourcingAggregatorService {
  final List<SourcingAdapter> _adapters = [];

  SourcingAggregatorService() {
    _adapters.add(CJDropshippingAdapter());
    _adapters.add(AlibabaAdapter());
    _adapters.add(AliExpressAdapter());
  }

  Future<Map<String, dynamic>> search(String query, String freightType) async {
    final futures = _adapters.map((adapter) => adapter.searchProducts(query, freightType));

    // Execute all adapter searches concurrently
    final results = await Future.wait(futures.map((future) => future.catchError((e) {
      print('Adapter failed: $e');
      return <UnifiedProduct>[]; // Return empty list on failure to prevent whole request failure
    })));

    List<UnifiedProduct> allProducts = [];
    for (var productList in results) {
      allProducts.addAll(productList);
    }

    // Sort by lowest landed cost
    allProducts.sort((a, b) {
      final costA = a.landedCostBreakdown?.totalLandedCost ?? double.infinity;
      final costB = b.landedCostBreakdown?.totalLandedCost ?? double.infinity;
      return costA.compareTo(costB);
    });

    // Tag the best value
    if (allProducts.isNotEmpty) {
      allProducts.first.bestValueToUs = true;
    }

    return {
      'query_context': {
        'search_term': query,
        'target_destination': 'US',
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      },
      'aggregated_products': allProducts.map((p) => p.toJson()).toList(),
      'discovered_new_platforms': [
        {
          'platform_name': '1688 Cross-Border (Kuajing)',
          'website_url': 'https://kuajing.1688.com',
          'business_model': 'Factory Direct',
          'shipping_capability': 'US Express Supported',
          'api_or_automation_support': 'REST API',
          'why_recommended': 'High margin potential with direct factory pricing for bulk imports.'
        }
      ],
      'api_integration_metadata': [
        {
          'platform': 'CJDropshipping',
          'base_endpoint': 'https://developers.cjdropshipping.com/api2.0/v1',
          'auth_type': 'OAuth2',
          'documentation_url': 'https://developers.cjdropshipping.com/',
          'technical_notes': 'Token expires every 30 days. Needs caching.'
        }
      ]
    };
  }
}
