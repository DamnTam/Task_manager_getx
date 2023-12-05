class NetworkResponse{
  final int? statusCode;
  final bool isSuccess;
  final dynamic jsonBody;
  final String? errorMassage;

  NetworkResponse(
      {this.statusCode=-1, required this.isSuccess, this.jsonBody, this.errorMassage='error'});
}