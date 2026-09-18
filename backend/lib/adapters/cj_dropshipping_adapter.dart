import '../models/product.dart';
import 'sourcing_adapter.dart';

class CJDropshippingAdapter implements SourcingAdapter {
  @override
  String get platformName => 'CJDropshipping';

  @override
  Future<List<UnifiedProduct>> searchProducts(String query, String freightType) async {
    // Simulating API response mapping
    const double fobPrice = 12.50;
    final double freightCost = freightType == 'Fast Sea DDP' ? 1.85 * 2 : 8.50 * 2; // Assuming 2kg weight
    final double customsBuffer = fobPrice * 0.065;

    return [
      UnifiedProduct(
        platform: 'CJDropshipping',
        externalId: 'cj-12345',
        title: 'CJ Dropshipping: $query',
        price: fobPrice,
        currency: 'USD',
        moq: 1,
        rating: 4.5,
        supplierName: 'CJ Official Fulfillment',
        productUrl: 'https://cjdropshipping.com/product/12345',
        imageUrl: 'https://cjdropshipping.com/image/12345.jpg',
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
