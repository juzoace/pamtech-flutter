import 'package:autotech/core/error/failures.dart';
import 'package:autotech/core/common/entities/user.dart';
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/exception/api_error_handler.dart';
import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepoInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponseModel> registration(Map<String, dynamic> register) async {
    try {
      print('got hereeeee');
      print('got hereeeee');

      Response response = await dioClient!.post(
        AppConstants.registrationUri,
        data: register,
      );
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> verifyOtp(String otp, String email) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.verifyOtpUri,
        data: {'otp': otp, 'email': email},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> googleSignIn(
    String email,
    String google_id,
    String name,
  ) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.googleSignInUri,
        data: {'email': email, 'google_id': google_id, 'name': name},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> login(String email, String password) async {
    print('inside auth repository login method');
    print(email);
    print(password);

    try {
      final response = await dioClient!.post(
        AppConstants.loginUri,
        data: {'email': email, 'password': password},
      );

      print('Login raw response: ${response.data}');

      // Better to check statusCode + success field
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
          final bearerToken = data['data']?['bearer_token'] as String?;
          print('checking token');
          print(bearerToken);

          if (bearerToken != null && bearerToken.isNotEmpty) {
            // Save token right here (recommended place)
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(AppConstants.userLoginToken, bearerToken);

            // Also update Dio header immediately
            dioClient?.updateHeader(bearerToken, null);
          }

          return ApiResponseModel.withSuccess(response);
        } else {
          return ApiResponseModel.withError(data['message'] ?? 'Login failed');
        }
      } else {
        return ApiResponseModel.withError(
          'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Login error: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> forgotPassword(String email) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.forgotPasswordUri,
        data: {'email': email},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> createNewPassword(
    String new_password,
    String email,
  ) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.createNewPasswordUri,
        data: {'new_password': new_password, 'email': email},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
