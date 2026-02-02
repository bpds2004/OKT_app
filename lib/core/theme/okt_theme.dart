import 'package:flutter/material.dart';

class OktTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5EFF)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
