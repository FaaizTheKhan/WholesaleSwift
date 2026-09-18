import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/header_bar.dart';
import '../widgets/search_bar_console.dart';
import '../widgets/platform_chip_bar.dart';
import '../widgets/comparison_result_card.dart';

class PriceComparisonScreen extends StatefulWidget {
  @override
  PriceComparisonScreenState createState() => PriceComparisonScreenState();
}

class PriceComparisonScreenState extends State<PriceComparisonScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  String _freightType = 'Air Express';
  String _selectedPlatform = 'ALL';
  List<UnifiedProduct> _products = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  bool _verifiedOnly = false;

  final List<String> _platforms = ['ALL', 'ALIBABA', 'ALIEXPRESS', '1688', 'CJDROPSHIPPING', 'MADE-IN-CHINA'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // We don't auto-search on every keystroke in the new UI per the "Compare Markets" button
    // But we keep the method signature in case we want to re-add debouncing.
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await _apiService.searchProducts(query, _freightType);
      setState(() {
        _products = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching markets: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _triggerRFQ(UnifiedProduct product) async {
    try {
      await _apiService.dispatchWebhook(
        'https://example.com/webhook',
        'rfq_requested',
        {
          'product_id': product.externalId,
          'platform': product.platform,
          'expected_price': product.price,
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('RFQ / Integration webhook dispatched successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error dispatching RFQ: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  List<UnifiedProduct> get _filteredProducts {
    return _products.where((p) {
      bool matchPlatform = _selectedPlatform == 'ALL' || p.platform.toUpperCase() == _selectedPlatform;
      bool matchVerified = !_verifiedOnly || p.isVerifiedSupplier;
      return matchPlatform && matchVerified;
    }).toList();
  }

  Map<String, int> get _platformCounts {
    final counts = <String, int>{};
    for (var p in _products) {
      final platform = p.platform.toUpperCase();
      counts[platform] = (counts[platform] ?? 0) + 1;
    }
    counts['ALL'] = _products.length;
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(),
      body: Column(
        children: [
          // Search Console Region
          SearchBarConsole(
            controller: _searchController,
            onChanged: _onSearchChanged,
            freightType: _freightType,
            onFreightChanged: (value) {
              if (value != null) {
                setState(() => _freightType = value);
                if (_hasSearched) _performSearch();
              }
            },
            onComparePressed: _performSearch,
          ),

          // Filters Region
          if (_hasSearched && !_isLoading)
            PlatformChipBar(
              platforms: _platforms,
              selectedPlatform: _selectedPlatform,
              onPlatformSelected: (platform) {
                setState(() => _selectedPlatform = platform);
              },
              verifiedOnly: _verifiedOnly,
              onVerifiedChanged: (val) {
                setState(() => _verifiedOnly = val);
              },
              resultCounts: _platformCounts,
            ),

          // Results Region
          Expanded(
            child: _buildBodyContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return _buildSkeletonLoader();
    }

    if (!_hasSearched) {
      return _buildEmptyState(
        icon: Icons.travel_explore,
        title: 'Global Market Intelligence',
        subtitle: 'Enter a product keyword and click "Compare Markets" to pull real-time wholesale pricing and DDP landed costs.',
      );
    }

    final results = _filteredProducts;
    if (results.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No Results Found',
        subtitle: 'We couldn\'t find any lots matching your criteria. Try adjusting your filters or search terms.',
      );
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1040),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return ComparisonResultCard(
              product: results[index],
              onInspect: () => _triggerRFQ(results[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1040),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: Icon(icon, size: 48, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
