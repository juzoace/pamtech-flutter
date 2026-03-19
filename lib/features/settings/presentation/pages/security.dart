import 'dart:math' as math;
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/exception/api_error_handler.dart';
import 'package:autotech/features/auth/presentation/pages/login.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/profile/controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autotech/di_container.dart' as di;

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateNewPassword() async {
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmNewPasswordController.text.trim();

    // ───── Client-side validation ─────
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      await CustomAlert.showError(
        context: context,
        message: 'All fields are required',
        buttonText: 'Okay',
      );
      return;
    }

    if (newPass.length < 8) {
      await CustomAlert.showError(
        context: context,
        message: 'New password must be at least 8 characters',
        buttonText: 'Okay',
      );
      return;
    }

    if (newPass != confirmPass) {
      await CustomAlert.showError(
        context: context,
        message: 'New password and confirmation do not match',
        buttonText: 'Okay',
      );
      return;
    }

    if (newPass == oldPass) {
      await CustomAlert.showError(
        context: context,
        message: 'New password must be different from old password',
        buttonText: 'Okay',
      );
      return;
    }

    // ───── Call API ─────
    final profile = Provider.of<ProfileController>(context, listen: false);

    // Start loading
    profile.setLoading(true);

    try {
      final success = await profile.updatePassword(
        old_password: oldPass,
        new_password: newPass,
      );

      if (!mounted) return;

      if (success) {
        await CustomAlert.showSuccess(
          context: context,
          message: 'Password updated successfully! Please log in again.',
          buttonText: 'Okay',
        );

        // Logout cleanup (same as your logout flow)
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(AppConstants.userLoginToken);

        // ignore: use_build_context_synchronously
        final dioClient = di.sl<DioClient>();
        dioClient.updateHeader(null, null); // clear token

        // Replace entire stack → no way back to Security page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } else {
        // Show backend-provided error or fallback
        await CustomAlert.showError(
          context: context,
          message:
              profile.errorMessage ??
              'Failed to update password. Please try again.',
          buttonText: 'Try Again',
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;

      final msg =
          ApiErrorHandler.getMessage(e) ??
          'Network error. Please check your connection.';
      await CustomAlert.showError(
        context: context,
        message: msg,
        buttonText: 'Okay',
      );
    } catch (e, stack) {
      debugPrint('Password change crash: $e');
      debugPrint('Stack: $stack');

      if (!mounted) return;

      await CustomAlert.showError(
        context: context,
        message: 'Something went wrong. Please try again later.',
        buttonText: 'Okay',
      );
    } finally {
      // Always stop loading – no matter what
      profile.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profile, child) {
        final isLoading = profile.isLoading;

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
              'Security',
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
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      'Enter your old password and create a new one. The new password must be different from the current one.',
                      style: TextStyle(
                        letterSpacing: -0.5,
                        color: Color(0xFF5C5C5C),
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Old Password
                    TextField(
                      controller: _oldPasswordController,
                      enabled: !isLoading,
                      obscureText: _obscureOldPassword,
                      decoration: InputDecoration(
                        hintText: 'Enter old password',
                        filled: true,
                        fillColor: Color(0xFFF7FAFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureOldPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () => setState(
                            () => _obscureOldPassword = !_obscureOldPassword,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // New Password
                    TextField(
                      controller: _newPasswordController,
                      enabled: !isLoading,
                      obscureText: _obscureNewPassword,
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        filled: true,
                        fillColor: Color(0xFFF7FAFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Confirm New Password
                    TextField(
                      controller: _confirmNewPasswordController,
                      enabled: !isLoading,
                      obscureText: _obscureConfirmNewPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        filled: true,
                        fillColor: Color(0xFFF7FAFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirmNewPassword =
                                !_obscureConfirmNewPassword,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleCreateNewPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          isLoading ? 'Updating...' : 'Update Password',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                            wordSpacing: -1
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Full-screen loading overlay
              if (isLoading)
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
}
