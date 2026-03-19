import 'dart:math' as math;

import 'package:flutter/material.dart';

class TermsPolicies extends StatefulWidget {
  const TermsPolicies({super.key});

  @override
  State<TermsPolicies> createState() => _TermsPoliciesState();
}

class _TermsPoliciesState extends State<TermsPolicies> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          'Terms and Policies',
          style: TextStyle(
            letterSpacing: -0.5,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 3,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              // ── Header section ────────────────────────────────
              const Text(
                'AGREEMENT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  wordSpacing: -1.8,
                  letterSpacing: -1.2,
                  color: Color(0xFFA4B9DA),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 18,
                  wordSpacing: -1.6,
                  letterSpacing: -1.2,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF134CA2),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Last updated on 5/10/2025',
                style: TextStyle(
                  fontSize: 12,
                  wordSpacing: -1,
                  letterSpacing: -1,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 20),

              // ── Light ash divider ─────────────────────────────
              Divider(color: Colors.grey.shade300, thickness: 1, height: 1),

              const SizedBox(height: 24),

              // ── Scrollable terms content with visible scrollbar ──
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true, // always visible
                  interactive: true,
                  thickness: 6,
                  radius: const Radius.circular(10),

                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        '''
Welcome to Palmtech Car Care!

These Terms of Service ("Terms") govern your access to and use of the Palmtech Car Care mobile application and any related services (collectively, the "Service"), operated by Palmtech Car Care.

1. Acceptance of Terms
By accessing or using the Service, you agree to be bound by these Terms. If you do not agree, do not use the Service.

2. Eligibility
You must be at least 18 years old and legally capable of entering into contracts to use the Service.

3. User Accounts
When you create an account, you agree to provide accurate information and keep it updated. You are responsible for all activity under your account.

4. Services
Palmtech Car Care connects users with car care service providers. We are not responsible for the quality of services provided by third-party vendors.

5. Payments
All payments are processed securely. Prices are displayed in Nigerian Naira (₦). Refunds are subject to our Refund Policy.

6. User Content
You retain ownership of content you submit, but grant us a license to use it for operating the Service.

7. Prohibited Conduct
You may not misuse the Service, post harmful content, or attempt to interfere with its operation.

8. Termination
We may suspend or terminate your access at any time for violation of these Terms.

9. Limitation of Liability
The Service is provided "as is". We are not liable for indirect, incidental, or consequential damages arising from use of the Service.

10. Governing Law
These Terms are governed by the laws of the Federal Republic of Nigeria.

11. Changes to Terms
We may update these Terms from time to time. Continued use after changes means you accept them.

Last updated: 5 October 2025

Questions? Contact support@palmtechcarcare.com
                        ''',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
