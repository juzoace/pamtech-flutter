import 'package:autotech/data/model/api_response.dart';

abstract class RepairsServiceInterface {
  /// Fetches the list of repairs/bookings/requests for the authenticated user
  /// Returns ApiResponseModel (which contains success/data or error)
  Future<ApiResponseModel> fetchUserRepairs();

  // You can add more methods later, e.g.:
  // Future<ApiResponseModel> createRepairRequest(Map<String, dynamic> data);
  // Future<ApiResponseModel> getRepairDetails(String repairId);
  // Future<ApiResponseModel> cancelRepair(String repairId);
}