import 'package:autotech/features/auth/domain/models/register_model.dart';

abstract class AuthServiceInterface {
  /// Registers a new user.
  /// Returns `true` on success, throws Exception on failure (with meaningful message).
  Future<bool> register(RegisterModel model);

  Future<bool> verifyOtp({
    required String otp,
    required String email,
  });

 Future<bool> googleSignIn({
  required String email,
  required String google_id,
  required String name,
 });

 Future<bool> login({
    required String email,
    required String password,
  });

  Future<bool> forgotPassword({
    required String email,
  });

  Future<bool> createNewPassword({
    required String new_password,
    required String email,
  });
}