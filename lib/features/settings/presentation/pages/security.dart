import 'dart:math' as math;

import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obsecureConfirmNewPassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateNewPassword() async {}

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        final isLoading = auth.isLoading;
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
            elevation: 3, // subtle but visible
            shadowColor: Colors.black.withOpacity(0.2),
            surfaceTintColor: const Color.fromARGB(0, 251, 250, 250),
            scrolledUnderElevation: 3,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    SizedBox(height: 24),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      'Enter your old password so to create a new password and the new password must be different from the current passowrd.',
                      style: TextStyle(
                        letterSpacing: -1,
                        color: Color(0xFF5C5C5C),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        // horizontal: 2,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _newPasswordController,
                            enabled: !isLoading,
                            obscureText: _obscureNewPassword,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Color(0xFF898A8C),
                                fontSize: 8,
                                wordSpacing: -2,
                                letterSpacing: -2,
                              ),
                              hintText: 'Enter your Password',
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
                                vertical: 10,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscureNewPassword =
                                        !_obscureNewPassword,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Divider(
                              color: const Color(0xFFDEE7F8),
                              thickness: 1,
                            ),
                          ),

                          const SizedBox(height: 30),
                          TextField(
                            controller: _newPasswordController,
                            enabled: !isLoading,
                            obscureText: _obscureNewPassword,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Color(0xFF898A8C),
                                fontSize: 8,
                                wordSpacing: -2,
                                letterSpacing: -2,
                              ),
                              hintText: 'Enter new Password',
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
                                vertical: 10,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscureNewPassword =
                                        !_obscureNewPassword,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _confirmNewPasswordController,
                            enabled: !isLoading,
                            obscureText: _obsecureConfirmNewPassword,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Color(0xFF898A8C),
                                fontSize: 8,
                                wordSpacing: -2,
                                letterSpacing: -2,
                              ),
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
                                vertical: 10,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obsecureConfirmNewPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obsecureConfirmNewPassword =
                                        !_obsecureConfirmNewPassword,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              // onPressed: _isLoading ? null : _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPallete.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 2,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : _handleCreateNewPassword,
                              child: Text(
                                'Create Password',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
