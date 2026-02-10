import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/interface/repo_interface.dart';

abstract class AuthRepoInterface<T> implements RepositoryInterface {
  Future<ApiResponseModel> registration(Map<String, dynamic> body);
  Future<ApiResponseModel> verifyOtp(String otp, String email);
  Future<ApiResponseModel> googleSignIn(String email, String google_id, String name);
  Future<ApiResponseModel> login(String email, String password);
  Future<ApiResponseModel> forgotPassword(String email);
  Future<ApiResponseModel> createNewPassword(String new_password, String email);

}
