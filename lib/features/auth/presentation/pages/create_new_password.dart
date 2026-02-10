import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/auth/controllers/auth_controller.dart';
import 'package:autotech/features/auth/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewPasswordPage extends StatefulWidget {
  final String email;
  const CreateNewPasswordPage({super.key, required this.email});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obsecureConfirmNewPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateNewPassword() async {
    if (_newPasswordController.text.trim() !=
        _confirmNewPasswordController.text.trim()) {
          await CustomAlert.showError(
        context: context,
        message: 'Passwords do not match',
        buttonText: 'Try Again',
      );
      return;
    }

    try {
      final auth = Provider.of<AuthController>(context, listen: false);
      final success = await auth.createNewPassword(
        new_password: _newPasswordController.text.trim(),
        email: widget.email,
      );

      if (!mounted) return;

      if (success) {
        await CustomAlert.showSuccess(
          context: context,
          message: 'Password update successful!',
          buttonText: 'Okay',
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      await CustomAlert.showError(
        context: context,
        message: 'Password update failed',
        buttonText: 'Try Again',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        final isLoading = auth.isLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 500,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login_header.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 450),
                          const Text(
                            'Create a new password',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      // .symmetric(horizontal: 8),
                      child: Text(
                        "Your new password must be different from previously used passwords",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF1A1A1A),
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
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
                              hintText: 'Create a new password',
                              filled: true,
                              fillColor: const Color(
                                0xFFE8F0FE,
                              ).withOpacity(0.55),
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
                              hintText: 'Confirm new password',
                              filled: true,
                              fillColor: const Color(
                                0xFFE8F0FE,
                              ).withOpacity(0.55),
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

                              // () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const NotificationPage(),
                              //     ),
                              //   );
                              // },
                              child: Text(
                                'Send',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
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
