class LandedCostBreakdown {
  final double fobPrice;
  final double freightCost;
  final double customsBuffer;
  final double totalLandedCost;

  LandedCostBreakdown({
    required this.fobPrice,
    required this.freightCost,
    required this.customsBuffer,
    required this.totalLandedCost,
  });

  factory LandedCostBreakdown.fromJson(Map<String, dynamic> json) {
    return LandedCostBreakdown(
      fobPrice: (json['fob_price'] as num).toDouble(),
      freightCost: (json['freight_cost'] as num).toDouble(),
      customsBuffer: (json['customs_buffer'] as num).toDouble(),
      totalLandedCost: (json['total_landed_cost'] as num).toDouble(),
    );
  }
}

class UnifiedProduct {
  final String platform;
  final String externalId;
  final String title;
  final double price;
  final String currency;
  final int moq;
  final double rating;
  final String supplierName;
  final String productUrl;
  final String imageUrl;
  final List<String> shippingCoverage;
  final String fulfillmentType;
  final LandedCostBreakdown? landedCostBreakdown;
  final bool bestValueToUs;
  final bool isVerifiedSupplier;
  final bool hasTradeAssurance;
  final int? goldSupplierYears;
  final int? leadTimeDays;

  UnifiedProduct({
    required this.platform,
    required this.externalId,
    required this.title,
    required this.price,
    required this.currency,
    required this.moq,
    required this.rating,
    required this.supplierName,
    required this.productUrl,
    required this.imageUrl,
    required this.shippingCoverage,
    required this.fulfillmentType,
    this.landedCostBreakdown,
    this.bestValueToUs = false,
    this.isVerifiedSupplier = false,
    this.hasTradeAssurance = false,
    this.goldSupplierYears,
    this.leadTimeDays,
  });

  factory UnifiedProduct.fromJson(Map<String, dynamic> json) {
    return UnifiedProduct(
      platform: json['platform'] as String,
      externalId: json['external_id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      moq: json['moq'] as int,
      rating: (json['rating'] as num).toDouble(),
      supplierName: json['supplier_name'] as String,
      productUrl: json['product_url'] as String,
      imageUrl: json['image_url'] as String,
      shippingCoverage: List<String>.from(json['shipping_coverage'] ?? []),
      fulfillmentType: json['fulfillment_type'] as String,
      landedCostBreakdown: json['landed_cost_breakdown'] != null
          ? LandedCostBreakdown.fromJson(json['landed_cost_breakdown'])
          : null,
      bestValueToUs: json['best_value_to_us'] ?? false,
      isVerifiedSupplier: json['is_verified_supplier'] ?? false,
      hasTradeAssurance: json['has_trade_assurance'] ?? false,
      goldSupplierYears: json['gold_supplier_years'] as int?,
      leadTimeDays: json['lead_time_days'] as int?,
    );
  }
}
