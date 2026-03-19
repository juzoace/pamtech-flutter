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
      print('print before api call');
      final response = await dioClient!.post(
        AppConstants.fetchUserRepairUri, // we'll define this constant next
        // You can add query params if needed, e.g. ?page=1&limit=20
        // queryParameters: {'status': 'pending'},
      );

      print('print after api call');

      // log('fetchUserRepairs raw response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
          print('ApiResponseModel.withSuccess(response);');
          print(ApiResponseModel.withSuccess(response));
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

  @override
  Future<ApiResponseModel> fetchRepairDetails(int repairId) async {
    var data = {"id": repairId};

    try {
      print('Fetching repair details for ID: $repairId');

      final response = await dioClient!.post(
        '${AppConstants.repairBaseUri}',
        data: data,
      );

      print('Repair details response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
          print('Repair details fetched successfully');
          return ApiResponseModel.withSuccess(response);
        } else {
          return ApiResponseModel.withError(
            data['message'] ?? 'Failed to fetch repair details',
          );
        }
      } else {
        return ApiResponseModel.withError(
          'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      log('Dio error fetching repair details: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    } catch (e) {
      log('Unexpected error fetching repair details: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> acceptRepairEstimate(dynamic data) async {
    try {
      final response = await dioClient!.post(
        '${AppConstants.acceptEstimateUri}',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
          // print(' details fetched successfully');
          return ApiResponseModel.withSuccess(response);
        } else {
          return ApiResponseModel.withError(
            data['message'] ?? 'Failed to accept estimate',
          );
        }
      } else {
        return ApiResponseModel.withError(
          'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (err) {
      log('Dio error accepting repair estimate: $err');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(err));
    } catch (e) {
      log('Unexpected error accepting repair estimate: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> rejectRepairEstimate(dynamic data) async {
    try {
      final response = await dioClient!.post(
        '${AppConstants.rejectEstimateUri}',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
          // print(' details fetched successfully');
          return ApiResponseModel.withSuccess(response);
        } else {
          return ApiResponseModel.withError(
            data['message'] ?? 'Failed to reject estimate',
          );
        }
      } else {
        return ApiResponseModel.withError(
          'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (err) {
      log('Dio error accepting repair estimate: $err');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(err));
    } catch (e) {
      log('Unexpected error rejecting repair estimate: $e');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
