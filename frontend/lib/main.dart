import 'package:flutter/material.dart';
import 'screens/sourcing_screen.dart';

void main() {
  runApp(const WholesaleSwiftApp());
}

class WholesaleSwiftApp extends StatelessWidget {
  const WholesaleSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WholesaleSwift',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: SourcingScreen(),
    );
  }
}
