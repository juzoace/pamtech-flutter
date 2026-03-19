import 'dart:math' as math;

import 'package:autotech/features/dashboard/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('EEEE, d MMMM yyyy • h:mm a').format(notification.createdAt);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 90,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color.fromARGB(255, 223, 228, 239)
                      .withValues(alpha: 0.9)
                  : Colors.grey.shade800.withValues(alpha: 0.4),
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
          'Notification',
          style: TextStyle(
            wordSpacing: -2,
            letterSpacing: -0.5,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        surfaceTintColor: const Color.fromARGB(0, 251, 250, 250),
        scrolledUnderElevation: 3,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2FD),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE5E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            color: Color(0xFF0E111A),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                            wordSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dateLabel,
                          style: const TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          notification.message,
                          style: const TextStyle(
                            color: Color(0xFF4A4A4A),
                            fontSize: 16,
                            height: 1.45,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
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
