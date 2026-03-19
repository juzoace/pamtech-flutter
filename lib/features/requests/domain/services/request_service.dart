import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/requests/domain/services/requests_service_interface.dart';

class RequestsService implements RequestsServiceInterface {
  final RequestsServiceInterface requestsRepoInterface;

  RequestsService({required this.requestsRepoInterface});

  // @ override
  // Future<bool>
  @override
  Future<ApiResponseModel<dynamic, dynamic>> fetchRequests() {
    return requestsRepoInterface.fetchRequests();
  }

  @override
  Future<ApiResponseModel<dynamic, dynamic>> fetchRequestMechanicServices() {
    return requestsRepoInterface.fetchRequestMechanicServices();
  }
}
