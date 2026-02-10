import 'package:autotech/features/auth/domain/models/register_model.dart';
import 'package:autotech/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:autotech/features/auth/domain/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  AuthRepoInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future registration(Map<String, dynamic> body) {
    return authRepoInterface.registration(body);
  }

  @override
  Future<bool> register(RegisterModel model) {
    return authRepoInterface.registration(model.toJson()).then((response) => response.isSuccess ?? false);
  }

  @override
  Future<bool> verifyOtp({required String otp, required String email}) {
    return authRepoInterface.verifyOtp(otp, email).then((response) => response.isSuccess ?? false);
  }

  @override
  Future<bool> googleSignIn({required String email, required String google_id, required String name}) {
    return authRepoInterface.googleSignIn(email, google_id, name).then((response) => response.isSuccess ?? false);
  }

  @override
  Future<bool> login({required String email, required String password}) {
    return authRepoInterface.login(email, password).then((response) => response.isSuccess ?? false);
  }

  @override
  Future<bool> forgotPassword({required String email}) {
    return authRepoInterface.forgotPassword(email).then((response) => response.isSuccess ?? false);
  }

  @override
  Future<bool> createNewPassword({required String new_password, required String email}) {
    return authRepoInterface.createNewPassword(new_password, email).then((response) => response.isSuccess ?? false);
  }
}
