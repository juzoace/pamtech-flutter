import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarManagementPage extends StatefulWidget {
  const CarManagementPage({super.key});

  @override
  State<CarManagementPage> createState() => _CarManagementPageState();
}

class _CarManagementPageState extends State<CarManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().refresh();
    });
  }

  String _vehicleTitle(dynamic vehicle) {
    final year = vehicle['year']?.toString() ?? '';
    final make = vehicle['make']?.toString() ?? 'Unknown';
    final model = vehicle['model']?.toString() ?? 'Vehicle';
    return '${year.isNotEmpty ? '$year ' : ''}$make $model';
  }

  String _vehicleSubtitle(dynamic vehicle) {
    final plate = vehicle['plate_number']?.toString();
    final color = vehicle['colour']?.toString();
    final transmission = vehicle['transmission']?.toString();

    final details = [
      if (plate != null && plate.isNotEmpty) plate,
      if (color != null && color.isNotEmpty) color,
      if (transmission != null && transmission.isNotEmpty) transmission,
    ];

    return details.isEmpty ? 'Vehicle registered' : details.join(' - ');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text('Car Management'),
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
          body: controller.isLoadingVehicles
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppPallete.primaryColor,
                  ),
                )
              : RefreshIndicator(
                  color: AppPallete.primaryColor,
                  onRefresh: controller.refresh,
                  child: controller.vehicles.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(24),
                          children: const [
                            SizedBox(height: 100),
                            _EmptyVehiclesState(),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          itemCount: controller.vehicles.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final vehicle = controller.vehicles[index];
                            return Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F0E2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/car_management.png',
                                        width: 28,
                                        height: 28,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _vehicleTitle(vehicle),
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
                                          _vehicleSubtitle(vehicle),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
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
                          },
                        ),
                ),
        );
      },
    );
  }
}

class _EmptyVehiclesState extends StatelessWidget {
  const _EmptyVehiclesState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5FB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/car_management.png',
              width: 72,
              height: 72,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'No Vehicles Yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
            wordSpacing: -1,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Registered vehicles will appear here once they are added to your account.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            height: 1.4,
            letterSpacing: -0.4,
            wordSpacing: -1,
          ),
        ),
      ],
    );
  }
}
