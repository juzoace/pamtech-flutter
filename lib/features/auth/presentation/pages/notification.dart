import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/dashboard/presentation/pages/home.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Spacing
            const SizedBox(height: 250),
            // 2. The Image & Card Section
            SizedBox(
              height: 380,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background Illustration
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/notification.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  // The "Stay in the know" Card
                  Positioned(
                    top: 0,
                    bottom: 180, // Keeps the card elevated on the image
                    left: 24,
                    right: 24,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        // Adjusted padding for a cleaner look
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1st Row: Logo and "Now"
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Using a SizedBox to prevent the logo from pushing the text down
                                SizedBox(
                                  height:
                                      84, // Reduced from 64 to tighten the vertical space
                                  width: 84,
                                  child: Image.asset(
                                    'assets/images/pamtech_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const Text(
                                  'Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            // This is the gap control
                            // const SizedBox(height: 2),

                            // 2nd Row: Bold Headline
                            const Text(
                              "You're checking in tomorrow",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                                height: 1.1, // Reduced line height
                              ),
                            ),
                            const SizedBox(height: 4),

                            // 3rd Row: Subtitle
                            const Text(
                              'Access your check-in information in the app',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 3. Bottom Content (Translated Upward to close the gap)
            Transform.translate(
              offset: const Offset(
                0,
                -80,
              ), // Pulls all content below the image UP
              child: Column(
                children: [
                  Text(
                    'Stay in the know',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: const Text(
                      "Get important updates and reminders about your booking when you turn on notifications.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DashboardScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Allow Notifications',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DashboardScreen(),
                      ),
                    ),
                    child: Text(
                      'Not Now',
                      style: TextStyle(
                        color: AppPallete.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Extra bottom padding for scroll safety
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
