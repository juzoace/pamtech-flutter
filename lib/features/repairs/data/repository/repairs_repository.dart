import 'package:autotech/core/error/failures.dart'; // if you use it elsewhere
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/exception/api_error_handler.dart';
import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service_interface.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class RepairsRepository implements RepairsServiceInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  RepairsRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponseModel> fetchUserRepairs() async {
    try {
      final response = await dioClient!.get(
        AppConstants.fetchUserRepairUri, // we'll define this constant next
        // You can add query params if needed, e.g. ?page=1&limit=20
        // queryParameters: {'status': 'pending'},
      );

      log('fetchUserRepairs raw response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
          // Optionally process/transform data here if needed
          return ApiResponseModel.withSuccess(response);
        } else {
          return ApiResponseModel.withError(
            data['message'] ?? 'Failed to fetch repairs',
          );
        }
      } else {
        return ApiResponseModel.withError(
          'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      log('Dio error fetching repairs: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    } catch (e) {
      log('Unexpected error fetching repairs: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Add more methods when needed, e.g.:
  /*
  @override
  Future<ApiResponseModel> createRepairRequest(Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.post(
        AppConstants.createRepairUri,
        data: data,
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
  */
}