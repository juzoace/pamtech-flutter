

import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/auth/controllers/auth_controller.dart';
import 'package:autotech/features/auth/presentation/pages/create_new_password.dart';
import 'package:autotech/features/auth/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool get _isOtpComplete {
    return _otpControllers.every((c) => c.text.length == 1);
  }

  String _getOtpCode() {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _handleOtp() async {
    try {
      final code = _getOtpCode();
      final auth = Provider.of<AuthController>(context, listen: false);
      final success = await auth.verifyOtp(otp: code, email: widget.email);

      if (!mounted) return;

      if (success) {
        await CustomAlert.showSuccess(
        context: context,
        message: 'Otp confirmed!',
        buttonText: 'Okay',
      );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
       await CustomAlert.showError(
        context: context,
        message: 'Otp confirmation failed',
        buttonText: 'Try Again',
      );
    }

    // Uncomment and adjust when ready
    /*
    final auth = Provider.of<AuthController>(context, listen: false);
    final success = await auth.verifyOtp(otp: code);
    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CreateNewPasswordPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP'), backgroundColor: Colors.red),
      );
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        final isLoading = auth.isLoading;
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        height: 550,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/login_header.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 500),
                            Text(
                              'OTP Code',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "A code has been sent to your email to verify your account",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // OTP Fields
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                enabled: !isLoading,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: const Color(
                                    0xFFE8F0FE,
                                  ).withOpacity(0.55),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1 && index < 3) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                  setState(
                                    () {},
                                  ); // ← crucial: rebuild on every change
                                },
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Send Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            // onPressed: isLoading || !_isOtpComplete ? null : _handleOtp,
                            onPressed: isLoading 
                                ? null
                                : _handleOtp,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: AppPallete.primaryColor
                                  .withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 2,
                            ),
                            child: 
                            
                            // isLoading
                            //     ? const SizedBox(
                            //         height: 24,
                            //         width: 24,
                            //         child: CircularProgressIndicator(
                            //           color: Colors.white,
                            //           strokeWidth: 3,
                            //         ),
                            //       )
                            //     : 
                                
                                const Text(
                                    'Send',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Resend
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "I didn't receive any code? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF616161),
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      // TODO: resend OTP
                                    },
                              child: const Text(
                                'Resend',
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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                // Loading overlay
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
          ),
        );
      },
    );
  }
}
