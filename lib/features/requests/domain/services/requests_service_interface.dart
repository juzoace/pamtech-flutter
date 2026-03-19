import 'package:autotech/data/model/api_response.dart';

abstract class RequestsServiceInterface {
  Future<ApiResponseModel> fetchRequests();
  Future<ApiResponseModel> fetchRequestMechanicServices();
}
