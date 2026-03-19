import 'package:autotech/core/error/failures.dart';
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/exception/api_error_handler.dart';
import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/profile/domain/services/profile_service_interface.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository implements ProfileServiceInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponseModel> fetchUserProfile() async {
    try {
      print('Fetching user profile...');

      final response = await dioClient!.post(
        AppConstants.fetchUserProfile,
        // Optional: add headers or query params if your API needs them
        // options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Profile fetch status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
          print('User profile fetched successfully');
          return ApiResponseModel.withSuccess(response);
        } else {
          return ApiResponseModel.withError(
            data['message'] ?? 'Failed to fetch user profile',
          );
        }
      } else {
        return ApiResponseModel.withError(
          'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      log('Dio error fetching user profile: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    } catch (e) {
      log('Unexpected error fetching user profile: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> uploadAvatar(FormData formData) async {
    try {
      final response = await dioClient!.post(
        AppConstants.uploadUserAvatar,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponseModel.withSuccess(response);
      } else {
        return ApiResponseModel.withError(
          response.data['message'] ?? 'Failed to upload avatar',
        );
      }
    } on DioException catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    } catch (e) {
      log('Unexpected error uploading avatar: $e');
      return ApiResponseModel.withError(e.toString());
    }
  }

  @override
  Future<ApiResponseModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.post(
        AppConstants.updateProfileUri,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponseModel.withSuccess(response);
      } else {
        return ApiResponseModel.withError(
          response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    } catch (e) {
      log('Unexpected error updating profile: $e');
      return ApiResponseModel.withError(e.toString());
    }
  }

  @override
  Future<ApiResponseModel> updatePassword(Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.post(
        AppConstants.updatePasswordUri,
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponseModel.withSuccess(response);
      } else {
        return ApiResponseModel.withError(
          response.data['message'] ?? 'Failed to update password',
        );
      }
    } on DioException catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    } catch (e) {
      log('Unexpected error updating password: $e');
      return ApiResponseModel.withError(e.toString());
    }
  }
}
