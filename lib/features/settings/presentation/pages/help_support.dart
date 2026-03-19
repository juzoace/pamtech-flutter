import 'dart:math' as math;

import 'package:flutter/material.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color.fromARGB(255, 223, 228, 239).withOpacity(0.9)
                  : Colors.grey.shade800.withOpacity(0.4),
            ),
            child: Center(
              child: Transform.rotate(
                angle: math.pi / 2,
                child: Image.asset(
                  'assets/images/backbutton.png',
                  height: 22,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help and Support',
          style: TextStyle(
            // wordSpacing: -2.0,
            letterSpacing: -0.5,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 3, // subtle but visible
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: const Color.fromARGB(0, 251, 250, 250),
        scrolledUnderElevation: 3,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Live Chat Support Button ────────────────────────────────
              InkWell(
                onTap: () {
                  // TODO: Open live chat / support screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening Live Chat...')),
                  );
                },
                // borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 68,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF5C5C5C), // blue border
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white, // or very light blue if preferred
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: icon + text
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/call_center.png', // ← your call center PNG
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Contact Live Chat',
                              style: TextStyle(
                                fontSize: 18,
                                wordSpacing: -1.8,
                                letterSpacing: -1.2,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        // Right: arrow icon
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: const Color(0xFF010309),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Add more support options below if needed
              const SizedBox(height: 24),

              // Complete buy adding email.png centered, a text underneath, then another underneath. All 3 centered
              // InkWell(...),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40),
                    // Email icon
                    Image.asset(
                      'assets/images/email.png',
                      height: 60,
                      width: 60,
                    ),
                    const SizedBox(height: 25),

                    // Helper text
                    Text(
                      'Send Us an e-mail:',
                      style: TextStyle(
                         wordSpacing: -1.8,
                                letterSpacing: -1.2,
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    // Main text
                    Text(
                      'support@pamtechcarcare.com',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.4,
                        color: Colors.black87,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
