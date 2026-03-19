import 'dart:math' as math;

import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CarDocumentsPage extends StatefulWidget {
  const CarDocumentsPage({super.key});

  @override
  State<CarDocumentsPage> createState() => _CarDocumentsPageState();
}

class _CarDocumentsPageState extends State<CarDocumentsPage> {
  final Set<String> _expandedDocumentKeys = <String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().fetchCarDocuments();
    });
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

  bool _isExpiringSoon(dynamic document) {
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
    final daysRemaining = expiryDay.difference(today).inDays;
    return daysRemaining >= 0 && daysRemaining <= 30;
  }

  String _documentKey(dynamic document, int index) {
    final id = document['id']?.toString();
    if (id != null && id.isNotEmpty) {
      return id;
    }
    return 'doc-$index';
  }

  String _formatDate(dynamic raw) {
    final value = raw?.toString() ?? '';
    if (value.isEmpty) {
      return '-';
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  String _vehicleName(dynamic document) {
    final vehicle = document['vehicle'];
    if (vehicle is! Map) {
      return '-';
    }
    final make = vehicle['make']?.toString() ?? '';
    final model = vehicle['model']?.toString() ?? '';
    final value = '$make $model'.trim();
    return value.isEmpty ? '-' : value;
  }

  String _vehiclePlate(dynamic document) {
    final vehicle = document['vehicle'];
    if (vehicle is! Map) {
      return '-';
    }
    final plate = vehicle['plate_number']?.toString() ?? '';
    return plate.isEmpty ? '-' : plate;
  }

  Color _statusColor(dynamic document) {
    if (_isDocumentExpired(document)) {
      return const Color(0xFFE94C46);
    }
    if (_isExpiringSoon(document)) {
      return const Color(0xFFF2A64A);
    }
    return const Color(0xFF4CC061);
  }

  String _statusLabel(dynamic document) {
    if (_isDocumentExpired(document)) {
      return 'Expired';
    }
    if (_isExpiringSoon(document)) {
      return 'Expiring Soon';
    }
    return 'Valid';
  }

  int _statusFilledBars(dynamic document) {
    if (_isDocumentExpired(document)) {
      return 5;
    }
    if (_isExpiringSoon(document)) {
      return 3;
    }
    return 2;
  }

  Widget _buildDashDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / 10).floor().clamp(8, 40);
        return Row(
          children: List.generate(
            dashCount,
            (_) => Container(
              width: 6,
              height: 1.5,
              margin: const EdgeInsets.only(right: 4),
              color: const Color(0xFFD2D6DE),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF20232B),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                wordSpacing: -1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFF6D7179),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.4,
                wordSpacing: -1,
              ),
            ),
          ),
        ],
      ),
    );
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

  String _vehicleLabel(dynamic vehicle) {
    final year = vehicle['year']?.toString() ?? '';
    final make = vehicle['make']?.toString() ?? 'Unknown';
    final model = vehicle['model']?.toString() ?? '';
    final plate = vehicle['plate_number']?.toString() ?? '';
    final name = '${year.isNotEmpty ? '$year ' : ''}$make $model'.trim();
    if (plate.isEmpty) {
      return name;
    }
    return '$name - $plate';
  }

  String? _documentVehicleId(dynamic document) {
    if (document == null) {
      return null;
    }

    final directVehicleId = document['vehicle_id']?.toString();
    if (directVehicleId != null && directVehicleId.isNotEmpty) {
      return directVehicleId;
    }

    final vehicle = document['vehicle'];
    if (vehicle is Map) {
      final nestedVehicleId = vehicle['id']?.toString();
      if (nestedVehicleId != null && nestedVehicleId.isNotEmpty) {
        return nestedVehicleId;
      }
    }

    return null;
  }

  Future<void> _showCarDocumentBottomSheet({dynamic document}) async {
    final controller = context.read<HomeController>();
    if (controller.vehicles.isEmpty) {
      await controller.fetchVehicles();
    }

    final isUpdate = document != null;
    final titleController = TextEditingController(
      text: document?['document_title']?.toString() ??
          document?['name']?.toString() ??
          document?['title']?.toString() ??
          '',
    );
    final numberController = TextEditingController(
      text: document?['document_number']?.toString() ??
          document?['number']?.toString() ??
          '',
    );
    final renewalAgencyController = TextEditingController(
      text: document?['renewal_agency']?.toString() ?? '',
    );
    DateTime? issuanceDate = DateTime.tryParse(
      document?['issuance_date']?.toString() ?? '',
    );
    DateTime? expiryDate = DateTime.tryParse(
      document?['expiry_date']?.toString() ??
          document?['expires_at']?.toString() ??
          '',
    );
    final issuanceDateController = TextEditingController(
      text: issuanceDate == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(issuanceDate),
    );
    final expiryDateController = TextEditingController(
      text:
          expiryDate == null ? '' : DateFormat('yyyy-MM-dd').format(expiryDate),
    );
    String? selectedVehicleId = _documentVehicleId(document);
    bool isSubmitting = false;
    String? issuanceDateErrorText;
    String? expiryDateErrorText;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  Future<void> pickDate({
                    required bool isIssuance,
                  }) async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: (isIssuance ? issuanceDate : expiryDate) ??
                          DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked == null) return;
                    setModalState(() {
                      if (isIssuance) {
                        issuanceDate = picked;
                        issuanceDateController.text =
                            DateFormat('yyyy-MM-dd').format(picked);
                        issuanceDateErrorText = null;
                        if (expiryDate != null &&
                            !DateTime(
                              expiryDate!.year,
                              expiryDate!.month,
                              expiryDate!.day,
                            ).isAfter(
                              DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                              ),
                            )) {
                          expiryDateErrorText =
                              'Expiry date must be after the issuance date.';
                        } else {
                          expiryDateErrorText = null;
                        }
                      } else {
                        expiryDate = picked;
                        expiryDateController.text =
                            DateFormat('yyyy-MM-dd').format(picked);
                        expiryDateErrorText = null;
                      }
                    });
                  }

                  final inputBorder = OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  );

                  final vehicles = controller.vehicles;
                  final hasVehicles = vehicles.isNotEmpty;
                  final hasSelectedVehicle = vehicles.any(
                    (vehicle) => vehicle['id']?.toString() == selectedVehicleId,
                  );
                  const hintTextStyle = TextStyle(
                    color: Color(0xFF898A8C),
                    fontWeight: FontWeight.w400,
                    letterSpacing: -1,
                    wordSpacing: -1,
                  );

                  return Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 7,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8CFD8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding: EdgeInsets.fromLTRB(
                                20,
                                8,
                                20,
                                20 + MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUpdate
                                        ? 'Update car document'
                                        : 'Add your car document',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -1,
                                      wordSpacing: -1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isUpdate
                                        ? 'Update your vehicle document details to keep your records accurate and accessible when needed.'
                                        : 'Add your car document to keep everything organised and easily accessible when needed.',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      height: 1.4,
                                      letterSpacing: -1,
                                      wordSpacing: -1,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  DropdownButtonFormField<String>(
                                    value: hasSelectedVehicle
                                        ? selectedVehicleId
                                        : null,
                                    hint: const Text(
                                      '- Select Vehicle -',
                                      style: hintTextStyle,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xFFF7FAFF),
                                      hintStyle: hintTextStyle,
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                    ),
                                    items: vehicles.map((vehicle) {
                                      final id =
                                          vehicle['id']?.toString() ?? '';
                                      return DropdownMenuItem<String>(
                                        value: id,
                                        child: Text(
                                          _vehicleLabel(vehicle),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: hasVehicles
                                        ? (value) => setModalState(
                                              () {
                                                selectedVehicleId = value;
                                              },
                                            )
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Document Title',
                                      hintStyle: hintTextStyle,
                                      filled: true,
                                      fillColor: const Color(0xFFF7FAFF),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: numberController,
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-Za-z ]'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Document Number',
                                      hintStyle: hintTextStyle,
                                      filled: true,
                                      fillColor: const Color(0xFFF7FAFF),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    readOnly: true,
                                    onTap: () => pickDate(isIssuance: true),
                                    controller: issuanceDateController,
                                    decoration: InputDecoration(
                                      hintText: 'Issuance Date',
                                      hintStyle: hintTextStyle,
                                      errorText: issuanceDateErrorText,
                                      suffixIcon: const Icon(
                                        Icons.calendar_month_rounded,
                                        color: Color(0xFF898A8C),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7FAFF),
                                      enabledBorder: inputBorder,
                                      errorBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE94C46),
                                        ),
                                      ),
                                      focusedErrorBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE94C46),
                                        ),
                                      ),
                                      focusedBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    readOnly: true,
                                    onTap: () => pickDate(isIssuance: false),
                                    controller: expiryDateController,
                                    decoration: InputDecoration(
                                      hintText: 'Expiry Date',
                                      hintStyle: hintTextStyle,
                                      errorText: expiryDateErrorText,
                                      suffixIcon: const Icon(
                                        Icons.calendar_month_rounded,
                                        color: Color(0xFF898A8C),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7FAFF),
                                      enabledBorder: inputBorder,
                                      errorBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE94C46),
                                        ),
                                      ),
                                      focusedErrorBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE94C46),
                                        ),
                                      ),
                                      focusedBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: renewalAgencyController,
                                    decoration: InputDecoration(
                                      hintText: 'Renewal Agency (Optional)',
                                      hintStyle: hintTextStyle,
                                      filled: true,
                                      fillColor: const Color(0xFFF7FAFF),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorder.copyWith(
                                        borderSide: const BorderSide(
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () async {
                                              final trimmedTitle =
                                                  titleController.text.trim();
                                              final trimmedNumber =
                                                  numberController.text.trim();
                                              final today = DateTime.now();
                                              final currentDate = DateTime(
                                                today.year,
                                                today.month,
                                                today.day,
                                              );
                                              final selectedIssuanceDate =
                                                  issuanceDate == null
                                                      ? null
                                                      : DateTime(
                                                          issuanceDate!.year,
                                                          issuanceDate!.month,
                                                          issuanceDate!.day,
                                                        );
                                              final selectedExpiryDate =
                                                  expiryDate == null
                                                      ? null
                                                      : DateTime(
                                                          expiryDate!.year,
                                                          expiryDate!.month,
                                                          expiryDate!.day,
                                                        );

                                              setModalState(() {
                                                issuanceDateErrorText = null;
                                                expiryDateErrorText = null;

                                                if (selectedIssuanceDate ==
                                                    null) {
                                                  issuanceDateErrorText =
                                                      'Please select the issuance date.';
                                                } else if (selectedIssuanceDate
                                                    .isAfter(currentDate)) {
                                                  issuanceDateErrorText =
                                                      'Issuance date cannot be in the future.';
                                                }

                                                if (selectedExpiryDate ==
                                                    null) {
                                                  expiryDateErrorText =
                                                      'Please select the expiry date.';
                                                } else if (selectedIssuanceDate !=
                                                        null &&
                                                    !selectedExpiryDate.isAfter(
                                                      selectedIssuanceDate,
                                                    )) {
                                                  expiryDateErrorText =
                                                      'Expiry date must be after the issuance date.';
                                                }
                                              });

                                              if (!hasVehicles) {
                                                await CustomAlert.showError(
                                                  context: this.context,
                                                  message:
                                                      'You do not have any vehicle yet. Please add a vehicle first.',
                                                );
                                                return;
                                              }

                                              if ((selectedVehicleId ?? '')
                                                      .isEmpty ||
                                                  trimmedTitle.isEmpty ||
                                                  trimmedNumber.isEmpty) {
                                                await CustomAlert.showError(
                                                  context: this.context,
                                                  message:
                                                      'Please fill all required fields.',
                                                );
                                                return;
                                              }

                                              if (issuanceDateErrorText !=
                                                      null ||
                                                  expiryDateErrorText != null) {
                                                await CustomAlert.showError(
                                                  context: this.context,
                                                  message:
                                                      'Please fix the highlighted date fields.',
                                                );
                                                return;
                                              }

                                              setModalState(
                                                () => isSubmitting = true,
                                              );
                                              try {
                                                if (isUpdate) {
                                                  final documentId =
                                                      document?['id']
                                                              ?.toString() ??
                                                          '';
                                                  if (documentId.isEmpty) {
                                                    throw Exception(
                                                      'Unable to update this car document.',
                                                    );
                                                  }

                                                  await controller
                                                      .updateCarDocument(
                                                    documentId: documentId,
                                                    vehicleId:
                                                        selectedVehicleId!,
                                                    documentTitle:
                                                        titleController.text
                                                            .trim(),
                                                    documentNumber:
                                                        numberController.text
                                                            .trim(),
                                                    issuanceDate: DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(issuanceDate!),
                                                    expiryDate: DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(expiryDate!),
                                                    renewalAgency:
                                                        renewalAgencyController
                                                            .text
                                                            .trim(),
                                                  );
                                                } else {
                                                  await controller
                                                      .createCarDocument(
                                                    vehicleId:
                                                        selectedVehicleId!,
                                                    documentTitle:
                                                        titleController.text
                                                            .trim(),
                                                    documentNumber:
                                                        numberController.text
                                                            .trim(),
                                                    issuanceDate: DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(issuanceDate!),
                                                    expiryDate: DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(expiryDate!),
                                                    renewalAgency:
                                                        renewalAgencyController
                                                            .text
                                                            .trim(),
                                                  );
                                                }
                                                if (context.mounted) {
                                                  Navigator.pop(sheetContext);
                                                  await CustomAlert.showSuccess(
                                                    context: this.context,
                                                    message: isUpdate
                                                        ? 'Car document updated successfully.'
                                                        : 'Car document added successfully.',
                                                  );
                                                }
                                              } catch (e) {
                                                if (this.context.mounted) {
                                                  await CustomAlert.showError(
                                                    context: this.context,
                                                    message: e
                                                        .toString()
                                                        .replaceFirst(
                                                          'Exception: ',
                                                          '',
                                                        ),
                                                  );
                                                }
                                              } finally {
                                                if (context.mounted) {
                                                  setModalState(
                                                    () => isSubmitting = false,
                                                  );
                                                }
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppPallete.primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        isUpdate
                                            ? 'Update Car Document'
                                            : 'Add Car Document',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -1,
                                          wordSpacing: -1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isSubmitting)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.15),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppPallete.primaryColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDocumentList(HomeController controller) {
    return RefreshIndicator(
      color: AppPallete.primaryColor,
      onRefresh: controller.fetchCarDocuments,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        itemCount: controller.carDocuments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Add your car document',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      wordSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your car document to keep everything organised and easily accessible when needed.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.4,
                      letterSpacing: -1,
                      wordSpacing: -1,
                    ),
                  ),
                ],
              ),
            );
          }

          final document = controller.carDocuments[index - 1];
          final subtitle = _documentSubtitle(document);
          final accentColor = _documentAccentColor(subtitle);
          final iconAsset = _isDocumentExpired(document)
              ? 'assets/images/expired_document.png'
              : 'assets/images/active_document.png';
          final key = _documentKey(document, index);
          final isExpanded = _expandedDocumentKeys.contains(key);
          final statusColor = _statusColor(document);
          final statusLabel = _statusLabel(document);
          final filledBars = _statusFilledBars(document);

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300, width: .8),
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedDocumentKeys.remove(key);
                        } else {
                          _expandedDocumentKeys.add(key);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _documentBadgeBackground(subtitle),
                                shape: BoxShape.circle,
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
                            Positioned(
                              right: -1,
                              bottom: -1,
                              child: Container(
                                width: 11,
                                height: 11,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            _documentTitle(document),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.8,
                              wordSpacing: -1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.chevron_right_rounded,
                          color: const Color(0xFF8A8D94),
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 16),
                    _buildDashDivider(),
                    const SizedBox(height: 14),
                    _buildDetailRow(
                      label: 'Vehicle:',
                      value: _vehicleName(document),
                    ),
                    _buildDetailRow(
                      label: 'Plate Number:',
                      value: _vehiclePlate(document),
                    ),
                    _buildDetailRow(
                      label: 'Document Number:',
                      value: document['document_number']?.toString() ?? '-',
                    ),
                    _buildDetailRow(
                      label: 'Insurance Date:',
                      value: _formatDate(document['issuance_date']),
                    ),
                    _buildDetailRow(
                      label: 'Expiry Date:',
                      value: _formatDate(document['expiry_date']),
                    ),
                    _buildDetailRow(
                      label: 'Renewal Agency:',
                      value: (document['renewal_agency']?.toString() ?? '')
                              .trim()
                              .isEmpty
                          ? '-'
                          : document['renewal_agency'].toString(),
                    ),
                    const SizedBox(height: 6),
                    _buildDashDivider(),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.8,
                                wordSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(
                                6,
                                (barIndex) => Container(
                                  width: 12,
                                  height: 6,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: barIndex < filledBars
                                        ? statusColor
                                        : const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () =>
                              _showCarDocumentBottomSheet(document: document),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppPallete.primaryColor,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: const TextStyle(
                              color: AppPallete.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final isEmpty = controller.carDocuments.isEmpty;
        final showEmptyState = isEmpty && !controller.isLoadingCarDocuments;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F8),
          floatingActionButton: controller.isLoadingCarDocuments ||
                  showEmptyState
              ? null
              : FloatingActionButton(
                  onPressed: _showCarDocumentBottomSheet,
                  backgroundColor: AppPallete.primaryColor,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
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
            title: const Text('Car Document'),
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
          body: controller.isLoadingCarDocuments
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppPallete.primaryColor,
                  ),
                )
              : showEmptyState
                  ? RefreshIndicator(
                      backgroundColor: const Color(0xFFF7F7F8),
                      color: AppPallete.primaryColor,
                      onRefresh: controller.fetchCarDocuments,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            height: 700,
                            child: _CarDocumentsEmptyState(
                              onAddCarDocument: _showCarDocumentBottomSheet,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildDocumentList(controller),
        );
      },
    );
  }
}

class _CarDocumentsEmptyState extends StatelessWidget {
  const _CarDocumentsEmptyState({required this.onAddCarDocument});

  final VoidCallback onAddCarDocument;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('assets/images/empty_car_document.png',
                    width: 250, height: 250
                    // fit: BoxFit.contain,
                    ),
              ),
              // Container(
              //   width: 220,
              //   height: 180,
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF3F5FB),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child:

              //   Center(
              //     child: Image.asset(
              //       'assets/images/empty_car_document.png',
              //       width: 130,
              //       height: 130,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              const Text(
                'No Car Document Yet!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF20232B),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                  wordSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Add your vehicle papers to keep everything\norganised and easily accessible when\nneeded.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF4A4A4A),
                  fontSize: 15,
                  height: 1.4,
                  letterSpacing: -0.3,
                  wordSpacing: -1,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onAddCarDocument,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add Car Document',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        wordSpacing: -1),
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
