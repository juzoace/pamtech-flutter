import 'package:autotech/data/model/api_response.dart';
import 'package:dio/dio.dart';

abstract class ProfileServiceInterface {
  Future<ApiResponseModel> fetchUserProfile();
  Future<ApiResponseModel> uploadAvatar(FormData formData);
  Future<ApiResponseModel> updateProfile(Map<String, dynamic> data);
  Future<ApiResponseModel> updatePassword(Map<String, dynamic> data);

  // You can add more profile-related methods later as needed, e.g.:
  // Future<ApiResponseModel> updateProfile(Map<String, dynamic> data);
  // Future<ApiResponseModel> uploadAvatar(String filePath);
  // Future<ApiResponseModel> changePassword(Map<String, dynamic> data);
  // Future<ApiResponseModel> deleteAccount();
}
