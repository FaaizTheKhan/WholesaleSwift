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

  Map<String, dynamic> toJson() {
    return {
      'fob_price': fobPrice,
      'freight_cost': freightCost,
      'customs_buffer': customsBuffer,
      'total_landed_cost': totalLandedCost,
    };
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
  LandedCostBreakdown? landedCostBreakdown;
  bool bestValueToUs;
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

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'external_id': externalId,
      'title': title,
      'price': price,
      'currency': currency,
      'moq': moq,
      'rating': rating,
      'supplier_name': supplierName,
      'product_url': productUrl,
      'image_url': imageUrl,
      'shipping_coverage': shippingCoverage,
      'fulfillment_type': fulfillmentType,
      if (landedCostBreakdown != null) 'landed_cost_breakdown': landedCostBreakdown!.toJson(),
      'best_value_to_us': bestValueToUs,
      'is_verified_supplier': isVerifiedSupplier,
      'has_trade_assurance': hasTradeAssurance,
      if (goldSupplierYears != null) 'gold_supplier_years': goldSupplierYears,
      if (leadTimeDays != null) 'lead_time_days': leadTimeDays,
    };
  }
}
