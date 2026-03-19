// import 'dart:developer';
// import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
// import 'package:autotech/data/model/api_response.dart';
// import 'package:autotech/features/settings/domain/services/settings_service_interface.dart';
// import 'package:autotech/util/app_constants.dart';
// import 'package:dio/dio.dart';

// class SettingsRepository implements SettingsServiceInterface {
//   final DioClient? dioClient;
//   SettingsRepository({required this.dioClient});

//   @override
//   Future<ApiResponseModel> reportProblem() async {
//     try {
//       final response = await dioClient!.post(AppConstants.reportIssueUri);
//     } on DioException catch (e) {
//     } catch (e) {}
//   }
// }

import 'dart:developer';
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/features/settings/domain/services/settings_service_interface.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository implements SettingsServiceInterface {
  final DioClient dioClient;
  final SharedPreferences? sharedPreferences;

  SettingsRepository({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<bool> reportProblem({
    required String subject,
    required String message,
  }) async {
    try {
      print('before call');

      final response = await dioClient.post(
        AppConstants.reportIssueUri,
        data: {'subject': subject, 'message': message},
      );
      print('after call');
      

      // Adjust according to your real API response structure
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        // Example: return data['success'] == true;
        return true;
      }

      return false;
    } on DioException catch (e) {
      log('DioException in reportProblem: ${e.message}', error: e.error);
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Status code: ${e.response?.statusCode}');
      }
      return false;
    } catch (e, stack) {
      log('Unexpected error in reportProblem', error: e, stackTrace: stack);
      return false;
    }
  }
}
