export interface UnifiedProduct {
  platform: 'aliexpress' | 'alibaba' | 'cjdropshipping' | 'amazon' | 'dhgate' | 'emerging_web';
  external_id: string;
  title: string;
  price: number; // USD
  currency: 'USD';
  moq: number;
  rating: number;
  supplier_name: string;
  product_url: string;
  image_url: string;
  shipping_coverage: string[]; // e.g., ["US"]
  fulfillment_type: 'Dropshipping' | 'Bulk Freight' | 'FBA' | 'POD';
}

export interface LandedCostBreakdown {
  fob_price: number;
  freight_cost: number;
  customs_buffer: number;
  total_landed_cost: number;
}

export interface UnifiedProductWithLandedCost extends UnifiedProduct {
  landed_cost_breakdown?: LandedCostBreakdown;
  best_value_to_us?: boolean;
}

export interface SourcingAdapter {
  platformName: string;
  searchProducts(query: string, freightType?: 'Air Express' | 'Fast Sea DDP'): Promise<UnifiedProductWithLandedCost[]>;
}

export interface DiscoveredPlatform {
  platform_name: string;
  website_url: string;
  business_model: string;
  shipping_capability: string;
  api_or_automation_support: 'REST API' | 'Webhook' | 'CSV Sync' | 'None';
  why_recommended: string;
}

export interface IntegrationMetadata {
  platform: string;
  base_endpoint: string;
  auth_type: 'OAuth2' | 'API-Key' | 'HMAC' | 'OpenPlatform';
  documentation_url: string;
  technical_notes: string;
}

export interface SourcingResponse {
  query_context: {
    search_term: string;
    target_destination: 'US';
    timestamp: string; // ISO-8601
  };
  aggregated_products: UnifiedProductWithLandedCost[];
  discovered_new_platforms: DiscoveredPlatform[];
  api_integration_metadata: IntegrationMetadata[];
}
