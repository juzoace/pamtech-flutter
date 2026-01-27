import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/auth/presentation/pages/auth_screen.dart';
import 'package:flutter/material.dart';

class ProductService extends StatefulWidget {
  const ProductService({super.key});

  @override
  State<ProductService> createState() => _ProductServiceState();
}

class _ProductServiceState extends State<ProductService> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'icon': 'assets/images/onboard_1.png',
      'image': 'assets/images/onboard.png',
      'title': 'Smarter Auto Care Starts Here',
      'description':
          'Experience seamless car maintenance, quick bookings, and trusted garages — all in one app.',
    },
    {
      'icon': 'assets/images/onboard_2.png',
      'image': 'assets/images/onboard.png',
      'title': 'Book Your Car Services With Ease',
      'description':
          'From oil changes to major repairs, find and schedule your car services anytime, anywhere.',
    },
    {
      'icon': 'assets/images/onboard_3.png',
      'image': 'assets/images/onboard.png',
      'title': 'Find Best Services',
      'description':
          'Discover nearby mechanics, compare prices and book appointments easily.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
    }
  }

  void _skipToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.50,
                          width: double.infinity,
                          child: Image.asset(
                            slide['image']!,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _slides.length,
                            (i) => GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                width: _currentPage == i ? 28 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _currentPage == i
                                      ? AppPallete.primaryColor
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        Text(
                          slide['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 18),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            slide['description']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5C5C5C),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const Spacer(flex: 2),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom row: Skip (left) + Image button (right)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 32, 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Skip - left
                  TextButton(
                    onPressed: _skipToLogin,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF5C5C5C),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // "Next" button = current onboarding image
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF134CA2).withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          _slides[_currentPage]['icon']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}