import 'dart:developer';
import 'package:autotech/features/dashboard/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:autotech/features/dashboard/domain/services/home_service_interface.dart';

class HomeController with ChangeNotifier {
  bool _vehiclesExpanded = false;
  bool get vehiclesExpanded => _vehiclesExpanded;

  set vehiclesExpanded(bool value) {
    _vehiclesExpanded = value;
    notifyListeners();
  }

  final HomeServiceInterface homeServiceInterface;

  HomeController({required this.homeServiceInterface});

  // ── Loading states ───────────────────────────────────────────────
  bool _isLoadingNotifications = false;
  bool _isLoadingVehicles = false;
  bool _isLoadingGarages = false;
  bool _isLoadingCarDocuments = false;

  bool get isLoadingAnything =>
      _isLoadingNotifications ||
      _isLoadingVehicles ||
      _isLoadingGarages ||
      _isLoadingCarDocuments;

  bool get isLoadingNotifications => _isLoadingNotifications;
  bool get isLoadingVehicles => _isLoadingVehicles;
  bool get isLoadingGarages => _isLoadingGarages;
  bool get isLoadingCarDocuments => _isLoadingCarDocuments;

  // ── Data ─────────────────────────────────────────────────────────
  List<dynamic> _notifications = [];
  List<dynamic> get notifications => _notifications;
  Set<String> _unreadNotificationIds = {};
  Set<String> get unreadNotificationIds => _unreadNotificationIds;

  List<dynamic> _vehicles = [];
  List<dynamic> get vehicles => _vehicles;

  List<dynamic> _garages = [];
  List<dynamic> get garages => _garages;

  List<dynamic> _carDocuments = [];
  List<dynamic> get carDocuments => _carDocuments;

  String? _carDocumentsMessage;
  String? get carDocumentsMessage => _carDocumentsMessage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── Computed / UI helpers ────────────────────────────────────────
  int get unreadNotificationCount {
    return _unreadNotificationIds.length;
  }

  bool get hasUnreadNotifications => unreadNotificationCount > 0;

  get error => null;

  // ── Fetch methods ────────────────────────────────────────────────
  Future<void> fetchAllData() async {
    _errorMessage = null;
    notifyListeners();

    // Parallel fetching — recommended for performance
    await Future.wait([
      fetchNotifications(),
      _fetchVehicles(),
      _fetchGarages(),
      fetchCarDocuments(),
    ]);

    // Final notify after all are done
    notifyListeners();
  }

  Future<void> fetchVehicles() => _fetchVehicles();

  Future<void> fetchNotifications() async {
    _isLoadingNotifications = true;
    notifyListeners();

    try {
      final response = await homeServiceInterface.fetchNotifications();

      if (response['success'] == true) {
        _notifications = _extractNotifications(response);
        await _fetchUnreadNotificationsSilently();
      } else {
        _errorMessage = response['message'] ?? 'Failed to load notifications';
      }
    } catch (e, stack) {
      log('Notifications fetch error: $e', error: e, stackTrace: stack);
      _errorMessage = 'Error loading notifications. Please try again.';
    } finally {
      _isLoadingNotifications = false;
      notifyListeners();
    }
  }

  Future<void> _fetchUnreadNotificationsSilently() async {
    try {
      final response = await homeServiceInterface.fetchUnreadNotifications();
      if (response['success'] == true) {
        _unreadNotificationIds = _extractUnreadNotificationIds(response);
      }
    } catch (e, stack) {
      log('Unread notifications fetch error: $e', error: e, stackTrace: stack);
      _unreadNotificationIds = _notifications
          .where((n) => n['read_at'] == null)
          .map(_notificationId)
          .whereType<String>()
          .toSet();
    }
  }

  bool isNotificationUnread(dynamic notification) {
    final id = _notificationId(notification);
    if (id != null) {
      return _unreadNotificationIds.contains(id);
    }
    return notification['read_at'] == null;
  }

  Future<void> markNotificationAsRead(dynamic notification) async {
    final id = _notificationId(notification);
    if (id == null || !isNotificationUnread(notification)) {
      return;
    }

    final nowIso = DateTime.now().toIso8601String();
    final notificationIndex = _notifications.indexWhere(
      (item) => _notificationId(item) == id,
    );

    bool hadReadAtKey = false;
    dynamic previousReadAt;
    if (notificationIndex != -1 && _notifications[notificationIndex] is Map) {
      final mapItem = _notifications[notificationIndex] as Map;
      hadReadAtKey = mapItem.containsKey('read_at');
      previousReadAt = mapItem['read_at'];
      mapItem['read_at'] = mapItem['read_at'] ?? nowIso;
    }

    // Optimistic UI update: clear unread state immediately.
    _unreadNotificationIds.remove(id);
    notifyListeners();

    try {
      await homeServiceInterface.markNotificationAsRead(id);
    } catch (e, stack) {
      _unreadNotificationIds.add(id);
      if (notificationIndex != -1 && _notifications[notificationIndex] is Map) {
        final mapItem = _notifications[notificationIndex] as Map;
        if (hadReadAtKey) {
          mapItem['read_at'] = previousReadAt;
        } else {
          mapItem.remove('read_at');
        }
      }
      notifyListeners();
      log('Mark notification as read error: $e', error: e, stackTrace: stack);
    }
  }

  Future<void> _fetchVehicles() async {
    _isLoadingVehicles = true;
    notifyListeners();

    try {
      final response = await homeServiceInterface.fetchVehicles();

      if (response['success'] == true) {
        _vehicles = (response['data'] as List?) ?? [];
      } else {
        _errorMessage = response['message'] ?? 'Failed to load vehicles';
      }
    } catch (e, stack) {
      log('Vehicles fetch error: $e', error: e, stackTrace: stack);
      _errorMessage = 'Error loading vehicles. Please try again.';
    } finally {
      _isLoadingVehicles = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createVehicle({
    required String vin,
    required String make,
    required String model,
    required String year,
    String? milage,
    String? mileage,
    String? enginType,
    String? engineType,
    required String plateNumber,
    required String colour,
    required String transmission,
  }) async {
    final resolvedMilage = (milage ?? mileage ?? '').trim();
    final resolvedEnginType = _normalizeEngineType(
      (enginType ?? engineType ?? '').trim(),
    );
    final resolvedTransmission = _normalizeTransmission(
      transmission.trim(),
    );

    final payload = {
      'vin': vin,
      'make': make,
      'model': model,
      'year': year,
      'milage': resolvedMilage,
      'engin_type': resolvedEnginType,
      'plate_number': plateNumber,
      'colour': colour,
      'transmission': resolvedTransmission,
    };

    final response = await homeServiceInterface.createVehicle(payload);
    final success = response['success'] == true;
    if (success) {
      await fetchVehicles();
      return response;
    }

    throw Exception(response['message'] ?? 'Failed to create vehicle');
  }

  String _normalizeEngineType(String value) {
    switch (value.toLowerCase()) {
      case 'fuel':
      case 'petrol':
        return 'fuel';
      case 'diesel':
      case 'disel':
        return 'disel';
      case 'cng':
        return 'cng';
      case 'electric':
        return 'electric';
      case 'hybrid':
        return 'hybrid';
      default:
        return value.toLowerCase();
    }
  }

  String _normalizeTransmission(String value) {
    switch (value.toLowerCase()) {
      case 'manual':
        return 'manual';
      case 'automatic':
        return 'automatic';
      default:
        return value.toLowerCase();
    }
  }

  Future<void> _fetchGarages() async {
    _isLoadingGarages = true;
    notifyListeners();

    try {
      final response = await homeServiceInterface.fetchGarages();

      if (response['success'] == true) {
        _garages = (response['data'] as List?) ?? [];
      } else {
        _errorMessage = response['message'] ?? 'Failed to load garages';
      }
    } catch (e, stack) {
      log('Garages fetch error: $e', error: e, stackTrace: stack);
      _errorMessage = 'Error loading garages. Please try again.';
    } finally {
      _isLoadingGarages = false;
      notifyListeners();
    }
  }

  Future<void> fetchCarDocuments() async {
    _isLoadingCarDocuments = true;
    _carDocumentsMessage = null;
    notifyListeners();

    try {
      final response = await homeServiceInterface.fetchCarDocuments();
      final documents = _extractCarDocuments(response);
      final success = response['success'] == true;
      final message = response['message']?.toString();
      final isEmptyResponse = _isEmptyCarDocumentsResponse(response, documents);

      if (success || isEmptyResponse) {
        _carDocuments = documents;
        if (_carDocuments.isEmpty) {
          _carDocumentsMessage = 'No car documents found';
        }
      } else {
        _carDocuments = [];
        _carDocumentsMessage = message ?? 'Failed to load car documents';
      }
    } catch (e, stack) {
      log('Car documents fetch error: $e', error: e, stackTrace: stack);
      _carDocuments = [];
      _carDocumentsMessage = 'Error loading car documents. Please try again.';
    } finally {
      _isLoadingCarDocuments = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createCarDocument({
    required String vehicleId,
    required String documentTitle,
    required String documentNumber,
    required String issuanceDate,
    required String expiryDate,
    String? renewalAgency,
  }) async {
    final payload = {
      'vehicle_id': vehicleId,
      'document_title': documentTitle,
      'document_number': documentNumber,
      'issuance_date': issuanceDate,
      'expiry_date': expiryDate,
      'renewal_agency': renewalAgency ?? '',
    };

    final response = await homeServiceInterface.createCarDocument(payload);
    final success = response['success'] == true;
    if (success) {
      await fetchCarDocuments();
      return response;
    }

    throw Exception(response['message'] ?? 'Failed to create car document');
  }

  Future<Map<String, dynamic>> updateCarDocument({
    required String documentId,
    required String vehicleId,
    required String documentTitle,
    required String documentNumber,
    required String issuanceDate,
    required String expiryDate,
    String? renewalAgency,
  }) async {
    final payload = {
      'id': documentId,
      'vehicle_id': vehicleId,
      'document_title': documentTitle,
      'document_number': documentNumber,
      'issuance_date': issuanceDate,
      'expiry_date': expiryDate,
      'renewal_agency': renewalAgency ?? '',
    };

    final response = await homeServiceInterface.updateCarDocument(payload);
    final success = response['success'] == true;
    if (success) {
      await fetchCarDocuments();
      return response;
    }

    throw Exception(response['message'] ?? 'Failed to update car document');
  }

  List<dynamic> _extractNotifications(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      const possibleKeys = [
        'notifications',
        'notification',
        'unread_notifications',
        'unread',
        'items',
        'data',
      ];
      for (final key in possibleKeys) {
        final value = data[key];
        if (value is List) {
          return value;
        }
      }
    }

    return [];
  }

  Set<String> _extractUnreadNotificationIds(Map<String, dynamic> response) {
    final unreadNotifications = _extractNotifications(response);
    return unreadNotifications.map(_notificationId).whereType<String>().toSet();
  }

  String? _notificationId(dynamic notification) {
    final rawId = notification['id'] ?? notification['notification_id'];
    final id = rawId?.toString();
    if (id == null || id.trim().isEmpty) {
      return null;
    }
    return id;
  }

  NotificationModel? toNotificationModel(dynamic notification) {
    if (notification is! Map<String, dynamic>) {
      return null;
    }
    return NotificationModel.fromJson(notification);
  }

  List<dynamic> _extractCarDocuments(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      const possibleKeys = [
        'documents',
        'car_documents',
        'carDocuments',
        'items',
      ];

      for (final key in possibleKeys) {
        final value = data[key];
        if (value is List) {
          return value;
        }
      }
    }

    return [];
  }

  bool _isEmptyCarDocumentsResponse(
    Map<String, dynamic> response,
    List<dynamic> documents,
  ) {
    if (documents.isNotEmpty) {
      return false;
    }

    final message = response['message']?.toString().trim().toLowerCase();
    if (message == 'no car documents found' ||
        message == 'no documents found') {
      return true;
    }

    final data = response['data'];
    if (data == null) {
      return true;
    }

    if (data is List) {
      return data.isEmpty;
    }

    if (data is Map<String, dynamic>) {
      if (data.isEmpty) {
        return true;
      }

      const possibleKeys = [
        'documents',
        'car_documents',
        'carDocuments',
        'items',
      ];

      for (final key in possibleKeys) {
        final value = data[key];
        if (value == null) {
          continue;
        }

        if (value is List) {
          return value.isEmpty;
        }
      }
    }

    return false;
  }

  // ── Utility methods ──────────────────────────────────────────────
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() => fetchAllData();

  // Optional: reset everything (useful on logout / session clear)
  void reset() {
    _notifications = [];
    _unreadNotificationIds = {};
    _vehicles = [];
    _garages = [];
    _carDocuments = [];
    _errorMessage = null;
    _carDocumentsMessage = null;
    _isLoadingNotifications = false;
    _isLoadingVehicles = false;
    _isLoadingGarages = false;
    _isLoadingCarDocuments = false;
    notifyListeners();
  }
}
