import 'dart:convert';

import 'package:autotech/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleAddressPage extends StatefulWidget {
  const GoogleAddressPage({
    super.key,
    this.initialQuery = '',
  });

  final String initialQuery;

  @override
  State<GoogleAddressPage> createState() => _GoogleAddressPageState();
}

class _GoogleAddressPageState extends State<GoogleAddressPage> {
  static const String _placesApiKey =
      String.fromEnvironment('GOOGLE_PLACES_API_KEY', defaultValue: '');

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _predictions = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
      if (widget.initialQuery.trim().isNotEmpty) {
        _searchPlaces(widget.initialQuery.trim());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _searchPlaces(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      setState(() {
        _predictions = <Map<String, dynamic>>[];
        _errorMessage = null;
      });
      return;
    }

    if (_placesApiKey.isEmpty) {
      setState(() {
        _predictions = <Map<String, dynamic>>[];
        _errorMessage =
            'Google Places API key is not configured for this build.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/autocomplete/json',
        <String, String>{
          'input': trimmedQuery,
          'key': _placesApiKey,
          'components': 'country:ng',
        },
      );

      final response = await http.get(uri);
      final payload = jsonDecode(response.body);

      if (response.statusCode == 200 && payload is Map<String, dynamic>) {
        final status = payload['status']?.toString() ?? '';
        if (status == 'OK' || status == 'ZERO_RESULTS') {
          final predictions = (payload['predictions'] as List? ?? <dynamic>[])
              .whereType<Map>()
              .map((prediction) => Map<String, dynamic>.from(prediction))
              .toList();

          setState(() {
            _predictions = predictions;
          });
        } else {
          setState(() {
            _predictions = <Map<String, dynamic>>[];
            _errorMessage = payload['error_message']?.toString() ??
                'Failed to fetch places.';
          });
        }
      } else {
        setState(() {
          _predictions = <Map<String, dynamic>>[];
          _errorMessage = 'Failed to fetch places.';
        });
      }
    } catch (_) {
      setState(() {
        _predictions = <Map<String, dynamic>>[];
        _errorMessage = 'Unable to search locations right now.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 84,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFE7EEF9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 30,
              color: Color(0xFF20232B),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Google address',
          style: TextStyle(
            color: Color(0xFF20232B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                onChanged: _searchPlaces,
                onSubmitted: _searchPlaces,
                decoration: InputDecoration(
                  hintText: 'Search address',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF98A2B3),
                    size: 30,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _searchPlaces('');
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Color(0xFF666666),
                          ),
                        ),
                      Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2F4F7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppPallete.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(
                      color: Color(0xFFD6DBE4),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(
                      color: AppPallete.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppPallete.primaryColor,
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _predictions.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              color: Color(0xFFE4E7EC),
                            ),
                            itemBuilder: (context, index) {
                              final prediction = _predictions[index];
                              final structured =
                                  prediction['structured_formatting']
                                      as Map<String, dynamic>?;
                              final mainText =
                                  structured?['main_text']?.toString() ??
                                      prediction['description']?.toString() ??
                                      '';
                              final secondaryText =
                                  structured?['secondary_text']?.toString() ??
                                      '';
                              final description =
                                  prediction['description']?.toString() ?? '';

                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                onTap: () =>
                                    Navigator.pop(context, description),
                                leading: const Icon(
                                  Icons.location_on_outlined,
                                  color: AppPallete.primaryColor,
                                  size: 30,
                                ),
                                title: Text(
                                  mainText,
                                  style: const TextStyle(
                                    color: Color(0xFF20232B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                subtitle: Text(
                                  secondaryText,
                                  style: const TextStyle(
                                    color: Color(0xFF667085),
                                    fontSize: 14,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
