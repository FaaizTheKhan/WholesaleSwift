import '../models/product.dart';
import 'sourcing_adapter.dart';

class AlibabaAdapter implements SourcingAdapter {
  @override
  String get platformName => 'Alibaba';

  @override
  Future<List<UnifiedProduct>> searchProducts(String query, String freightType) async {
    const double fobPrice = 8.00;
    final double freightCost = freightType == 'Fast Sea DDP' ? 1.85 * 5 : 8.50 * 5; // 5kg
    final double customsBuffer = fobPrice * 0.065;

    return [
      UnifiedProduct(
        platform: 'Alibaba',
        externalId: 'ali-b2b-999',
        title: 'Alibaba Wholesale: $query',
        price: fobPrice,
        currency: 'USD',
        moq: 100,
        rating: 4.8,
        supplierName: 'Shenzhen Tech Factory',
        productUrl: 'https://alibaba.com/product/999',
        imageUrl: 'https://alibaba.com/image/999.jpg',
        shippingCoverage: ['US'],
        fulfillmentType: 'Bulk Freight',
        isVerifiedSupplier: true,
        hasTradeAssurance: true,
        goldSupplierYears: 5,
        landedCostBreakdown: LandedCostBreakdown(
          fobPrice: fobPrice,
          freightCost: freightCost,
          customsBuffer: customsBuffer,
          totalLandedCost: fobPrice + freightCost + customsBuffer,
        ),
      )
    ];
  }
}

class AliExpressAdapter implements SourcingAdapter {
  @override
  String get platformName => 'AliExpress';

  @override
  Future<List<UnifiedProduct>> searchProducts(String query, String freightType) async {
    const double fobPrice = 15.00;
    final double freightCost = freightType == 'Fast Sea DDP' ? 1.85 * 1 : 8.50 * 1; // 1kg
    final double customsBuffer = fobPrice * 0.065;

    return [
      UnifiedProduct(
        platform: 'AliExpress',
        externalId: 'aliex-777',
        title: 'AliExpress Retail/Drop: $query',
        price: fobPrice,
        currency: 'USD',
        moq: 1,
        rating: 4.2,
        supplierName: 'Global E-commerce Store',
        productUrl: 'https://aliexpress.com/item/777.html',
        imageUrl: 'https://aliexpress.com/image/777.jpg',
        shippingCoverage: ['US'],
        fulfillmentType: 'Dropshipping',
        landedCostBreakdown: LandedCostBreakdown(
          fobPrice: fobPrice,
          freightCost: freightCost,
          customsBuffer: customsBuffer,
          totalLandedCost: fobPrice + freightCost + customsBuffer,
        ),
      )
    ];
  }
}
