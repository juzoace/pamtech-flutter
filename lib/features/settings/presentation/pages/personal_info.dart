import 'dart:math' as math;

import 'package:autotech/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool isLoading = false;

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController     = TextEditingController();
  final _phoneController     = TextEditingController();
  final _dobController       = TextEditingController();

  // Gender selection
  String? _selectedGender;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  DateTime? _selectedDate;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppPallete.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppPallete.primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  ? const Color.fromARGB(255, 223, 228, 239).withOpacity(0.9)
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
          'Edit Profile',
          style: TextStyle(
            wordSpacing: -2.0,
            letterSpacing: -0.5,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: const Color.fromARGB(0, 251, 250, 250),
        scrolledUnderElevation: 3,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: AppPallete.primaryColor.withOpacity(0.15),
                  child: Icon(Icons.person, size: 40, color: AppPallete.primaryColor),
                ),
              ),
              const SizedBox(height: 60),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Divider(color: const Color(0xFFDEE7F8), thickness: 1),
              ),

              const SizedBox(height: 40),

              // Full Name
              _buildTextField(
                controller: _fullNameController,
                label: '',
                hint: 'Enter your full name',
              ),
              const SizedBox(height: 20),

              // Email
              _buildTextField(
                controller: _emailController,
                label: '',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Phone
              _buildTextField(
                controller: _phoneController,
                label: '',
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Date of Birth
              _buildDateField(),
              const SizedBox(height: 20),

              // Gender Dropdown
              _buildGenderField(),
              const SizedBox(height: 40),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() => isLoading = true);
                          // TODO: save profile logic
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) setState(() => isLoading = false);
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -1),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: !isLoading,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF898A8C), fontSize: 14),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7FAFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: isLoading ? null : () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: _dobController,
          readOnly: true,
          enabled: !isLoading,
          decoration: InputDecoration(
            labelText: '',
            labelStyle: const TextStyle(color: Color(0xFF898A8C), fontSize: 14),
            hintText: 'Select your date of birth',
            filled: true,
            fillColor: const Color(0xFFF7FAFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/images/calendar.png',
                height: 24,
                width: 24,
                color: const Color(0xFF898A8C),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Select Gender',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ..._genderOptions.map(
                          (gender) => ListTile(
                            title: Text(gender),
                            onTap: () {
                              setState(() => _selectedGender = gender);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              );
            },
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: _selectedGender ?? ''),
          readOnly: true,
          enabled: !isLoading,
          decoration: InputDecoration(
            labelText: '',
            labelStyle: const TextStyle(color: Color(0xFF898A8C), fontSize: 14),
            hintText: 'Select your gender',
            filled: true,
            fillColor: const Color(0xFFF7FAFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/images/gendar.png',          // ← your gender icon here
                height: 24,
                width: 24,
                color: const Color(0xFF898A8C),
              ),
            ),
          ),
        ),
      ),
    );
  }
}