import 'package:flutter/material.dart';

class PlatformChipBar extends StatelessWidget {
  final List<String> platforms;
  final String selectedPlatform;
  final ValueChanged<String> onPlatformSelected;
  final bool verifiedOnly;
  final ValueChanged<bool> onVerifiedChanged;
  final Map<String, int> resultCounts;

  const PlatformChipBar({
    super.key,
    required this.platforms,
    required this.selectedPlatform,
    required this.onPlatformSelected,
    required this.verifiedOnly,
    required this.onVerifiedChanged,
    required this.resultCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVerifiedToggle(),
            const SizedBox(width: 16),
            Container(width: 1, height: 24, color: const Color(0x1AFFFFFF)),
            const SizedBox(width: 16),
            ...platforms.map((platform) => _buildPlatformChip(platform)),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedToggle() {
    return InkWell(
      onTap: () => onVerifiedChanged(!verifiedOnly),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: verifiedOnly ? const Color(0xFF0EA5E9).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: verifiedOnly ? const Color(0xFF0EA5E9) : const Color(0x33FFFFFF),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.verified_user,
              size: 16,
              color: verifiedOnly ? const Color(0xFF0EA5E9) : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 8),
            Text(
              'Verified Suppliers Only',
              style: TextStyle(
                color: verifiedOnly ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: verifiedOnly ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformChip(String platform) {
    final isSelected = selectedPlatform == platform;
    final count = resultCounts[platform] ?? 0;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          count > 0 ? '$platform ($count)' : platform,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) onPlatformSelected(platform);
        },
        backgroundColor: Colors.transparent,
        selectedColor: const Color(0xFF4F46E5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0x33FFFFFF),
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}
