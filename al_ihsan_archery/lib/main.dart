import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al Ihsan Archery',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF10B982),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}
