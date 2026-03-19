// features/dashboard/data/repositories/home_repository.dart
// (or wherever you keep your repositories)

import 'dart:developer';

import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/exception/api_error_handler.dart';
import 'package:autotech/features/dashboard/domain/services/home_service_interface.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository implements HomeServiceInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  HomeRepository({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<Map<String, dynamic>> fetchNotifications() async {
    try {
      final response = await dioClient!.post(
        AppConstants.notificationsUri,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch notifications');
        }
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException fetching notifications: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error fetching notifications',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchUnreadNotifications() async {
    try {
      final response = await dioClient!.post(
        AppConstants.unreadNotificationsUri,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException fetching unread notifications: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error fetching unread notifications',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> markNotificationAsRead(
      String notificationId) async {
    try {
      final response = await dioClient!.post(
        AppConstants.markNotificationAsReadUri,
        data: {'notification_id': notificationId},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException marking notification as read: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error marking notification as read',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchVehicles() async {
    try {
      final response = await dioClient!.post(
        AppConstants.vehiclesUri,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch vehicles');
        }
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException fetching vehicles: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error fetching vehicles', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createVehicle(Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.post(
        AppConstants.createVehicleUri,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final payload = response.data;
        if (payload is Map<String, dynamic>) {
          return payload;
        }
        return {
          'success': true,
          'message': 'Vehicle created successfully',
          'data': payload,
        };
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException creating vehicle: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error creating vehicle', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchGarages() async {
    try {
      final response = await dioClient!.post(
        AppConstants.garagesUri,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch garages');
        }
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException fetching garages: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error fetching garages', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCarDocuments() async {
    try {
      final response = await dioClient!.post(
        AppConstants.carDocumentsUri,
      );

      if (response.statusCode == 200) {
        final payload = response.data;
        if (payload == null) {
          return {
            'success': true,
            'message': 'No car documents found',
            'data': <dynamic>[],
          };
        }

        if (payload is Map<String, dynamic>) {
          return payload;
        }

        if (payload is List) {
          return {
            'success': true,
            'message': payload.isEmpty
                ? 'No car documents found'
                : 'Car documents fetched successfully',
            'data': payload,
          };
        }

        return {
          'success': true,
          'message': 'No car documents found',
          'data': <dynamic>[],
        };
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException fetching car documents: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error fetching car documents',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createCarDocument(
      Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.post(
        AppConstants.createCarDocumentUri,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final payload = response.data;
        if (payload is Map<String, dynamic>) {
          return payload;
        }
        return {
          'success': true,
          'message': 'Car document created successfully',
          'data': payload,
        };
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException creating car document: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error creating car document',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateCarDocument(
      Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.post(
        AppConstants.updateCarDocumentUri,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final payload = response.data;
        if (payload is Map<String, dynamic>) {
          return payload;
        }
        return {
          'success': true,
          'message': 'Car document updated successfully',
          'data': payload,
        };
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException updating car document: $e');
      final errorMsg = ApiErrorHandler.getMessage(e);
      throw Exception(errorMsg);
    } catch (e, stack) {
      log('Unexpected error updating car document',
          error: e, stackTrace: stack);
      rethrow;
    }
  }
}
