
// class ApiResponseModel<T> {
//   final T? response;
//   final dynamic error;
//   final bool isSuccess;

//   ApiResponseModel(this.response, this.error, this.isSuccess);

//   ApiResponseModel.withError(dynamic errorValue, {T? responseValue}) : response = responseValue, error = errorValue, isSuccess = false;

//   ApiResponseModel.withSuccess(T? responseValue)
//       : response = responseValue,
//         error = null, isSuccess = true;
// }


class ApiResponseModel<T, D> {
  final T? response;
  final dynamic error;
  final bool isSuccess;
  final D? data;

  ApiResponseModel(this.response, this.error, this.isSuccess, {this.data});

  ApiResponseModel.withError(dynamic errorValue, {T? responseValue, D? dataValue})
      : response = responseValue,
        error = errorValue,
        isSuccess = false,
        data = dataValue;

  ApiResponseModel.withSuccess(T? responseValue, {D? dataValue})
      : response = responseValue,
        error = null,
        isSuccess = true,
        data = dataValue;
}