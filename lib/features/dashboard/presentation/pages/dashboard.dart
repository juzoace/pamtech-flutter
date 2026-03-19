import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/car_documents/presentation/pages/car_documents_page.dart';
import 'package:autotech/features/car_management/presentation/pages/car_management_page.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:autotech/features/dashboard/presentation/pages/garage.dart';
import 'package:autotech/features/dashboard/presentation/pages/notification/notification.dart';
import 'package:autotech/features/fuel_tracker/presentation/pages/fuel_tracker_page.dart';
import 'package:autotech/features/requests/presentation/pages/requests.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  static const double _vehicleHeaderCollapsedHeight = 96.0;
  static const double _vehicleHeaderTopInset = -6.0;
  static const double _vehicleHeaderHorizontalInset = 16.0;
  int _selectedVehicleIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<HomeController>(context, listen: false);
      controller.fetchAllData();
    });
  }

  String _getDisplayedVehicleText(HomeController controller) {
    if (controller.vehicles.isEmpty) return "No vehicles";
    final vehicle = _getSelectedVehicle(controller);
    final make = vehicle['make']?.toString() ?? 'Unknown';
    final model = vehicle['model']?.toString() ?? 'Unknown';
    final year = vehicle['year']?.toString() ?? '';
    return '${year.isNotEmpty ? year : ''} $make $model   ';
  }

  dynamic _getSelectedVehicle(HomeController controller) {
    if (controller.vehicles.isEmpty) {
      return null;
    }

    final safeIndex = _selectedVehicleIndex < controller.vehicles.length
        ? _selectedVehicleIndex
        : 0;

    return controller.vehicles[safeIndex];
  }

  String _garageName(dynamic garage) {
    return garage['name']?.toString() ??
        garage['garage_name']?.toString() ??
        garage['title']?.toString() ??
        'Pamtech Garage';
  }

  String _garageAddress(dynamic garage) {
    return garage['address']?.toString() ??
        garage['location']?.toString() ??
        garage['full_address']?.toString() ??
        'Address unavailable';
  }

  String _garageImage(dynamic garage) {
    return garage['image']?.toString() ??
        garage['image_url']?.toString() ??
        garage['photo']?.toString() ??
        '';
  }

  String _garageRating(dynamic garage) {
    final rating = garage['rating']?.toString() ??
        garage['average_rating']?.toString() ??
        garage['ratings']?.toString();
    if (rating == null || rating.isEmpty) {
      return '4.7';
    }
    final parsedRating = double.tryParse(rating);
    if (parsedRating == null) {
      return '4.7';
    }
    return parsedRating.toStringAsFixed(1);
  }

  String _garageReviewCount(dynamic garage) {
    return garage['reviews_count']?.toString() ??
        garage['review_count']?.toString() ??
        garage['total_reviews']?.toString() ??
        '50';
  }

  String _garageServicesCount(dynamic garage) {
    return garage['services_count']?.toString() ??
        garage['service_count']?.toString() ??
        garage['total_services']?.toString() ??
        '30';
  }

  Widget _buildGarageImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/login_header.png',
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/login_header.png',
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildGarageCard(dynamic garage) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: _buildGarageImage(_garageImage(garage)),
            ),
            Container(
              width: double.infinity,
              color: AppPallete.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _garageName(garage),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1,
                        wordSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.asset(
                    'assets/images/auto_repairer.png',
                    height: 28,
                    width: 28,
                    // size: 28,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _garageAddress(garage),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      height: 1.35,
                      letterSpacing: -0.7,
                      wordSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF0B24D),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_garageRating(garage)} (${_garageReviewCount(garage)} Reviews)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1,
                            wordSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/services_icon.png',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_garageServicesCount(garage)} Services',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -1,
                          wordSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBookRepairBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Book a Repair',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      wordSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose how you want to continue with your repair request.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.4,
                      letterSpacing: -0.5,
                      wordSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _buildBookRepairOption(
                    icon: Icons.handyman_rounded,
                    title: 'Request Mechanic',
                    subtitle: 'Open the mechanic request flow.',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Requests(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildBookRepairOption(
                    icon: Icons.garage_rounded,
                    title: 'Browse Garages',
                    subtitle: 'Check nearby garages before booking.',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Garage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookRepairOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.8,
                        wordSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        height: 1.35,
                        letterSpacing: -0.4,
                        wordSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String assetPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
              width: .4,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      assetPath,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            letterSpacing: -1,
                            wordSpacing: -1,
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            letterSpacing: -1,
                            wordSpacing: -1,
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    IconData? icon,
    String? assetPath,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: assetPath != null
                ? Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                    ),
                  )
                : Icon(
                    icon ?? Icons.info_outline,
                    color: const Color(0xFFE1A03A),
                    size: 36,
                  ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF20232B),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1,
                    wordSpacing: -1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    letterSpacing: -0.8,
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

  String _documentTitle(dynamic document) {
    return document['document_title']?.toString() ??
        document['name']?.toString() ??
        document['title']?.toString() ??
        document['document_name']?.toString() ??
        document['document_type']?.toString() ??
        'Car document';
  }

  String _documentSubtitle(dynamic document) {
    final rawExpiryDate = document['expiry_date']?.toString() ??
        document['expires_at']?.toString();
    if (rawExpiryDate == null || rawExpiryDate.isEmpty) {
      return 'Document available';
    }

    final expiryDate = DateTime.tryParse(rawExpiryDate);
    if (expiryDate == null) {
      return 'Document available';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiryDay =
        DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final daysRemaining = expiryDay.difference(today).inDays;

    if (daysRemaining < 0) {
      return 'Expired';
    }

    if (daysRemaining == 0) {
      return 'Expires today';
    }

    if (daysRemaining == 1) {
      return 'Expires in 1 day';
    }

    return 'Expires in $daysRemaining days';
  }

  bool _isDocumentExpired(dynamic document) {
    final rawExpiryDate = document['expiry_date']?.toString() ??
        document['expires_at']?.toString();
    if (rawExpiryDate == null || rawExpiryDate.isEmpty) {
      return false;
    }

    final expiryDate = DateTime.tryParse(rawExpiryDate);
    if (expiryDate == null) {
      return false;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiryDay =
        DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiryDay.isBefore(today);
  }

  Color _documentAccentColor(String subtitle) {
    final normalized = subtitle.toLowerCase();
    if (normalized.contains('expired')) {
      return const Color(0xFFF04438);
    }
    if (normalized.contains('expire')) {
      return const Color(0xFFF2A64A);
    }
    return AppPallete.primaryColor;
  }

  Color _documentBadgeBackground(String subtitle) {
    final normalized = subtitle.toLowerCase();
    if (normalized.contains('expired')) {
      return const Color(0xFFFDECEC);
    }
    if (normalized.contains('expire')) {
      return const Color(0xFFFFF6E8);
    }
    return const Color(0xFFF3F5FB);
  }

  Widget _buildDocumentsEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      child: Column(
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5FB),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/empty_document.png',
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'No Car Document Yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
              wordSpacing: -1,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Add your vehicle papers to keep in check.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.7,
              wordSpacing: -1,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(dynamic document) {
    final subtitle = _documentSubtitle(document);
    final accentColor = _documentAccentColor(subtitle);
    final iconAsset = _isDocumentExpired(document)
        ? 'assets/images/expired_document.png'
        : 'assets/images/active_document.png';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _documentBadgeBackground(subtitle),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                iconAsset,
                width: 26,
                height: 26,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _documentTitle(document),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1,
                    wordSpacing: -1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.6,
                    wordSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'View',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8,
              wordSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(HomeController controller) {
    final hasNoDocuments = controller.carDocuments.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Documents & Reminders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -1,
            wordSpacing: -1,
          ),
        ),
        const SizedBox(height: 18),
        if (controller.isLoadingCarDocuments)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (hasNoDocuments)
          _buildDocumentsEmptyState()
        else
          Column(
            children: controller.carDocuments.take(2).map((document) {
              final isLast =
                  identical(document, controller.carDocuments.take(2).last);
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                child: _buildDocumentCard(document),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildVehicleHeader(HomeController controller) {
    return Material(
      color: Colors.transparent,
      child: Card(
        color: AppPallete.primaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _vehicleHeaderCollapsedHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 22),
                          if (controller.vehicles.isEmpty)
                            const Text(
                              "No vehicles added yet",
                              style: TextStyle(color: Colors.grey),
                            )
                          else if (controller.isLoadingVehicles)
                            const Text("Loading vehicles...")
                          else
                            Text(
                              _getDisplayedVehicleText(controller),
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -1,
                                  wordSpacing: -1),
                            ),
                        ],
                      ),
                    ),
                    if (controller.vehicles.length > 1)
                      IconButton(
                        icon: Icon(
                          controller.vehiclesExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        tooltip:
                            controller.vehiclesExpanded ? 'Collapse' : 'Expand',
                        onPressed: () {
                          controller.vehiclesExpanded =
                              !controller.vehiclesExpanded;
                        },
                      ),
                  ],
                ),
              ),
            ),
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: controller.vehiclesExpanded &&
                        controller.vehicles.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: controller.vehicles.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final vehicle = entry.value;
                            final make =
                                vehicle['make']?.toString() ?? 'Unknown';
                            final model =
                                vehicle['model']?.toString() ?? 'Unknown';
                            final year = vehicle['year']?.toString() ?? '';
                            final plate =
                                vehicle['plate_number']?.toString() ?? '';

                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedVehicleIndex = index;
                                });
                                controller.vehiclesExpanded = false;
                              },
                              // leading: const Icon(
                              //   Icons.directions_car_filled_rounded,
                              //   color: Colors.blueGrey,
                              // ),
                              title: Text(
                                "$make $model ${year.isNotEmpty ? '($year)' : ''}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              subtitle: plate.isNotEmpty
                                  ? Text(
                                      " $plate",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : null,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoVehiclePromptCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF9FB3DA),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Color(0xFF3A3A3A),
                  fontSize: 14,
                  height: 1.35,
                  letterSpacing: -0.5,
                ),
                children: [
                  TextSpan(
                    text: 'You haven\'t added any vehicle yet! ',
                    style: TextStyle(
                        color: Color(0xFF20232B),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1,
                        wordSpacing: -1),
                  ),
                  TextSpan(
                      text:
                          'Click on the link here to add your car information.',
                      style: TextStyle(letterSpacing: -1, wordSpacing: -1)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarManagementPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: const Text(
              'Add Vehicle',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.6,
                wordSpacing: -1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const SizedBox.shrink(),
            leadingWidth: 140,
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
              child: Image.asset(
                'assets/images/pamtech_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 6, 0),
                child: IconButton(
                  icon: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(
                        'assets/images/notifications_no_message.png',
                        fit: BoxFit.contain,
                        width: 70,
                      ),
                      if (controller.hasUnreadNotifications)
                        Positioned(
                          right: 8,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              controller.unreadNotificationCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  iconSize: 60,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notification(),
                      ),
                    );
                  },
                ),
              ),
            ],
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(16),
              child: SizedBox(height: 16),
            ),
          ),
          body: controller.isLoadingAnything
              ? const Center(
                  child: CircularProgressIndicator(
                  color: AppPallete.primaryColor,
                  backgroundColor: Colors.white,
                ))
              : RefreshIndicator(
                  color: AppPallete.primaryColor,
                  onRefresh: controller.refresh,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: controller.vehicles.isEmpty
                                  ? 10
                                  : _vehicleHeaderCollapsedHeight +
                                      (_vehicleHeaderTopInset * 2),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                SizedBox(
                                  height: controller.vehicles.isEmpty ? 0 : 16,
                                ),
                                if (controller.vehicles.isEmpty) ...[
                                  _buildNoVehiclePromptCard(context),
                                  const SizedBox(height: 24),
                                ],
                                Container(
                                  color: Colors.white,
                                  child: Text('Quick Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 20,
                                          letterSpacing: -1,
                                          wordSpacing: -1)),
                                ),
                                // const ,
                                SizedBox(height: 10),
                                _buildQuickActionCard(
                                  assetPath: 'assets/images/car_document.png',
                                  title: 'Car Documents',
                                  subtitle: 'Upload your vehicle documents',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CarDocumentsPage(),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10),
                                _buildQuickActionCard(
                                  assetPath: 'assets/images/book_repair.png',
                                  title: 'Book a Repair',
                                  subtitle: 'Book an appointment',
                                  onTap: _openBookRepairBottomSheet,
                                ),
                                SizedBox(height: 10),
                                _buildQuickActionCard(
                                  assetPath: 'assets/images/fuel_tracker.png',
                                  title: 'Fuel Tracker',
                                  subtitle: 'Track fuel usage and spending',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FuelTrackerPage(),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10),
                                _buildQuickActionCard(
                                  assetPath: 'assets/images/car_management.png',
                                  title: 'Car Management',
                                  subtitle: 'Vehicles registered',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CarManagementPage(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Available Garages',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -1,
                                          wordSpacing: -1,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Garage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'View all',
                                        style: TextStyle(
                                          letterSpacing: -1,
                                          color: AppPallete.primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 390,
                                  child: controller.garages.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'No garages available yet',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller.garages.length,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(width: 16),
                                          itemBuilder: (context, index) {
                                            final garage =
                                                controller.garages[index];
                                            return _buildGarageCard(garage);
                                          },
                                        ),
                                ),
                                const SizedBox(height: 28),
                                const Text(
                                  'Daily Tips & Insights',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -1,
                                    wordSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                _buildTipCard(
                                  assetPath:
                                      'assets/images/pressure_checker.png',
                                  title: 'Check Your Tire Pressure',
                                  description:
                                      'Proper tire pressure improves fuel efficiency by up to 3% and extends tire life.',
                                ),
                                const SizedBox(height: 7),
                                _buildTipCard(
                                  assetPath: 'assets/images/spanner.png',
                                  title: 'Regular Oil Changes',
                                  description:
                                      'Change your oil every 5,000-7,500 miles to keep your engine running smoothly.',
                                ),
                                const SizedBox(height: 28),
                                _buildDocumentsSection(controller),
                                const SizedBox(height: 28),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: _vehicleHeaderTopInset,
                        left: _vehicleHeaderHorizontalInset,
                        right: _vehicleHeaderHorizontalInset,
                        child: controller.vehicles.isEmpty
                            ? const SizedBox.shrink()
                            : _buildVehicleHeader(controller),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
