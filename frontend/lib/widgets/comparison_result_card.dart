import 'package:flutter/material.dart';
import '../models/product.dart';

class ComparisonResultCard extends StatelessWidget {
  final UnifiedProduct product;
  final VoidCallback onInspect;

  const ComparisonResultCard({
    super.key,
    required this.product,
    required this.onInspect,
  });

  @override
  Widget build(BuildContext context) {
    final isBestValue = product.bestValueToUs;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBestValue ? const Color(0xFF10B981) : const Color(0x1AFFFFFF),
          width: isBestValue ? 2 : 1,
        ),
        boxShadow: isBestValue
            ? const [
                BoxShadow(
                  color: Color(0x3310B981),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isBestValue)
              Container(
                color: const Color(0xFF10B981).withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.stars, color: Color(0xFF10B981), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Lowest Landed Rate',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return _buildMobileLayout();
                  }
                  return _buildDesktopLayout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Supplier & Platform
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  product.platform,
                  style: const TextStyle(
                    color: Color(0xFF818CF8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.supplierName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                  ),
                  if (product.isVerifiedSupplier) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, color: Color(0xFF0EA5E9), size: 14),
                  ],
                  if (product.goldSupplierYears != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${product.goldSupplierYears}Y Gold',
                      style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 12),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Center Column: Product Specs & Cost Breakdown
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildSpecBadge('MOQ: ${product.moq} pcs'),
                  const SizedBox(width: 8),
                  _buildSpecBadge('ETA: 8-12 Days'), // Hardcoded for demo, normally dynamic
                ],
              ),
              const SizedBox(height: 16),
              if (product.landedCostBreakdown != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0x1AFFFFFF)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '[Base: \$${product.landedCostBreakdown!.fobPrice.toStringAsFixed(2)}]',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                      const Text(
                        ' + ',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                      Text(
                        '[Freight: \$${product.landedCostBreakdown!.freightCost.toStringAsFixed(2)}]',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                      const Text(
                        ' = ',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                      Text(
                        'Total: \$${product.landedCostBreakdown!.totalLandedCost.toStringAsFixed(2)}/pc',
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Right Column: Action
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Landed',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${(product.landedCostBreakdown?.totalLandedCost ?? product.price).toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onInspect,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Inspect Lot'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                product.platform,
                style: const TextStyle(
                  color: Color(0xFF818CF8),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              '\$${(product.landedCostBreakdown?.totalLandedCost ?? product.price).toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              product.supplierName,
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
            ),
            const Spacer(),
            if (product.isVerifiedSupplier)
              const Icon(Icons.verified, color: Color(0xFF0EA5E9), size: 14),
          ],
        ),
        const SizedBox(height: 16),
        if (product.landedCostBreakdown != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Base: \$${product.landedCostBreakdown!.fobPrice.toStringAsFixed(2)} + Freight: \$${product.landedCostBreakdown!.freightCost.toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Landed Cost: \$${product.landedCostBreakdown!.totalLandedCost.toStringAsFixed(2)}/pc',
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onInspect,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Inspect Lot / Source'),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF334155),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
