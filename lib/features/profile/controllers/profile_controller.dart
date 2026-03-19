import 'dart:io';
import 'package:autotech/core/error/failures.dart';
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/exception/api_error_handler.dart';
import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/profile/data/models/profile.dart';
import 'package:autotech/features/profile/domain/entities/profile.dart';
import 'package:autotech/features/profile/domain/services/profile_service_interface.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ProfileController with ChangeNotifier {
  final ProfileServiceInterface profileServiceInterface;

  ProfileController({required this.profileServiceInterface});

  Profile _profile = const Profile(
    id: 0,
    name: 'Guest User',
    email: 'guest@example.com',
    phone: 'N/A',
    preference: null,
    description: null,
    gender: null,
    country: 'Unknown',
    state: null,
    city: null,
    dob: null,
    address: null,
    referralId: 'N/A',
    referralBy: 'N/A',
    role: 'guest',
    garagePosition: null,
    garageId: null,
    status: 'inactive',
    registerStatus: 'new',
    allowPush: '0',
    terms: '0',
    expoToken: null,
    deviceId: null,
    platform: 'unknown',
    googleId: null,
    emailVerifiedAt: null,
    avatar: 'https://example.com/default-avatar.png',
    createdAt: 'N/A',
    updatedAt: 'N/A',
  );

  Profile get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _updatePasswordSuccess;
  String? get updatePasswordSuccess => _updatePasswordSuccess;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('Fetching user profile...');

      final apiResponse = await profileServiceInterface.fetchUserProfile();

      if (apiResponse.isSuccess) {
        final responseData =
            apiResponse.response?.data as Map<String, dynamic>?;

        if (responseData != null && responseData['success'] == true) {
          final userJson = _extractProfileJson(responseData['data']);

          if (userJson != null) {
            final profileModel = ProfileModel.fromJson(userJson);
            _profile = profileModel; // since ProfileModel extends Profile
            print('Profile loaded successfully: ${_profile.name}');
          } else {
            _errorMessage = 'No profile data found';
          }
        } else {
          _errorMessage = responseData?['message'] ?? 'Failed to fetch profile';
        }
      } else {
        _errorMessage = 'Network or server error';
      }
    } catch (e) {
      log('Unexpected error in fetchProfile: $e');
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? _extractProfileJson(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nestedUser = data['user'];
      if (nestedUser is Map<String, dynamic> && nestedUser.isNotEmpty) {
        return nestedUser;
      }
      if (data.isNotEmpty) {
        return data;
      }
      return null;
    }

    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is Map<String, dynamic>) {
        return first;
      }
    }

    return null;
  }

  void setProfile(Profile profile) {
    _profile = profile;
    _errorMessage = null;
    notifyListeners();
  }

  void clearProfile() {
    setProfile(
      const Profile(
        id: 0,
        name: 'Guest User',
        email: 'guest@example.com',
        phone: 'N/A',
        preference: null,
        description: null,
        gender: null,
        country: 'Unknown',
        state: null,
        city: null,
        dob: null,
        address: null,
        referralId: 'N/A',
        referralBy: 'N/A',
        role: 'guest',
        garagePosition: null,
        garageId: null,
        status: 'inactive',
        registerStatus: 'new',
        allowPush: '0',
        terms: '0',
        expoToken: null,
        deviceId: null,
        platform: 'unknown',
        googleId: null,
        emailVerifiedAt: null,
        avatar: 'https://example.com/default-avatar.png',
        createdAt: 'N/A',
        updatedAt: 'N/A',
      ),
    );
  }

  Future<bool> uploadAvatar(File imageFile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await profileServiceInterface.uploadAvatar(formData);

      if (response.isSuccess) {
        // You can parse new avatar URL here if the API returns it
        // For now we just refresh the whole profile
        await fetchProfile();
        return true;
      } else {
        _errorMessage = "Failed to upload avatar";
        return false;
      }
    } catch (e) {
      _errorMessage = "Error uploading avatar: $e";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String dob,
    required String gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = {'name': name, 'phone': phone, 'dob': dob, 'gender': gender};

      final response = await profileServiceInterface.updateProfile(data);

      if (response.isSuccess) {
        await fetchProfile(); // refresh local data
        return true;
      } else {
        _errorMessage = "Failed to update profile";
        return false;
      }
    } catch (e) {
      _errorMessage = "Error updating profile: $e";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePassword({
    required String old_password,
    required String new_password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _updatePasswordSuccess = null; // clear previous success message if any
    notifyListeners();

    try {
      final data = {
        "old_password": old_password.trim(),
        "new_password": new_password.trim(),
      };

      final response = await profileServiceInterface.updatePassword(data);

      if (response.isSuccess) {
        _updatePasswordSuccess = "Password updated successfully!";
        return true;
      } else {
        _errorMessage = "Failed to update password. Please try again.";
        return false;
      }
    } on DioException catch (e) {
      // Handle network/auth errors more gracefully
      _errorMessage = ApiErrorHandler.getMessage(e) ??
          "Network error. Please check your connection.";
      return false;
    } catch (e, stackTrace) {
      // Catch everything else (JSON parse, timeout, etc.)
      debugPrint('Password update unexpected error: $e');
      debugPrint('Stack: $stackTrace');
      _errorMessage = "An unexpected error occurred. Please try again later.";
      return false;
    } finally {
      // Always reset loading — this prevents the infinite spinner bug
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
