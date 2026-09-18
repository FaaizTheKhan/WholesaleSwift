import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class SourcingScreen extends StatefulWidget {
  @override
  _SourcingScreenState createState() => _SourcingScreenState();
}

class _SourcingScreenState extends State<SourcingScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  String _freightType = 'Air Express';
  String _selectedPlatform = 'ALL';
  List<UnifiedProduct> _products = [];
  bool _isLoading = false;
  Timer? _debounce;
  bool _verifiedOnly = false;

  final List<String> _platforms = ['ALL', 'ALIBABA', 'ALIEXPRESS', '1688', 'CJDROPSHIPPING'];

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _searchProducts(query);
      } else {
        setState(() {
          _products = [];
        });
      }
    });
  }

  Future<void> _searchProducts(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _apiService.searchProducts(query, _freightType);
      setState(() {
        _products = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching products: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _triggerRFQ(UnifiedProduct product) async {
    try {
      await _apiService.dispatchWebhook(
        'https://example.com/webhook', // Example target
        'rfq_requested',
        {
          'product_id': product.externalId,
          'platform': product.platform,
          'expected_price': product.price,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RFQ dispatched successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error dispatching RFQ: $e')),
      );
    }
  }

  List<UnifiedProduct> get _filteredProducts {
    return _products.where((p) {
      bool matchPlatform = _selectedPlatform == 'ALL' || p.platform.toUpperCase() == _selectedPlatform;
      bool matchVerified = !_verifiedOnly || p.isVerifiedSupplier;
      return matchPlatform && matchVerified;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WholesaleSwift Intelligence'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Products (e.g., Hoodies, Tumblers)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Freight: '),
              DropdownButton<String>(
                value: _freightType,
                items: <String>['Air Express', 'Fast Sea DDP'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _freightType = newValue;
                      if (_searchController.text.isNotEmpty) {
                        _searchProducts(_searchController.text);
                      }
                    });
                  }
                },
              ),
            ],
          ),
          SingleChildScrollView(
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
                ..._platforms.map((platform) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(platform),
                    selected: _selectedPlatform == platform,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedPlatform = platform;
                      });
                    },
                  ),
                );
              }).toList(),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onRequestRFQ: () => _triggerRFQ(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final UnifiedProduct product;
  final VoidCallback onRequestRFQ;

  const ProductCard({
    required this.product,
    required this.onRequestRFQ,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (product.bestValueToUs)
            Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: const Text(
                'BEST NET VALUE TO US',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ListTile(
            title: Text(product.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Supplier: ${product.supplierName} | Platform: ${product.platform}'),
                Row(
                  children: [
                    if (product.isVerifiedSupplier) const Icon(Icons.verified, size: 16, color: Colors.blue),
                    if (product.hasTradeAssurance) const Icon(Icons.shield, size: 16, color: Colors.green),
                    if (product.goldSupplierYears != null) Text(' Gold: ${product.goldSupplierYears}Y', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MOQ: ${product.moq} | Rating: ${product.rating}'),
                const SizedBox(height: 8),
                if (product.landedCostBreakdown != null) ...[
                  const Text('Landed Cost Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('FOB Price: \$${product.landedCostBreakdown!.fobPrice.toStringAsFixed(2)}'),
                  Text('US DDP Freight: \$${product.landedCostBreakdown!.freightCost.toStringAsFixed(2)}'),
                  Text('Tariff/Customs: \$${product.landedCostBreakdown!.customsBuffer.toStringAsFixed(2)}'),
                  const Divider(),
                  Text(
                    'Total Landed Cost: \$${product.landedCostBreakdown!.totalLandedCost.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ] else ...[
                  Text('Price: \$${product.price.toStringAsFixed(2)}'),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRequestRFQ,
                  child: const Text('Request Quote (RFQ) via Webhook'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
