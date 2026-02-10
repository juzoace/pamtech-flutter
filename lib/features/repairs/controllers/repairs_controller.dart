import 'dart:developer';
import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service_interface.dart';
import 'package:flutter/material.dart';

class RepairsController with ChangeNotifier {
  final RepairsServiceInterface repairsServiceInterface;

  RepairsController({required this.repairsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  dynamic _repairsData; // ← will hold the list or map from API
  dynamic get repairsData => _repairsData;

  bool _fetchSuccess = false;
  bool get fetchSuccess => _fetchSuccess;

  Future<bool> fetchUserRepairs() async {
    _isLoading = true;
    _errorMessage = null;
    _fetchSuccess = false;
    _repairsData = null;
    notifyListeners();

    try {
      final ApiResponseModel response = await repairsServiceInterface.fetchUserRepairs();

      if (response.isSuccess) {
        // Assuming your API returns something like:
        // { "success": true, "data": { "repairs": [...] } } or { "data": [...] }
        final rawData = response.response?.data as Map<String, dynamic>?;

        _repairsData = rawData?['data'] ?? rawData?['repairs'] ?? [];
        _fetchSuccess = true;
        _errorMessage = null;
      } else {


        // fix later
        // _errorMessage = response.message ?? 'Failed to load repairs. Please try again.';
      }

      return _fetchSuccess;
    } catch (e, stack) {
      log('Fetch repairs error: $e', error: e, stackTrace: stack);
      _errorMessage = e.toString().contains('Exception')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _fetchSuccess = false;
    _repairsData = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}