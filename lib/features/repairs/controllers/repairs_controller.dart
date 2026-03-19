import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service_interface.dart';

class RepairsController with ChangeNotifier {
  final RepairsServiceInterface repairsServiceInterface;

  RepairsController({required this.repairsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Map<String, dynamic>> _repairsData = [];
  List<Map<String, dynamic>> get repairsData => _repairsData;

  bool _fetchSuccess = false;
  bool get fetchSuccess => _fetchSuccess;

  // ── For detailed repair fetch ──────────────────────────────────────────────
  bool _fetchingRepairDetails = false;
  bool get fetchingRepairDetails => _fetchingRepairDetails;

  Map<String, dynamic>? _currentRepairDetails;
  Map<String, dynamic>? get currentRepairDetails => _currentRepairDetails;

  Future<void> fetchUserRepairs() async {
    _isLoading = true;
    _errorMessage = null;
    _fetchSuccess = false;
    // _repairsData = null;

    // Don't notify here if called from initState

    notifyListeners();

    try {
      final ApiResponseModel response = await repairsServiceInterface
          .fetchUserRepairs();

      if (response.isSuccess) {
        print('checking controller file which was success block');
        print(response.response?.data);

        final outerData = response.response?.data as Map<String, dynamic>?;

        if (outerData != null && outerData['success'] == true) {
          // Go one level deeper: outer 'data' is a Map → inner 'data' is the list
          final nestedData = outerData['data'] as Map<String, dynamic>?;

          // Now get the actual repairs array
          final repairsList = nestedData?['data'] as List<dynamic>? ?? [];

          _repairsData = repairsList.cast<Map<String, dynamic>>();
          _fetchSuccess = true;
          _errorMessage = null;

          print('Successfully extracted ${repairsList.length} repairs');
          print(
            'First repair (for debug): ${repairsList.isNotEmpty ? repairsList[0] : 'empty'}',
          );
        } else {
          _errorMessage = outerData?['message'] ?? 'Failed to load repairs.';
        }
      } else {
        _errorMessage = 'Server error: ${response.response?.statusCode}';
      }
    } catch (e, stack) {
      log('Fetch repairs error: $e', error: e, stackTrace: stack);
      _errorMessage = 'Something went wrong. Please check your connection.';
    } finally {
      _isLoading = false;
      // if (mounted) {
      //   notifyListeners(); // safe here
      // }
    }
  }

  /// Fetch detailed data for a single repair by ID
  Future<bool> fetchRepairDetails(int repairId) async {
    // _isLoading = true;
    _fetchingRepairDetails = true;
    _errorMessage = null;
    _currentRepairDetails = null;
    notifyListeners();

    try {
      final ApiResponseModel response = await repairsServiceInterface
          .fetchRepairDetails(repairId);

      print('response when fetching repair details');
      print(response);

      if (response.isSuccess) {
        print('success fetching repair detaild');
        print(response.response?.data as Map<String, dynamic>);
        final data = response.response?.data as Map<String, dynamic>?;

        if (data != null && data['success'] == true) {
          _currentRepairDetails = data['data'] as Map<String, dynamic>?;
          print(_currentRepairDetails);
          _errorMessage = null;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data?['message'] ?? 'Failed to load repair details.';
        }
      } else {
        _errorMessage = 'Server error: ${response.response?.statusCode}';
      }
    } catch (e, stack) {
      log('Fetch repair details error: $e', error: e, stackTrace: stack);
      _errorMessage = 'Failed to load repair details. Please try again.';
    } finally {
      _fetchingRepairDetails = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> acceptRepairEstimateItem(data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponseModel response = await repairsServiceInterface
          .acceptRepairEstimate(data);

      if (response.isSuccess) {
        print('success fetching repair detaild');
        print(response.response?.data as Map<String, dynamic>);
        final data = response.response?.data as Map<String, dynamic>?;

        if (data != null && data['success'] == true) {
          _currentRepairDetails = data['data'] as Map<String, dynamic>?;
          print(_currentRepairDetails);
          _errorMessage = null;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data?['message'] ?? 'Failed to load repair details.';
        }
      } else {
        _errorMessage = 'Server error: ${response.response?.statusCode}';
      }
    } catch (e, stack) {
      // log(' repair details error: $e', error: e, stackTrace: stack);
      _errorMessage = 'Failed to accept repair estimate. Please try again.';
    } finally {
      _fetchingRepairDetails = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> rejectRepairEstimateItem(data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final ApiResponseModel response = await repairsServiceInterface
          .rejectRepairEstimate(data);

      if (response.isSuccess) {
        // print('success fetching repair detaild');
        print(response.response?.data as Map<String, dynamic>);
        final data = response.response?.data as Map<String, dynamic>?;

        if (data != null && data['success'] == true) {
          _currentRepairDetails = data['data'] as Map<String, dynamic>?;
          print(_currentRepairDetails);
          _errorMessage = null;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data?['message'] ?? 'Failed to load repair details.';
        }
      } else {
        _errorMessage = 'Server error: ${response.response?.statusCode}';
      }
    } catch (e, stack) {
      _errorMessage = 'Failed to reject repair estimate. Please try again.';
    } finally {
      _fetchingRepairDetails = false;
      notifyListeners();
    }
    return false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _fetchSuccess = false;
    // _repairsData = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
