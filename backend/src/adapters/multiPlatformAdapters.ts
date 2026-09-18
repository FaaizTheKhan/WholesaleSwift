import { SourcingAdapter, UnifiedProductWithLandedCost } from '../types/sourcing';

export class AlibabaAdapter implements SourcingAdapter {
  platformName = 'alibaba';

  async searchProducts(query: string, freightType?: 'Air Express' | 'Fast Sea DDP'): Promise<UnifiedProductWithLandedCost[]> {
    const fobPrice = 8.00;
    const freightCost = freightType === 'Fast Sea DDP' ? 1.85 * 5 : 8.50 * 5; // 5kg
    const customsBuffer = fobPrice * 0.065;

    return [
      {
        platform: 'alibaba',
        external_id: 'ali-b2b-999',
        title: `Alibaba Wholesale: ${query}`,
        price: fobPrice,
        currency: 'USD',
        moq: 100,
        rating: 4.8,
        supplier_name: 'Shenzhen Tech Factory',
        product_url: 'https://alibaba.com/product/999',
        image_url: 'https://alibaba.com/image/999.jpg',
        shipping_coverage: ['US'],
        fulfillment_type: 'Bulk Freight',
        landed_cost_breakdown: {
          fob_price: fobPrice,
          freight_cost: freightCost,
          customs_buffer: customsBuffer,
          total_landed_cost: fobPrice + freightCost + customsBuffer
        }
      }
    ];
  }
}

export class AliExpressAdapter implements SourcingAdapter {
  platformName = 'aliexpress';

  async searchProducts(query: string, freightType?: 'Air Express' | 'Fast Sea DDP'): Promise<UnifiedProductWithLandedCost[]> {
    const fobPrice = 15.00;
    const freightCost = freightType === 'Fast Sea DDP' ? 1.85 * 1 : 8.50 * 1; // 1kg
    const customsBuffer = fobPrice * 0.065;

    return [
      {
        platform: 'aliexpress',
        external_id: 'aliex-777',
        title: `AliExpress Retail/Drop: ${query}`,
        price: fobPrice,
        currency: 'USD',
        moq: 1,
        rating: 4.2,
        supplier_name: 'Global E-commerce Store',
        product_url: 'https://aliexpress.com/item/777.html',
        image_url: 'https://aliexpress.com/image/777.jpg',
        shipping_coverage: ['US'],
        fulfillment_type: 'Dropshipping',
        landed_cost_breakdown: {
          fob_price: fobPrice,
          freight_cost: freightCost,
          customs_buffer: customsBuffer,
          total_landed_cost: fobPrice + freightCost + customsBuffer
        }
      }
    ];
  }
}
