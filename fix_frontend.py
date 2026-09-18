import re

with open('frontend/lib/services/api_service.dart', 'r') as f:
    content = f.read()

content = content.replace("Uri.parse('$_baseUrl/sourcing/search?q=$query&freight=$freightType')", "Uri.parse('$_baseUrl/sourcing/search?q=${Uri.encodeComponent(query)}&freight=${Uri.encodeComponent(freightType)}')")

with open('frontend/lib/services/api_service.dart', 'w') as f:
    f.write(content)

with open('frontend/lib/models/product.dart', 'r') as f:
    content = f.read()

content = content.replace('final bool bestValueToUs;', 'final bool bestValueToUs;\n  final bool isVerifiedSupplier;\n  final bool hasTradeAssurance;\n  final int? goldSupplierYears;\n  final int? leadTimeDays;')
content = content.replace('this.bestValueToUs = false,\n  });', 'this.bestValueToUs = false,\n    this.isVerifiedSupplier = false,\n    this.hasTradeAssurance = false,\n    this.goldSupplierYears,\n    this.leadTimeDays,\n  });')
content = content.replace("bestValueToUs: json['best_value_to_us'] ?? false,", "bestValueToUs: json['best_value_to_us'] ?? false,\n      isVerifiedSupplier: json['is_verified_supplier'] ?? false,\n      hasTradeAssurance: json['has_trade_assurance'] ?? false,\n      goldSupplierYears: json['gold_supplier_years'] as int?,\n      leadTimeDays: json['lead_time_days'] as int?,")

with open('frontend/lib/models/product.dart', 'w') as f:
    f.write(content)


with open('frontend/lib/screens/sourcing_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("final List<String> _platforms = ['ALL', 'ALIBABA', 'ALIEXPRESS', 'CJDROPSHIPPING'];", "final List<String> _platforms = ['ALL', 'ALIBABA', 'ALIEXPRESS', '1688', 'CJDROPSHIPPING'];\n  bool _verifiedOnly = false;")

content = content.replace("""SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _platforms.map((platform) {""", """SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: const Text('Verified Only'),
                    selected: _verifiedOnly,
                    onSelected: (bool selected) {
                      setState(() {
                        _verifiedOnly = selected;
                      });
                    },
                  ),
                ),
                ..._platforms.map((platform) {""")

content = content.replace("}).toList(),\n            ),", "}).toList(),\n              ],\n            ),")

content = content.replace("List<UnifiedProduct> get _filteredProducts {\n    if (_selectedPlatform == 'ALL') return _products;\n    return _products.where((p) => p.platform.toUpperCase() == _selectedPlatform).toList();\n  }", """List<UnifiedProduct> get _filteredProducts {
    return _products.where((p) {
      bool matchPlatform = _selectedPlatform == 'ALL' || p.platform.toUpperCase() == _selectedPlatform;
      bool matchVerified = !_verifiedOnly || p.isVerifiedSupplier;
      return matchPlatform && matchVerified;
    }).toList();
  }""")

content = content.replace("subtitle: Text('Supplier: ${product.supplierName} | Platform: ${product.platform}'),", "subtitle: Column(\n              crossAxisAlignment: CrossAxisAlignment.start,\n              children: [\n                Text('Supplier: \\${product.supplierName} | Platform: \\${product.platform}'),\n                Row(\n                  children: [\n                    if (product.isVerifiedSupplier) const Icon(Icons.verified, size: 16, color: Colors.blue),\n                    if (product.hasTradeAssurance) const Icon(Icons.shield, size: 16, color: Colors.green),\n                    if (product.goldSupplierYears != null) Text(' Gold: \\${product.goldSupplierYears}Y', style: const TextStyle(fontSize: 12)),\n                  ],\n                ),\n              ],\n            ),")

with open('frontend/lib/screens/sourcing_screen.dart', 'w') as f:
    f.write(content)
