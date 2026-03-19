import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:autotech/features/requests/controllers/requests_controller.dart';
import 'package:autotech/features/requests/presentation/pages/google_address_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  bool _initialLoading = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestsController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Request a Mechanic"),
            titleTextStyle: const TextStyle(
              letterSpacing: -1,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.2),
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 3,
            centerTitle: true,
          ),
          backgroundColor: Colors.grey.shade50,
          body: SafeArea(
            child: _initialLoading || controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.primaryColor,
                    ),
                  )
                : controller.requestData.isEmpty
                    ? Center(
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 100,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  height: 120,
                                  'assets/images/no_requests.png',
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "You haven't requested for a mechanic yet!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      wordSpacing: -1,
                                      letterSpacing: -1),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "You haven't made any bookings yet. Once you schedule a service, your details will appear here.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      height: 1.4,
                                      wordSpacing: -1,
                                      letterSpacing: -1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 0,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppPallete.primaryColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                24,
                                              ),
                                            ),
                                            elevation: 2,
                                          ),
                                          onPressed: () {
                                            _requestMechanicBottomSheet();
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (BuildContext context) =>
                                            //         DashboardScreen(),
                                            //   ),
                                            // );
                                          },
                                          child: const Text(
                                            'Request Mechanic',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                wordSpacing: -1,
                                                letterSpacing: -1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.requestData.length,
                        itemBuilder: (context, index) {
                          return const SizedBox();
                        },
                      ),
          ),
        );
      },
    );
  }

  Future<void> _fetchRequests() async {
    try {
      final controller = Provider.of<RequestsController>(
        context,
        listen: false,
      );
      await controller.fetchRequests();
    } catch (e) {
      print('Error fetching repairs: $e');
    } finally {
      if (mounted) {
        setState(() {
          _initialLoading = false;
        });
      }
    }
  }

  void _requestMechanicBottomSheet() async {
    final requestsController = context.read<RequestsController>();
    final homeController = context.read<HomeController>();

    if (requestsController.services.isEmpty) {
      await requestsController.fetchRequestMechanicServices();
    }

    if (homeController.vehicles.isEmpty) {
      await homeController.fetchVehicles();
    }

    if (!mounted) return;

    final locationController = TextEditingController();
    final Set<String> selectedServiceIds = <String>{};
    String? selectedVehicleId;
    bool isSubmitting = false;

    Future<void> openGoogleAddressPage() async {
      final selectedAddress = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => GoogleAddressPage(
            initialQuery: locationController.text,
          ),
        ),
      );

      if (selectedAddress == null || selectedAddress.trim().isEmpty) {
        return;
      }

      locationController.text = selectedAddress;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.86,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                final services = requestsController.services;
                final vehicles = homeController.vehicles;

                Future<void> openAddVehicleModal() async {
                  final vinController = TextEditingController();
                  final makeController = TextEditingController();
                  final modelController = TextEditingController();
                  final yearController = TextEditingController();
                  final colourController = TextEditingController();
                  String? engineType;
                  final mileageController = TextEditingController();
                  final plateController = TextEditingController();
                  String? transmission;
                  bool isCreatingVehicle = false;

                  await showModalBottomSheet<void>(
                    context: sheetContext,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (vehicleSheetContext) {
                      return StatefulBuilder(
                        builder: (context, setVehicleModalState) {
                          final inputBorder = OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          );

                          Future<void> submitVehicle() async {
                            if (vinController.text.trim().isEmpty ||
                                makeController.text.trim().isEmpty ||
                                modelController.text.trim().isEmpty ||
                                yearController.text.trim().isEmpty ||
                                colourController.text.trim().isEmpty ||
                                (engineType ?? '').isEmpty ||
                                mileageController.text.trim().isEmpty ||
                                plateController.text.trim().isEmpty ||
                                (transmission ?? '').isEmpty) {
                              await CustomAlert.showError(
                                context: sheetContext,
                                message: 'Please fill all vehicle fields.',
                              );
                              return;
                            }

                            setVehicleModalState(
                              () => isCreatingVehicle = true,
                            );

                            try {
                              await homeController.createVehicle(
                                vin: vinController.text.trim(),
                                make: makeController.text.trim(),
                                model: modelController.text.trim(),
                                year: yearController.text.trim(),
                                milage: mileageController.text.trim(),
                                enginType: engineType!,
                                plateNumber: plateController.text.trim(),
                                colour: colourController.text.trim(),
                                transmission: transmission!,
                              );

                              final updatedVehicles = homeController.vehicles;
                              final dynamic newVehicle = updatedVehicles.isEmpty
                                  ? null
                                  : updatedVehicles.last;
                              final String? newVehicleId =
                                  newVehicle?['id']?.toString();

                              if (vehicleSheetContext.mounted) {
                                Navigator.pop(vehicleSheetContext);
                              }

                              setModalState(() {
                                selectedVehicleId = newVehicleId;
                              });

                              await CustomAlert.showSuccess(
                                context: sheetContext,
                                message: 'Vehicle added successfully.',
                              );
                            } catch (e) {
                              await CustomAlert.showError(
                                context: sheetContext,
                                message: e
                                    .toString()
                                    .replaceFirst('Exception: ', ''),
                              );
                            } finally {
                              if (context.mounted) {
                                setVehicleModalState(
                                  () => isCreatingVehicle = false,
                                );
                              }
                            }
                          }

                          return DraggableScrollableSheet(
                            initialChildSize: 0.82,
                            minChildSize: 0.45,
                            maxChildSize: 0.95,
                            expand: false,
                            builder: (context, vehicleScrollController) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(28),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    SingleChildScrollView(
                                      controller: vehicleScrollController,
                                      padding: EdgeInsets.fromLTRB(
                                        20,
                                        12,
                                        20,
                                        24 +
                                            MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 64,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFC8CFD8),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          const Text(
                                            'Your Vehicle Hub!',
                                            style: TextStyle(
                                              color: Color(0xFF20232B),
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -1,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Stay on top of your vehicle’s health with detailed service history and maintenance updates. Enter your vehicle details below',
                                            style: TextStyle(
                                              color: Color(0xFF7B7F87),
                                              fontSize: 14,
                                              height: 1.4,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          _buildVehicleInput(
                                            controller: vinController,
                                            hintText:
                                                'Vehicle Identification Number',
                                            inputBorder: inputBorder,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildVehicleInput(
                                            controller: makeController,
                                            hintText: 'Make',
                                            inputBorder: inputBorder,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildVehicleInput(
                                            controller: modelController,
                                            hintText: 'Model',
                                            inputBorder: inputBorder,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildVehicleInput(
                                            controller: yearController,
                                            hintText: 'Year',
                                            inputBorder: inputBorder,
                                            keyboardType: TextInputType.number,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildVehicleInput(
                                            controller: colourController,
                                            hintText: 'Color',
                                            inputBorder: inputBorder,
                                          ),
                                          const SizedBox(height: 12),
                                          DropdownButtonFormField<String>(
                                            value: engineType,
                                            decoration: InputDecoration(
                                              hintText: 'Engine Type',
                                              filled: true,
                                              fillColor:
                                                  const Color(0xFFF7FAFF),
                                              enabledBorder: inputBorder,
                                              focusedBorder:
                                                  inputBorder.copyWith(
                                                borderSide: const BorderSide(
                                                  color:
                                                      AppPallete.primaryColor,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 14,
                                              ),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'fuel',
                                                child: Text('fuel'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'disel',
                                                child: Text('disel'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'cng',
                                                child: Text('cng'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'electric',
                                                child: Text('electric'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'hybrid',
                                                child: Text('hybrid'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setVehicleModalState(
                                                () => engineType = value,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 12),
                                          _buildVehicleInput(
                                            controller: mileageController,
                                            hintText: 'Mileage',
                                            inputBorder: inputBorder,
                                            keyboardType: TextInputType.number,
                                          ),
                                          const SizedBox(height: 12),
                                          DropdownButtonFormField<String>(
                                            value: transmission,
                                            decoration: InputDecoration(
                                              hintText: 'Transmission',
                                              filled: true,
                                              fillColor:
                                                  const Color(0xFFF7FAFF),
                                              enabledBorder: inputBorder,
                                              focusedBorder:
                                                  inputBorder.copyWith(
                                                borderSide: const BorderSide(
                                                  color:
                                                      AppPallete.primaryColor,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 14,
                                              ),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'automatic',
                                                child: Text('automatic'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'manual',
                                                child: Text('manual'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setVehicleModalState(
                                                () => transmission = value,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 12),
                                          _buildVehicleInput(
                                            controller: plateController,
                                            hintText: 'Vehicle Plate No',
                                            inputBorder: inputBorder,
                                          ),
                                          const SizedBox(height: 22),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 54,
                                            child: ElevatedButton(
                                              onPressed: isCreatingVehicle
                                                  ? null
                                                  : submitVehicle,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppPallete.primaryColor,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    999,
                                                  ),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: const Text(
                                                'Add your Vehicle',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: -0.6,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isCreatingVehicle)
                                      Positioned.fill(
                                        child: Container(
                                          color: Colors.black.withValues(
                                            alpha: 0.12,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: AppPallete.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }

                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 64,
                            height: 6,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8CFD8),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding: EdgeInsets.fromLTRB(
                                20,
                                8,
                                20,
                                24 + MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'What kind of Service do you need? (${selectedServiceIds.length})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF20232B),
                                      letterSpacing: -0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  if (services.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        'No services available right now.',
                                        style: TextStyle(
                                          color: Color(0xFF8A8F98),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  else
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: services.map((service) {
                                        final serviceId =
                                            service['id']?.toString() ?? '';
                                        final serviceName =
                                            service['name']?.toString() ??
                                                'Service';
                                        final isSelected = selectedServiceIds
                                            .contains(serviceId);

                                        return GestureDetector(
                                          onTap: serviceId.isEmpty
                                              ? null
                                              : () {
                                                  setModalState(() {
                                                    if (isSelected) {
                                                      selectedServiceIds
                                                          .remove(serviceId);
                                                    } else {
                                                      selectedServiceIds
                                                          .add(serviceId);
                                                    }
                                                  });
                                                },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFFEAF1FF)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppPallete.primaryColor
                                                    : const Color(0xFFD6DBE4),
                                              ),
                                            ),
                                            child: Text(
                                              serviceName,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? AppPallete.primaryColor
                                                    : const Color(0xFF5C6270),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.4,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  const SizedBox(height: 28),
                                  TextField(
                                    controller: locationController,
                                    readOnly: true,
                                    onTap: openGoogleAddressPage,
                                    decoration: InputDecoration(
                                      hintText: 'Search your location',
                                      hintStyle: const TextStyle(
                                        letterSpacing: -1,
                                        wordSpacing: -1,
                                        color: Color(0xFF8A8F98),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 18,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFD6DBE4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        borderSide: const BorderSide(
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                      suffixIcon: Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF2F4F7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color: AppPallete.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  const Text(
                                    'Saved Vehicles',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF20232B),
                                      letterSpacing: -0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  if (vehicles.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 12),
                                      child: Text(
                                        'No saved vehicles found.',
                                        style: TextStyle(
                                          color: Color(0xFF8A8F98),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ...vehicles.map((vehicle) {
                                    final vehicleId =
                                        vehicle['id']?.toString() ?? '';
                                    final isSelected =
                                        selectedVehicleId == vehicleId;
                                    final make =
                                        vehicle['make']?.toString() ?? '';
                                    final model =
                                        vehicle['model']?.toString() ?? '';
                                    final plate =
                                        vehicle['plate_number']?.toString() ??
                                            '';
                                    final title = '$make $model'.trim().isEmpty
                                        ? 'Vehicle'
                                        : '$make $model'.trim();

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: vehicleId.isEmpty
                                            ? null
                                            : () => setModalState(
                                                  () => selectedVehicleId =
                                                      vehicleId,
                                                ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppPallete.primaryColor
                                                  : const Color(0xFFE2E8F0),
                                              width: isSelected ? 1.5 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 42,
                                                height: 42,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFE9F0FF),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.directions_car,
                                                  color:
                                                      AppPallete.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      title,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF20232B),
                                                        letterSpacing: -0.5,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      plate.isEmpty
                                                          ? 'No plate number'
                                                          : plate,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFF8A8F98),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                isSelected
                                                    ? Icons.check_circle
                                                    : Icons.chevron_right,
                                                color: isSelected
                                                    ? AppPallete.primaryColor
                                                    : const Color(0xFF98A2B3),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: OutlinedButton(
                                      onPressed: openAddVehicleModal,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF42454C),
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add New vehicles',
                                        style: TextStyle(
                                            color: Color(0xFF42454C),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -1,
                                            wordSpacing: -1),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () async {
                                              if (selectedServiceIds.isEmpty ||
                                                  (selectedVehicleId ?? '')
                                                      .isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Select at least one service and one vehicle.',
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              setModalState(
                                                () => isSubmitting = true,
                                              );

                                              await Future<void>.delayed(
                                                const Duration(
                                                    milliseconds: 500),
                                              );

                                              if (sheetContext.mounted) {
                                                setModalState(
                                                  () => isSubmitting = false,
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppPallete.primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Request Mechanic',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.6,
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
                      if (requestsController.isLoadingServices || isSubmitting)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.12),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppPallete.primaryColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildVehicleInput({
    required TextEditingController controller,
    required String hintText,
    required InputBorder inputBorder,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF898A8C),
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
        ),
        filled: true,
        fillColor: const Color(0xFFF7FAFF),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppPallete.primaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
    );
  }
}
