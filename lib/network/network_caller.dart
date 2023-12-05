import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:task_manager_project/service/authController.dart';
import 'network_response.dart';


class  NetworkCaller {
  Future<NetworkResponse> postRequest(String url, {dynamic body}) async {
    try {
      log(url);
      log(body.toString());
      final Response response =
      await post(Uri.parse(url), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'token' : AuthController.token.toString()
      });
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          jsonBody: jsonDecode(response.body),
          statusCode: 200,
        );
      }
      else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          jsonBody: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMassage: e.toString());
    }
  }


  Future<NetworkResponse> getRequest(String url) async {
    try {
      log(url);
      final Response response =
      await get(Uri.parse(url),headers: {
        'Content-Type': 'application/json',
        'token' : AuthController.token.toString()
      });
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          jsonBody: jsonDecode(response.body),
          statusCode: 200,
        );
      }
      else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          jsonBody: jsonDecode(response.body),
        );


      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMassage: e.toString());
    }
  }
}