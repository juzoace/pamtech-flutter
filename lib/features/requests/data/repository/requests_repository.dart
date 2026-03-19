import 'dart:developer';
import 'package:autotech/features/requests/domain/services/requests_service_interface.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/exception/api_error_handler.dart';
import 'package:autotech/data/model/api_response.dart';

class RequestsRepository implements RequestsServiceInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  RequestsRepository(
      {required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponseModel> fetchRequests() {
    // TODO: implement fetchRequests
    throw UnimplementedError();
  }

  @override
  Future<ApiResponseModel> fetchRequestMechanicServices() async {
    try {
      final response = await dioClient!.post(
        AppConstants.requestMechanicFetchServicesUri,
      );

      if (response.statusCode == 200) {
        final payload = response.data;
        if (payload is Map<String, dynamic>) {
          return ApiResponseModel.withSuccess(
            payload,
            dataValue: payload['data'],
          );
        }

        return ApiResponseModel.withSuccess(
          {
            'success': true,
            'message': 'Record fetched successfully.',
            'data': payload,
          },
          dataValue: payload,
        );
      }

      return ApiResponseModel.withError(
        'Server responded with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      log('DioException fetching request mechanic services: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      return ApiResponseModel.withError(errorMsg);
    } catch (e, stack) {
      log('Unexpected error fetching request mechanic services',
          error: e, stackTrace: stack);
      return ApiResponseModel.withError(e.toString());
    }
  }
}
