import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(bottom: BorderSide(color: Color(0x1AFFFFFF))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.blur_on, color: Color(0xFF4F46E5), size: 32),
            const SizedBox(width: 12),
            const Text(
              'WholesaleSwift Intelligence',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.5)),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Color(0xFF818CF8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x6610B981),
                        blurRadius: 4,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Live Feed',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.history, color: Color(0xFF94A3B8)),
              onPressed: () {},
              tooltip: 'History',
            ),
            IconButton(
              icon: const Icon(Icons.dark_mode, color: Color(0xFF94A3B8)),
              onPressed: () {},
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
