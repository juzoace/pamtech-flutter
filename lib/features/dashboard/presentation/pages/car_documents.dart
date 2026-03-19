import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarDocumentsPage extends StatefulWidget {
  const CarDocumentsPage({super.key});

  @override
  State<CarDocumentsPage> createState() => _CarDocumentsPageState();
}

class _CarDocumentsPageState extends State<CarDocumentsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().fetchCarDocuments();
    });
  }

  String _documentTitle(dynamic document) {
    return document['name']?.toString() ??
        document['title']?.toString() ??
        document['document_name']?.toString() ??
        document['document_type']?.toString() ??
        'Car document';
  }

  String _documentSubtitle(dynamic document) {
    return document['number']?.toString() ??
        document['document_number']?.toString() ??
        document['expiry_date']?.toString() ??
        document['expires_at']?.toString() ??
        document['status']?.toString() ??
        'Document available';
  }

  Widget _buildDocumentList(HomeController controller) {
    return RefreshIndicator(
      color: AppPallete.primaryColor,
      onRefresh: controller.fetchCarDocuments,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        itemCount: controller.carDocuments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final document = controller.carDocuments[index];
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300, width: .8),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5FB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/car_document.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _documentTitle(document),
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
                        _documentSubtitle(document),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final isEmpty = controller.carDocuments.isEmpty;
        final showEmptyState = isEmpty &&
            !controller.isLoadingCarDocuments &&
            controller.carDocumentsMessage == 'No car documents found';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            titleSpacing: 0,
            title: const Text(
              'Documents & Reminders',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -1,
                wordSpacing: -1,
              ),
            ),
          ),
          body: controller.isLoadingCarDocuments
              ? const Center(child: CircularProgressIndicator())
              : showEmptyState
                  ? RefreshIndicator(
                      color: AppPallete.primaryColor,
                      onRefresh: controller.fetchCarDocuments,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 140),
                          SizedBox(
                            height: 340,
                            child: _CarDocumentsEmptyState(),
                          ),
                        ],
                      ),
                    )
                  : isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 56,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  controller.carDocumentsMessage ??
                                      'Unable to load car documents.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton(
                                  onPressed: controller.fetchCarDocuments,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppPallete.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Try again'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _buildDocumentList(controller),
        );
      },
    );
  }
}

class _CarDocumentsEmptyState extends StatelessWidget {
  const _CarDocumentsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  'assets/images/car_document.png',
                  width: 72,
                  height: 72,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No Car Document Yet!',
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
              'Add your vehicle papers to keep in check.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.7,
                wordSpacing: -1,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
