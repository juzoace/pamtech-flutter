import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/profile/domain/services/profile_service_interface.dart';
import 'package:dio/dio.dart';

class ProfileService implements ProfileServiceInterface {
  final ProfileServiceInterface profileRepoInterface;

  ProfileService({required this.profileRepoInterface});

  @override
  Future<ApiResponseModel> fetchUserProfile() {
    return profileRepoInterface.fetchUserProfile();
  }

  @override
  Future<ApiResponseModel> uploadAvatar(FormData formData) {
    return profileRepoInterface.uploadAvatar(formData);
  }

  @override
  Future<ApiResponseModel> updateProfile(Map<String, dynamic> data) {
    return profileRepoInterface.updateProfile(data);
  }

  @override
  Future<ApiResponseModel> updatePassword(Map<String, dynamic> data) {
    return profileRepoInterface.updatePassword(data);
  }
}
