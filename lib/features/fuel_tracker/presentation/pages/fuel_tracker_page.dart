import 'package:autotech/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class FuelTrackerPage extends StatelessWidget {
  const FuelTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Fuel Tracker'),
        titleTextStyle: const TextStyle(
          letterSpacing: -1,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 3,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPallete.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fuel Overview',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Track refills, usage, and spend from one place.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -1,
                      wordSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _FuelInfoCard(
              title: 'No fuel logs yet',
              description:
                  'Fuel tracking will appear here once refill logging is connected.',
              icon: Icons.local_gas_station_rounded,
            ),
            const SizedBox(height: 12),
            _FuelInfoCard(
              title: 'Planned scope',
              description:
                  'This module is ready for trip history, cost trends, and mileage insights.',
              icon: Icons.insights_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _FuelInfoCard extends StatelessWidget {
  const _FuelInfoCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F0E2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppPallete.primaryColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.8,
                    wordSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.4,
                    letterSpacing: -0.4,
                    wordSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
