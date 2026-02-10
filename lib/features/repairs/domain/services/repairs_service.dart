import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service_interface.dart';

class RepairsService implements RepairsServiceInterface {
  RepairsServiceInterface repairsRepoInterface;
  RepairsService({required this.repairsRepoInterface});

  @override
  Future<ApiResponseModel> fetchUserRepairs() {
    return repairsRepoInterface.fetchUserRepairs();
  }
}
