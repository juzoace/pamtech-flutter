import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service_interface.dart';

class RepairsService implements RepairsServiceInterface {
  final RepairsServiceInterface repairsRepoInterface;

  RepairsService({required this.repairsRepoInterface});

  @override
  Future<ApiResponseModel> fetchUserRepairs() {
    return repairsRepoInterface.fetchUserRepairs();
  }

  @override
  Future<ApiResponseModel> fetchRepairDetails(int repairId) {
    // ← Add int repairId here
    return repairsRepoInterface.fetchRepairDetails(
      repairId,
    ); // ← Pass it forward
  }

  @override
  Future<ApiResponseModel> acceptRepairEstimate(data) {
    return repairsRepoInterface.acceptRepairEstimate(data);
  }

  @override
  Future<ApiResponseModel> rejectRepairEstimate(data) {
    return repairsRepoInterface.rejectRepairEstimate(data);
  }
}
