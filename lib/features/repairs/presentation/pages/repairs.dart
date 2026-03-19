import 'dart:io';

import 'package:autotech/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/repairs/controllers/repairs_controller.dart';

class Repairs extends StatefulWidget {
  const Repairs({super.key});

  @override
  State<Repairs> createState() => _RepairsState();
}

class _RepairsState extends State<Repairs> {
  bool _initialLoading = true;
  bool isLoading = false;

  Future<void> _handlePdfDownload() async {
    final controller = Provider.of<RepairsController>(context, listen: false);
    final repair = controller.currentRepairDetails;
    final user = Provider.of<ProfileController>(context, listen: false);
    print('user');
    print(user.profile.name);
    if (repair == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No repair details loaded")));
      return;
    }

    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Generating PDF...")));

      // ── Load custom fonts ───────────────────────────────────────────────
      final regularData = await rootBundle.load(
        'assets/fonts/Roboto-Regular.ttf',
      );
      final boldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

      final regularFont = pw.Font.ttf(regularData);
      final boldFont = pw.Font.ttf(boldData);

      // Helper to create consistent text style with custom font
      pw.TextStyle textStyle({
        double size = 11,
        bool bold = false,
        PdfColor? color,
      }) {
        return pw.TextStyle(
          font: bold ? boldFont : regularFont,
          fontSize: size,
          color: color ?? PdfColors.black,
          lineSpacing: 1.2,
        );
      }

      final pdf = pw.Document();

      // ── Helper formatters ───────────────────────────────────────
      String money(num? v) {
        if (v == null) return "₦0";
        final f = NumberFormat.currency(
          locale: 'en_US',
          symbol: '₦',
          decimalDigits: 0,
        );
        return f.format(v);
      }

      String safe(String? s) {
        return (s?.trim().isNotEmpty == true) ? s!.trim() : "—";
      }

      // Parse vehicle
      final vehicle = repair['vehicle'] as Map<String, dynamic>? ?? {};
      final make = safe(vehicle['make']);
      final model = safe(vehicle['model']);
      final plate = safe(vehicle['plate_number']);
      final year = safe(vehicle['year']?.toString());
      final vin = safe(vehicle['vin']);

      // Estimate items
      final items = repair['estimate_items'] as List<dynamic>? ?? [];

      double subTotal = 0;
      double totalVat = 0;
      double grandTotal = 0;
      double amountPaid =
          double.tryParse(repair['paid_amount']?.toString() ?? '0') ?? 0;
      double discountSum = 0;

      final rows = <pw.TableRow>[];

      for (final raw in items) {
        final item = raw as Map<String, dynamic>;
        final name = safe(item['name']);
        final qty = double.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
        final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
        final discPct =
            double.tryParse(item['discount']?.toString() ?? '0') ?? 0;

        final subtotal = price * qty;
        final discAmt = subtotal * discPct / 100;
        final afterDisc = subtotal - discAmt;
        final vatAmt = afterDisc * 0.075;
        final totalRow = afterDisc + vatAmt;

        subTotal += subtotal;
        discountSum += discAmt;
        totalVat += vatAmt;
        grandTotal += totalRow;

        rows.add(
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(name, style: textStyle(size: 10)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  qty.toStringAsFixed(0),
                  textAlign: pw.TextAlign.center,
                  style: textStyle(),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  money(price),
                  textAlign: pw.TextAlign.right,
                  style: textStyle(),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  "${discPct.toStringAsFixed(0)}%",
                  textAlign: pw.TextAlign.center,
                  style: textStyle(),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  money(totalRow),
                  textAlign: pw.TextAlign.right,
                  style: textStyle(),
                ),
              ),
            ],
          ),
        );
      }

      final amountDue = (grandTotal - amountPaid).clamp(0.0, double.infinity);

      // ── Build PDF ────────────────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context ctx) => [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Pamtech Autoland Port Harcourt",
                      style: textStyle(size: 16, bold: true),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "info@pamtechautoland.com",
                      style: textStyle(size: 10),
                    ),
                    pw.Text("Port Harcourt", style: textStyle(size: 10)),
                  ],
                ),
                pw.Text(
                  DateFormat("dd/MM/yyyy, hh:mm a").format(DateTime.now()),
                  style: textStyle(size: 11),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Customer: ${safe(user.profile.name ?? 'N/A')}",
                    style: textStyle(size: 12),
                  ),
                  pw.Text(
                    "Phone: ${safe(user.profile.phone ?? 'N/A')}",
                    style: textStyle(size: 11),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Vehicle: $make $model",
                    style: textStyle(size: 12, bold: true),
                  ),
                  pw.Text(
                    "Plate: $plate    Year: $year    VIN: $vin",
                    style: textStyle(size: 11),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // Items Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: pw.FlexColumnWidth(4),
                1: pw.FixedColumnWidth(50),
                2: pw.FixedColumnWidth(80),
                3: pw.FixedColumnWidth(60),
                4: pw.FixedColumnWidth(90),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.blueGrey100,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        "Service / Description",
                        style: textStyle(bold: true),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Center(
                        child: pw.Text("Qty", style: textStyle(bold: true)),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Center(
                        child: pw.Text(
                          "Unit Price",
                          style: textStyle(bold: true),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Center(
                        child: pw.Text(
                          "Discount %",
                          style: textStyle(bold: true),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Center(
                        child: pw.Text("Amount", style: textStyle(bold: true)),
                      ),
                    ),
                  ],
                ),
                ...rows,
              ],
            ),

            pw.SizedBox(height: 16),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 240,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _totalRow(
                      "Sub Total",
                      money(subTotal),
                      textStyle: textStyle(),
                    ),
                    _totalRow(
                      "Discount",
                      "(${money(discountSum)})",
                      textStyle: textStyle(),
                    ),
                    _totalRow(
                      "VAT (7.5%)",
                      money(totalVat),
                      textStyle: textStyle(),
                    ),
                    pw.Divider(),
                    _totalRow(
                      "Grand Total",
                      money(grandTotal),
                      bold: true,
                      textStyle: textStyle(),
                    ),
                    pw.SizedBox(height: 8),
                    _totalRow(
                      "Amount Paid",
                      money(amountPaid),
                      textStyle: textStyle(),
                    ),
                    pw.Divider(),
                    _totalRow(
                      "Amount Due",
                      money(amountDue),
                      bold: true,
                      color: PdfColors.red,
                      textStyle: textStyle(),
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 24),

            // Disclaimer
            pw.Text(
              "DISCLAIMER:\n"
              "1. Estimates must be customer-approved within seven (7) days, else they will be removed from the company premises.\n"
              "2. Upon estimate approval, make a 70% down payment, or incur daily N1,000 demurrage charges after seven (7) days.\n"
              "3. If additional spares are required for repairs, a separate estimate will be issued.\n"
              "4. We have a non-refund policy which states that unused funds may only be applied to subsequent repairs.\n"
              "5. Accepting our estimate gives us permission to utilize your car in promotional digital and social media content.\n"
              "6. In rare cases where repairs cannot be completed due to lack of accurate information or cooperation from the customer, 70% of the total payment made will be refunded.\n"
              "Note that Diagnostic fees are non-refundable.",
              style: textStyle(size: 9),
            ),
            pw.SizedBox(height: 16),

            pw.Center(
              child: pw.Text(
                "FOR YOUR NEXT SERVICE APPOINTMENT PLEASE CALL: 08115004000 or send a message @pamtechgroup on social media.\nExtra Care for your car • Extra Mile for you",
                style: textStyle(size: 10, bold: true),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ),
      );

      // ── Save & open ───────────────────────────────────────
      final dir = await getApplicationDocumentsDirectory();
      final safeId = repair['id']?.toString() ?? 'unknown';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = "${dir.path}/repair_estimate_${safeId}_$timestamp.pdf";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      final openResult = await OpenFile.open(path);

      if (openResult.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "PDF saved, but could not open: ${openResult.message}",
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PDF generated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stack) {
      print("PDF generation failed: $e\n$stack");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create PDF: $e")));
    }
  }

  // Updated _totalRow helper to accept custom style
  pw.Widget _totalRow(
    String label,
    String value, {
    bool bold = false,
    PdfColor? color,
    required pw.TextStyle textStyle,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: textStyle.copyWith(
            fontWeight: bold ? pw.FontWeight.bold : null,
          ),
        ),
        pw.Text(
          value,
          style: textStyle.copyWith(
            fontWeight: bold ? pw.FontWeight.bold : null,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRepairs();
    });
  }

  Future<void> _fetchRepairs() async {
    try {
      final controller = Provider.of<RepairsController>(context, listen: false);
      await controller.fetchUserRepairs();
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleAcceptEstimateItem(int id) async {
    // print('heredfrgre      fdvrb');
    final confirmed = await CustomAlert.showAcceptEstimateItem(
      context: context,
      title: 'Accept Estimate?',
      message: 'Are you sure you want to accept this estimate?',
      confirmText: 'Yes',
      cancelText: 'Cancel',
    );

    if (confirmed == true) {
      print('heresjbfd khvbfjde');
      try {
        final repair = Provider.of<RepairsController>(context, listen: false);
        final data = {"id": id};
        print('data in handle accept');
        print(data);

        final success = await repair.acceptRepairEstimateItem(data);
        if (success) {
          // repair.updateEstimateItemStatus(itemId, id, 'approved');
          // await _fetchRepairDetails(id);
          await CustomAlert.showSuccess(
            context: context,
            message: 'Estimate Accepted',
          );
        } else {}
        // spinner by using the isLoading in the repair controller
        // make api call using the repair controler
        // update status of the particular repair so it shouws up in bottomsheet
        // show success custom alert
      } catch (err) {}
    }
  }

  Future<void> _handleRejectEstimateItem(int id) async {
    final confirmed = await CustomAlert.showRejectEstimateItem(
      context: context,
      title: 'Reject Estimate?',
      message: 'Are you sure you want to reject this estimate?',
      confirmText: 'Yes',
      cancelText: 'Cancel',
    );

    if (confirmed == true) {
      try {
        final repair = Provider.of<RepairsController>(context, listen: false);
        final data = {"id": id};
        final success = await repair.rejectRepairEstimateItem(data);
      } catch (err) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RepairsController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Repairs"),
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
                : controller.repairsData.isEmpty
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
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        itemCount: controller.repairsData.length,
                        itemBuilder: (context, index) {
                          final repair = controller.repairsData[index]
                              as Map<String, dynamic>;

                          final vehicle =
                              repair['vehicle'] as Map<String, dynamic>? ?? {};
                          final vehicleName =
                              '${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}'
                                  .trim();
                          final plateNumber =
                              vehicle['plate_number'] as String?;

                          return Card(
                            color: Colors.white,
                            elevation: .1,
                            margin: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 22, 14, 22),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/car.png',
                                            height: 52,
                                            width: 52,
                                          ),
                                          const SizedBox(width: 4),
                                          Column(
                                            children: [
                                              Text(
                                                repair['vehicle']['make'] !=
                                                            null &&
                                                        repair['vehicle']
                                                                ['model'] !=
                                                            null
                                                    ? '$vehicleName'
                                                    : 'Repair #${index + 1}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  letterSpacing: -1,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 48,
                                                ),
                                                child: Text(
                                                  repair['vehicle']
                                                          ['plate_number'] ??
                                                      'Date: —',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade700,
                                                    letterSpacing: -1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            repair['status'] as String?,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          (repair['status'] as String?)
                                                      ?.isNotEmpty ==
                                                  true
                                              ? (repair['status'] as String)[0]
                                                      .toUpperCase() +
                                                  (repair['status'] as String)
                                                      .substring(1)
                                                      .toLowerCase()
                                              : 'Status: —',
                                          style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: -0.8,
                                            color: _getStatusTextColor(
                                              repair['status'] as String?,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Arrival Date',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -1,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _formatDate(repair['arrival_date']),
                                            style: const TextStyle(
                                              color: Color(0xFF5C5C5C),
                                              letterSpacing: -0.5,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/services_image.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${_getServiceCount(repair)} Services',
                                            style: const TextStyle(
                                              letterSpacing: -1,
                                              color: Color(0xFF5C5C5C),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          repair['description'] ??
                                              'No description available',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF5C5C5C),
                                            letterSpacing: -0.5,
                                            fontSize: 14,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if ((repair['status'] as String?)
                                                  ?.toLowerCase() ==
                                              'completed') {
                                            _repairEstimateBottomSheet(repair);
                                          } else {
                                            _repairEstimateBottomSheet(repair);
                                          }
                                        },
                                        child: Text(
                                          (repair['status'] as String?)
                                                      ?.toLowerCase() ==
                                                  'completed'
                                              ? 'View Invoice'
                                              : 'View Estimate',
                                          style: TextStyle(
                                            letterSpacing: -1,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: (repair['status'] as String?)
                                                        ?.toLowerCase() ==
                                                    'completed'
                                                ? Colors.red
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _repairDetailsBottomSheet(repair);
                                        },
                                        child: const Text(
                                          'View Details',
                                          style: TextStyle(
                                            letterSpacing: -1,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppPallete.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }

  void _repairEstimateBottomSheet(dynamic repair) async {
    final repairId = repair['id'] as int?;
    print('repair Id');
    print(repairId);
    if (repairId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid repair ID')));
      return;
    }

    await _fetchRepairDetails(repairId);

    final controller = Provider.of<RepairsController>(context, listen: false);
    final freshRepair = controller.currentRepairDetails;

    if (freshRepair == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No details available')));
      return;
    }

    bool applyVatGlobally = freshRepair['status'] == 'labour';
    final estimateItems = freshRepair['estimate_items'] as List<dynamic>? ?? [];

    String vatRateStr = '7.50';
    if (freshRepair['estimate'] is List &&
        (freshRepair['estimate'] as List).isNotEmpty) {
      final estimates = freshRepair['estimate'] as List;
      final latest = estimates.cast<Map>().reduce(
            (a, b) => (a['id'] as num? ?? 0) > (b['id'] as num? ?? 0) ? a : b,
          );
      vatRateStr = latest['vat'] as String? ?? '7.50';
    }
    final vatRate = double.tryParse(vatRateStr) ?? 7.5;

    double grandTotal = 0.0;
    double summarySubTotal = 0.0;
    double summaryDiscount = 0.0;
    for (final itemRaw in estimateItems) {
      final item = itemRaw as Map<String, dynamic>;
      final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
      final quantity =
          double.tryParse(item['quantity']?.toString() ?? '1') ?? 1.0;
      final discountPct =
          double.tryParse(item['discount']?.toString() ?? '0') ?? 0.0;

      double subtotal = price * quantity;
      double discountAmount = subtotal * (discountPct / 100);
      double afterDiscount = subtotal - discountAmount;
      summarySubTotal += subtotal;
      summaryDiscount += discountAmount;

      double finalItemValue = afterDiscount;
      if (applyVatGlobally) {
        final vatAmount = afterDiscount * (vatRate / 100);
        finalItemValue += vatAmount;
      }
      grandTotal += finalItemValue;
    }

    // ───────────────────────────────────────────────
    // 2. Updated Format Helper for Commas
    // ───────────────────────────────────────────────
    String formatMoney(double value) {
      // NumberFormat('#,##0.##') adds commas and up to 2 decimal places
      final formatter = NumberFormat('#,##0.00', 'en_US');
      String formatted = formatter.format(value);

      // Removes .00 if it's a whole number, keeping it clean
      return formatted.endsWith('.00')
          ? formatted.substring(0, formatted.length - 3)
          : formatted;
    }

    final totalDisplay = formatMoney(grandTotal);

    double paidAmountValue = 0.0;
    if (freshRepair['estimate'] is List &&
        (freshRepair['estimate'] as List).isNotEmpty) {
      final estimates = freshRepair['estimate'] as List;
      final latest = estimates.cast<Map>().reduce(
            (a, b) => (a['id'] as num? ?? 0) > (b['id'] as num? ?? 0) ? a : b,
          );

      final paidStr = latest['paid_amount'] as String? ?? '0';
      paidAmountValue = double.tryParse(paidStr) ?? 0.0;
    } else {
      final paidRaw = freshRepair['paid_amount']?.toString() ?? '0';
      paidAmountValue = double.tryParse(paidRaw) ?? 0.0;
    }

    final paidDisplay = formatMoney(paidAmountValue);
    final balanceValue = (grandTotal - paidAmountValue).clamp(
      0.0,
      double.infinity,
    );
    final balanceDisplay = formatMoney(balanceValue);
    const summaryVatRate = 5.0;
    final summaryVatValue =
        (summarySubTotal - summaryDiscount) * (summaryVatRate / 100);
    final summaryAmountDueValue = ((summarySubTotal - summaryDiscount) +
            summaryVatValue -
            paidAmountValue)
        .clamp(0.0, double.infinity);
    final summarySubTotalDisplay = formatMoney(summarySubTotal);
    final summaryDiscountDisplay = formatMoney(summaryDiscount);
    final summaryVatDisplay = formatMoney(summaryVatValue);
    final summaryAmountDueDisplay = formatMoney(summaryAmountDueValue);

    // ───────────────────────────────────────────────
    // UI Section
    // ───────────────────────────────────────────────
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFFF9FAFC),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Total Estimate Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(109, 198, 218, 246),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Estimate',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF5C5C5C),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₦$totalDisplay', // Simplified: totalDisplay already handles 0
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                    letterSpacing: -1,
                                    wordSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Amount Paid & Balance Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoBox(
                                  label: 'Amount Paid',
                                  value: '₦$paidDisplay',
                                  color: const Color(
                                    0xFFE45C4C,
                                  ).withOpacity(0.15),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoBox(
                                  label: 'Estimated Balance',
                                  value: '₦$balanceDisplay',
                                  color: const Color(
                                    0xFF0D898D,
                                  ).withOpacity(0.15),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 45),
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/divider.png',
                              height: 10,
                              width: 300,
                            ),
                          ),

                          // ... Rest of your services UI ...
                          const SizedBox(height: 40),

                          // ───────────────────────────────────────────────
                          // Estimate Breakdown Section
                          // ───────────────────────────────────────────────
                          if (estimateItems.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF002050),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Estimate Breakdown',
                                style: TextStyle(
                                  letterSpacing: -1,
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: estimateItems.map((itemRaw) {
                                  final item = itemRaw as Map<String, dynamic>;

                                  final name =
                                      item['name'] as String? ?? 'Unknown Item';
                                  final priceStr =
                                      item['price'] as String? ?? '0';
                                  final qtyStr =
                                      item['quantity'] as String? ?? '1';
                                  final discountStr =
                                      item['discount'] as String? ?? '0';

                                  final price =
                                      double.tryParse(priceStr) ?? 0.0;
                                  final quantity =
                                      double.tryParse(qtyStr) ?? 1.0;
                                  final discountPct =
                                      double.tryParse(discountStr) ?? 0.0;

                                  final subtotal = price * quantity;
                                  final discountAmount =
                                      subtotal * (discountPct / 100);
                                  final afterDiscount =
                                      subtotal - discountAmount;

                                  double finalAmount = afterDiscount;
                                  if (applyVatGlobally) {
                                    final vatAmount =
                                        afterDiscount * (vatRate / 100);
                                    finalAmount += vatAmount;
                                  }

                                  // Formatting
                                  final qtyText = quantity.toStringAsFixed(0);
                                  final unitPriceText = formatMoney(price);
                                  final subtotalText = formatMoney(subtotal);
                                  final discountText = discountPct > 0
                                      ? '${discountPct.toStringAsFixed(0)}% (₦${formatMoney(discountAmount)})'
                                      : 'None';
                                  final finalAmountText = formatMoney(
                                    finalAmount,
                                  );

                                  return Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Description label + Item name
                                          const Text(
                                            'Description',
                                            style: TextStyle(
                                              letterSpacing: -1,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            name,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              letterSpacing: -0.5,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xDD959595),
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          // Qty
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Qty',
                                                style: TextStyle(
                                                  letterSpacing: -1,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                qtyText,
                                                style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xDD5C5C5C),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // Discount %
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Discount %',
                                                style: TextStyle(
                                                  letterSpacing: -1,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                discountPct > 0
                                                    ? '${discountPct.toStringAsFixed(0)}%'
                                                    : '0%',
                                                style: TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: discountPct > 0
                                                      ? Colors.red.shade700
                                                      : Color(0xDD5C5C5C),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (discountPct > 0) ...[
                                            const SizedBox(height: 4),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '(-₦${formatMoney(discountAmount)})',
                                                style: TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 12),

                                          // Unit Price
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Unit price',
                                                style: TextStyle(
                                                  letterSpacing: -1,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                '₦$unitPriceText',
                                                style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xDD5C5C5C),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // Final Amount
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Amount',
                                                style: TextStyle(
                                                  letterSpacing: -1,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                '₦$finalAmountText',
                                                style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF0D898D),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 24),

                                          // ───────────────────────────────────────────────
                                          // Status / Action Buttons – pushed to the RIGHT
                                          // ───────────────────────────────────────────────
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Builder(
                                              builder: (context) {
                                                final status =
                                                    (item['status'] as String?)
                                                            ?.toLowerCase() ??
                                                        'pending';

                                                if (status == 'approved') {
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 28,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF00C247,
                                                      ).withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Accepted',
                                                      style: TextStyle(
                                                        letterSpacing: -1,
                                                        color: Color(
                                                          0xFF00C247,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  );
                                                } else if (status ==
                                                    'rejected') {
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 28,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.red.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Rejected',
                                                      style: TextStyle(
                                                        letterSpacing: -1,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  // Pending – smaller, compact buttons
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Accept – small filled green
                                                      SizedBox(
                                                        height: 36,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            _handleAcceptEstimateItem(
                                                              item['id'],
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                              0xFF00C247,
                                                            ),
                                                            foregroundColor:
                                                                Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                            ),
                                                            // minimumSize: const Size(90, 36),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                6,
                                                              ),
                                                            ),
                                                            elevation: 0,
                                                          ),
                                                          child: const Text(
                                                            'Accept',
                                                            style: TextStyle(
                                                              letterSpacing: -1,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      // Reject – small outlined red
                                                      SizedBox(
                                                        height: 36,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            _handleRejectEstimateItem(
                                                              item['id'],
                                                            );
                                                            // TODO: Call your reject API here
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                              0xFFFF0000,
                                                            ),
                                                            foregroundColor:
                                                                Colors.white,
                                                            // side: BorderSide(color: Colors.red.shade700, width: 1.2),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 14,
                                                            ),
                                                            // minimumSize: const Size(90, 36),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                6,
                                                              ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Reject',
                                                            style: TextStyle(
                                                              letterSpacing: -1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x6CDFE8F9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Terms and Conditions',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF002050),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Please pay within 15 days from the date of invoice, overdue interest @ 14% will be charged on delayed payments.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF5C5C5C),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -1,
                                    wordSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Please quote invoice number when remitting funds.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF5C5C5C),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -1,
                                    wordSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),
                          Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Qty
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Sub Total',
                                        style: TextStyle(
                                          letterSpacing: -1,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '₦$summarySubTotalDisplay',
                                        style: const TextStyle(
                                          letterSpacing: -0.5,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xDD5C5C5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Discount %
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Discount',
                                        style: TextStyle(
                                          letterSpacing: -1,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '-₦$summaryDiscountDisplay',
                                        style: const TextStyle(
                                          letterSpacing: -0.5,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xDD5C5C5C),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Unit Price
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Vat(5%)',
                                        style: TextStyle(
                                          letterSpacing: -1,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '₦$summaryVatDisplay',
                                        style: const TextStyle(
                                          letterSpacing: -0.5,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xDD5C5C5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity, // full width
                                    height: 1, // thickness of the line
                                    color: Colors.black,
                                  ),

                                  const SizedBox(height: 12),

                                  // Unit Price
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Amount Due',
                                        style: TextStyle(
                                          letterSpacing: -1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xDD002050),
                                        ),
                                      ),
                                      Text(
                                        '₦$summaryAmountDueDisplay',
                                        style: const TextStyle(
                                          letterSpacing: -0.5,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xDD5C5C5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity, // full width
                                    height: 1, // thickness of the line
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),

                          Container(
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () {
                                // Add your download logic here
                                print('Download tapped');
                                // Add spinner to depiect action
                                // Perform download
                                _handlePdfDownload();
                              },
                              child: Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: -1,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF134CA2),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFF134CA2),
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
            );
          },
        );
      },
    );
  }

  // Helper widget to keep the Row clean
  Widget _buildInfoBox({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5C5C5C),
              fontWeight: FontWeight.w400,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: -1,
              wordSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _repairDetailsBottomSheet(dynamic repair) {
    final vehicle = repair['vehicle'] as Map<String, dynamic>? ?? {};
    final vehicleName =
        '${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}'.trim();
    final plateNumber = vehicle['plate_number'] as String?;

    final services = repair['services'] as List<dynamic>? ?? [];
    final serviceNames = services
        .map(
          (s) =>
              (s as Map<String, dynamic>)['name'] as String? ??
              'Unknown Service',
        )
        .toList();

    final status = (repair['status'] as String?)?.toLowerCase() ?? '';
    double progress = 0.0;
    Color progressColor = const Color(0xFF5486D1);

    if (status == 'pending') {
      progress = 0.25;
    } else if (status.contains('progress') || status == 'in-progress') {
      progress = 0.50;
    } else if (status == 'completed') {
      progress = 0.75;
    } else if (status == 'delivered') {
      progress = 1.0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8CFD8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Vehicle + Status ──────────────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/car.png',
                                    height: 52,
                                    width: 52,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicleName.isNotEmpty
                                            ? vehicleName
                                            : 'Repair error',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        plateNumber ?? 'Plate: —',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    repair['status'] as String?,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  (repair['status'] as String?)?.isNotEmpty ==
                                          true
                                      ? () {
                                          final s = (repair['status'] as String)
                                              .toLowerCase()
                                              .trim();
                                          if (s == 'inprogress' ||
                                              s == 'in-progress')
                                            return 'In-Progress';
                                          return s[0].toUpperCase() +
                                              s.substring(1);
                                        }()
                                      : 'Status: —',
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: -0.8,
                                    color: _getStatusTextColor(
                                      repair['status'] as String?,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── Arrival Date + Expected Delivery ─────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Arrival Date',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -1,
                                      wordSpacing: -.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDate(repair['arrival_date']),
                                    style: const TextStyle(
                                      color: Color(0xFF5C5C5C),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Expected Delivery',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -1,
                                      wordSpacing: -.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDate(
                                      repair['pickup_date'] ??
                                          repair['completion_date'],
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF5C5C5C),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── Garage Section ───────────────────────────────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/pamtech_logo.png',
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Pamtech Autoland PH',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'No 3 Edward Woherem Avenue opp Ruby Center behind Winner\'s Chapel Rumuodomanya Port Harcourt.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        letterSpacing: -0.3,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/divider.png',
                              height: 10,
                              width: 300,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Description ──────────────────────────────────────────────
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.8,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            repair['description'] ?? 'No description available',
                            style: const TextStyle(
                              color: Color(0xFF5C5C5C),
                              fontSize: 14,
                              height: 1.4,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Services Box ─────────────────────────────────────────────
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFD4D5DF),
                                width: .5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Service Required',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: -0.8,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (serviceNames.isEmpty)
                                  const Text(
                                    'No services listed',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  )
                                else
                                  ...serviceNames.map(
                                    (name) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF5C5C5C),
                                                letterSpacing: -1,
                                                wordSpacing: -.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Repair Progress ──────────────────────────────────────────
                          const Text(
                            'Repair Progress',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: -1,
                              wordSpacing: -.5,
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final barWidth = constraints.maxWidth;
                                  final pointerPosition =
                                      progress * barWidth - 12;

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFBAC8FF),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 8,
                                        width: barWidth * progress,
                                        decoration: BoxDecoration(
                                          color: progressColor,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: pointerPosition.clamp(
                                          -12.0,
                                          barWidth - 12,
                                        ),
                                        top: -6,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppPallete.primaryColor,
                                            border: Border.all(
                                              color: progressColor,
                                              width: 3,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                  0.15,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/divider.png',
                              height: 10,
                              width: 300,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Activity Section ─────────────────────────────────────────
                          const Text(
                            'Activity',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: -0.8,
                            ),
                          ),

                          const SizedBox(height: 8),
                          Column(children: _buildActivityTimeline(repair)),

                          const SizedBox(height: 32),

                          // ── Reviews Section ──────────────────────────────────────────
                          ..._buildReviewsSection(repair),

                          const SizedBox(height: 24),
                        ],
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
  }

  // ── Reviews Section Builder ─────────────────────────────────────────────────
  List<Widget> _buildReviewsSection(dynamic repair) {
    final reviews = repair['reviews'] as List<dynamic>? ?? [];

    return [
      Align(
        alignment: Alignment.center,
        child: Image.asset('assets/images/divider.png', height: 10, width: 300),
      ),
      const SizedBox(height: 24),
      const Text(
        'Reviews',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: -0.8,
        ),
      ),
      const SizedBox(height: 8),
      if (reviews.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'No reviews yet',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        )
      else
        ...reviews.map((review) => _buildReviewItem(review)).toList(),
    ];
  }

  // ── Single Review Item ──────────────────────────────────────────────────────
  Widget _buildReviewItem(dynamic review) {
    final reviewMap = review as Map<String, dynamic>;
    final rating = int.tryParse(reviewMap['rating']?.toString() ?? '0') ?? 0;
    final comment = reviewMap['comment'] as String? ?? '';
    final createdAt = reviewMap['created_at'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: date on left, stars on right ───────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Date
              Text(
                _formatActivityDate(createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  letterSpacing: -0.3,
                ),
              ),

              // Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (starIndex) {
                  final isFilled = starIndex < rating;
                  return Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: isFilled
                        ? const Color(0xFFFFC107) // yellow/amber for filled
                        : const Color(0xFFE0E0E0), // light grey for unfilled
                  );
                }),
              ),
            ],
          ),

          // ── Comment ──────────────────────────────────────────────────────
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              comment,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3D3D3D),
                height: 1.45,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'just now';

    try {
      final date = DateTime.parse(rawDate).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds}s ago';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '${years}y ago';
      }
    } catch (e) {
      return 'just now';
    }
  }

  List<Widget> _buildActivityTimeline(dynamic repair) {
    final statusDescriptions =
        repair['status_descriptions'] as List<dynamic>? ?? [];

    final sortedActivities = statusDescriptions
      ..sort((a, b) {
        final dateA = DateTime.parse(a['created_at'] as String);
        final dateB = DateTime.parse(b['created_at'] as String);
        return dateB.compareTo(dateA);
      });

    if (sortedActivities.isEmpty) {
      return [
        const Text(
          'No activity recorded yet',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ];
    }

    return List.generate(sortedActivities.length, (index) {
      final activity = sortedActivities[index] as Map<String, dynamic>;
      print('checking your activity');
      print(print);
      final isLast = index == sortedActivities.length - 1;

      final status = (activity['status'] as String?)?.toLowerCase() ?? '';
      final circleColor = _getStatusColor(status);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Image.asset('assets/images/activity_dot.png', width: 18),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  // padding: const EdgeInsets.only(left: 62),
                  width: 1,
                  height: 40,
                  color: const Color(0xFF6B757E).withOpacity(0.2),

                  // circleColor.withOpacity(0.4),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['description'] ?? 'Activity recorded',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                      letterSpacing: -1,
                      wordSpacing: -1),
                ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    _formatActivityDate(activity['created_at']),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  String _formatActivityDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'just now';

    try {
      final date = DateTime.parse(rawDate).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds}s ago';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '${years}y ago';
      }
    } catch (e) {
      return 'just now';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchRepairDetails(int repairId) async {
    try {
      final controller = Provider.of<RepairsController>(context, listen: false);

      setState(() {
        isLoading = true; // or use a separate loading flag for details
      });

      final success = await controller.fetchRepairDetails(repairId);

      if (success && controller.currentRepairDetails != null) {
        // Optional: Show success message or refresh UI
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Repair details loaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              controller.errorMessage ?? 'Failed to load repair details',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error in _fetchRepairDetails: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor(String? status) {
    print(status);
    final lowerStatus = status?.toLowerCase() ?? '';

    if (lowerStatus == 'completed') {
      return const Color(0xFF00C247).withOpacity(0.1);
    } else if (lowerStatus.contains('progress') ||
        lowerStatus == 'inprogress') {
      return const Color(0xFF004CE8).withOpacity(0.1);
    } else if (lowerStatus.contains('progress') || lowerStatus == 'pending') {
      return Colors.red;
    }

    return Colors.grey.shade300;
  }

  // String __getStatusText(String? status) {}

  Color _getStatusTextColor(String? status) {
    final lowerStatus = status?.toLowerCase() ?? '';

    if (lowerStatus == 'completed') {
      return const Color(0xFF00C247);
    } else if (lowerStatus.contains('progress') ||
        lowerStatus == 'in-progress') {
      return const Color(0xFF004CE8);
    } else if (lowerStatus.contains('pending') || lowerStatus == 'pending') {
      return Colors.white;
    }

    return Colors.grey.shade300;
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'Date: —';

    try {
      final parts = rawDate.split('-');
      if (parts.length != 3) return 'Date: —';

      final day = parts[2].padLeft(2, '0');
      final month = parts[1].padLeft(2, '0');
      final year = parts[0];

      return '$day/$month/$year';
    } catch (e) {
      return 'Date: —';
    }
  }

  int _getServiceCount(dynamic repair) {
    final serviceId = repair['service_id'];
    if (serviceId == null) return 0;

    if (serviceId is List) {
      return serviceId.length;
    } else if (serviceId is String) {
      return serviceId.split(',').where((id) => id.trim().isNotEmpty).length;
    }

    return 0;
  }
}
