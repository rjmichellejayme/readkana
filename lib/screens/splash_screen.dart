import 'dart:async'; // For Timer
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startDelayTimer();
  }

  void _startDelayTimer() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
            context, '/signup'); // Navigate to SignUpScreen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4A0BA), // Set background color to #f4a0ba
      body: Center(
        child: Image.asset(
          'assets/images/loader.gif',
          fit: BoxFit.contain,
          width: 300, // Set a smaller width for the logo
          height: 300, // Set a smaller height for the logo
        ),
      ),
    );
  }
}
