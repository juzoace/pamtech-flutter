import 'dart:math' as math;

import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:autotech/features/dashboard/data/models/notification_model.dart';
import 'package:autotech/features/dashboard/presentation/pages/notification/notification_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().fetchNotifications();
    });
  }

  String _timeLabel(NotificationModel notification) {
    final date = notification.createdAt;
    return DateFormat('h.mma').format(date).toLowerCase();
  }

  String _dateSectionLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) {
      return 'Today';
    }
    if (diff == 1) {
      return 'Yesterday';
    }
    return DateFormat('d MMMM yyyy').format(day);
  }

  List<_NotificationSection> _groupNotifications(
    List<NotificationModel> notifications,
  ) {
    final sorted = [...notifications]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final sections = <_NotificationSection>[];
    for (final notification in sorted) {
      final label = _dateSectionLabel(notification.createdAt);
      if (sections.isEmpty || sections.last.label != label) {
        sections.add(_NotificationSection(label: label, items: [notification]));
      } else {
        sections.last.items.add(notification);
      }
    }
    return sections;
  }

  Widget _buildSectionHeader(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FD),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF152A5B),
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.8,
          wordSpacing: -1,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F6),
          borderRadius: BorderRadius.circular(34),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/notifications_no_message.png',
              width: 170,
              height: 170,
            ),
            const SizedBox(height: 24),
            const Text(
              'No Notifications!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF20232B),
                fontSize: 42,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.4,
                wordSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We\'ll let you know when there will be\nsomething to update you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 18,
                height: 1.45,
                letterSpacing: -0.4,
                wordSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    HomeController controller,
    NotificationModel notification,
  ) {
    final unread = controller.isNotificationUnread(notification.raw);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        if (unread) {
          await controller.markNotificationAsRead(notification.raw);
        }
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationDetailPage(
              notification: notification,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
        decoration: BoxDecoration(
          color: unread ? const Color(0xFFEFF2FD) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                _timeLabel(notification),
                style: const TextStyle(
                  color: Color(0xFF7B7B7B),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5E5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_rounded,
                    size: 18,
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
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.8,
                          wordSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 16,
                          height: 1.4,
                          letterSpacing: -0.3,
                          wordSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, home, child) {
        final notifications = home.notifications
            .map(home.toNotificationModel)
            .whereType<NotificationModel>()
            .toList();
        final sections = _groupNotifications(notifications);

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
            child: home.isLoadingNotifications
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.primaryColor,
                    ),
                  )
                : notifications.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        color: AppPallete.primaryColor,
                        onRefresh: home.fetchNotifications,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                          itemCount: sections.length,
                          itemBuilder: (context, sectionIndex) {
                            final section = sections[sectionIndex];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(section.label),
                                const SizedBox(height: 12),
                                ...section.items.map((item) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: _buildNotificationTile(
                                        context,
                                        home,
                                        item,
                                      ),
                                    )),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        );
      },
    );
  }
}

class _NotificationSection {
  _NotificationSection({required this.label, required this.items});

  final String label;
  final List<NotificationModel> items;
}
