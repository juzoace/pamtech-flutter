import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/repairs/controllers/repairs_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Repairs extends StatefulWidget {
  const Repairs({super.key});

  @override
  State<Repairs> createState() => _RepairsState();
}

class _RepairsState extends State<Repairs> {
  // Simulate data state (replace later with real API data)
  final bool _hasData = false; // ← change this to true when you have data
  final List<Map<String, dynamic>> _repairHistory = [
    
  ]; // empty for now

  @override
  void initState() {
    super.initState();
    fetchRepairs();
  }

  fetchRepairs() async {
    print('called fetch repairs');
    try {} catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RepairsController>(
      builder: (context, repairs, child) {
        final isLoading = repairs.isLoading;
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Repairs"),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 3, // subtle but visible
            shadowColor: Colors.black.withOpacity(0.99999),
            surfaceTintColor: const Color.fromARGB(0, 251, 250, 250),
            scrolledUnderElevation: 3,
            centerTitle: true, // optional – looks better on most devices
          ),
          backgroundColor: Colors.grey.shade50, // light background for contrast
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header / Title

                  // Scrollable content
                  Expanded(
                    child: _hasData && _repairHistory.isNotEmpty
                        ? ListView.builder(
                            itemCount: _repairHistory.length,
                            itemBuilder: (context, index) {
                              final repair = _repairHistory[index];
                              return Card(
                                // margin:EdgeInsets.all(24),
                                elevation: 2,
                                margin: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: AppPallete.primaryColor
                                        .withOpacity(0.1),
                                    radius: 28,
                                    child: Icon(
                                      Icons.build,
                                      color: AppPallete.primaryColor,
                                      size: 32,
                                    ),
                                  ),
                                  title: Text(
                                    repair['title'] ?? 'Repair #${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        repair['date'] ?? 'Date: 12 Oct 2025',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        repair['status'] ?? 'Status: Completed',
                                        style: TextStyle(
                                          color: AppPallete.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                  ),
                                  onTap: () {
                                    // TODO: Navigate to repair detail page
                                  },
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Card(
                              elevation: 4, // subtle shadow
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
                                  mainAxisSize: MainAxisSize
                                      .min, // important – prevents stretching
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/norepairs.png',
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),

                                    const SizedBox(height: 24),
                                    const Text(
                                      'No Repair History Yet!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "You haven't booked a repair or arrived at the garage yet. Once you do, your service history will appear here",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          
          
          ),

          // Floating Action Button
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Navigate to "New Repair Request" or form page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New repair request coming soon!'),
                ),
              );
            },
            backgroundColor: AppPallete.primaryColor,
            foregroundColor: Colors.white,
            elevation: 6.0,
            shape: const CircleBorder(),
            tooltip: 'New Repair',
            child: const Icon(Icons.add, size: 28),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
