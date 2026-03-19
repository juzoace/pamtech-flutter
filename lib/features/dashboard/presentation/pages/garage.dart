import 'dart:math' as math;

import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Garage extends StatefulWidget {
  const Garage({super.key});

  @override
  State<Garage> createState() => _GarageState();
}

class _GarageState extends State<Garage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              height: 220,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1,
                        wordSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.engineering_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _garageAddress(garage),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.35,
                      letterSpacing: -1,
                      wordSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF0B24D),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${_garageRating(garage)} (${_garageReviewCount(garage)} Reviews)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1,
                            wordSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/images/services_icon.png',
                        height: 22,
                        width: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${_garageServicesCount(garage)} Services',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
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

  List<dynamic> _filterGarages(List<dynamic> garages) {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return garages;
    }

    return garages.where((garage) {
      final name = _garageName(garage).toLowerCase();
      final address = _garageAddress(garage).toLowerCase();
      return name.contains(normalizedQuery) ||
          address.contains(normalizedQuery);
    }).toList();
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search garages',
        hintStyle: const TextStyle(
          color: Colors.black45,
          fontSize: 14,
          letterSpacing: -0.3,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Colors.black54,
        ),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.black54,
                ),
              ),
        filled: true,
        fillColor: const Color(0xFFF6F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        final filteredGarages = _filterGarages(controller.garages);

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
                      ? const Color.fromARGB(
                          255,
                          223,
                          228,
                          239,
                        ).withValues(alpha: 0.9)
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
              'Garage',
              style: TextStyle(
                letterSpacing: -0.5,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 3,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            centerTitle: true,
          ),
          body: SafeArea(
            child: controller.isLoadingGarages
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.primaryColor,
                    ),
                  )
                : controller.garages.isEmpty
                    ? const Center(
                        child: Text(
                          'No garages available yet',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: controller.refresh,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          itemCount: filteredGarages.isEmpty
                              ? 2
                              : filteredGarages.length + 1,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildSearchBar();
                            }

                            if (filteredGarages.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F7FB),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'No garages match your search.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    letterSpacing: -0.4,
                                    wordSpacing: -1,
                                  ),
                                ),
                              );
                            }

                            return _buildGarageCard(filteredGarages[index - 1]);
                          },
                        ),
                      ),
          ),
        );
      },
    );
  }
}
