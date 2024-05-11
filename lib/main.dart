import 'package:flutter/material.dart';
import 'package:watts_my_bill/pages/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watt\'s My Bill',
      theme: _buildAppTheme(),
      home: const HomePage(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Avenir Next',
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontFamily: 'Avenir Next', fontWeight: FontWeight.bold),
        bodyLarge:
            TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
