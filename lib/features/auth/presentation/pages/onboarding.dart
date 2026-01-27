import 'dart:async';
import 'package:autotech/features/auth/presentation/pages/product_services.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto navigate after 5 seconds
    _timer = Timer(const Duration(seconds: 5), _navigateToLogin);
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductService()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: null, // ← removed app bar completely (cleaner for onboarding)
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background image
          Image.asset(
            'assets/images/onboarding.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 3. Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
