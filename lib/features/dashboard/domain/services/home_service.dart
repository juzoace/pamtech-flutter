// features/dashboard/domain/services/home_service.dart

import 'package:autotech/features/dashboard/domain/services/home_service_interface.dart';

class HomeService implements HomeServiceInterface {
  final HomeServiceInterface homeRepoInterface;

  HomeService({required this.homeRepoInterface});

  @override
  Future<Map<String, dynamic>> fetchNotifications() {
    return homeRepoInterface.fetchNotifications();
  }

  @override
  Future<Map<String, dynamic>> fetchUnreadNotifications() {
    return homeRepoInterface.fetchUnreadNotifications();
  }

  @override
  Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) {
    return homeRepoInterface.markNotificationAsRead(notificationId);
  }

  @override
  Future<Map<String, dynamic>> fetchVehicles() {
    return homeRepoInterface.fetchVehicles();
  }

  @override
  Future<Map<String, dynamic>> createVehicle(Map<String, dynamic> data) {
    return homeRepoInterface.createVehicle(data);
  }

  @override
  Future<Map<String, dynamic>> fetchGarages() {
    return homeRepoInterface.fetchGarages();
  }

  @override
  Future<Map<String, dynamic>> fetchCarDocuments() {
    return homeRepoInterface.fetchCarDocuments();
  }

  @override
  Future<Map<String, dynamic>> createCarDocument(Map<String, dynamic> data) {
    return homeRepoInterface.createCarDocument(data);
  }

  @override
  Future<Map<String, dynamic>> updateCarDocument(Map<String, dynamic> data) {
    return homeRepoInterface.updateCarDocument(data);
  }
}
