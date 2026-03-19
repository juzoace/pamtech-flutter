import 'dart:io';
import 'dart:math' as math;
import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/profile/controllers/profile_controller.dart';
import 'package:autotech/features/profile/domain/entities/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool isLoading = false;

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  // Gender selection
  String? _selectedGender;
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Prefer not to say',
  ];
  DateTime? _selectedDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProfileController>(context, listen: false);
      controller.fetchProfile().then((_) {
        _populateFields(controller.profile);
      });
    });
  }

  void _populateFields(Profile profile) {
    setState(() {
      _fullNameController.text =
          profile.name != 'Guest User' ? profile.name : '';
      _emailController.text =
          profile.email != 'guest@example.com' ? profile.email : '';
      _phoneController.text = profile.phone != 'N/A' ? profile.phone : '';

      // Gender
      _selectedGender = _normalizeGender(profile.gender);

      // DOB - parse safely
      if (profile.dob != null &&
          profile.dob!.isNotEmpty &&
          profile.dob != 'N/A') {
        try {
          final date = DateFormat(
            'yyyy-MM-dd',
          ).parse(profile.dob!.split(' ').first);
          _selectedDate = date;
          _dobController.text = DateFormat('dd MMM yyyy').format(date);
        } catch (e) {
          _dobController.text = '';
        }
      } else {
        _dobController.text = '';
      }
    });
  }

  String _normalizeGender(String? rawGender) {
    final normalized = (rawGender ?? '').trim().toLowerCase();
    if (normalized == 'male') {
      return 'Male';
    }
    if (normalized == 'female') {
      return 'Female';
    }
    if (normalized == 'prefer not to say' ||
        normalized == 'prefer not to say.' ||
        normalized == 'none' ||
        normalized == 'other') {
      return 'Prefer not to say';
    }
    return 'Prefer not to say';
  }

  Future<void> _pickAndUploadAvatar() async {
    final XFile? xFile = await showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppPallete.primaryColor),
              title: const Text(
                "Take Photo",
                style: TextStyle(letterSpacing: -1, wordSpacing: -1),
              ),
              onTap: () async {
                final file = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (file != null) Navigator.pop(context, file);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: AppPallete.primaryColor,
              ),
              title: const Text(
                "Choose from Gallery",
                style: TextStyle(letterSpacing: -1, wordSpacing: -1),
              ),
              onTap: () async {
                final file = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (file != null) Navigator.pop(context, file);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (xFile == null) return;

    final file = File(xFile.path);

    setState(() {
      _selectedImage = file;
      _isUploading = true;
    });

    try {
      final controller = Provider.of<ProfileController>(context, listen: false);
      final success = await controller.uploadAvatar(file);

      if (success && mounted) {
        await CustomAlert.showSuccess(
          context: context,
          message: 'Profile picture updated successfully',
          buttonText: 'Okay',
        );

        await controller.fetchProfile();

        // Clear local image AFTER fetching so the new network URL takes over
        if (mounted) {
          setState(() {
            _selectedImage = null;
          });
        }
      } else if (mounted) {
        await CustomAlert.showError(
          context: context,
          message: 'Failed to upload profile picture',
          buttonText: 'Try Again',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

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
            colorScheme: const ColorScheme.light(
              primary: AppPallete.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppPallete.primaryColor,
              ),
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
        child: Consumer<ProfileController>(
          builder: (context, controller, child) {
            // Error state (only shown when not loading and there's an error)
            if (controller.errorMessage != null && !controller.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.fetchProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // ✅ Stack so the overlay sits on top of the full body
            return Stack(
              children: [
                // Always-visible scrollable form
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 28,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),

                      // Avatar with edit icon
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor:
                                  AppPallete.primaryColor.withOpacity(0.15),
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!) as ImageProvider
                                  : NetworkImage(
                                      controller.profile.avatar.isNotEmpty &&
                                              !controller.profile.avatar
                                                  .contains('example.com')
                                          ? controller.profile.avatar
                                          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(controller.profile.name)}&background=134CA2&color=fff&size=128',
                                    ),
                            ),

                            // Edit icon - bottom right
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isUploading || isLoading
                                    ? null
                                    : _pickAndUploadAvatar,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppPallete.primaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: _isUploading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 0.2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/edit_icon.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Divider(
                          color: const Color(0xFFDEE7F8),
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Full Name
                      _buildTextField(
                        controller: _fullNameController,
                        label: '',
                        hint: 'Enter your full name',
                        initialValue: controller.profile.name != 'Guest User'
                            ? controller.profile.name
                            : '',
                      ),
                      const SizedBox(height: 20),

                      // Email (read-only)
                      _buildTextField(
                        controller: _emailController,
                        label: '',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        initialValue:
                            controller.profile.email != 'guest@example.com'
                                ? controller.profile.email
                                : '',
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),

                      // Phone
                      _buildTextField(
                        controller: _phoneController,
                        label: '',
                        hint: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                        initialValue: controller.profile.phone != 'N/A'
                            ? controller.profile.phone
                            : '',
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
                              : () async {
                                  if (_fullNameController.text.trim().isEmpty ||
                                      _phoneController.text.trim().isEmpty ||
                                      _selectedGender == null ||
                                      _selectedDate == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please fill all required fields",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => isLoading = true);

                                  final controller =
                                      Provider.of<ProfileController>(
                                    context,
                                    listen: false,
                                  );

                                  final success =
                                      await controller.updateProfile(
                                    name: _fullNameController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                    dob: DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDate!),
                                    gender: _selectedGender!,
                                  );

                                  setState(() => isLoading = false);

                                  if (success && mounted) {
                                    await CustomAlert.showSuccess(
                                      context: context,
                                      message: 'Profile updated successfully',
                                      buttonText: 'Okay',
                                    );

                                    await controller.fetchProfile();

                                    if (mounted) {
                                      setState(() => _selectedImage = null);
                                    }
                                  } else if (mounted) {
                                    await CustomAlert.showError(
                                      context: context,
                                      message: 'Profile update failed',
                                      buttonText: 'Try Again',
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Update Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // ✅ Full-screen overlay loader — covers everything like login page
                if (controller.isLoading || isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppPallete.primaryColor,
                        strokeWidth: 4,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String initialValue = '',
    bool readOnly = false,
    Color? fillColor,
    TextStyle? textStyle,
  }) {
    if (controller.text.isEmpty && initialValue.isNotEmpty) {
      controller.text = initialValue;
    }

    return TextField(
      controller: controller,
      readOnly: readOnly,
      enabled: !isLoading && !readOnly,
      keyboardType: keyboardType,
      style: textStyle ??
          TextStyle(
            letterSpacing: -1,
            wordSpacing: 1,
            color: readOnly ? Colors.black54 : null,
          ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF898A8C), fontSize: 14),
        hintText: hint,
        filled: true,
        fillColor: fillColor ?? const Color(0xFFF7FAFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: isLoading ? null : () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          style: const TextStyle(letterSpacing: -1, wordSpacing: -1),
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
              borderSide: const BorderSide(
                color: Colors.blueAccent,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
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
    return DropdownButtonFormField<String>(
      value: _genderOptions.contains(_selectedGender) ? _selectedGender : null,
      hint: const Text(
        'Select your gender',
        style: TextStyle(color: Color(0xFF898A8C), fontSize: 14),
      ),
      items: _genderOptions.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(
            gender,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              letterSpacing: -1,
            ),
          ),
        );
      }).toList(),
      onChanged: isLoading
          ? null
          : (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
      decoration: InputDecoration(
        labelText: '',
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey,
        size: 24,
      ),
      dropdownColor: Colors.white,
      elevation: 2,
      isExpanded: true,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
