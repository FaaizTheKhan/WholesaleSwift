import { SourcingAdapter, UnifiedProductWithLandedCost, SourcingResponse, DiscoveredPlatform, IntegrationMetadata } from '../types/sourcing';
import { CJDropshippingAdapter } from '../adapters/cjDropshippingAdapter';
import { AlibabaAdapter, AliExpressAdapter } from '../adapters/multiPlatformAdapters';

export class SourcingAggregatorService {
  private adapters: SourcingAdapter[] = [];

  constructor() {
    this.registerAdapter(new CJDropshippingAdapter());
    this.registerAdapter(new AlibabaAdapter());
    this.registerAdapter(new AliExpressAdapter());
  }

  public registerAdapter(adapter: SourcingAdapter) {
    this.adapters.push(adapter);
  }

  public async search(query: string, freightType: 'Air Express' | 'Fast Sea DDP' = 'Air Express'): Promise<SourcingResponse> {
    const searchPromises = this.adapters.map(adapter => adapter.searchProducts(query, freightType));

    // Execute concurrently, failing single platform doesn't fail the entire request
    const results = await Promise.allSettled(searchPromises);

    let allProducts: UnifiedProductWithLandedCost[] = [];

    results.forEach(result => {
      if (result.status === 'fulfilled') {
        allProducts = allProducts.concat(result.value);
      } else {
        console.error('Adapter search failed:', result.reason);
      }
    });

    // Sort by landed cost ascending
    allProducts.sort((a, b) => {
      const costA = a.landed_cost_breakdown?.total_landed_cost || Infinity;
      const costB = b.landed_cost_breakdown?.total_landed_cost || Infinity;
      return costA - costB;
    });

    // Tag the best net value to US (lowest total landed cost)
    if (allProducts.length > 0) {
      allProducts[0].best_value_to_us = true;
    }

    // Mock discovered platforms
    const discovered_new_platforms: DiscoveredPlatform[] = [
      {
        platform_name: '1688 Cross-Border (Kuajing)',
        website_url: 'https://kuajing.1688.com',
        business_model: 'Factory Direct',
        shipping_capability: 'US Express Supported',
        api_or_automation_support: 'REST API',
        why_recommended: 'High margin potential with direct factory pricing for bulk imports.'
      }
    ];

    const api_integration_metadata: IntegrationMetadata[] = [
      {
        platform: 'CJDropshipping',
        base_endpoint: 'https://developers.cjdropshipping.com/api2.0/v1',
        auth_type: 'OAuth2',
        documentation_url: 'https://developers.cjdropshipping.com/',
        technical_notes: 'Token expires every 30 days. Needs caching.'
      }
    ];

    return {
      query_context: {
        search_term: query,
        target_destination: 'US',
        timestamp: new Date().toISOString()
      },
      aggregated_products: allProducts,
      discovered_new_platforms,
      api_integration_metadata
    };
  }
}
