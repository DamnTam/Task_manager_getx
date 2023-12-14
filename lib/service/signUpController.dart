import 'package:get/get.dart';

import '../network/network_caller.dart';
import '../network/network_response.dart';
import '../network/urls.dart';


class SignUpController extends GetxController{
  bool _signUpInProgress=false;
  String _snackMessage='';
  bool get signUpInProgress=>_signUpInProgress;
  String get snackMessage=> _snackMessage;

  Future<bool> signUp(String email,firstName,lastName,mobile,password) async {
    _signUpInProgress = true;
    update();
    NetworkResponse response =
    await NetworkCaller().postRequest(Urls.registrationUrl, body: {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": null,
    });
    _signUpInProgress = false;
    update();
    if(response.isSuccess){
      _snackMessage='SignUp SuccessFull';
      return true;

    }
    else{
      _snackMessage='SignUp Failed!!!';
      return false;

    }


  }

}