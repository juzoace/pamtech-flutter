import 'dart:developer';
import 'package:autotech/features/auth/domain/models/register_model.dart';
import 'package:autotech/features/auth/domain/services/auth_service_interface.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool _registrationSuccess = false;
  bool get registrationSuccess => _registrationSuccess;
  bool _verifyOtpSuccess = false;
  bool get verifyOtpSuccess => _verifyOtpSuccess;
  bool _googleSignInSuccess = false;
  bool get googleSignInSuccess => _googleSignInSuccess;
  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;
  bool _forgotPasswordSuccess = false;
  bool get forgotPasswordSuccess => _forgotPasswordSuccess;
  bool _createNewPasswordSuccess = false;
  bool get createNewPasswordSuccess => _createNewPasswordSuccess;

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _registrationSuccess = false;
    notifyListeners(); // ← important: UI updates immediately

    try {
      final model = RegisterModel(
        name: name,
        email: email,
        phone: phone,
        password: password,
        // add referral_id here later if you fetch it from storage
        // referralId: await _getReferralId(),
      );

      print('got here');

      final success = await authServiceInterface.register(model);

      if (success) {
        _registrationSuccess = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'Registration failed. Please try again.';
      }

      return success;
    } catch (e, stack) {
      log('Registration error: $e', error: e, stackTrace: stack);
      _errorMessage = e.toString().contains('Exception')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners(); // ← UI updates with final state
    }
  }

  Future<bool> verifyOtp({required String otp, required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    _verifyOtpSuccess = false;
    notifyListeners(); // ← important: UI updates immediately

    try {
      final success = await authServiceInterface.verifyOtp(
        otp: otp,
        email: email,
      );

      if (success) {
        _verifyOtpSuccess = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'OTP verification failed. Please try again.';
      }
      return success;
    } catch (e, stack) {
      log('OTP verification error: $e', error: e, stackTrace: stack);
      _errorMessage = e.toString().contains('Exception')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners(); // ← UI updates with final state
    }
  }

  Future<bool> googleSignIn(account) async {
    _isLoading = true;
    _errorMessage = null;
    _googleSignInSuccess = false;
    notifyListeners();

    try {
      final success = await authServiceInterface.googleSignIn(
        email: account.email,
        google_id: account.id,
        name: account.displayName,
      );

      if (success) {
        _googleSignInSuccess = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'Google Sign-In failed. Please try again.';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Google Sign-In error: ${e.toString()}';
      // notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    _loginSuccess = false;
    notifyListeners();

    try {
      final success = await authServiceInterface.login(
        email: email,
        password: password,
      );
      print('checking response in authcontroller file');
      print(success);

      if (success) {
        _loginSuccess = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'Login failed. Please check your credentials.';
      }
      return success;
    } catch (e, stack) {
      log('Login error: $e', error: e, stackTrace: stack);
      _errorMessage = e.toString().contains('Exception')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    _forgotPasswordSuccess = false;
    notifyListeners();
    try {
      print('checking email');
      print(email);
      final success = await authServiceInterface.forgotPassword(email: email);

      if (success) {
        _forgotPasswordSuccess = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'Forgot password failed. Please try again.';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Forgot Password error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createNewPassword({
    required String new_password,
    required String email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _createNewPasswordSuccess = false;
    notifyListeners();
    try {
      final success = await authServiceInterface.createNewPassword(
        new_password: new_password,
        email: email,
      );

      if (success) {
        _createNewPasswordSuccess = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'Create new password failed. Please try again.';
      }
      return success;

    } catch (e) {
      _errorMessage = e.toString().contains('Exception')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners(); // ← UI updates with final state
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Optional: clear success flag after navigation or use case
  void reset() {
    _registrationSuccess = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
