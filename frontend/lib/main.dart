import 'package:flutter/material.dart';
import 'screens/price_comparison_screen.dart';

void main() {
  runApp(const WholesaleSwiftApp());
}

class WholesaleSwiftApp extends StatelessWidget {
  const WholesaleSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WholesaleSwift Intelligence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4F46E5), // Indigo
          secondary: Color(0xFF10B981), // Emerald
          surface: Color(0xFF1E293B),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Fallback, would ideally use Inter or similar
      ),
      home: PriceComparisonScreen(),
    );
  }
}
