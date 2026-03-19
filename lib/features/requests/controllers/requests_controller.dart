import 'dart:developer';
import 'package:autotech/features/requests/domain/services/requests_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:autotech/data/model/api_response.dart';

class RequestsController with ChangeNotifier {
  final RequestsServiceInterface requestsServiceInterface;

  RequestsController({required this.requestsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _requestData = [];
  List<Map<String, dynamic>> get requestData => _requestData;

  bool _fetchSuccess = false;
  bool get fetchSuccess => _fetchSuccess;

  bool _isLoadingServices = false;
  bool get isLoadingServices => _isLoadingServices;

  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> get services => _services;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  fetchRequests() async {
    _isLoading = true;
    _errorMessage = null;
    _fetchSuccess = false;

    notifyListeners();
    try {
      await requestsServiceInterface.fetchRequests();
    } catch (err, stack) {
      log('Error fetching requests: $err', error: err, stackTrace: stack);
      _errorMessage = err.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRequestMechanicServices() async {
    _isLoadingServices = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponseModel response =
          await requestsServiceInterface.fetchRequestMechanicServices();

      if (response.isSuccess) {
        final payload = response.response;
        final data = payload is Map<String, dynamic> ? payload['data'] : null;
        if (data is List) {
          _services = data
              .whereType<Map>()
              .map((service) => Map<String, dynamic>.from(service))
              .toList();
        } else {
          _services = [];
        }
      } else {
        _services = [];
        _errorMessage = response.error?.toString() ?? 'Failed to load services';
      }
    } catch (err, stack) {
      log('Error fetching request mechanic services: $err',
          error: err, stackTrace: stack);
      _services = [];
      _errorMessage = err.toString();
    } finally {
      _isLoadingServices = false;
      notifyListeners();
    }
  }
}
