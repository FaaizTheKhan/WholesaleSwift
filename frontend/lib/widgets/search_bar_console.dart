import 'package:flutter/material.dart';

class SearchBarConsole extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String freightType;
  final ValueChanged<String?> onFreightChanged;
  final VoidCallback onComparePressed;

  const SearchBarConsole({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.freightType,
    required this.onFreightChanged,
    required this.onComparePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1040),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return Column(
              children: [
                _buildSearchField(),
                const Divider(color: Color(0x1AFFFFFF), height: 16),
                _buildFreightPicker(),
                const SizedBox(height: 8),
                _buildCompareButton(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 3, child: _buildSearchField()),
              Container(width: 1, height: 32, color: const Color(0x1AFFFFFF)),
              Expanded(flex: 1, child: _buildFreightPicker()),
              const SizedBox(width: 8),
              _buildCompareButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: const InputDecoration(
        hintText: 'Trending: GSM 420 Hoodies, 304 Stainless Steel...',
        hintStyle: TextStyle(color: Color(0xFF64748B)),
        prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildFreightPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: freightType,
          dropdownColor: const Color(0xFF1E293B),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
          style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14),
          isExpanded: true,
          items: <String>['Air Express', 'Fast Sea DDP', 'Railway', 'Goods Cargo'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value.contains('Air') ? Icons.flight_takeoff : Icons.directions_boat,
                    size: 16,
                    color: const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: onFreightChanged,
        ),
      ),
    );
  }

  Widget _buildCompareButton() {
    return ElevatedButton(
      onPressed: onComparePressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: const Text(
        'Compare Markets',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
