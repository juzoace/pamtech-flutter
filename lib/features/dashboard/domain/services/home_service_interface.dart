// abstract class HomeServiceInterface {
//   Future<Map<String, dynamic>> fetchNotifications();
//   Future<Map<String, dynamic>> fetchVehicles();
//   Future<Map<String, dynamic>> fetchGarages();
// }

// features/dashboard/domain/services/home_service_interface.dart

abstract class HomeServiceInterface {
  Future<Map<String, dynamic>> fetchNotifications();
  Future<Map<String, dynamic>> fetchUnreadNotifications();
  Future<Map<String, dynamic>> markNotificationAsRead(String notificationId);
  Future<Map<String, dynamic>> fetchVehicles();
  Future<Map<String, dynamic>> createVehicle(Map<String, dynamic> data);
  Future<Map<String, dynamic>> fetchGarages();
  Future<Map<String, dynamic>> fetchCarDocuments();
  Future<Map<String, dynamic>> createCarDocument(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateCarDocument(Map<String, dynamic> data);
}
