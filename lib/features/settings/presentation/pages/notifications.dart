import 'dart:math' as math;

import 'package:autotech/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // State for each toggle
  bool _notificationsFromUs = true;
  bool _statusUpdates = false;
  bool _trackYourService = false;
  bool _realTimeAlerts = false;
  bool _dontMissAnUpdate = false;
  bool _beTheFirstToKnow = false;
  bool _serviceStatusAtYourFingertips = false;
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
          'Notifications',
          style: TextStyle(
            wordSpacing: -2.0,
            letterSpacing: -0.5,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: const Color.fromARGB(0, 251, 250, 250),
        scrolledUnderElevation: 3,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Notifications from us',
                  style: TextStyle(
                    color: Color(0xFF002050),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                    wordSpacing: -0.5,
                  ),
                ),
              ),
              Text(
                'Receive the latest news, updates, and industry tutorials from us.',
                style: TextStyle(
                  letterSpacing: -1,
                  color: const Color(0xFF5C5C5C),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Divider(color: const Color(0xFFDEE7F8), thickness: 1),
              ),

              const SizedBox(height: 30),

              // Toggle rows
              _buildToggleRow(
                title: 'Enable Status Updates',
                subtitle:
                    'Allow notifications to stay informed as your service progresses from check-in to completion',
                value: _statusUpdates,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() => _statusUpdates = value);
                  }
                },
              ),

              const SizedBox(height: 28),

              _buildToggleRow(
                title: 'Track your Service',
                subtitle:
                    'Stay updated as your vehicle moves through each repair stage—from diagnosis to delivery.',
                value: _trackYourService,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() => _trackYourService = value);
                  }
                },
              ),

              const SizedBox(height: 28),

              _buildToggleRow(
                title: 'Get Real-Time Alerts',
                subtitle:
                    'Turn on notifications to receive instant updates when your vehicle status changes.',
                value: _realTimeAlerts,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() => _realTimeAlerts = value);
                  }
                },
              ),

              const SizedBox(height: 28),

              _buildToggleRow(
                title: 'Be the First to Know',
                subtitle:
                    'Enable alerts so you’ll know exactly when parts arrive, repairs start, and your car is ready.',
                value: _beTheFirstToKnow,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() => _beTheFirstToKnow = value);
                  }
                },
              ),

              const SizedBox(height: 28),

              _buildToggleRow(
                title: 'Don’t Miss an Update',
                subtitle:
                    'Stay in the loop with timely notifications about your car’s progress and service timeline.',
                value: _dontMissAnUpdate,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() => _dontMissAnUpdate = value);
                  }
                },
              ),

              const SizedBox(height: 28),

              _buildToggleRow(
                title: 'Service Status at Your Fingertips',
                subtitle:
                    'Receive a heads-up as your vehicle moves from check-in to diagnostics, repair, and handover.',
                value: _serviceStatusAtYourFingertips,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() => _serviceStatusAtYourFingertips = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: text content takes most space
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  letterSpacing: -1,
                  color: Color(0xFF5C5C5C),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        // Right side: Checkbox aligned to the extreme right
        Transform.scale(
          scale: 1.2, // slightly larger for better touch target
          child: Checkbox(
            value: value,
            activeColor: AppPallete.primaryColor, // ← blue when checked
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Color(0xFF898A8C), width: 1),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
