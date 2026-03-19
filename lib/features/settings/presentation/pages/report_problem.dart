// import 'dart:math' as math;
// import 'package:autotech/core/theme/app_pallete.dart';
// import 'package:autotech/features/settings/controller/settings_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ReportProblem extends StatefulWidget {
//   const ReportProblem({super.key});

//   @override
//   State<ReportProblem> createState() => _ReportProblemState();
// }

// class _ReportProblemState extends State<ReportProblem> {
//   String? _selectedIssueType;
//   final TextEditingController _descriptionController = TextEditingController();

//   final List<String> _issueTypes = [
//     'Payment',
//     'Security',
//     'Repairs',
//     'Booking',
//   ];

//   Future<void> _handleReportProblem() async {
//     try {
//       final settings = Provider.of<SettingsController>(context, listen: false);
//       final success = await settings.reportProblem(
//         subject: _selectedIssueType,
//         message: _descriptionController.text.trim()
//       );
//     } catch (err) {}
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 90,
//         leading: IconButton(
//           icon: Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Theme.of(context).brightness == Brightness.light
//                   ? const Color.fromARGB(255, 223, 228, 239).withOpacity(0.9)
//                   : Colors.grey.shade800.withOpacity(0.4),
//             ),
//             child: Center(
//               child: Transform.rotate(
//                 angle: math.pi / 2,
//                 child: Image.asset(
//                   'assets/images/backbutton.png',
//                   height: 22,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Report a Problem',
//           style: TextStyle(
//             letterSpacing: -0.5,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 3,
//         shadowColor: Colors.black.withOpacity(0.2),
//         surfaceTintColor: Colors.transparent,
//         scrolledUnderElevation: 3,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 32),
//               // Introductory text
//               Text(
//                 'Having an issue? Let us know and our team will look into it as soon as possible.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   wordSpacing: -1,
//                   letterSpacing: -1,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),

//               const SizedBox(height: 32),

//               DropdownButtonFormField<String>(
//                 value: _selectedIssueType,
//                 hint: const Text(
//                   'Issue Type',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 13,
//                     wordSpacing: -1,
//                     letterSpacing: -1,
//                   ),
//                 ),
//                 items: _issueTypes.map((String type) {
//                   return DropdownMenuItem<String>(
//                     value: type,
//                     child: Text(type),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedIssueType = newValue;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0xFFF7FAFF),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: const BorderSide(
//                       color: Colors.blueAccent,
//                       width: 1.5,
//                     ),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                 ),
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down_rounded,
//                   color: Colors.grey,
//                 ),
//                 dropdownColor: Colors.white,
//                 elevation: 2,
//                 isExpanded: true,
//                 borderRadius: BorderRadius.circular(12),
//               ),

//               const SizedBox(height: 22),

//               TextField(
//                 controller: _descriptionController,
//                 maxLines: 6,
//                 minLines: 4,
//                 keyboardType: TextInputType.multiline,
//                 textInputAction: TextInputAction.newline,
//                 decoration: InputDecoration(
//                   hintText: 'Message',
//                   hintStyle: const TextStyle(
//                     color: Colors.grey,
//                     fontSize: 13,
//                     wordSpacing: -1,
//                     letterSpacing: -1,
//                   ),
//                   filled: true,
//                   fillColor: const Color(0xFFF7FAFF), // light blue background
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: const BorderSide(
//                       color: Colors.blueAccent,
//                       width: 1.5,
//                     ),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 22),

//               // Submit Button (example)
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _handleReportProblem();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppPallete.primaryColor,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: const Text(
//                     'Send',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: -1,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:math' as math;
import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportProblem extends StatefulWidget {
  const ReportProblem({super.key});

  @override
  State<ReportProblem> createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  String? _selectedIssueType;
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _issueTypes = [
    'Payment',
    'Security',
    'Repairs',
    'Booking',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleReportProblem() async {
    try {
      if (!_formKey.currentState!.validate()) return;

      final settings = Provider.of<SettingsController>(context, listen: false);
      final success = await settings.reportProblem(
        subject: _selectedIssueType ?? 'Other',
        message: _descriptionController.text.trim(),
      );

      print('success');
      print(success);

      if (!mounted) return;

      if (success) {
        await CustomAlert.showSuccess(
          context: context,
          message: 'Thank you! Your report has been submitted.',
          // buttonText: '',
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to report problem');
      }
    } catch (e) {
       await CustomAlert.showError(
        context: context,
        message:
            'Failed to report problem',
        buttonText: 'Try Again',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, controller, child) {
        return Scaffold(
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
                        ).withOpacity(0.9)
                      : Colors.grey.shade800.withOpacity(0.4),
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
              'Report a Problem',
              style: TextStyle(
                letterSpacing: -0.5,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.2),
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          'Having an issue? Let us know and our team will look into it as soon as possible.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 32),

                        DropdownButtonFormField<String>(
                          value: _selectedIssueType,
                          validator: (value) =>
                              value == null ? 'Please select an issue type' : null,
                          hint: const Text('Issue Type'),
                          items: _issueTypes.map((type) {
                            return DropdownMenuItem(value: type, child: Text(type));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedIssueType = value),
                          decoration: _inputDecoration('Issue Type'),
                          isExpanded: true,
                        ),

                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 6,
                          minLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().length < 10) {
                              return 'Please describe the problem (min 10 characters)';
                            }
                            return null;
                          },
                          decoration: _inputDecoration('Describe the issue...'),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : _handleReportProblem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 1.5,
                            ),
                            child: controller.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.4,
                                    ),
                                  )
                                : const Text(
                                    'Submit Report',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 4,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF7FAFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.3),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    );
  }
}
