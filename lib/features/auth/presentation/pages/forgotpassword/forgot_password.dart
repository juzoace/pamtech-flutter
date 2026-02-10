import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/features/auth/controllers/auth_controller.dart';
import 'package:autotech/features/auth/presentation/pages/forgotpassword/otp.dart';
import 'package:flutter/material.dart';
import 'package:autotech/features/auth/presentation/pages/login.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    // Implement forgot password logic here
    try {
      // Example: Call your AuthController's forgot password method
      final auth = Provider.of<AuthController>(
        context,
        listen: false,
      );
      final success = await auth.forgotPassword(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        await CustomAlert.showSuccess(
          context: context,
          message: 'Forgot password instructions sent!',
          buttonText: 'Okay',
        );

        // Set token in storage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(email: _emailController.text.trim()),
          ),
        );
      } else {
        throw Exception('Forgot password failed');
      }
    } catch (e) {
      // Handle error
      await CustomAlert.showError(
        context: context,
        message:
            'Forgot password failed.\nPlease check your details and try again.',
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
                    // Top Header Section
                    Container(
                      height: 600,
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
                          const SizedBox(height: 500),
                          const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Don't worry, We'll send you reset instructions",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF1A1A1A),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _emailController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your email address',
                              filled: true,
                              fillColor: const Color(
                                0xFFE8F0FE,
                              ).withOpacity(0.55),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ), // light border
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
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : _handleForgotPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPallete.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Send',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "I remember my password...",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(97, 97, 97, 1),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets
                                        .zero, // ← removes default padding
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: AppPallete.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
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
